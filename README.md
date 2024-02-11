# [GNU Make] toolchain for [Buck2].

This repository implements a [Buck2] toolchain for using [GNU Make].

[GNU Make] binaries are not downloaded from some source. Instead, the source code
is built from the source.

## Dependencies


### [Autoconf]

Since [GNU Make] relies on [Autoconf], [Autoconf] is thus needed.


_Note_: A toolchain for [Autoconf] may be implemented later.

### `python_bootstrap` and `genrule`.

Both `python_bootstrap` and `genrule` toolchains must be enabled.

To do so, make sure that the following two rules are called:

```starlark
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
```

## Installation

Clone this repository to your repository. Then, to enable the [GNU Make]
toolchain, add the following cell:

```
# .buckconfig

[repositories]
gnumake = gnumake/
```

## Usage

WIP.

## License

Apache2, see [License](LICENSE).

[GNU Make]: https://www.gnu.org/software/make/
[Buck2]: https://buck2.build/
[Autoconf]: https://www.gnu.org/software/autoconf/
