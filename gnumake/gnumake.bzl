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

load(":providers.bzl", "GNUMakeToolchainInfo")

def _gnumake_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    """Implementation of the GNU Make toolchain.

    Returns:
      List of providers.
    """

    return [
        DefaultInfo(),
        GNUMakeToolchainInfo(
            bin = ctx.attrs._gnumake_built[RunInfo],
        ),
    ]

gnumake_toolchain = rule(
    impl = _gnumake_toolchain_impl,
    doc = "GNU Make toolchain",
    attrs = {
        "_gnumake_built": attrs.default_only(
            attrs.exec_dep(
                doc = "GNUMake built",
                default = "@rules_gnumake//gnumake:gnumake",
                providers = [RunInfo],
            ),
        ),
    },
    is_toolchain_rule = True,
)
