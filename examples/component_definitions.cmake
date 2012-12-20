#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#



#
# Establish the list of components in this system
# Some functions in LPSCommon use the COMPONENTS var in a multi-comp
# system.
#
set(COMPONENTS ${PROJECT_NAME} CACHE STRING "List of components in this system" FORCE)

#
# Define the clusters for this component.
#
set(clusters sheaf fiber_bundle field)

#
# Platform definitions
#

# OS is 64 bit Windows, compiler is MSVC
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows" AND MSVC AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(WIN64 1)
# OS is 64 bit linux, compiler is g++
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux" AND CMAKE_COMPILER_IS_GNUCXX AND CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(LINUX64 1)
else()
    message(FATAL_ERROR "A 64 bit Windows or Linux environment was not detected; exiting")
endif()

#
# Include functions and definitions common to all components.
# .
include(${CMAKE_MODULE_PATH}/LPSCommon.cmake)

#
# Include cmake test functions and macros
#
include(CTest)

#
# Check for the presence of system cxx includes.
#
check_cxx_includes()

#
# sheafSystem include paths.
#
include_directories(${STD_IPATH} ${FIELDS_IPATHS})

#
# JDK include paths.
#
#include_directories(${JDK_INC_DIR} ${JDK_PLATFORM_INC_DIR})

#
# Conditionally include VTK.
#
if(${USE_VTK})
    include_directories(${VTK_INC_DIRS})
endif()

#------------------------------------------------------------------------------
# FUNCTION DEFINITION SECTION
#------------------------------------------------------------------------------


#
# Create the library targets for this component.
#

#function(add_library_targets)

#    if(${USE_VTK})
#        link_directories(${VTK_LIB_DIR} ${JDK_LIB_DIR} ${JVM_LIB_DIR} ${XAWT_LIB_DIR})
#    else()
#        link_directories(${JDK_LIB_DIR} ${JVM_LIB_DIR} ${XAWT_LIB_DIR})    
#    endif()

#    if(WIN64)

        # Tell the linker where to look for this project's libraries.
#        link_directories(${${COMPONENT}_OUTPUT_DIR})

        # Create the DLL.
#        add_library(${${COMPONENT}_DYNAMIC_LIB} SHARED ${${COMPONENT}_SRCS})
#        if(${USE_VTK})
#            target_link_libraries(${${COMPONENT}_DYNAMIC_LIB} fieldsdll ${TETGEN_LIB} ${HDF5_DLL_LIBRARY} ${VTK_LIBS})
#        else()
#            target_link_libraries(${${COMPONENT}_DYNAMIC_LIB} fieldsdll ${TETGEN_LIB} ${HDF5_DLL_LIBRARY})       
#        endif()
#        # Override cmake's placing of "${${COMPONENT}_DYNAMIC_LIB}_EXPORTS into the preproc symbol table.
#        set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES DEFINE_SYMBOL "MBASCIENCES_DLL_EXPORTS")
#        set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES FOLDER "Component Library Targets") 
#       # Define the library version.
#       set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES VERSION ${LIB_VERSION})
#       
#    else()

        # Static library
#        add_library(${${COMPONENT}_STATIC_LIB} STATIC ${${COMPONENT}_SRCS})
#        set_target_properties(${${COMPONENT}_STATIC_LIB} PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
#        if(${USE_VTK})
#            add_dependencies(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_STATIC_LIBS})
#        else()
#            add_dependencies(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_STATIC_LIBS})        
#        endif()
        
        # Shared library
#        add_library(${${COMPONENT}_SHARED_LIB} SHARED ${${COMPONENT}_SRCS})
#        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES OUTPUT_NAME ${PROJECT_NAME} LINKER_LANGUAGE CXX)
#       if(${USE_VTK})
#           add_dependencies(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_SHARED_LIBS})
#           target_link_libraries(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_STATIC_LIBS})
#            target_link_libraries(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_SHARED_LIBS})
#         else()
#            add_dependencies(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_SHARED_LIBS})
#            target_link_libraries(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_STATIC_LIBS})
#            target_link_libraries(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_SHARED_LIBS})     
#        endif()
               
        # Override cmake's placing of "${COMPONENT_LIB}_EXPORTS into the preproc symbol table.
        # CMake apparently detects the presence of cdecl_dllspec in the source and places
        # -D<LIBRARY>_EXPORTS into the preproc symbol table no matter the platform.
#        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES DEFINE_SYMBOL "")

        # Define the library version.
#        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES VERSION ${LIB_VERSION})  
    
        # Library alias definitions
#        add_dependencies(shared-lib ${${COMPONENT}_SHARED_LIB})
#        add_dependencies(static-lib ${${COMPONENT}_STATIC_LIB})
#        add_dependencies(lib shared-lib static-lib)    
   
#    endif()

#endfunction(add_library_targets)







