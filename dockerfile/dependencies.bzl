load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def dockerfile_repositories():

    existing = native.existing_rules().keys()


#    if "io_bazel_rules_go" not in existing:
#        git_repository(
#            name = "io_bazel_rules_go",
#            remote = "git@github.com:bazelbuild/rules_go.git",
#            tag = "0.12.0",
#        )

    if "io_bazel_rules_docker" not in existing:
        git_repository(
            name = "io_bazel_rules_docker",
            commit = "7401cb256222615c497c0dee5a4de5724a4f4cc7",
            remote = "git@github.com:bazelbuild/rules_docker.git",
        )

#    if "io_bazel_rules_k8s" not in existing:
#        git_repository(
#            name = "io_bazel_rules_k8s",
#            commit = "8f152b5538d30bba0304c7b090b40fc8ddcbd87f",
#            remote = "git@github.com:bazelbuild/rules_k8s.git",
#        )
