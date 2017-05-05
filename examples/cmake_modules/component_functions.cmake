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
# Functions called from <component>/CMakeLists.txt.
#------------------------------------------------------------------------------

# 
# Declare and initialize all variables that are component-specific.
#
function(SSPG_set_component_variables xcomponent_name)

   # Preconditions:

   dbc_require_or(SSPG_WINDOWS SSPG_LINUX)

   # Body:

   string(TOUPPER ${xcomponent_name} LCOMP_NAME_UC)
   string(TOLOWER ${xcomponent_name} lcomp_name_lc)

   # Source collection variables.

   set(${LCOMP_NAME_UC}_SRCS CACHE STRING "${lcomp_name_lc} sources" FORCE)
   mark_as_advanced(FORCE ${LCOMP_NAME_UC}_SRCS)

   set(${LCOMP_NAME_UC}_INCS CACHE STRING "${lcomp_name_lc} includes" FORCE)
   mark_as_advanced(FORCE ${LCOMP_NAME_UC}_INCS)

   set(${LCOMP_NAME_UC}_UNIT_TEST_SRCS CACHE STRING "${lcomp_name_lc} unit test sources" FORCE)
   mark_as_advanced(FORCE ${LCOMP_NAME_UC}_UNIT_TEST_SRCS)

   set(${LCOMP_NAME_UC}_EXAMPLE_SRCS CACHE STRING "${lcomp_name_lc} example sources" FORCE)
   mark_as_advanced(FORCE ${LCOMP_NAME_UC}_EXAMPLE_SRCS)

   # Executable variables

   set(${LCOMP_NAME_UC}_UNIT_TESTS CACHE STRING "List of unit test binaries" FORCE)
   mark_as_advanced(${LCOMP_NAME_UC}_UNIT_TESTS)

   set(${LCOMP_NAME_UC}_EXAMPLES CACHE STRING "List of example binaries" FORCE)      
   mark_as_advanced(${LCOMP_NAME_UC}_EXAMPLES)    

endfunction(SSPG_set_component_variables)

#
# Add the list of clusters to this component.
#
function(SSPG_add_clusters clusters)

   foreach(cluster ${clusters})

      # Add each cluster subdir to the project. 

      add_subdirectory(${cluster})

   endforeach()

endfunction(SSPG_add_clusters)

# 
# Create a target for each example.
#
function(SSPG_add_component_example_targets xcomponent_name)

   # Preconditions:

   dbc_require_or(SSPG_WINDOWS SSPG_LINUX)

   # Body

   string(TOUPPER ${xcomponent_name} LCOMP_NAME_UC)
   string(TOLOWER ${xcomponent_name} lcomp_name_lc)

   # Set the path to the SheafSystem bin directory; used by debugger paths below.

   set(SSPG_SHEAFSYSTEM_BIN_DIR "${SSPG_SHEAFSYSTEM_ROOT}/bin"
      CACHE STRING "Path to SheafSystem bin directory" FORCE)
   mark_as_advanced(FORCE SSPG_SHEAFSYSTEM_BIN_DIR)   

   # $$TODO: Decompose into OS specific routines as test_tagets above.

   foreach(t_cc_file ${${LCOMP_NAME_UC}_EXAMPLE_SRCS})

      # Deduce name of executable from source filename

      string(REPLACE .cc "" t_file_with_path ${t_cc_file})

      # Remove path information so the executable goes into build/bin (or build/VisualStudio)
      # and not into build/bin/examples (or build/VisualStudio/examples)

      get_filename_component(t_file ${t_file_with_path} NAME)
      set(${LCOMP_NAME_UC}_EXAMPLES ${${LCOMP_NAME_UC}_EXAMPLES} ${t_file} CACHE STRING "List of example binaries" FORCE)      

      # Add building of executable and link with shared library

      add_executable(${t_file} ${t_cc_file})
      
      # Make sure the library is up to date

      if(SSPG_WINDOWS)

         target_link_libraries(${t_file} ${FIELDS_IMPORT_LIB})

         # Insert the unit tests into the VS folder "unit_tests"

         set_target_properties(${t_file} PROPERTIES FOLDER "Example Targets")

         # Set up the debugger environment for this target.
         # Apparently CMake or Visual Studio automatically appends the build type.

         set(SSPG_DEBUGGER_PATH1 "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
         file(TO_NATIVE_PATH "${SSPG_DEBUGGER_PATH1}" SSPG_DEBUGGER_PATH1)

         set(SSPG_DEBUGGER_PATH2 "${SSPG_SHEAFSYSTEM_BIN_DIR}")
         file(TO_NATIVE_PATH "${SSPG_DEBUGGER_PATH2}" SSPG_DEBUGGER_PATH2)
         
         configure_file(${SSPG_CMAKE_MODULE_PATH}/project.vcxproj.user.in 
            ${CMAKE_BINARY_DIR}/${t_file}.vcxproj.user @ONLY)

      elseif(SSPG_LINUX)

         target_link_libraries(${t_file} ${FIELDS_SHARED_LIB})

      endif()
      
      # Supply the *_DLL_IMPORTS directive to preprocessor

      set_target_properties(${t_file} PROPERTIES COMPILE_DEFINITIONS "SHEAF_DLL_IMPORTS")
      
   endforeach()

endfunction(SSPG_add_component_example_targets)

#------------------------------------------------------------------------------
# Functions called from <cluster>/CMakeLists.txt.
#------------------------------------------------------------------------------

#
# Append standalone executables to their respective component variables
# Used in cluster level CMakeLists.txt
#
function(SSPG_collect_example_sources xcomponent_name xexample_srcs)

   # Prepend the path to each member of the execs list

   set(execsrcs)
   foreach(src ${xexample_srcs})
      list(APPEND execsrcs ${CMAKE_CURRENT_SOURCE_DIR}/${src})
   endforeach()

   string(TOUPPER ${xcomponent_name} LCOMP_NAME_UC)

   set(${LCOMP_NAME_UC}_EXAMPLE_SRCS ${${LCOMP_NAME_UC}_EXAMPLE_SRCS} ${execsrcs} 
      CACHE STRING "EXEC sources." FORCE)

endfunction(SSPG_collect_example_sources)

