#
# Copyright (c) 2014 Limit Point Systems, Inc. 
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

#
# Information omitted from CMake documentation and discussion regarding CTest and CDash:
#
# 1. CTestConfig.cmake must be in the top level of your project.
#
#    1.1 DROP_SITE value must be a FQDN sans "http://". Numerical IP will not work!
#
#    1.2 If the system is multi-component, then the vars in CTestConfig.cmake
#        must be cached so they are placed in the cmake global namespace and 
#        therefore visible to all components.
#
# 2. The prerequisite for all ctest targets e.g. "Experimental" is ALL.
#     If you plan to submit tests to a dashboard, it might be a good idea
#     to carefully review what constitutes "ALL" in your system to avoid
#     uneccessary time consuming tasks.
#
# 3. It is only neccessary to include CTest at the top level of the System.
#    enable_testing() is implied by the inclusion of the CTest modules and
#    therefore an explicit reference to it is redundant and perhaps problematic
#    under certain conditions. 
#    2016-5-23: If Ctest is only included at top level, component check targets
#    complain they can't find the configuration file DartConfiguration.tcl. 
#    Moved include(CTest) to component CMakeLists.txt files.

#
# Specify the minimum cmake version.
#
cmake_minimum_required(VERSION 3.5.0)

#
# Make sure if() treats constants like TRUE as constants 
# rather than implicitly treating them as variables and trying to dereference them.

cmake_policy(SET CMP0012 NEW)

# Setting CMAKE_CONFIGURATION_TYPES prior to the project function call
# will eliminate the default configuration types (debug,release,RelWithDebugInfo, et al.) --
# or at least stop them from appearing in the VS configuration list.
# It does NOT stop cmake from setting all the cache variables associated with those same
# configurations however.

set(CMAKE_CONFIGURATION_TYPES Debug_contracts CACHE STRING "Supported configuration types" FORCE)
mark_as_advanced(FORCE CMAKE_CONFIGURATION_TYPES)

#
# Establish the project name
#    
project(SheafSystemProgrammersGuide)

#
# Set the cmake module path.
#
set(SSPG_CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules"
   CACHE STRING "Location of SheafSystemProgrammersGuide Cmake modules")
mark_as_advanced(FORCE SSPG_CMAKE_MODULE_PATH)

# Make the requires and ensures functions available.

include(${SSPG_CMAKE_MODULE_PATH}/design_by_contract.cmake)

#
# Include variable definitions and functions
# unique to and/or required at the system level.
#
include(system_definitions.cmake)
SSPG_make_system_definitions()

#
# Set up output directories
#
SSPG_create_output_dirs()

include(${SSPG_CMAKE_MODULE_PATH}/component_functions.cmake)

#
# Initialize variables
#
SSPG_set_component_variables(SheafSystemProgrammersGuide)

#
# Define the clusters for this component.
#
set(clusters sheaf fiber_bundle field)

#
# Add clusters to the (single component) system
#
SSPG_add_clusters("${clusters}")

#
# Add all the example targets.
#
SSPG_add_component_example_targets(SheafSystemProgrammersGuide)

#
# Add all the system level targets.
#
include(${SSPG_CMAKE_MODULE_PATH}/target_declarations.cmake)
SSPG_add_system_targets()

#
# Configure the environment variable scripts. 
#
if(SSPG_LINUX)
   SSPG_configure_set_env_var_scripts()
endif()
