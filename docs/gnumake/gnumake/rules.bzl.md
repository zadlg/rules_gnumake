## CxxToolchainInfo

```python
CxxToolchainInfo: provider_callable
```

---
## GNUMakeToolchainInfo

```python
GNUMakeToolchainInfo: provider_callable
```

---
## cxx\_by\_platform

```python
def cxx_by_platform(
    ctx: context,
    xs: list[(str, typing.Any)]
) -> list[typing.Any]
```

---
## gnumake

```python
def gnumake(
    *,
    name: str,
    default_target_platform: None | str = _,
    target_compatible_with: list[str] = _,
    compatible_with: list[str] = _,
    exec_compatible_with: list[str] = _,
    visibility: list[str] = _,
    within_view: list[str] = _,
    metadata: opaque_metadata = _,
    tests: list[str] = _,
    _cxx_toolchain: str = _,
    _gnumake_toolchain: str = _,
    _wrapped_make: str = _,
    args: list[str] = _,
    compiler_flags: list[str] = _,
    install_prefix: str = _,
    makefile: str = _,
    out_binaries: list[str] = _,
    out_binary_dir: str = _,
    out_include_dir: str = _,
    out_lib_dir: str = _,
    out_shared_libs: list[str] = _,
    out_static_libs: list[str] = _,
    platform_compiler_flags: list[(str, list[str])] = _,
    srcs: list[str],
    targets: list[str] = _
) -> None
```

#### Parameters

* `name`: name of the target
* `default_target_platform`: specifies the default target platform, used when no platforms are specified on the command line
* `target_compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with a configuration
* `compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with a configuration
* `exec_compatible_with`: a list of constraints that are required to be satisfied for this target to be compatible with an execution platform
* `visibility`: a list of visibility patterns restricting what targets can depend on this one
* `within_view`: a list of visibility patterns restricting what this target can depend on
* `metadata`: a key-value map of metadata associated with this target
* `tests`: a list of targets that provide tests for this one
* `_cxx_toolchain`: CXX toolchain.
* `_gnumake_toolchain`: GNUMake toolchain.
* `_wrapped_make`: Wrapped make script.
* `args`: A list of arguments to forward to the call to GNUMake.
* `compiler_flags`: Flags to use when compiling.
* `install_prefix`: Install prefix path, relative to where to install the result of the build. This is passed an an argument to `make` as `PREFIX=<value>`.
* `makefile`: The Makefile to use. This must contain the relative path to the Makefile.
* `out_binaries`: Filenames of output executable binaries. These files will be fetched from the `out_binary_dir` directory.
* `out_binary_dir`: Name of the subdirectory that contains the executable binary files.
* `out_include_dir`: Name of the subdirectory that contains the header files.
* `out_lib_dir`: Name of the subdirectory that contains the library files.
* `out_shared_libs`: Filenames of output shared libraries. These files will be fetched from the `out_lib_dir` directory.
* `out_static_libs`: Filenames of output static libraries. These files will be fetched from the `out_lib_dir` directory.
* `platform_compiler_flags`: Flags to use when compiling.
* `srcs`: Input source.
* `targets`: A list of targets to produce.


---
## gnumake\_rule\_get\_attributes

```python
def gnumake_rule_get_attributes() -> dict[typing.Any, typing.Any]
```

Returns the attributes of the `gnumake` rule.

---
## native

```python
native: struct(..)
```
