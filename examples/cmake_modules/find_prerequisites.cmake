#
# $RCSfile: find_prerequisites.cmake,v $ $Revision: 1.9 $ $Date: 2012/07/05 19:18:14 $
#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

#
# Prerequisite Discovery
#
# This file is included in the top level CmakeLists.txt file, hence any prereq
# discovered and included here will be visible to the entire system.
#
find_package(HDF5 1.8.3 REQUIRED)

if(HDF5_FOUND)
    configure_file(${CMAKE_MODULE_PATH}/hdf_definitions.cmake.in ${CMAKE_BINARY_DIR}/hdf_definitions.cmake)
    include(${CMAKE_BINARY_DIR}/hdf_definitions.cmake)
    link_directories(${HDF5_LIBRARY_DIRS})
    include_directories(${HDF5_INCLUDE_DIRS})
endif()

#
# Set the location of the sheaf system top level.
#
set(SHEAFSYSTEM_HOME CACHE PATH "Sheaf_system top level directory.")

find_package(Sheaf)

# HDF5, Tetgen, and Doxygen need to be found for all target platforms.

#
# Find Doxygen; Make sure we have exactly v1.5.4.
# 1.5.4 does the best version of documenting our code base.
#
find_package(Doxygen)

if(DOXYGEN_FOUND)
    configure_file(${CMAKE_MODULE_PATH}/doxygen_definitions.cmake.in ${CMAKE_BINARY_DIR}/doxygen_definitions.cmake)
    configure_file(${CMAKE_MODULE_PATH}/dev_doxyfile.cmake.in ${CMAKE_BINARY_DIR}/dev_doxyfile)
    configure_file(${CMAKE_MODULE_PATH}/user_doxyfile.cmake.in ${CMAKE_BINARY_DIR}/user_doxyfile)
else()
    message(WARNING "Doxygen was not found. Documentation will not be generated.")
endif()



#
# Find tetgen
#
find_package(Tetgen REQUIRED)
if(TETGEN_FOUND)
    configure_file(${CMAKE_MODULE_PATH}/tetgen_definitions.cmake.in ${CMAKE_BINARY_DIR}/tetgen_definitions.cmake)
    include(${CMAKE_BINARY_DIR}/tetgen_definitions.cmake)
    include_directories(${TETGEN_INC_DIR})
    link_directories(${TETGEN_LIB_DIR})
endif()

#
# Find VTK
#
find_package(VTK REQUIRED)
if(VTK_FOUND)
    configure_file(${CMAKE_MODULE_PATH}/vtk_definitions.cmake.in ${CMAKE_BINARY_DIR}/vtk_definitions.cmake)
    include(${CMAKE_BINARY_DIR}/vtk_definitions.cmake)
endif()
    
#
# Find Java, Python, VTK, JMF, and Swig
#
if(LINUX64GNU OR LINUX64INTEL)
    # Needed for some checks
    find_package(Gnuplot)
    if(GNUPLOT_FOUND)
        message(STATUS "Found Gnuplot")
    endif()
    # Find the JDK
    find_package(Java 1.6 REQUIRED)
    if(JAVA_FOUND)
        message(STATUS "About to configure JDK")
        configure_file(${CMAKE_MODULE_PATH}/java_definitions.cmake.in ${CMAKE_BINARY_DIR}/java_definitions.cmake)
        include(${CMAKE_BINARY_DIR}/java_definitions.cmake)
        set(JAVA_BINDING_COMPILE_OPTIONS "-I${JDK_INC_DIR}" "-I${JDK_PLATFORM_INC_DIR}" CACHE STRING "JDK compile includes") 
    endif()
    
    # Find Swig
    find_package(SWIG)
    if(SWIG_FOUND)
        configure_file(${CMAKE_MODULE_PATH}/swig_definitions.cmake.in ${CMAKE_BINARY_DIR}/swig_definitions.cmake)
        include(${CMAKE_BINARY_DIR}/swig_definitions.cmake)
        find_package(PythonLibs REQUIRED)
        if(PYTHONLIBS_FOUND)
            configure_file(${CMAKE_MODULE_PATH}/python_definitions.cmake.in ${CMAKE_BINARY_DIR}/python_definitions.cmake)
            include(${CMAKE_BINARY_DIR}/python_definitions.cmake)
        endif()
    endif()
   
    # Find the JMF
    find_package(JMF REQUIRED)
    if(JMF_FOUND)
        configure_file(${CMAKE_MODULE_PATH}/jmf_definitions.cmake.in ${CMAKE_BINARY_DIR}/jmf_definitions.cmake)
        include(${CMAKE_BINARY_DIR}/jmf_definitions.cmake)
    endif()   
endif()


