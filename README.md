# [GNU Make] toolchain for [Buck2].

This repository implements a [Buck2] toolchain for using [GNU Make].

[GNU Make] binaries are not downloaded from some source. Instead, the source code
is built from the source.

_TL;DR_: See [`gnumake`](docs/gnumake/gnumake/rules.bzl.md#gnumake).

## Dependencies

### `python_bootstrap`, `genrule` and `cxx` toolchains.

`python_bootstrap`, `genrule` and `cxx` toolchains must be enabled.

To do so, make sure that the following two rules are called:

```starlark
load("@prelude//toolchains:cxx.bzl", "system_cxx_toolchain")
load("@prelude//toolchains:genrule.bzl", "system_genrule_toolchain")
load("@prelude//toolchains:python.bzl", "system_python_bootstrap_toolchain", "system_python_toolchain")

system_python_bootstrap_toolchain(
    name = "python_bootstrap",
    visibility = ["PUBLIC"],
)

system_genrule_toolchain(
    name = "genrule",
    visibility = ["PUBLIC"],
)

system_cxx_toolchain(
    name = "cxx",
    visibility = ["PUBLIC"],
)
```

## Installation

Clone this repository to your repository. Then, to enable the [GNU Make]
toolchain, add the following cell:

```
# .buckconfig

[repositories]
gnumake = <path_to_gnumake>/

[parser]
target_platform_detector_spec = target:gnumake//...->prelude//platforms:default
```

### Example

First, we clone the repository under `external_deps/gnumake`:

```shell
$ mkdir -p external_deps/gnumake
$ git clone 'https://github.com/zadlg/buck2_rules_gnumake.git' external_deps/gnumake
```

Then, we declare the cell by adding an entry under the section `repositories`
of the `.buckconfig` file:

```
# .buckconfig

[repositories]
gnumake = external_deps/gnumake
```

Finally, we add a new entry under the section `parser` to tell Buck which
platforms should be targeted for the `gnumake` cell:

```
# .buckconfig

[parser]
target_platform_detector_spec = target:gnumake//...->prelude//platforms:default
```

## Usage

### Enable the toolchain

First, we have to enable the [GNU Make] toolchain. To do so, edit your toolchain
`BUCK` file (usually under `toolchains/BUCK`), and add the following:

```starlark
load("@gnumake//gnumake:gnumake.bzl", "gnumake_toolchain")

gnumake_toolchain(
    name = "gnumake",
    visibility = ["PUBLIC"],
)
```

### Import and use the rule

Once the toolchain is enabled, one can do the following:

```starlark
# BUCK file

load("@gnumake//gnumake:rules.bzl", "gnumake")

gnumake(
    name = "mylib",
    srcs = glob(["Makefile", "*.c"]),
    compiler_flags = ["-DENABLE_MY_FEATURE"],
)
```

To build your target, simply use buck:

```shell
$ buck2 build //:mylib
```

## Examples

See [`examples/`](examples/).

## License

Apache2, see [License](LICENSE).

[GNU Make]: https://www.gnu.org/software/make/
[Buck2]: https://buck2.build/
