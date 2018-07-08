
def _dockerfile_rootfs_impl(ctx):
    """
    """
    imageid_file = ctx.actions.declare_file("%s_imageid" % ctx.attr.name)

    ctx.actions.run_shell(
        mnemonic = "DockerBuild",
        progress_message = "Building dockerfile '%s'" % ctx.file.dockerfile.path,
        inputs = [ctx.file.dockerfile] + ctx.files.build_context,
        outputs = [imageid_file],
        arguments = [
            ctx.file.dockerfile.path,
            imageid_file.path
        ] + ctx.attr.docker_build_args,
        command = """
            set -euo pipefail
            DOCKERFILE=$(realpath "$1"); shift
            IIDFILE="$PWD/$1"; shift
            cd $(dirname $DOCKERFILE)
            docker build --network=host --iidfile="$IIDFILE" -f "$(basename $DOCKERFILE)" "$@" .
            touch -t 197001010000 "$IIDFILE"
            """,
        execution_requirements = {
            "no-cache": "1",
            "no-remote": "1",
        },
    )

    ctx.actions.run_shell(
        mnemonic = "DockerExport",
        progress_message = "Exporting rootfs of %s" % ctx.file.dockerfile.path,
        inputs = [imageid_file],
        outputs = [ctx.outputs.rootfs],
        arguments = [
            imageid_file.path,
            ctx.outputs.rootfs.path
        ],
        command = """
            set -euo pipefail
            IMAGEID=$(cat $1)
            OUTFILE=$2
            TMP_CONTAINER=$(mktemp -u XXXXX|tr '[:upper:]' '[:lower:]')
            docker create --name=$TMP_CONTAINER $IMAGEID > /dev/null
            docker export --output=$OUTFILE "$TMP_CONTAINER" > /dev/null
            docker rm "$TMP_CONTAINER" > /dev/null
            touch -t 197001010000 "$OUTFILE"
            """,
        execution_requirements = {
            "no-remote": "1",
        },
    )



_dockerfile_rootfs = rule(
    implementation = _dockerfile_rootfs_impl,
    attrs = {
        "dockerfile": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "docker_build_args": attr.string_list(default=[]),
        "build_context": attr.label_list(
            allow_empty = True,
            allow_files = True
        ),
    },
    outputs = {
        "rootfs": "%{name}.tar",
    }
)

def dockerfile_rootfs(dockerfile, **kwargs):
    """
    """
    # validate that the specified dockerfile exists within this package
    if dockerfile.startswith(":") or dockerfile.startswith("/"):
        fail("`dockerfile` arg must be a file name relative to the current package (eg 'Dockerfile' or 'subpath/Dockerfile')")

    dockerfile_pathparts = dockerfile.split("/")[:-1]
    glob_pattern = "/".join(dockerfile_pathparts + ["**"])

    # we wrap the actual rule in a macro so we can set build_context to a glob by default
    build_ctx_files = native.glob([glob_pattern], exclude=[
        ".git/**",
        "BUILD",
        "BUILD.bazel",
        "WORKSPACE",
        "**/.terraform/**"])

    _dockerfile_rootfs(
        dockerfile = dockerfile,
        build_context = build_ctx_files,
        **kwargs
    )


