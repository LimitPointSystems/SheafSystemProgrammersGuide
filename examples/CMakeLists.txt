#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

set(CMAKE_CONFIGURATION_TYPES Debug-contracts Debug-no-contracts Release-contracts Release-no-contracts CACHE
    STRING "Supported configuration types"
    FORCE)

#
# Define the name of this component.
# 
project(examples)

cmake_minimum_required(VERSION 2.8.3)

#
# Include variable definitions and functions
# unique to and/or required at the system level.
#
include(system_definitions.cmake)

#
# Add components to the system
#
clear_component_variables(${PROJECT_NAME})

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
# Set the compiler optimization level
#
set_optimization_level()

#
# Set compiler flags for all build configurations
#
set_compiler_flags()

#
# Snapshot target for Visual Studio
#

if(WIN64)
    create_vswin64_snapshot_target()
endif()

#
# Set up output directories
#
create_output_dirs()

#
# Add the library targets
#
add_library_targets()

#
# Add Bindings targets
#
add_bindings_target()

#
# Add a check target
#
add_custom_target(check)

#
# Make a folder for the check targets
#
set_target_properties(check PROPERTIES FOLDER "Check Targets")

#
# Add the unit test targets
#
add_test_targets()

#
# Add the examples targets
#
add_example_targets()

#
# Add the documentation targets (doc, docclean)
#
add_doc_targets()

#
# Installation target
#
add_install_target()

#
# Add files to the clean target
#
add_clean_files()

#
# Generate emacs tags
#
add_tags_target()

#
# Configure the environment scripts. Output is in "build".
#
configure_file(${CMAKE_MODULE_PATH}/set_env_vars.csh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.csh)
configure_file(${CMAKE_MODULE_PATH}/set_env_vars.sh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.sh)
configure_file(${CMAKE_MODULE_PATH}/snapshot_vars.cmake.in ${CMAKE_BINARY_DIR}/snapshot_vars.cmake)

#
# System level is responsible for installing the documentation. The component list (see system_definitions.cmake)
# determines what components are included in the docs.
#
install(DIRECTORY ${CMAKE_BINARY_DIR}/documentation/ DESTINATION documentation)

#
# Cpack Setup
#
if(LINUX64)
    set(CPACK_PACKAGE_VERSION "${LIB_VERSION}") 
    set(CPACK_GENERATOR "TBZ2")
    include(CPack)
endif()

#
# Write this component's lib targets to an export file.
#
export_targets()

#
# Write this component's variables to an export file.
#
export_variables()
