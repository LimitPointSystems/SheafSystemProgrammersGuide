#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
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
# Add the clusters to the project
#
add_clusters("${clusters}")

#
# Check for the presence of system cxx includes.
#
check_cxx_includes()









