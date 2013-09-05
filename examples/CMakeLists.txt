
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

if(WIN32)
    set(CMAKE_CONFIGURATION_TYPES Debug-contracts Debug-no-contracts Release-contracts Release-no-contracts 
         RelWithDebInfo-contracts RelWithDebInfo-no-contracts CACHE STRING "Supported configuration types" FORCE)
else()
    set(CMAKE_CONFIGURATION_TYPES Debug-contracts Debug-no-contracts Release-contracts Release-no-contracts 
             CACHE STRING "Supported configuration types" FORCE)
endif()
project(examples)

message(STATUS "Processing ${PROJECT_NAME}")

cmake_minimum_required(VERSION 2.8.6)

#
# Include variable definitions and functions
# unique to and/or required at the system level.
#
include(system_definitions.cmake)

clear_component_variables(${PROJECT_NAME})

#
# Set the cmake module path.
#
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)

#
# Include the functions and variable definitions unigue to this component.
#
include(${CMAKE_CURRENT_SOURCE_DIR}/component_definitions.cmake)

#
# Set compiler flags for all build configurations
#
set_compiler_flags()

#
# Set the compiler optimization level
#
set_optimization_level()

#
# Set up output directories
#
create_output_dirs()

#
# Add the individual example targets.
#
add_example_targets()

#
# Add the cumulative examples target.
#
add_custom_target(examples)
add_dependencies(examples ${${COMPONENT}_EXAMPLES}})
    
#
# Add files to the clean target
#
#add_clean_files()

#
# Configure the environment scripts. 
#
if(LINUX64GNU OR LINUX64INTEL)
    configure_file(${CMAKE_MODULE_PATH}/set_env_vars.csh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.csh)
    configure_file(${CMAKE_MODULE_PATH}/set_env_vars.sh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.sh)
endif()



