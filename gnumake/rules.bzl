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

def _gnumake_impl(ctx: AnalysisContext):
    return [
        DefaultInfo(),
    ]

def _gnumake_attributes() -> dict[str, Attr]:
    return {
        "_gnumake_toolchain": attrs.default_only(attrs.toolchain_dep(default = "@gnumake//:gnumake", providers = [GNUMakeToolchainInfo])),
    }

gnumake = rule(
    impl = _gnumake_impl,
    attrs = _gnumake_attributes(),
)
