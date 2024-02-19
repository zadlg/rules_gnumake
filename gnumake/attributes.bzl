# Copyright 2024 github.com/zadlg
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@gnumake//gnumake:toolchain_info.bzl", "GNUMakeToolchainInfo")

def gnumake_rule_get_attributes() -> dict:
    """Returns the attributes of the `gnumake` rule.

    Returns:
      Attributes of `gnumake` rule.
    """

    return {
        "args": attrs.list(
            attrs.arg(),
            default = [],
            doc = """
    A list of arguments to forward to the call to GNUMake.
""",
        ),
        "compiler_flags": attrs.list(
            attrs.arg(),
            default = [],
            doc = """
    Flags to use when compiling.
""",
        ),
        "install_prefix": attrs.string(
            default = "__install__",
            doc = """
    Install prefix path, relative to where to install the result of the build.
This is passed an an argument to `make` as `PREFIX=<value>`.
""",
        ),
        "platform_compiler_flags": attrs.list(
            attrs.tuple(
                attrs.regex(),
                attrs.list(
                    attrs.arg(),
                    default = [],
                    doc = """
    Platform specific compiler flags. See `cxx_common.platform_compiler_flags_arg()` for more information.
""",
                ),
            ),
            default = [],
            doc = """
    Flags to use when compiling.
""",
        ),
        "srcs": attrs.list(
            attrs.source(),
            doc = """
    Input source.
""",
        ),
        "makefile": attrs.string(
            default = "Makefile",
            doc = """
    The Makefile to use. This must contain the relative path to the Makefile.
""",
        ),
        "targets": attrs.list(
            attrs.string(),
            default = ["", "install"],
            doc = """
    A list of targets to produce.
""",
        ),
        "out_lib_dir": attrs.string(
            default = "lib",
            doc = """
    Name of the subdirectory that contains the library files.
""",
        ),
        "out_static_libs": attrs.list(
            attrs.string(),
            default = [],
            doc = """
    Filenames of output static libraries. These files will be fetched
    from the `out_lib_dir` directory.
""",
        ),
        "out_shared_libs": attrs.list(
            attrs.string(),
            default = [],
            doc = """
    Filenames of output shared libraries. These files will be fetched
    from the `out_lib_dir` directory.
""",
        ),
        "out_binary_dir": attrs.string(
            default = "bin",
            doc = """
    Name of the subdirectory that contains the executable binary files.
""",
        ),
        "out_binaries": attrs.list(
            attrs.string(),
            default = [],
            doc = """
    Filenames of output executable binaries. These files will be fetched
    from the `out_binary_dir` directory.
""",
        ),
        "out_include_dir": attrs.string(
            default = "",
            doc = """
    Name of the subdirectory that contains the header files.
""",
        ),
        "_gnumake_toolchain": attrs.default_only(
            attrs.toolchain_dep(
                default = "@gnumake//:gnumake",
                providers = [GNUMakeToolchainInfo],
            ),
            doc = """
    GNUMake toolchain.
""",
        ),
        "_cxx_toolchain": attrs.default_only(
            attrs.toolchain_dep(
                default = "@toolchains//:cxx",
            ),
            doc = """
    CXX toolchain.
""",
        ),
        "_wrapped_make": attrs.dep(
            default = "@gnumake//gnumake:wrapped_make",
            doc = """
    Wrapped make script.
""",
            providers = [RunInfo],
        ),
    }
