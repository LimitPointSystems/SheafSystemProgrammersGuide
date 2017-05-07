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
# Checks if the variable with name xvar_name is a valid absolute path to a directory.
#
function(SSPG_check_dir_prereq xvar_name)
   # message("Entering SSPG_check_dir_prereq")
   
   # Body:

   if(NOT IS_ABSOLUTE ${${xvar_name}})

      # Path is not absolute.
      
      message("Error in ${xvar_name}: path ${${xvar_name}} is not absolute.")
      set(LVAR_IS_VALID FALSE PARENT_SCOPE)

   elseif(NOT EXISTS ${${xvar_name}})

      # Path doesn't exist.
      
      message("Error in ${xvar_name}: path ${${xvar_name}} does not exist.")
      set(LVAR_IS_VALID FALSE PARENT_SCOPE)

   elseif(NOT IS_DIRECTORY  ${${xvar_name}})

      # Path doesn't refer to a directory.
      
      message("Error in ${xvar_name}: path ${${xvar_name}} refers to a file, not a directory.")
      set(LVAR_IS_VALID FALSE PARENT_SCOPE)

   else()
      
      set(LVAR_IS_VALID TRUE PARENT_SCOPE)
      
   endif()

   # message("Leaving SSPG_check_dir_prereq")
endfunction(SSPG_check_dir_prereq xvar_name)


#
# Initializes variable <xvar_name> of type <xtype> as a prerequisite variable
# refering to a directory.
#
function(SSPG_init_dir_prereq xpkg_name xvar_name xdoc_string xinternal_var_name)   
   # message("Entering SSPG_init_dir_prereq xpkg_name.")
   
   # Preconditions:

   # Body:

   if(NOT ${xvar_name})
      
      # Variable is either not defined or empty.

      if(DEFINED ENV{${xvar_name}})

         # Client has defined variable as environment variable;
         # make it into a cache variable.

         set(${xvar_name} $ENV{${xvar_name}} CACHE PATH ${xdoc_string} FORCE)

         # Escape any white space.

         file(TO_NATIVE_PATH "${${xvar_name}}" ${xvar_name})

         # Check if the PREREQ variable is valid absolute directory path; sets LVAR_IS_VALID)

         SSPG_check_dir_prereq(${xvar_name})

         # message("LVAR_IS_VALID=${LVAR_IS_VALID}")
         
         if(LVAR_IS_VALID)

            # Set the internal variable from the PREREQ variable.

            set(${xinternal_var_name} ${${xvar_name}} CACHE PATH ${xdoc_string} FORCE)
            mark_as_advanced(FORCE ${xinternal_var_name})

            set(LVAR_INITIALIZED TRUE PARENT_SCOPE)
            
         else()

            # PREREQ variable is invalid.
            # Set internal variables as if find_program failed.
            
            unset(${xinternal_var_name} CACHE)
            mark_as_advanced(FORCE ${xinternal_var_name})

            set(${xpkg_name}_FOUND FALSE CACHE BOOL "True if ${xpkg_name} found." FORCE)
            mark_as_advanced(FORCE ${xpkg_name}_FOUND)

            set(SSPG_PREREQS_FOUND FALSE CACHE INTERNAL "")

            set(LVAR_INITIALIZED FALSE PARENT_SCOPE)
            
         endif()

      else()

         # Initialize to empty.

         set(${xvar_name} CACHE PATH ${xdoc_string} FORCE)

         # Unset the internal variable.
   
         unset(${xinternal_var_name} CACHE)   

         # Call the find function

         set(LVAR_INITIALIZED TRUE PARENT_SCOPE)

      endif()

   else()

      # Variable is already defined, possibly by -D on cmake invocation.
      # It appears from experiment that, in spite of documentation to the contrary,
      # the variable set by -D is not a cache variable if the type is not specified
      # on the command line. So force it.

      set(${xvar_name} ${${xvar_name}}  CACHE PATH ${xdoc_string} FORCE)

      # Escape any white space.

      file(TO_NATIVE_PATH "${${xvar_name}}" ${xvar_name})

      # Check if the PREREQ variable is valid absolute dir path; sets LVAR_IS_VALID.

      SSPG_check_dir_prereq(${xvar_name})
      
      if(LVAR_IS_VALID)

         # Set the internal variable from the PREREQ variable.

         set(${xinternal_var_name} ${${xvar_name}} CACHE PATH ${xdoc_string} FORCE)
         mark_as_advanced(FORCE ${xinternal_var_name})

         set(LVAR_INITIALIZED TRUE PARENT_SCOPE)
         
      else()

         # PREREQ variable is invalid.

         # Set internal variables as if find_package failed.
         
         unset(${xinternal_var_name} CACHE)
         mark_as_advanced(FORCE ${xinternal_var_name})
         
         set(${xpkg_name}_FOUND FALSE CACHE BOOL "True if ${xpkg_name} found." FORCE)
         mark_as_advanced(FORCE ${xpkg_name}_FOUND)

         set(SSPG_PREREQS_FOUND FALSE CACHE INTERNAL "")

         set(LVAR_INITIALIZED FALSE PARENT_SCOPE)
         
      endif()
       
   endif(NOT ${xvar_name})

   # Make sure the variable is not marked as advanced.

   mark_as_advanced(CLEAR ${xvar_name})
   
   # message("Leaving SSPG_init_dir_prereq xpkg_name.")
endfunction(SSPG_init_dir_prereq)


#
# Find all the prerequisites for SheafSystemProgrammersGuide.
#
function(SSPG_find_prerequisites)

   # Initialize the PREREQ variable; sets LVAR_INITIALIZED

   SSPG_init_dir_prereq(SheafSystem PREREQ_SHEAFSYSTEM_CONFIG_DIR
      "Path to folder containing SheafSystemConfig.cmake." SheafSystem_DIR)

   if(LVAR_INITIALIZED)

      # find_package won't search if _FOUND is set from some previous call, even if it is false.
      
      unset(SheafSystem_FOUND CACHE)

      #
      # Find the SheafSystem using CONFIG mode.
      # Hints for the installation tree and build tree locations for 
      # SheafSystemConfig.cmake relative to PREREQ_SHEAFSYSTEM_CONFIG_DIR.
      #
      find_package(SheafSystem QUIET CONFIG HINTS ${SHEAFSYSTEM_CONFIG_DIR}
         NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH)

      # Find_package always sets <pkg>_DIR;
      # mark it advanced to keep user interface clean.
      
      mark_as_advanced(FORCE SheafSystem_DIR)

      set(SSPG_SHEAFSYSTEM_FOUND ${SheafSystem_FOUND} CACHE BOOL "True if SheafSystem has been found." FORCE)
      mark_as_advanced(FORCE SSPG_SHEAFSYSTEM_FOUND)

      if(SheafSystem_FOUND)
         set(SSPG_PREREQS_FOUND TRUE CACHE INTERNAL "")
      else()

         # Couldn't find SheafSystem; remind the client to set the PREREQ variable.

         message("Unable to find prerequisite SheafSystem; check setting of PREREQ_SHEAFSYSTEM_CONFIG_DIR.")
         set(SSPG_PREREQS_FOUND FALSE CACHE INTERNAL "")

      endif(SheafSystem_FOUND)

   else()

      set(SSPG_SHEAFSYSTEM_FOUND FALSE CACHE BOOL "True if SheafSystem has been found." FORCE)
      mark_as_advanced(FORCE SSPG_SHEAFSYSTEM_FOUND)

      # Couldn't find SheafSystem; remind the client to set the PREREQ variable.

      message("Unable to find prerequisite SheafSystem; check setting of PREREQ_SHEAFSYSTEM_CONFIG_DIR.")
      set(SSPG_PREREQS_FOUND FALSE CACHE INTERNAL "")
      
   endif(LVAR_INITIALIZED)


   if(NOT SSPG_PREREQS_FOUND)
      message(FATAL_ERROR "Unable to find some prereqs. Please review PREREQ variable settings")
   endif()

   # If we get here, we've successfully set the prereq varibles.

   # The several SheafSystem directories we will need all hang off the parent
   # of SheafSystem_DIR

   get_filename_component(lshfsys_root ${SheafSystem_DIR} DIRECTORY)

   set(SSPG_SHEAFSYSTEM_ROOT ${lshfsys_root} CACHE PATH "Path to parent of config dir." FORCE)
   mark_as_advanced(FORCE SSPG_SHEAFSYSTEM_ROOT)
   
   # Configure the set_prereq_vars scripts.
   
   if(SSPG_WINDOWS)
      configure_file(${SSPG_CMAKE_MODULE_PATH}/set_prereq_vars.bat.cmake.in
         ${CMAKE_BINARY_DIR}/set_prereq_vars.bat)      
   elseif(SSPG_LINUX)
      configure_file(${SSPG_CMAKE_MODULE_PATH}/set_prereq_vars.csh.cmake.in
         ${CMAKE_BINARY_DIR}/set_prereq_vars.csh)
      configure_file(${SSPG_CMAKE_MODULE_PATH}/set_prereq_vars.sh.cmake.in
         ${CMAKE_BINARY_DIR}/set_prereq_vars.sh)
   endif()   

   # Postconditions:

   dbc_ensure(SSPG_SHEAFSYSTEM_FOUND)

endfunction(SSPG_find_prerequisites)


