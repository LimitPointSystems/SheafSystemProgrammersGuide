#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

#
# Initialize the found variable
#
set(SHEAF_FOUND 0)

#set(SHEAF_HOME $ENV{SHEAF_HOME} CACHE STRING "Sheaf Home Directory" FORCE)

#
# Find the exports file
#
message(STATUS "Looking for sheafSystem exports file ...")
find_file(SHEAFEXPORTSFILE sheafSystem-exports.cmake
    HINTS ${SHEAF_HOME} ${SHEAF_HOME}/build)
# Not good. The exports file wasn't where SHEAF_HOME claimed it was.    
if(${SHEAFEXPORTSFILE} MATCHES "SHEAFEXPORTSFILE-NOTFOUND")
    message(FATAL_ERROR "The sheafSystem exports file was not found in ${SHEAF_HOME}; Is the SHEAF_HOME variable set correctly?")
else()
    message(STATUS "Found ${SHEAFEXPORTSFILE}")
    include(${SHEAFEXPORTSFILE})
    set(SHEAF_FOUND 1)
endif()


   


          