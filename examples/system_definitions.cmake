
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

#
# This file is the system level counterpart to the component_definitions file
# found in the top level of any component. Functions and variables
# that need to have system scope should be declared and/or defined here.
#

#
# Platform definitions
#
# OS is 64 bit Windows, compiler is cl 
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows" AND MSVC AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(WIN64MSVC ON CACHE BOOL "MS compiler in use.")
# OS is 64 bit Windows, compiler is icl
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows" AND CMAKE_CXX_COMPILER_ID MATCHES "Intel" AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(WIN64INTEL ON CACHE BOOL "Intel compiler in use.")
# OS is 64 bit linux, compiler is g++
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux" AND CMAKE_COMPILER_IS_GNUCXX AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
                OUTPUT_VARIABLE GCC_VERSION)
        if(GCC_VERSION VERSION_EQUAL 4.4 OR GCC_VERSION VERSION_GREATER 4.4 )            
            set(CMAKE_CXX_FLAGS "-std=c++0x")
        elseif(GCC_VERSION VERSION_GREATER 4.2.1 AND GCC_VERSION VERSION_LESS 4.4 )            
            set(CMAKE_CXX_FLAGS "-ansi")
        elseif(GCC_VERSION VERSION_LESS 4.2.2)
            message(FATAL "g++ ${GCC_VERSION} is unsupported. Version must be >= 4.2.2")                
        endif()
   set(LINUX64GNU ON CACHE BOOL "GNU CXX compiler ${GCC_VERSION} in use.")
# OS is 64 bit linux, compiler is icpc
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux" AND CMAKE_CXX_COMPILER_ID MATCHES "Intel" AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(LINUX64INTEL ON CACHE BOOL "Intel compiler in use.")
else()
    message(FATAL_ERROR "A 64 bit Windows or Linux environment was not detected; exiting")
endif()
#
# Set the cmake module path.
#
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules CACHE STRING "Location of Cmake modules")

#
# Set the default build type.
#
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug_contracts" CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

#
# Tell Cmake which configurations it should see and "Debug"
#
set_property(GLOBAL PROPERTY DEBUG_CONFIGURATIONS "Debug_contracts" "Debug_no_contracts" ) 

#
# Debug lib has "_d" appended to filename for Win32, "_debug" for Linux.
#
if(WIN32)
    set(CMAKE_DEBUG_CONTRACTS_POSTFIX "_d" CACHE STRING "Debug libs suffix")
    set(CMAKE_DEBUG_NO_CONTRACTS_POSTFIX "_d" CACHE STRING "Debug libs suffix")
else()
    set(CMAKE_DEBUG_CONTRACTS_POSTFIX "_debug" CACHE STRING "Debug libs suffix")
    set(CMAKE_DEBUG_NO_CONTRACTS_POSTFIX "_debug" CACHE STRING "Debug libs suffix")
endif()


set(ALL_BIN_TARGETS CACHE STRING "Aggregate list of component bin targets")
    
#
# Toggle intel compiler warnings.
#
set(INTELWARN CACHE BOOL "Toggle Intel compiler warnings")

#
# True if we want kd_lattice to link against VTK
#
#set(USE_VTK ON CACHE BOOL "Set to link geometry against VTK libs.")

#
# Toggle multi-process compilation in win32.
#
set(ENABLE_WIN32_MP ON CACHE BOOL "Toggle win32 compiler MP directive. Works for MS and Intel. Default is ON.")

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
# C++11 features
#
message(STATUS " ")
message(STATUS "Checking for C++11 Compliance - ")
message(STATUS " ")

include(${CMAKE_MODULE_PATH}/CheckCXX11Features.cmake)

# If SHEAFSYSTEM_HOME contains white space, escape it.
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
#  Make emacs tags
#
function(add_tags_target)

    if(LINUX64GNU OR LINUX64INTEL)
        add_custom_target(tags
            COMMAND find ${CMAKE_CURRENT_SOURCE_DIR} -name build -prune -o -name "*.cc" -print -o -name "*.h" -print -o -name "*.t.cc" -print | etags --c++ --members -
        )
    endif()

endfunction(add_tags_target) 

#
# Set the compiler flags per build configuration
#
function(set_compiler_flags)
       
       # Toggle multi-process compilation in Windows
       # Set in system_definitions.cmake
       if(ENABLE_WIN32_MP)
           set(MP "/MP")
       else()
           set(MP "")
       endif()
        
    if(WIN64MSVC)
       set(LPS_CXX_FLAGS "${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /EHsc" 
           CACHE STRING "C++ Compiler Flags")       
       set(LPS_SHARED_LINKER_FLAGS 
           "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /MACHINE:X64"
           CACHE STRING "Linker Flags for Shared Libs")
       set(LPS_EXE_LINKER_FLAGS 
           "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /MACHINE:X64" 
           CACHE STRING "Linker Flags for Executables")
    elseif(WIN64INTEL)
       set(LPS_CXX_FLAGS 
           "/D_USRDLL ${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /wd2651 /EHsc /Qprof-gen:srcpos /D_HDF5USEDLL_" 
           CACHE STRING "C++ Compiler Flags")
       set(LPS_SHARED_LINKER_FLAGS 
           "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /NXCOMPAT /MACHINE:X64" 
           CACHE STRING "Linker Flags") 
    elseif(LINUX64INTEL)
        if(ENABLE_COVERAGE)
            if(INTELWARN)
               set(LPS_CXX_FLAGS 
                   "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated -prof-gen=srcpos")
            else()
               set(LPS_CXX_FLAGS 
                   "-ansi -m64 -w0 -Wno-deprecated  -prof-gen=srcpos")
            endif()
        else()
            if(INTELWARN)
               set(LPS_CXX_FLAGS "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated ")
            else()
               set(LPS_CXX_FLAGS "-ansi -m64 -w0 -Wno-deprecated ")
            endif()
       endif() # ENABLE_COVERAGE        
    elseif(LINUX64GNU)
        # 12/20/13 -- added "-Wno-abi to suppress the following:
        #"SheafSystem/sheaves/support/primitive_attributes.h:115: 
        #note: The ABI of passing union with long double has changed in GCC 4.4"
        # The probrem is still there; we have only suppressed the warning.
        set(LPS_CXX_FLAGS "-m64 -Wno-deprecated -Wno-abi") 
    #$$TODO: A 32 bit option is not needed. Do away with this case.
    else() # Assume 32-bit i686 linux for the present
       set(LPS_CXX_FLAGS "-ansi -m32 -Wno-deprecated ")
    endif()

    #                 
    # DEBUG_CONTRACTS section
    #
        
    # Configuration specific flags 
    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_DEBUG_CONTRACTS 
            "${LPS_CXX_FLAGS} /Zi /D\"_ITERATOR_DEBUG_LEVEL=2\" /MDd /LDd /Od " 
            CACHE STRING "Flags used by the C++ compiler for Debug_contracts builds" )       
        set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_CONTRACTS "${LPS_SHARED_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRT" 
            CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS "${LPS_EXE_LINKER_FLAGS} /DEBUG" 
            CACHE STRING "Flags used by the linker for executables for Debug_contracts builds")            
        set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_CONTRACTS "${LPS_SHARED_LINKER_FLAGS} /DEBUG" 
            CACHE STRING "Debug_contracts linker flags - binding libs" )
    else() # Linux
        set(CMAKE_CXX_FLAGS_DEBUG_CONTRACTS "${LPS_CXX_FLAGS} -g " 
            CACHE STRING "Flags used by the C++ compiler for Debug_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS ${CMAKE_EXE_LINKER_FLAGS}  
            CACHE STRING "Flags used by the linker for executables for Debug_contracts builds")        
    endif()
    
    mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_DEBUG_CONTRACTS)

    #                 
    # DEBUG_NO_CONTRACTS section
    #      

    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS 
             "${LPS_CXX_FLAGS} /Zi /D\"_ITERATOR_DEBUG_LEVEL=2\" /MDd /LDd /Od /DNDEBUG " 
             CACHE STRING "Flags used by the C++ compiler for Debug_no_contracts builds" )            
        set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_NO_CONTRACTS 
             "${LPS_SHARED_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRT" 
             CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_DEBUG_NO_CONTRACTS 
             "${LPS_EXE_LINKER_FLAGS} /DEBUG" 
             CACHE STRING "Flags used by the linker for executables for Debug_contracts builds")                  
        set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS} /DEBUG" 
            CACHE STRING "Debug_no_contracts linker flags - binding libs" )
    else()
        set(CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS "${LPS_CXX_FLAGS} -g -DNDEBUG" CACHE
            STRING "Flags used by the C++ compiler for Debug_no_contracts builds" )
    endif()

    mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_DEBUG_NO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_DEBUG_NO_CONTRACTS)
         
    #                 
    # RELEASE_CONTRACTS section
    #

    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_RELEASE_CONTRACTS 
            "${LPS_CXX_FLAGS} /MD /LD /O2 " 
            CACHE STRING "Flags used by the C++ compiler for Release_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS 
            "${LPS_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD  /NXCOMPAT"  
            CACHE STRING "Flags used by the linker for executables for Release_contracts builds" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS}" 
            CACHE STRING "Flags used by the linker for shared libraries for Release_contracts builds" ) 
        set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS}" 
            CACHE STRING "Release_contracts linker flags - binding libs" )
    else()
        set(CMAKE_CXX_FLAGS_RELEASE_CONTRACTS "${LPS_CXX_FLAGS} " 
            CACHE STRING "Flags used by the C++ compiler for Release_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS "${LPS_EXE_LINKER_FLAGS}"  
            CACHE STRING "Flags used by the linker for executables for Release_contracts builds" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS "${LPS_SHARED_LINKER_FLAGS}" 
           CACHE STRING "Flags used by the linker for shared libraries for Release_contracts builds" )
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELEASE_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS)
         
    #                 
    # RELEASE_NO_CONTRACTS section
    #

    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS 
            "${LPS_CXX_FLAGS}  /MD /LD /O2 /DNDEBUG" 
            CACHE STRING "Flags used by the C++ compiler for Release_no_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
            "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD  /NXCOMPAT" 
            CACHE STRING "Flags used by the linker for executables for Release_no_contracts builds" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS}" 
            CACHE STRING "Flags used by the linker for shared libraries for Release_no_contracts builds" )
        set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS}" 
            CACHE STRING "Release_no_contracts linker flags - binding libs" )
    else()
        set(CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS 
            "${LPS_CXX_FLAGS}  -DNDEBUG" 
            CACHE STRING "Flags used by the C++ compiler for Release_no_contracts builds" )
        set(CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
            "${CMAKE_EXE_LINKER_FLAGS}" 
           CACHE STRING "Flags used by the linker for executables for Release_no_contracts builds" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS}" 
            CACHE STRING "Flags used by the linker for shared libraries for Release_no_contracts builds" )
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS)

    #                 
    # RelWithDebInfo_contracts section
    #

    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_CONTRACTS 
            "${LPS_CXX_FLAGS} /MD /LD /O2 " CACHE
            STRING "RelWithDebInfo_contracts compiler flags" )
        set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS 
            "${LPS_EXE_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRTD  /NXCOMPAT"  
            CACHE STRING "RelWithDebInfo_contracts linker flags - executables" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS} /DEBUG" CACHE
            STRING "RelWithDebInfo_contracts linker flags - shared libs" ) 
        set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS} /DEBUG" CACHE
            STRING "RelWithDebInfo_contracts linker flags - binding libs" )
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELWITHDEBINFO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS)
        
    #                 
    # RelWithDebInfo_no_contracts section
    #

    # Configuration specific flags         
    if(WIN64MSVC OR WIN64INTEL)
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
            "${LPS_CXX_FLAGS} /MD /LD /O2 /DNDEBUG" CACHE
            STRING "RelWithDebInfo_no_contracts compiler flags" )
        set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
            "${CMAKE_EXE_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRTD /NXCOMPAT" 
            CACHE STRING "RelWithDebInfo_no_contracts linker flags - executables" )
        set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS} /DEBUG" CACHE
            STRING "RelWithDebInfo_no_contracts linker flags - shared libs" )
        set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
            "${LPS_SHARED_LINKER_FLAGS} /DEBUG" CACHE
            STRING "RelWithDebInfo_no_contracts linker flags - binding libs" )
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELWITHDEBINFO_NO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS)
         
endfunction(set_compiler_flags)	