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

GNUMakeCompilationInfo = provider(
    doc = "Configuration info about a target compiled with GNU Make",
    fields = {
        # C flags specified in `CFLAGS` argument.
        "c_compiler_flags": provider_field(list[str]),

        # C++ flags specified in `CXXFLAGS` argument.
        "cxx_compiler_flags": provider_field(list[str]),
    },
)

GNUMakeArtifactInfo = provider(
    doc = "Additional information about an artifact produced by `gnumake` rule",
    fields = {
        # Output file.
        "output": provider_field(Artifact),

        # Original path to the artifact within the install directory.
        "original_path": provider_field(str),
    },
)

GNUMakeOutputInfo = provider(
    doc = "GNUMake output info",
    fields = {
        # Information about the compilation.
        "compilation_info": provider_field(GNUMakeCompilationInfo),

        # All make flags being used for compiling the target.
        "make_flags": provider_field(dict),

        # The install prefix directory/
        "install_prefix": provider_field(Artifact),

        # Sources being used for compiling the target.
        "srcs": provider_field(Artifact),
    },
)

GNUMakeToolchainInfo = provider(
    doc = "GNUMake toolchain info",
    fields = {
        # GNU Make binary.
        "bin": provider_field(RunInfo),
    },
)
