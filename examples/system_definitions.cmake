#
# $RCSfile: system_definitions.cmake,v $ $Revision $ $Date $
#
#
# Copyright (c) 2011 Limit Point Systems, Inc.
#
#
# This file is the system level counterpart to the component_definitions file
# found in the top level of any component. Functions and variables
# that need to have system scope should be declared and/or defined here.
#

# Set backward compatibility so we can link to modules. If not, we can't link to the bindings libs.
set(CMAKE_BACKWARDS_COMPATIBILITY 2.2 CACHE STRING "backward compat so we can link to bindings libs")

#
# Platform definitions
#

# OS is 64 bit Windows, compiler is MSVC
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows" AND MSVC AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(WIN64 1)
# OS is 64 bit linux, compiler is g++
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux" AND CMAKE_COMPILER_IS_GNUCXX AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(LINUX64 1)
else()
    message(FATAL_ERROR "A 64 bit Windows or Linux environment was not detected; exiting")
endif()

set(EXPORTS_FILE ${PROJECT_NAME}-exports.cmake CACHE STRING "System exports file name")

# Windows has a notion of Debug and Release builds. For practical purposes, "Release" is
# equivalent to "not Debug". We'll carry that notion through to linux/gcc as well for now, with
# "Release" equivalent to "!-g"
set(CMAKE_CONFIGURATION_TYPES Debug-contracts Debug-no-contracts Release-contracts Release-no-contracts CACHE
    STRING "Supported configuration types"
    FORCE)

#
# Delete the exports file at the start of each cmake run
#
execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_BINARY_DIR}/${EXPORTS_FILE})

#
# Set the default build type.
#
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug-contracts" CACHE STRING
      "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}."      
      FORCE)
endif(NOT CMAKE_BUILD_TYPE)

#
# True if we want this component to use VTK
#
set(USE_VTK ON CACHE BOOL "Set to link geometry against VTK libs.")

#   
#  Type of system documentation to build: Dev or User
#
if(NOT LPS_DOC_STATE)
    set(LPS_DOC_STATE Dev CACHE STRING "Type of documentation to build: [Dev|User]")
endif()

#
# Set compiler optimization level.
#

set(OPTIMIZATION_LEVEL "0" CACHE STRING "Compiler optimization level. Valid values for are 0,1,2,3, and \"s\(Linux only\)\". Default is 0. \n Linux values translate to -On. \n\n Windows values are: \n\n 0 = /0d \(no optimization\) \n 1 = /O1 \(Minimize Size\) \n 2 = /O2 \(Maximize Speed\) \n 3 = /GL \(Whole Program Optimization\) \n ")

#
# Default linux installation location is /usr/local
# Set a default where the user has write permission ; in this
# case, the top of the components source tree.
# "lib", "include", and "bin" will be appended to this location.
# See "add_install_target" in LPSCommon for source.
#
if(LINUX64)
    set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR} CACHE STRING "System install location")
elseif(WIN64)
    set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR} CACHE STRING "System install location")
endif()

#
# Establish the version number for this build.
# This is only relevant for releases. 1.36.18 is chosen here
# simply because that is our current release number.
# $$TODO: Finish this mechanism. The goal is to eventually have our
# release script call "cmake -D:LIB_VERSION=xx.xx.xx ..". In this way,
# The libraries all get the release version in their file system names and 
# their sonames.
#

set(LIB_VERSION 1.1.1 CACHE STRING "Library version number for release purposes")

mark_as_advanced(LIB_VERSION)

#
# Set the cmake module path.
#
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)

#
# Targets with global scope are declared and optionally defined in 
# target_declarations.cmake; otherwise defined at first use.
#
include(${CMAKE_MODULE_PATH}/target_declarations.cmake)

#
# Prerequisite discovery
#
include(${CMAKE_MODULE_PATH}/find_prerequisites.cmake)

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
    unset(${COMP}_CHECK_EXEC_SRCS CACHE)

    # clear the example binaries var so consecutive cmake runs don't
    # list the same sources n times.
    unset(${COMP}_EXEC_SRCS CACHE)
    
    # clear the unit tests var so consecutive cmake runs don't
    # list the same unit tests n times.
    unset(${COMP}_CHECK_EXECS CACHE)
    
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
    if(LINUX64)
        if(${OPTIMIZATION_LEVEL} STREQUAL 0)
            set(OPTIMIZATION "-O" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} STREQUAL 1)
            set(OPTIMIZATION "-O1" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 2)
            set(OPTIMIZATION "-O2" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} STREQUAL 3)
            set(OPTIMIZATION "-O3" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} STREQUAL s)
            set(OPTIMIZATION "-Os" PARENT_SCOPE)
        else()
            break()
        endif()   # anything else, exit.
    elseif(WIN64)
        if(${OPTIMIZATION_LEVEL} STREQUAL 0)
            set(OPTIMIZATION "/Od" PARENT_SCOPE)    
        elseif(${OPTIMIZATION_LEVEL} STREQUAL 1)
            set(OPTIMIZATION "/O1" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} EQUAL 2)
            set(OPTIMIZATION "/O2" PARENT_SCOPE)
        elseif(${OPTIMIZATION_LEVEL} STREQUAL 3)
            set(OPTIMIZATION "/GL" PARENT_SCOPE)    
        endif()
    endif()    
endfunction(set_optimization_level)

# 
#  Make emacs tags
#
function(add_tags_target)

    if(LINUX64)
        add_custom_target(tags
            COMMAND find ${CMAKE_CURRENT_SOURCE_DIR} -name build -prune -o -name "*.cc" -print -o -name "*.h" -print -o -name "*.t.cc" -print | etags --c++ --members -
        )
    endif()

endfunction(add_tags_target) 
