#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
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
   


          