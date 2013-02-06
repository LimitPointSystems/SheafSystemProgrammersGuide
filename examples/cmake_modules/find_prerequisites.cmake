#
#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#

#
# Prerequisite Discovery
#
# This file is included in the top level CmakeLists.txt file, hence any prereq
# discovered and included here will be visible to the entire system.
#
#find_package(HDF5 1.8.3)
#
#if(HDF5_FOUND)
#    configure_file(${CMAKE_MODULE_PATH}/hdf_definitions.cmake.in ${CMAKE_BINARY_DIR}/hdf_definitions.cmake)
#    include(${CMAKE_BINARY_DIR}/hdf_definitions.cmake)
#    link_directories(${HDF5_LIBRARY_DIRS})
#    include_directories(${HDF5_INCLUDE_DIRS})
#endif()

#
# Set the location of the sheaf system top level.
#
set(SHEAFSYSTEM_HOME CACHE PATH "Sheaf_system top level directory.")

find_package(Sheaf)

#
# Find tetgen
#
#find_package(Tetgen)
#if(TETGEN_FOUND)
#    configure_file(${CMAKE_MODULE_PATH}/tetgen_definitions.cmake.in ${CMAKE_BINARY_DIR}/tetgen_definitions.cmake)
#    include(${CMAKE_BINARY_DIR}/tetgen_definitions.cmake)
#    include_directories(${TETGEN_INC_DIR})
#    link_directories(${TETGEN_LIB_DIR})
#endif()

#
# Find VTK
#
#find_package(VTK)
#if(VTK_FOUND)
#    configure_file(${CMAKE_MODULE_PATH}/vtk_definitions.cmake.in ${CMAKE_BINARY_DIR}/vtk_definitions.cmake)
#    include(${CMAKE_BINARY_DIR}/vtk_definitions.cmake)
#endif()
    

