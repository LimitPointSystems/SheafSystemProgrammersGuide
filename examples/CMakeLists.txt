#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#

# Windows has a notion of Debug and Release builds. For practical purposes, "Release" is
# equivalent to "!Debug". We'll carry that notion through to linux/gcc as well for now, with
# "Release" equivalent to "!-g"
#
set(CMAKE_CONFIGURATION_TYPES Debug-contracts Debug-no-contracts Release-contracts Release-no-contracts CACHE
    STRING "Supported configuration types"
    FORCE)
 
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
add_clean_files()

#
# Configure the environment scripts. 
#
if(LINUX64GNU OR LINUX64INTEL)
    configure_file(${CMAKE_MODULE_PATH}/set_env_vars.csh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.csh)
    configure_file(${CMAKE_MODULE_PATH}/set_env_vars.sh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.sh)
endif()



