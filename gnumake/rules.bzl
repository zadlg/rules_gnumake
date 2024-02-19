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

def _move_artifacts(
        ctx: AnalysisContext,
        install_dir: Artifact,
        sub_dir: str,
        filenames: list[str],
        identifier_format: str) -> (list[Artifact], dict):
    """Moves files from `install_dir`/`sub_dir`.

    Attrs:
      ctx:
        Analysis context.
      install_dir:
        Install directory.
      sub_dir:
        Sub directory within `install_dir`.
      filenames:
        List of file names to move.
      identifier_format:
        ctx.actions.run identifier format. Must contain `label`, `i`
        and `filename`.

    Returns:
      List of artifacts and dict of DefaultInfo provider.
    """

    out_files = []
    sub_targets = {}
    for i in range(len(filenames)):
        filename = filenames[i]
        src = cmd_args(install_dir, format = "{{}}/{sub_dir}/{filename}".format(
            sub_dir = sub_dir,
            filename = filename,
        ))
        out = ctx.actions.declare_output("{sub_dir}_{i}".format(
            sub_dir = sub_dir,
            i = i,
        ), filename)
        ctx.actions.run(
            cmd_args(["mv", src, out.as_output()]),
            category = "gnumake",
            identifier = identifier_format.format(
                label = ctx.label,
                i = i,
                filename = filename,
            ),
        )
        out_files.append(out)
        sub_targets[filename] = [
            DefaultInfo(default_output = out),
        ]

    return out_files, sub_targets

def _fetch_out_executable_binaries(ctx: AnalysisContext, install_dir: Artifact) -> (list[Artifact], dict):
    """Fetches the output executable binaries, using `attr.output_binary_dir`
    and `attr.out_binaries`.

    Attrs:
      ctx:
        Analysis context.
      install_dir:
        Install directory.

    Returns:
      List of artifacts and dictionary of providers. This list may be empty."""

    outs, sub_targets = _move_artifacts(
        ctx = ctx,
        install_dir = install_dir,
        sub_dir = ctx.attrs.out_binary_dir,
        filenames = ctx.attrs.out_binaries,
        identifier_format = "{label}/out_binaries[{i}]={filename}",
    )

    for i in range(len(ctx.attrs.out_binaries)):
        sub_targets[ctx.attrs.out_binaries[i]].append(RunInfo(cmd_args(outs[i])))

    return outs, sub_targets

def _fetch_out_static_libraries(ctx: AnalysisContext, install_dir: Artifact) -> (list[Artifact], dict):
    """Fetches the output static libraries, using `attr.out_lib_dir`
    and `attr.out_static_libs`.

    Attrs:
      ctx:
        Analysis context.
      install_dir:
        Install directory.

    Returns:
      List of artifacts and dictionary of providers. This list may be empty."""

    return _move_artifacts(
        ctx = ctx,
        install_dir = install_dir,
        sub_dir = ctx.attrs.out_lib_dir,
        filenames = ctx.attrs.out_static_libs,
        identifier_format = "{label}/out_static_libs[{i}]={filename}",
    )

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
    args = cmd_args([gnumake_bin, install_dir.as_output()])
    args.add(["-C", srcs_dir])
    args.add(["-f", ctx.attrs.makefile])
    args.add(cmd_args(cmd_args(install_dir.as_output()).relative_to(srcs_dir), format = "PREFIX={}"))
    args.add(ctx.attrs.args)
    args.add(ctx.attrs.targets)
    env = {
        "CFLAGS": " ".join(cflags),
        "CXXFLAGS": " ".join(cxxflags),
    }

    ctx.actions.run(
        args,
        category = "gnumake",
        always_print_stderr = True,
        env = env,
        exe = ctx.attrs._wrapped_make[RunInfo],
    )

    out_binaries, out_binaries_sub_targets = _fetch_out_executable_binaries(
        ctx = ctx,
        install_dir = install_dir,
    )

    out_static_libs, out_static_libs_sub_targets = _fetch_out_static_libraries(
        ctx = ctx,
        install_dir = install_dir,
    )

    sub_targets = {}
    sub_targets.update(out_binaries_sub_targets)
    sub_targets.update(out_static_libs_sub_targets)

    return [
        DefaultInfo(
            default_outputs = [install_dir] + out_binaries + out_static_libs,
            sub_targets = sub_targets,
        ),
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

gnumake = rule(
    impl = _gnumake_impl,
    attrs = _gnumake_attributes(),
)
