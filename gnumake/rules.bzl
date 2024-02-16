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
load("@prelude//cxx:cxx_toolchain_types.bzl", "CxxToolchainInfo")
load("@prelude//cxx:platform.bzl", "cxx_by_platform")

def _symlink_all_source_files(ctx: AnalysisContext, subdir: str = "srcs"):
    """Create symlinks for all source files.

      Arguments:
        ctx:
          Analysis context
        subdir:
          Subdirectory which will contain the symlinks.

      Returns:
        Artifact to the subdirectory.
    """
    srcs = {}
    for src in ctx.attrs.srcs:
        srcs[src.short_path] = src

    return ctx.actions.symlinked_dir("srcs", srcs)

def _get_platform_specific_compiler_flags(ctx: AnalysisContext, platform_compiler_flags: list) -> list[str]:
    """Return the platform-specific compiler flags.

    Attrs:
      ctx:
        Analysis context.
      platform_compiler_flags:
        List of tuple of shape (regex, list[flags]).

    Returns:
      A list[str] of flags.
    """
    pcf = []
    all_flags = cxx_by_platform(ctx, platform_compiler_flags)
    for flags in all_flags:
        pcf.extend([str(flag) for flag in flags])
    return pcf

def _build_cflags_arg(ctx: AnalysisContext, cxx_toolchain_info: CxxToolchainInfo, extra_flags: list = []) -> list[str]:
    """Build the list of flags for the CFLAGS argument.
      Attrs:
        ctx:
          Analysis context.
        cxx_toolchain_info: CxxToolchainInfo
          Information on the cxx toolchain.
        extra_flags: list[Any]
          Extra flags to add.

      Returns:
          List[str]: list of C flags.
    """
    return cxx_toolchain_info.c_compiler_info.compiler_flags + \
           [str(flag) for flag in extra_flags] + \
           _get_platform_specific_compiler_flags(ctx, ctx.attrs.platform_compiler_flags)

def _build_cxxflags_arg(ctx: AnalysisContext, cxx_toolchain_info: CxxToolchainInfo, extra_flags: list = []) -> list[str]:
    """Build the list of flags for the CXXFLAGS argument.
      Attrs:
        ctx:
          Analysis context.
        cxx_toolchain_info: CxxToolchainInfo
          Information on the cxx toolchain.
        extra_flags: list[Any]
          Extra flags to add.

      Returns:
          List[str]: list of CXX flags.
    """
    platform_compiler_flags = []
    [platform_compiler_flags.extend([str(flag) for flag in flags]) for flags in cxx_by_platform(ctx, ctx.attrs.platform_compiler_flags)]
    return cxx_toolchain_info.cxx_compiler_info.compiler_flags + \
           [str(flag) for flag in extra_flags] + \
           _get_platform_specific_compiler_flags(ctx, ctx.attrs.platform_compiler_flags)

def _gnumake_impl(ctx: AnalysisContext) -> list:
    """Implementation of rule `gnumake`."""
    gnumake_bin = ctx.attrs._gnumake_toolchain[GNUMakeToolchainInfo].bin
    cxx_toolchain_info = ctx.attrs._cxx_toolchain[CxxToolchainInfo]

    install_dir = ctx.actions.declare_output(ctx.attrs.install_prefix, dir = True)

    srcs_dir = _symlink_all_source_files(ctx)

    cflags = _build_cflags_arg(
        ctx,
        cxx_toolchain_info = cxx_toolchain_info,
        extra_flags = ctx.attrs.compiler_flags,
    )
    cxxflags = _build_cxxflags_arg(
        ctx,
        cxx_toolchain_info = cxx_toolchain_info,
        extra_flags = ctx.attrs.compiler_flags,
    )
    args = cmd_args()
    args.add(["-C", srcs_dir])
    args.add(["-f", ctx.attrs.makefile])
    args.add(cmd_args(cmd_args(install_dir.as_output()).relative_to(srcs_dir), format = "PREFIX={}"))
    args.add(ctx.attrs.args)
    args.add(ctx.attrs.targets)
    args.add(cmd_args(" ".join(cflags), format = "CFLAGS={}"))
    args.add(cmd_args(" ".join(cxxflags), format = "CXXFLAGS={}"))

    ctx.actions.run(
        args,
        category = "gnumake",
        always_print_stderr = True,
        exe = gnumake_bin,
    )

    return [
        DefaultInfo(default_output = install_dir),
    ]

def _gnumake_attributes() -> dict[str, Attr]:
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
    }

gnumake = rule(
    impl = _gnumake_impl,
    attrs = _gnumake_attributes(),
)
