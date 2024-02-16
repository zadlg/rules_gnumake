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
    args: list[str] = _,
    compiler_flags: list[str] = _,
    install_prefix: str = _,
    makefile: str = _,
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
* `args`: A list of arguments to forward to the call to GNUMake.
* `compiler_flags`: Flags to use when compiling.
* `install_prefix`: Install prefix path, relative to where to install the result of the build. This is passed an an argument to `make` as `PREFIX=<value>`.
* `makefile`: The Makefile to use. This must contain the relative path to the Makefile.
* `platform_compiler_flags`: Flags to use when compiling.
* `srcs`: Input source.
* `targets`: A list of targets to produce.


---
## native

```python
native: struct(..)
```