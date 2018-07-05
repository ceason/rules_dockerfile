load("@io_bazel_rules_docker//container:image.bzl", _container_image = "container_image")
load(":rootfs.bzl", _dockerfile_rootfs = "dockerfile_rootfs")


def dockerfile_image(name, dockerfile, env={}, docker_build_args=[], **kwargs):
    """
    """
    rootfs_name = "%s.rootfs" % name

    container_env = {
        "PATH": ":".join([
            "/usr/local/sbin",
            "/usr/local/bin",
            "/usr/sbin",
            "/usr/bin",
            "/sbin",
            "/bin"
        ])
    }
    container_env.update(env)

    _dockerfile_rootfs(
        name = rootfs_name,
        dockerfile = dockerfile,
        docker_build_args = docker_build_args,
    )

    _container_image(
        name = name,
        tars = [rootfs_name],
        env = container_env,
        **kwargs
    )



