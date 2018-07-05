load("//dockerfile:image.bzl", "dockerfile_image")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")

dockerfile_image(
    name = "dotnet-aspnetapp",
    dockerfile = "dotnet-aspnetapp/Dockerfile",
    entrypoint = [
        "dotnet",
        "aspnetapp.dll",
    ],
    env = {
        "ASPNETCORE_URLS": "http://+:80",
        "DOTNET_RUNNING_IN_CONTAINER": "true",
        "ASPNETCORE_VERSION": "2.1.1",
    },
    workdir = "/app",
)

k8s_object(
    name = "deployment",
    cluster = "{STABLE_K8S_CLUSTER}",
    image_chroot = "{STABLE_IMAGE_CHROOT}",
    images = {
        "dotnet-aspnetapp:latest": ":dotnet-aspnetapp",
    },
    kind = "deployment",
    template = ":deployment.yaml",
)
