
#
# Copyright (c) 2013 Limit Point Systems, Inc. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#------------------------------------------------
# Programmer Filename Entry Section
#------------------------------------------------

set(CLUSTER ${CMAKE_CURRENT_BINARY_DIR})

#
# Source for example executables.
#
set(EXAMPLE_SRCS
    example1.cc
    example2.cc
    example3.cc
    example4.cc
    example5.cc
    example6.cc
    example9.cc
    example10.cc
    example11.cc
    example12.cc
    example13.cc
    example14.cc
    example15.cc
    exampleA1.cc
    exampleA2.cc
    )

SSPG_collect_example_sources(SheafSystemProgrammersGuide "${EXAMPLE_SRCS}")

