load("@io_bazel_rules_docker//container:image.bzl", _container_image = "container_image")
load("@io_bazel_rules_docker//container:layer.bzl", _container_layer = "container_layer")
load(":rootfs.bzl", _dockerfile_rootfs = "dockerfile_rootfs")


def dockerfile_image(name, dockerfile, env={}, docker_build_args=[], layers=[], **kwargs):
    """
    """
    rootfs_name = "%s.rootfs" % name
    layer_name = "%s.rootfs-layer" % name

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

    _container_layer(
        name = layer_name,
        tars = [rootfs_name],
    )

    _container_image(
        name = name,
        layers = layers + [":"+layer_name],
        env = container_env,
        **kwargs
    )



