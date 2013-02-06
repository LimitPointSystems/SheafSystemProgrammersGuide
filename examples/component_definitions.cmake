#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#



#
# Include functions and definitions common to all components.
# .
include(${CMAKE_MODULE_PATH}/LPSCommon.cmake)

#
# Define the clusters for this component.
#
set(clusters sheaf fiber_bundle field)

#
# Initialize all variables for this component.
#
set_component_vars()

#
# Add the clusters to the project
#
add_clusters("${clusters}")

#
# Platform definitions
#


#
# Check for the presence of system cxx includes.
#
check_cxx_includes()









