#
# $RCSfile: CMakeLists.txt,v $ $Revision: 1.6 $ $Date: 2012/01/26 18:55:32 $
#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
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

cmake_minimum_required(VERSION 2.8.8)

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
# Initialize all variables for this component.
#
set_component_vars()

#
# Add the clusters to the project
#
add_clusters("${clusters}")

#
# Set compiler flags for all build configurations
#
set_compiler_flags()

#
# Set up output directories
#
create_output_dirs()

#
# Add the unit test targets
#
add_example_targets()

#
# Add the documentation targets (doc, docclean)
#
add_doc_targets()

#
# Add files to the clean target
#
add_clean_files()

#
# Configure the environment scripts. Output is in "build".
#
configure_file(${CMAKE_MODULE_PATH}/set_env_vars.csh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.csh)
configure_file(${CMAKE_MODULE_PATH}/set_env_vars.sh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.sh)



