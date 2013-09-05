
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
# Initialize the found variable
#
set(SHEAF_FOUND 0)

#
# Find the SheafSystem exports file
#
message(STATUS "Looking for SheafSystem exports file ...")
# Look for a binary installation of SheafSystem first
if(LINUX64GNU OR LINUX64INTEL)
    if(EXISTS ${SHEAFSYSTEM_HOME}/${CMAKE_BUILD_TYPE}/config/SheafSystem-exports.cmake.in)
        set(SHEAFEXPORTSFILE ${SHEAFSYSTEM_HOME}/${CMAKE_BUILD_TYPE}/config/SheafSystem-exports.cmake.in)
        configure_file(${SHEAFEXPORTSFILE} ${CMAKE_BINARY_DIR}/SheafSystem-exports.cmake)
        include(${CMAKE_BINARY_DIR}/SheafSystem-exports.cmake)
        set(SHEAF_FOUND 1)
    # Didn't find install. Assume we are dealing with a build tree.    
    elseif(EXISTS ${SHEAFSYSTEM_HOME}/build/SheafSystem-exports.cmake)
        set(SHEAFEXPORTSFILE ${SHEAFSYSTEM_HOME}/build/SheafSystem-exports.cmake CACHE STRING "Location of SheafSystem Exports file" FORCE)
        include(${SHEAFEXPORTSFILE})
        set(SHEAF_FOUND 1)
    # Didn't find either. Puke and exit.
    else()
        message(FATAL_ERROR "SheafSystem exports file not found; Check the value of SHEAFSYSTEM_HOME.")
    endif()  
else()
    if(EXISTS ${SHEAFSYSTEM_HOME}/config/${CMAKE_BUILD_TYPE}/SheafSystem-exports.cmake.in)
        set(SHEAFEXPORTSFILE ${SHEAFSYSTEM_HOME}/config/${CMAKE_BUILD_TYPE}/SheafSystem-exports.cmake.in)
        configure_file(${SHEAFEXPORTSFILE} ${CMAKE_BINARY_DIR}/SheafSystem-exports.cmake)
        include(${CMAKE_BINARY_DIR}/SheafSystem-exports.cmake)
        set(SHEAF_FOUND 1)
    # Didn't find install. Assume we are dealing with a build tree.    
    elseif(EXISTS ${SHEAFSYSTEM_HOME}/build/SheafSystem-exports.cmake)
        set(SHEAFEXPORTSFILE ${SHEAFSYSTEM_HOME}/build/SheafSystem-exports.cmake CACHE STRING "Location of SheafSystem Exports file" FORCE)
        include(${SHEAFEXPORTSFILE})
        set(SHEAF_FOUND 1)
    # Didn't find either. Puke and exit.
    else()
        message(FATAL_ERROR "SheafSystem exports file not found; Check the value of SHEAFSYSTEM_HOME.")
    endif()   
endif()
   


          