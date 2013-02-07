#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#
# This file is the system level counterpart to the component_definitions file
# found in the top level of any component. Functions and variables
# that need to have system scope should be declared and/or defined here.
#

#
# Establish the list of components in this system
#
set(COMPONENTS sheaf fiber_bundle field CACHE STRING "List of components in this system" FORCE)

#
# Set the cmake module path.
#
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules CACHE STRING "Location of Cmake modules")

#
# Set the default build type.
#

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug-contracts" CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

set(ALL_BIN_TARGETS CACHE STRING "Aggregate list of component bin targets")
    
#
# $$HACK Toggle intel compiler warnings.
#
set(INTELWARN CACHE BOOL "Toggle Intel compiler warnings")

#
# Toggle multi-process compilation in win32.
#
set(ENABLE_WIN32_MP OFF CACHE BOOL "Toggle win32 compiler MP directive. Works for MS and Intel. Default is OFF.")

#   
#  Type of system documentation to build: Dev or User
#
if(NOT LPS_DOC_STATE)
    set(LPS_DOC_STATE Dev CACHE STRING "Type of documentation to build: [Dev|User]")
endif()

#
# Set compiler optimization level.
# Default is zero.
#
#$$TODO: Make certain optimization values for win32 compilers are valid. Adding win32 clause was "down and dirty".
#$$TODO: We still need provision for user set opt levels. Can't always force "2" on the user.

if(LINUX64GNU OR LINUX64INTEL)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug-contracts" OR CMAKE_BUILD_TYPE STREQUAL "Debug-no-contracts")
        set(OPTIMIZATION_LEVEL "0" CACHE STRING "Compiler optimization level. Valid values for are 0,1,2,3, and \"s\(Linux only\)\". Default is 0. \n Linux values translate to -On. \n\n Windows values are: \n\n 0 = /0d \(no optimization\) \n 1 = /O1 \(Minimize Size\) \n 2 = /O2 \(Maximize Speed\) \n 3 = /GL \(Whole Program Optimization\) \n " FORCE)
    else()
        # Optimize for execution speed.
        set(OPTIMIZATION_LEVEL "2" CACHE STRING "Compiler optimization level. Valid values for are 0,1,2,3, and \"s\(Linux only\)\". Default is 0. \n Linux values translate to -On. \n\n Windows values are: \n\n 0 = /0d \(no optimization\) \n 1 = /O1 \(Minimize Size\) \n 2 = /O2 \(Maximize Speed\) \n 3 = /GL \(Whole Program Optimization\) \n " FORCE)
    endif()
else() # Win32
    if($(Outdir) STREQUAL "Debug-contracts" OR $(Outdir) STREQUAL "Debug-no-contracts")
        set(OPTIMIZATION_LEVEL "0" CACHE STRING "Compiler optimization level. Valid values for are 0,1,2,3, and \"s\(Linux only\)\". Default is 0. \n Linux values translate to -On. \n\n Windows values are: \n\n 0 = /0d \(no optimization\) \n 1 = /O1 \(Minimize Size\) \n 2 = /O2 \(Maximize Speed\) \n 3 = /GL \(Whole Program Optimization\) \n " FORCE)
    else()
        # Optimize for execution speed.
        set(OPTIMIZATION_LEVEL "2" CACHE STRING "Compiler optimization level. Valid values for are 0,1,2,3, and \"s\(Linux only\)\". Default is 0. \n Linux values translate to -On. \n\n Windows values are: \n\n 0 = /0d \(no optimization\) \n 1 = /O1 \(Minimize Size\) \n 2 = /O2 \(Maximize Speed\) \n 3 = /GL \(Whole Program Optimization\) \n " FORCE)
    endif()
endif()
mark_as_advanced(OPTIMIZATION_LEVEL)

#
# Default linux installation location is /usr/local
# Set a default where the user has write permission ; in this
# case, the top of the components source tree.
# "lib", "include", and "bin" will be appended to this location.
# See "add_install_target" in cmake_modules/LPSCommon.cmake for source.
#
set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR} CACHE STRING "System install location")

#
# Establish the version number for this build.
# This is only relevant for releases. 1.1.1 is chosen here
# simply as a stub.
#
set(LIB_VERSION 1.1.1 CACHE STRING "Library version number for release purposes")
mark_as_advanced(LIB_VERSION)

#
# Targets with global scope are declared and optionally defined in 
# target_declarations.cmake; otherwise defined at first use.
#
include(${CMAKE_MODULE_PATH}/target_declarations.cmake)

#
# Prerequisite discovery
#
include(${CMAKE_MODULE_PATH}/find_prerequisites.cmake)

# If SHEAFSYSTEM_HOME contains white space, escape it.
#string(REGEX REPLACE " " "\\\\ "  SHEAFSYSTEM_HOME "${SHEAFSYSTEM_HOME}")
file(TO_NATIVE_PATH "${SHEAFSYSTEM_HOME}" SHEAFSYSTEM_HOME)

# When we are dealing with an install, the hdf and tetgen include files are
# in the release include dir. If it's a build directory, then we need to know where
# the prereqs are. The includes below are defind in SheafSystem-exports.cmake
# If there's a RELEASE file in SHEAFSYSTEM_HOME, then we are dealing with a release.
if(NOT EXISTS ${SHEAFSYSTEM_HOME}/RELEASE)
    include_directories(${HDF_INCLUDE_DIR})
    include_directories(${TETGEN_INCLUDE_DIR})
endif()

#
# Clear cached variables at the start of each cmake run.
#
function(clear_component_variables comp)

    string(TOUPPER ${comp} COMP)

    # clear the srcs vars so consecutive cmake runs don't
    # list the same sources n times.
    unset(${COMP}_SRCS CACHE)
    
    # clear the unit tests var so consecutive cmake runs don't
    # list the same sources n times.
    unset(${COMP}_UNIT_TEST_SRCS CACHE)

    # clear the example binaries var so consecutive cmake runs don't
    # list the same sources n times.
    unset(${COMP}_EXAMPLE_SRCS CACHE)
    
    # clear the unit tests var so consecutive cmake runs don't
    # list the same unit tests n times.
    unset(${COMP}_UNIT_TESTS CACHE)
    
    # clear the unit tests var so consecutive cmake runs don't
    # list the same includes n times.
    unset(${COMP}_INCS CACHE)
    
    # clear the ipath var so consecutive cmake runs don't
    # list the same include paths n times.
    unset(${COMP}_IPATH CACHE)
    
endfunction(clear_component_variables)

#
# Set compiler optimization level.
#
function(set_optimization_level)

    if(LINUX64GNU OR LINUX64INTEL)
        if(${OPTIMIZATION_LEVEL} EQUAL 0)
            set(OPTIMIZATION "-O0" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 1)
            set(OPTIMIZATION "-O1" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 2)
            set(OPTIMIZATION "-O2" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 3)
            set(OPTIMIZATION "-O3" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL s)
            set(OPTIMIZATION "-Os" PARENT_SCOPE)
        else()
            break()
        endif()   # anything else, exit.
    elseif(WIN64MSVC OR WIN64INTEL)
        if(${OPTIMIZATION_LEVEL} EQUAL 0)
            set(OPTIMIZATION "/Od" PARENT_SCOPE)    
        elseif(${OPTIMIZATION_LEVEL} EQUAL 1)
            set(OPTIMIZATION "/O1" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 2)
            set(OPTIMIZATION "/O2" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 3)
            set(OPTIMIZATION "/GL" PARENT_SCOPE)    
        endif()
    endif()    

endfunction(set_optimization_level)

# 
#  Make emacs tags
#
function(add_tags_target)

    if(LINUX64GNU OR LINUX64INTEL)
        add_custom_target(tags
            COMMAND find ${CMAKE_CURRENT_SOURCE_DIR} -name build -prune -o -name "*.cc" -print -o -name "*.h" -print -o -name "*.t.cc" -print | etags --c++ --members -
        )
    endif()

endfunction(add_tags_target) 
