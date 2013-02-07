#
#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#


#
# Library targets
#
if(LINUX64GNU OR LINUX64INTEL)
    
    include(${CMAKE_MODULE_PATH}/help_targets.cmake)
    
    add_custom_target(realclean 
            COMMAND ${CMAKE_COMMAND} --build  ${CMAKE_BINARY_DIR} --target clean
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)   

endif()

