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
# This file contains declarations and functions unique to this component.
#
    
#------------------------------------------------------------------------------
# FUNCTION DEFINITION SECTION
#------------------------------------------------------------------------------

#
# Create the library targets for this component.
#
function(ShfSysTst_add_sheaves_test_library_targets)

   #message("Entering sheaves_test/component_definitions.cmake:add_library_targets")

   # Preconditions:

   dbc_require_or(SHFSYSTST_WINDOWS SHFSYSTST_LINUX)

   # Body

   # Target to create copies of header files with path ${SHFSYSTST_HEADER_SCOPE}/*.h,
   # so uniquely scoped paths in include directives will work.

   ShfSysTst_add_component_scoped_headers_target(sheaves_test)

   if(SHFSYSTST_WINDOWS)
      
      # DLL.

      add_library(${SHEAVES_TEST_DYNAMIC_LIB} SHARED ${SHEAVES_TEST_SRCS})
      add_dependencies(${SHEAVES_TEST_DYNAMIC_LIB} sheaves_test_scoped_headers)
#      target_include_directories(${SHEAVES_TEST_DYNAMIC_LIB}
#         PUBLIC ${SHEAVES_TEST_IPATH} ${CMAKE_BINARY_DIR}/include)
      target_include_directories(${SHEAVES_TEST_DYNAMIC_LIB} PUBLIC ${CMAKE_BINARY_DIR}/include)
      target_link_libraries(${SHEAVES_TEST_DYNAMIC_LIB} PUBLIC ${SHEAVES_IMPORT_LIB})
      set_target_properties(${SHEAVES_TEST_DYNAMIC_LIB} PROPERTIES FOLDER "Library Targets")

      # Override cmake's placing of "${SHEAVES_TEST_DYNAMIC_LIB}_EXPORTS
      # into the preproc symbol table.

      set_target_properties(${SHEAVES_TEST_DYNAMIC_LIB}
         PROPERTIES DEFINE_SYMBOL "SHEAF_DLL_EXPORTS")

      # Static library

      add_library(${SHEAVES_TEST_STATIC_LIB} STATIC ${SHEAVES_TEST_SRCS})            

   elseif(SHFSYSTST_LINUX)

      # Static library; depends on imported libsheaves target

      add_library(${SHEAVES_TEST_STATIC_LIB} STATIC ${SHEAVES_TEST_SRCS})
      add_dependencies(${SHEAVES_TEST_STATIC_LIB} sheaves_test_scoped_headers)
#      target_include_directories(${SHEAVES_TEST_STATIC_LIB}
#         PUBLIC ${SHEAVES_TEST_IPATH} ${CMAKE_BINARY_DIR}/include)
      target_include_directories(${SHEAVES_TEST_STATIC_LIB} PUBLIC ${CMAKE_BINARY_DIR}/include)
      target_link_libraries(${SHEAVES_TEST_STATIC_LIB} ${SHEAVES_STATIC_LIB})

      # Not clear why we are setting output_name for the library
      # or whether the value is correct.

      set_target_properties(${SHEAVES_TEST_STATIC_LIB} PROPERTIES OUTPUT_NAME sheaves_test)

      # Shared library

      add_library(${SHEAVES_TEST_SHARED_LIB} SHARED ${SHEAVES_TEST_SRCS})
      add_dependencies(${SHEAVES_TEST_SHARED_LIB} sheaves_test_scoped_headers)
#      target_include_directories(${SHEAVES_TEST_SHARED_LIB}
#         PUBLIC ${SHEAVES_TEST_IPATH} ${CMAKE_BINARY_DIR}/include)
      target_include_directories(${SHEAVES_TEST_SHARED_LIB} PUBLIC ${CMAKE_BINARY_DIR}/include)
      target_link_libraries(${SHEAVES_TEST_SHARED_LIB} ${SHEAVES_SHARED_LIB})

      set_target_properties(${SHEAVES_TEST_SHARED_LIB} PROPERTIES LINKER_LANGUAGE CXX)

      # Not clear why we are setting output_name for the library
      # or whether the value is correct.

      set_target_properties(${SHEAVES_TEST_SHARED_LIB} PROPERTIES OUTPUT_NAME sheaves_test)
      
      # Override cmake's placing of "${COMPONENT_LIB}_EXPORTS into the preproc symbol table.
      # CMake apparently detects the presence of cdecl_dllspec in the source and places
      # -D<LIBRARY>_EXPORTS into the preproc symbol table no matter the platform.

      set_target_properties(${SHEAVES_TEST_SHARED_LIB} PROPERTIES DEFINE_SYMBOL "")
      
      # Define the library version.

      set_target_properties(${SHEAVES_TEST_SHARED_LIB} PROPERTIES VERSION ${LIB_VERSION})  
      
      # Library alias definitions; 

      add_custom_target(sheaves_test-static-lib)
      add_dependencies(sheaves_test-static-lib ${SHEAVES_TEST_STATIC_LIB})

      add_custom_target(sheaves_test-shared-lib)
      add_dependencies(sheaves_test-shared-lib ${SHEAVES_TEST_SHARED_LIB})
      
   endif()

   #message("Leaving sheaves_test/component_definitions.cmake:add_library_targets")

endfunction(ShfSysTst_add_sheaves_test_library_targets)


