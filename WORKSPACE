workspace(name = "rules_dockerfile")

git_repository(
    name = "io_bazel_rules_k8s",
    commit = "d6e1b65317246fe044482f9e042556c77e6893b8",
    remote = "git@github.com:bazelbuild/rules_k8s.git",
)

load("//dockerfile:dependencies.bzl", "dockerfile_repositories")

dockerfile_repositories()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")

k8s_repositories()