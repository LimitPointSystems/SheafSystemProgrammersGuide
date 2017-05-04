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

#------------------------------------------------------------------------------
# FUNCTION DEFINITION SECTION
#------------------------------------------------------------------------------

#
#  Define system level variables and initialize to default values.
#
function(SSPG_set_system_variable_defaults)
   
   # System level target lists

   set(ALL_UNIT_TEST_TARGETS CACHE STRING "Aggregate list of all unit test targets" FORCE)
   mark_as_advanced(FORCE ALL_UNIT_TEST_TARGETS) 

   set(ALL_BIN_TARGETS CACHE STRING "Aggregate list of all bin targets" FORCE)
   mark_as_advanced(FORCE ALL_BIN_TARGETS) 

   set(ALL_COMP_CHECK_TARGETS CACHE STRING "Aggregate list of all check targets" FORCE)
   mark_as_advanced(FORCE ALL_COMP_CHECK_TARGETS)

endfunction(SSPG_set_system_variable_defaults)


#
# Set platform definitions
#
function(SSPG_set_platform_variables)

   # Make sure platform variables are defined.

   set(SSPG_CXX_IMPLICIT_LINK_DIRECTORIES CACHE STRING "C++ compiler library directories." FORCE)
   mark_as_advanced(FORCE SSPG_CXX_IMPLICIT_LINK_DIRECTORIES)

   set(SSPG_WINDOWS OFF CACHE BOOL "True if platform is Windows" FORCE)
   mark_as_advanced(FORCE SSPG_WINDOWS)

   set(SSPG_LINUX OFF CACHE BOOL "True if platform is Linux" FORCE)
   mark_as_advanced(FORCE SSPG_LINUX)

   set(SSPG_WIN64MSVC OFF CACHE BOOL "True if platform is Windows and MS compiler in use." FORCE)
   mark_as_advanced(FORCE SSPG_WIN64MSVC)

   set(SSPG_WIN64INTEL OFF CACHE BOOL "True if platorm is Windows and Intel compiler in use." FORCE)
   mark_as_advanced(SSPG_WIN64INTEL)

   set(SSPG_LINUX64GNU OFF CACHE BOOL "True if platform is Linux and GNU CXX compiler in use." FORCE)
   mark_as_advanced(SSPG_LINUX64GNU)

   set(SSPG_LINUX64INTEL OFF CACHE BOOL "True if platform is Linux and Intel compiler in use." FORCE)
   mark_as_advanced(SSPG_LINUX64INTEL)   

   if(CMAKE_SIZEOF_VOID_P MATCHES "8")

      if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")

         # OS is 64 bit Windows 

         set(SSPG_WINDOWS ON CACHE BOOL "True if platform is Windows" FORCE)

         # Toggle multi-process compilation in win32.

         set(SSPG_ENABLE_WIN32_MP ON
            CACHE BOOL "Toggle win32 compiler MP directive. Works for MS and Intel. Default is ON.")
         mark_as_advanced(FORCE SSPG_ENABLE_WIN32_MP)

         # Turn on project folders for Visual Studio.

         set_property(GLOBAL PROPERTY USE_FOLDERS ON)

         if(MSVC)

            # OS is 64 bit Windows, compiler is cl 

            set(SSPG_WIN64MSVC ON CACHE BOOL "True if platform is Windows and MS compiler in use." FORCE)

         elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")

            # OS is 64 bit Windows, compiler is icl

            set(SSPG_WIN64INTEL ON CACHE BOOL "True if platorm is Windows and Intel compiler in use." FORCE)

            set(INTELWARN CACHE BOOL "Toggle Intel compiler warnings")
            mark_as_advanced(FORCE INTELWARN)

         else()

            message(FATAL_ERROR "Compiler ${CMAKE_CXX_COMPILER_ID} not supported.")

         endif()

      elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")

         # OS is 64 bit Linux 

         set(SSPG_LINUX ON CACHE BOOL "True if platform is Linux" FORCE)

         if(CMAKE_COMPILER_IS_GNUCXX)

            # OS is 64 bit linux, compiler is g++

            if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9.3)
               message(FATAL "g++ ${CMAKE_CXX_COMPILER_VERSION} is unsupported. Version must be >= 4.9.3")                
            endif()

            set(SSPG_LINUX64GNU ON CACHE BOOL "True if platform is Linux and GNU CXX compiler in use." FORCE)

         elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")

            # OS is 64 bit linux, compiler is icpc

            set(SSPG_LINUX64INTEL ON CACHE BOOL "True if platform is Linux and Intel compiler in use." FORCE)

            set(INTELWARN CACHE BOOL "Toggle Intel compiler warnings")
            mark_as_advanced(FORCE INTELWARN)

         else()

            message(FATAL_ERROR "Compiler ${CMAKE_CXX_COMPILER_ID} not supported.")

         endif(CMAKE_COMPILER_IS_GNUCXX)

         # The compiler library path; used to set LD_LIBRARY_PATH in env scripts.

         string(REPLACE ";" ":" lshfsys_lib_dirs "${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES}")
         set(SSPG_CXX_IMPLICIT_LINK_DIRECTORIES "${lshfsys_lib_dirs}" 
            CACHE STRING "C++ compiler library directories." FORCE)

      else()

         # Neither Windows or Linux

         message(FATAL_ERROR "Operating system ${CMAKE_HOST_SYSTEM_NAME} not supported")

      endif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")

   else(CMAKE_SIZEOF_VOID_P MATCHES "8")

         message(FATAL_ERROR "Only 64 bit platform supported.")

   endif(CMAKE_SIZEOF_VOID_P MATCHES "8")

   dbc_ensure_or(SSPG_WINDOWS SSPG_LINUX)

endfunction(SSPG_set_platform_variables)


#
# Set the compiler flags per build configuration
#
function(SSPG_set_compiler_flags)

   # Preconditions:

   dbc_require_or(SSPG_WINDOWS SSPG_LINUX)

   # Body:
   
   # Toggle multi-process compilation in Windows

   if(SSPG_ENABLE_WIN32_MP)
      set(MP "/MP")
   else()
      set(MP "")
   endif()
   
   if(SSPG_WIN64MSVC)

      # Windows with MS Visual C++ compiler.

      set(SSPG_CXX_FLAGS "${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /EHsc /wd4251" 
         CACHE STRING "C++ Compiler Flags")

      set(SSPG_SHARED_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /MACHINE:X64"
         CACHE STRING "Linker Flags for Shared Libs")

      set(SSPG_EXE_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /SUBSYSTEM:CONSOLE /MACHINE:X64" 
         CACHE STRING "Linker Flags for Executables")

      set(SSPG_EXE_LINKER_FLAGS_DEBUG "/DEBUG" CACHE STRING "Debug Linker Flags")

   elseif(SSPG_WIN64INTEL)

      # Windows with Intel compiler.

      set(SSPG_CXX_FLAGS "/D_USRDLL ${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /wd2651 /EHsc /Qprof-gen:srcpos /D_HDF5USEDLL_" 
         CACHE STRING "C++ Compiler Flags")

      set(SSPG_SHARED_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /NXCOMPAT /MACHINE:X64" 
         CACHE STRING "Linker Flags") 

      set(SSPG_EXE_LINKER_FLAGS CACHE STRING "Linker Flags for Executables")

      set(SSPG_EXE_LINKER_FLAGS_DEBUG CACHE STRING "Debug Linker Flags" )

   elseif(SSPG_LINUX64INTEL)

      # Linux with Intel compiler.

      if(SSPG_ENABLE_COVERAGE)
         if(INTELWARN)
            set(SSPG_CXX_FLAGS "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated -prof-gen=srcpos")
         else()
            set(SSPG_CXX_FLAGS "-ansi -m64 -w0 -Wno-deprecated  -prof-gen=srcpos")
         endif()
      else()
         if(INTELWARN)
            set(SSPG_CXX_FLAGS "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated ")
         else()
            set(SSPG_CXX_FLAGS "-ansi -m64 -w0 -Wno-deprecated ")
         endif()
      endif(SSPG_ENABLE_COVERAGE)

      set(SSPG_SHARED_LINKER_FLAGS CACHE STRING "Linker Flags") 

      set(SSPG_EXE_LINKER_FLAGS CACHE STRING "Linker Flags for Executables")

      set(SSPG_EXE_LINKER_FLAGS_DEBUG CACHE STRING "Debug Linker Flags" )
        
   elseif(SSPG_LINUX64GNU)

      # Linux with g++ compiler.

      # 12/20/13 -- added "-Wno-abi to suppress the following:
      #"SheafSystem/sheaves/support/primitive_attributes.h:115: 
      #note: The ABI of passing union with long double has changed in GCC 4.4"
      # The probrem is still there; we have only suppressed the warning.

      set(SSPG_CXX_FLAGS "-std=c++11 -m64 -Wno-deprecated -Wno-abi") 

      set(SSPG_SHARED_LINKER_FLAGS CACHE STRING "Linker Flags") 

      set(SSPG_EXE_LINKER_FLAGS CACHE STRING "Linker Flags for Executables")

      set(SSPG_EXE_LINKER_FLAGS_DEBUG CACHE STRING "Debug Linker Flags" )

   endif()

   mark_as_advanced(FORCE SSPG_CXX_FLAGS)
   mark_as_advanced(FORCE SSPG_SHARED_LINKER_FLAGS)
   mark_as_advanced(FORCE SSPG_EXE_LINKER_FLAGS)
   mark_as_advanced(FORCE SSPG_EXE_LINKER_FLAGS_DEBUG)
   
   # Configuration specific flags 

   #                 
   # DEBUG_CONTRACTS section
   #

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_DEBUG_CONTRACTS "${SSPG_CXX_FLAGS} /Zi /D\"_ITERATOR_DEBUG_LEVEL=2\" /MDd /LDd /Od " 
         CACHE STRING "Flags used by the C++ compiler for Debug_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRT" 
         CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Flags used by the linker for executables for Debug_contracts builds" FORCE)

      set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Debug_contracts linker flags - binding libs" )

   elseif(SSPG_LINUX) 

      set(CMAKE_CXX_FLAGS_DEBUG_CONTRACTS "${SSPG_CXX_FLAGS} -g " 
         CACHE STRING "Flags used by the C++ compiler for Debug_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS ${CMAKE_EXE_LINKER_FLAGS}  
         CACHE STRING "Flags used by the linker for executables for Debug_contracts builds")

      set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Debug_contracts linker flags - binding libs" )

   endif(SSPG_WINDOWS)
   
   mark_as_advanced(FORCE 
      CMAKE_CXX_FLAGS_DEBUG_CONTRACTS
      CMAKE_EXE_LINKER_FLAGS_DEBUG_CONTRACTS 
      CMAKE_SHARED_LINKER_FLAGS_DEBUG_CONTRACTS
      CMAKE_MODULE_LINKER_FLAGS_DEBUG_CONTRACTS)

   #                 
   # DEBUG_NO_CONTRACTS section
   #      

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_CXX_FLAGS} /Zi /D\"_ITERATOR_DEBUG_LEVEL=2\" /MDd /LDd /Od /DNDEBUG " 
         CACHE STRING "Flags used by the C++ compiler for Debug_no_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRT" 
         CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Flags used by the linker for executables for Debug_no_contracts builds" FORCE)

      set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Debug_no_contracts linker flags - binding libs" )

   elseif(SSPG_LINUX)

      set(CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_CXX_FLAGS} -g -DNDEBUG" 
         CACHE STRING "Flags used by the C++ compiler for Debug_no_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Debug_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Flags used by the linker for executables for Debug_no_contracts builds" FORCE)

      set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Debug_no_contracts linker flags - binding libs" )

   endif(SSPG_WINDOWS)

   mark_as_advanced(FORCE 
      CMAKE_CXX_FLAGS_DEBUG_NO_CONTRACTS
      CMAKE_EXE_LINKER_FLAGS_DEBUG_NO_CONTRACTS 
      CMAKE_SHARED_LINKER_FLAGS_DEBUG_NO_CONTRACTS
      CMAKE_MODULE_LINKER_FLAGS_DEBUG_NO_CONTRACTS)
   
   #                 
   # RELEASE_CONTRACTS section
   #

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_RELEASE_CONTRACTS "${SSPG_CXX_FLAGS}  /MD /LD /O2 " 
         CACHE STRING "Flags used by the C++ compiler for Release_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD  /NXCOMPAT" 
         CACHE STRING "Flags used by the linker for executables for Release_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Release_contracts builds" )

      set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Release_contracts linker flags - binding libs" )

   elseif(SSPG_LINUX)

      set(CMAKE_CXX_FLAGS_RELEASE_CONTRACTS "${SSPG_CXX_FLAGS} " 
         CACHE STRING "Flags used by the C++ compiler for Release_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS "${SSPG_EXE_LINKER_FLAGS}"  
         CACHE STRING "Flags used by the linker for executables for Release_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Release_contracts builds" )

      set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Release_contracts linker flags - binding libs" )

   endif(SSPG_WINDOWS)
   
   mark_as_advanced(FORCE 
      CMAKE_CXX_FLAGS_RELEASE_CONTRACTS
      CMAKE_EXE_LINKER_FLAGS_RELEASE_CONTRACTS 
      CMAKE_SHARED_LINKER_FLAGS_RELEASE_CONTRACTS
      CMAKE_MODULE_LINKER_FLAGS_RELEASE_CONTRACTS)
   
   #                 
   # RELEASE_NO_CONTRACTS section
   #

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_CXX_FLAGS}  /MD /LD /O2 /DNDEBUG" 
         CACHE STRING "Flags used by the C++ compiler for Release_no_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD  /NXCOMPAT" 
         CACHE STRING "Flags used by the linker for executables for Release_no_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Release_no_contracts builds" )

      set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Release_no_contracts linker flags - binding libs" )

   elseif(SSPG_LINUX)

      set(CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_CXX_FLAGS}  -DNDEBUG" 
         CACHE STRING "Flags used by the C++ compiler for Release_no_contracts builds" )

      set(CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${CMAKE_EXE_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for executables for Release_no_contracts builds" )

      set(CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Flags used by the linker for shared libraries for Release_no_contracts builds" )

      set(CMAKE_MODULE_LINKER_FLAGS_RELEASE_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS}" 
         CACHE STRING "Release_no_contracts linker flags - binding libs" )

   endif(SSPG_WINDOWS)
   
   mark_as_advanced(FORCE 
      CMAKE_CXX_FLAGS_RELEASE_NO_CONTRACTS
      CMAKE_EXE_LINKER_FLAGS_RELEASE_NO_CONTRACTS 
      CMAKE_SHARED_LINKER_FLAGS_RELEASE_NO_CONTRACTS
      CMAKE_MODULE_LINKER_FLAGS_RELEASE_NO_CONTRACTS)

   #                 
   # RelWithDebInfo_contracts section; Windows only.
   #

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_CONTRACTS "${SSPG_CXX_FLAGS} /MD /LD /O2 " 
         CACHE STRING "RelWithDebInfo_contracts compiler flags" )

      set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS "${SSPG_EXE_LINKER_FLAGS} /DEBUG /NODEFAULTLIB:MSVCRTD  /NXCOMPAT"
         CACHE STRING "RelWithDebInfo_contracts linker flags - executables" )

      set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS  "${CMAKE_EXE_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Flags used by the linker for executables for RelWithDebInfo_contracts builds" FORCE)

      set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "RelWithDebInfo_contracts linker flags - binding libs" )

      set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "RelWithDebInfo_contracts linker flags - shared libs" ) 
      
      mark_as_advanced(FORCE 
         CMAKE_CXX_FLAGS_RELWITHDEBINFO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS
         CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_CONTRACTS)

   endif(SSPG_WINDOWS)
   
   #                 
   # RelWithDebInfo_no_contracts section; Windows only.
   #

   if(SSPG_WINDOWS)

      set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_NO_CONTRACTS "${SSPG_CXX_FLAGS} /MD /LD /O2 /DNDEBUG" CACHE
         STRING "RelWithDebInfo_no_contracts compiler flags" )

      set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS
         "${CMAKE_EXE_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "Flags used by the linker for executables for RelWithDebInfo_no_contracts builds"
         FORCE)

      set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "RelWithDebInfo_contracts linker flags - shared libs" ) 

      set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS "${SSPG_SHARED_LINKER_FLAGS} ${SSPG_EXE_LINKER_FLAGS_DEBUG}" 
         CACHE STRING "RelWithDebInfo_contracts linker flags - binding libs" )
      
      mark_as_advanced(FORCE 
         CMAKE_CXX_FLAGS_RELWITHDEBINFO_NO_CONTRACTS
         CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS 
         CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS
         CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_NO_CONTRACTS)

   endif(SSPG_WINDOWS)
   
endfunction(SSPG_set_compiler_flags)


#
# Set debug configuration properties.
#
function(SSPG_set_debug_configuration)

   # Preconditions:

   dbc_require_or(SSPG_WINDOWS SSPG_LINUX)

   # Body:

   # Tell CMake which configurations are "debug"

   set_property(GLOBAL PROPERTY DEBUG_CONFIGURATIONS "Debug_contracts") 

   # Establish the file name suffix for debug type compiler output

   if(SSPG_WINDOWS)

      set(CMAKE_DEBUG_CONTRACTS_POSTFIX "_d" CACHE STRING "Debug libs suffix")
      mark_as_advanced(FORCE CMAKE_DEBUG_CONTRACTS_POSTFIX)

      set(CMAKE_DEBUG_NO_CONTRACTS_POSTFIX "_d" CACHE STRING "Debug libs suffix")
      mark_as_advanced(FORCE CMAKE_DEBUG_NO_CONTRACTS_POSTFIX)

   elseif(SSPG_LINUX)

      set(CMAKE_DEBUG_CONTRACTS_POSTFIX "_debug" CACHE STRING "Debug libs suffix")
      mark_as_advanced(FORCE CMAKE_DEBUG_CONTRACTS_POSTFIX)

      set(CMAKE_DEBUG_NO_CONTRACTS_POSTFIX "_debug" CACHE STRING "Debug libs suffix")
      mark_as_advanced(FORCE CMAKE_DEBUG_NO_CONTRACTS_POSTFIX)

   endif()

endfunction(SSPG_set_debug_configuration)

#
# Set the default build type.
#
function(SSPG_set_default_build_type)

   # Debug_contracts is the only supported type.
   
   if(NOT CMAKE_BUILD_TYPE)
      set(CMAKE_BUILD_TYPE "Debug_contracts" 
         CACHE 
         STRING 
         "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}."
         FORCE)
   elseif(NOT (CMAKE_BUILD_TYPE IN_LIST CMAKE_CONFIGURATION_TYPES))
      message(FATAL_ERROR "CMAKE_BUILD_TYPE must be one of ${CMAKE_CONFIGURATION_TYPES}")
   endif()
   
   # Build type isn't configurable so keep it out of the basic user interface.
   
   mark_as_advanced(FORCE CMAKE_BUILD_TYPE)

   # Set STRINGS property so GUI displays cycle-through or drop-down list.
   
   set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CMAKE_CONFIGURATION_TYPES})   

endfunction(SSPG_set_default_build_type)

#
# Set the default value for install location
#
function(SSPG_set_default_system_install_location)

   # There is no notion of installing SheafSystemTest.
   
   set(CMAKE_INSTALL_PREFIX "" CACHE STRING "System install location")
   mark_as_advanced(FORCE CMAKE_INSTALL_PREFIX)

endfunction(SSPG_set_default_system_install_location)

#
# Create the build output directories.
#
function(SSPG_create_output_dirs)

   # Preconditions:

   dbc_require_or(SSPG_WINDOWS SSPG_LINUX)

   # Body:

   # Create directory for documentation files.

   file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/documentation)
   
   # Visual Studio will generate cmake_build_dir folders for the current build type.
   # Linux needs to be told.

   if(SSPG_WINDOWS)

      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin PARENT_SCOPE)

      # Create build/lib for libraries.

      file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

      # Create build/bin for executables.

      file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin)        

   elseif(SSPG_LINUX)

      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib PARENT_SCOPE)
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib PARENT_SCOPE)
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/bin PARENT_SCOPE)
      
      # Create build/lib for libraries.

      file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib)
      
      # Create build/bin for executables.

      file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/bin)        

   endif(SSPG_WINDOWS)

endfunction(SSPG_create_output_dirs)

#
# Adds components to the system.
#
function(SSPG_add_components)

   set(lcomponents sheaf fiber_bundle field)

   foreach(comp ${lcomponents})
      add_subdirectory(${comp})
   endforeach()

endfunction(SSPG_add_components)

# 
# Get the current system date and store it in RESULT
#
macro(get_date RESULT)
   if(WIN32)
      execute_process(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ${RESULT})
      string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${RESULT} ${${RESULT}})
   elseif(UNIX)
      execute_process(COMMAND "date" "+%m/%d/%Y" OUTPUT_VARIABLE ${RESULT})
      string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${RESULT} ${${RESULT}})
   else(WIN32)
      message(WARNING "date not implemented")
      set(${RESULT} 000000)
   endif(WIN32)
endmacro(get_date)

function(SSPG_make_system_definitions)

   SSPG_set_system_variable_defaults()
   SSPG_set_platform_variables()
   SSPG_set_compiler_flags()
   SSPG_set_debug_configuration()
   SSPG_set_default_build_type()
   SSPG_set_default_system_install_location()

   include(${SSPG_CMAKE_MODULE_PATH}/find_prerequisites.cmake)
   SSPG_find_prerequisites()

endfunction(SSPG_make_system_definitions)

# 
# Convenience wrapper for the message function.
# The Eclipse Cmakeed plugin renders this pretty much obsolete
# from a pregramming viewpoint, but the syntax is prettier
# than what it wraps.
#
function(SSPG_status_message txt)

   # Let the user know what's being configured

   message(STATUS " ")
   message(STATUS "${txt} - ")
   message(STATUS " ")

#   message( " ")
#   message( "${txt} - ")
#   message( " ")

endfunction(SSPG_status_message)

#
# Configures the set_env_var scripts.
#
function(SSPG_configure_set_env_var_scripts)

   # Set the path to the SheafSytem lib directory; used by set_env_var scripts.

   set(SHEAFSYSTEM_LIB_DIR ${SSPG_SHEAFSYSTEM_ROOT}/${CMAKE_BUILD_TYPE}/lib
      CACHE STRING "Path to SheafSystem library directory" FORCE)
   mark_as_advanced(FORCE SHEAFSYSTEM_LIB_DIR)   

   configure_file(${SSPG_CMAKE_MODULE_PATH}/set_env_vars.csh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.csh)
   configure_file(${SSPG_CMAKE_MODULE_PATH}/set_env_vars.sh.cmake.in ${CMAKE_BINARY_DIR}/set_env_vars.sh)
   
endfunction(SSPG_configure_set_env_var_scripts)
