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
include_directories(${STD_IPATH} ${SHEAFSYSTEM_IPATH})

#
# JDK include paths.
#
include_directories(${JDK_INC_DIR} ${JDK_PLATFORM_INC_DIR})

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

function(add_library_targets)

    if(${USE_VTK})
        link_directories(${VTK_LIB_DIR} ${JDK_LIB_DIR} ${JVM_LIB_DIR} ${XAWT_LIB_DIR})
    else()
        link_directories(${JDK_LIB_DIR} ${JVM_LIB_DIR} ${XAWT_LIB_DIR})    
    endif()

    if(WIN64)

        # Tell the linker where to look for this project's libraries.
        link_directories(${${COMPONENT}_OUTPUT_DIR})

        # Create the DLL.
        add_library(${${COMPONENT}_DYNAMIC_LIB} SHARED ${${COMPONENT}_SRCS})
        if(${USE_VTK})
            target_link_libraries(${${COMPONENT}_DYNAMIC_LIB} fieldsdll ${TETGEN_LIB} ${HDF5_DLL_LIBRARY} ${VTK_LIBS})
        else()
            target_link_libraries(${${COMPONENT}_DYNAMIC_LIB} fieldsdll ${TETGEN_LIB} ${HDF5_DLL_LIBRARY})       
        endif()
        # Override cmake's placing of "${${COMPONENT}_DYNAMIC_LIB}_EXPORTS into the preproc symbol table.
        set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES DEFINE_SYMBOL "MBASCIENCES_DLL_EXPORTS")
        set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES FOLDER "Component Library Targets") 
        # Define the library version.
        set_target_properties(${${COMPONENT}_DYNAMIC_LIB} PROPERTIES VERSION ${LIB_VERSION})
        
    else()

        # Static library
        add_library(${${COMPONENT}_STATIC_LIB} STATIC ${${COMPONENT}_SRCS})
        set_target_properties(${${COMPONENT}_STATIC_LIB} PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
        if(${USE_VTK})
            add_dependencies(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_STATIC_LIBS})
        else()
            add_dependencies(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_STATIC_LIBS})        
        endif()
        
        # Shared library
        add_library(${${COMPONENT}_SHARED_LIB} SHARED ${${COMPONENT}_SRCS})
        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES OUTPUT_NAME ${PROJECT_NAME} LINKER_LANGUAGE CXX)
        if(${USE_VTK})
            add_dependencies(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_SHARED_LIBS})
            target_link_libraries(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_STATIC_LIBS})
            target_link_libraries(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${VTK_LIBS} ${SHEAFSYSTEM_SHARED_LIBS})
         else()
            add_dependencies(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_SHARED_LIBS})
            target_link_libraries(${${COMPONENT}_STATIC_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_STATIC_LIBS})
            target_link_libraries(${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES} ${JDK_LIB_OPTIONS} ${SHEAFSYSTEM_SHARED_LIBS})     
        endif()
               
        # Override cmake's placing of "${COMPONENT_LIB}_EXPORTS into the preproc symbol table.
        # CMake apparently detects the presence of cdecl_dllspec in the source and places
        # -D<LIBRARY>_EXPORTS into the preproc symbol table no matter the platform.
        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES DEFINE_SYMBOL "")

        # Define the library version.
        set_target_properties(${${COMPONENT}_SHARED_LIB} PROPERTIES VERSION ${LIB_VERSION})  
    
        # Library alias definitions
        add_dependencies(shared-lib ${${COMPONENT}_SHARED_LIB})
        add_dependencies(static-lib ${${COMPONENT}_STATIC_LIB})
        add_dependencies(lib shared-lib static-lib)    
   
    endif()

endfunction(add_library_targets)

#
# Create the bindings targets for this component.
#
function(add_bindings_targets)

    if(LINUX64 AND SWIG_FOUND)
    
        include(${SWIG_USE_FILE})
        link_directories(${FIELDS_LIB_OUTPUT_DIR} ${JDK_LIB_DIR} ${JVM_LIB_DIR} ${XAWT_LIB_DIR})
        set(SWIG_CXX_EXTENSION "cc")
        set(CMAKE_SWIG_FLAGS -package bindings.java)
        
        # java 
        include_directories(${JDK_INC_DIR} ${JDK_PLATFORM_INC_DIR})
        include_directories(${SHEAVES_JAVA_BINDING_SRC_DIR})
        include_directories(${SHEAVES_COMMON_BINDING_SRC_DIR})
        include_directories(${FIBER_BUNDLES_JAVA_BINDING_SRC_DIR})
        include_directories(${FIBER_BUNDLES_COMMON_BINDING_SRC_DIR})
        include_directories(${GEOMETRY_JAVA_BINDING_SRC_DIR})
        include_directories(${GEOMETRY_COMMON_BINDING_SRC_DIR})
        include_directories(${FIELDS_JAVA_BINDING_SRC_DIR})
        include_directories(${FIELDS_COMMON_BINDING_SRC_DIR})
        include_directories(${${COMPONENT}_JAVA_BINDING_SRC_DIR})
        include_directories(${${COMPONENT}_COMMON_BINDING_SRC_DIR})
        
        set_source_files_properties(${${COMPONENT}_JAVA_BINDING_SRC_DIR}/${${COMPONENT}_SWIG_JAVA_INTERFACE} PROPERTIES CPLUSPLUS ON)
        # Add the java binding library target
        swig_add_module(${${COMPONENT}_JAVA_BINDING_LIB} java ${${COMPONENT}_JAVA_BINDING_SRC_DIR}/${${COMPONENT}_SWIG_JAVA_INTERFACE})
        add_dependencies(${${COMPONENT}_JAVA_BINDING_LIB} ${FIELDS_JAVA_BINDING_LIB} ${${COMPONENT}_SHARED_LIB})
        set_target_properties(${${COMPONENT}_JAVA_BINDING_LIB} PROPERTIES LINKER_LANGUAGE CXX)
                
        # Define the library version.
        set_target_properties(${${COMPONENT}_JAVA_BINDING_LIB} PROPERTIES VERSION ${LIB_VERSION})
        if(${USE_VTK})
            target_link_libraries(${${COMPONENT}_JAVA_BINDING_LIB} ${JDK_LIB_OPTIONS} ${HDF5_LIBRARIES} ${VTK_LIBS} ${FIELDS_JAVA_BINDING_LIB} ${${COMPONENT}_SHARED_LIB}) 
        else()
            target_link_libraries(${${COMPONENT}_JAVA_BINDING_LIB} ${JDK_LIB_OPTIONS} ${HDF5_LIBRARIES} ${FIELDS_JAVA_BINDING_LIB} ${${COMPONENT}_SHARED_LIB})
        endif()
         
        # Set the classpath for this component; for downstream use.    
        set(${COMPONENT}_CLASSPATH ${FIELDS_CLASSPATH}:${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/${${COMPONENT}_JAVA_BINDING_JAR}:${VTK_JAR}:${JMF_JAR} 
            CACHE STRING "Cumulative classpath for ${PROJECT_NAME}")
            
        mark_as_advanced(FORCE ${COMPONENT}_CLASSPATH)
        
         # Create the bindings jar file 
        add_custom_command(TARGET ${${COMPONENT}_JAVA_BINDING_LIB} 
                       POST_BUILD
                       COMMAND cmake -E echo "Compiling Java files..."
                       COMMAND ${JAVAC_EXECUTABLE} -classpath .:${${COMPONENT}_CLASSPATH} -d . *.java
                       COMMAND cmake -E echo "Creating jar file..."
                       COMMAND ${JAR_EXECUTABLE} cvf ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/${${COMPONENT}_JAVA_BINDING_JAR}  bindings/java/*.class
        )   

        # Java documentation
        add_custom_target(${PROJECT_NAME}-java-docs 
                    COMMAND ${JDK_BIN_DIR}/javadoc -classpath .:${${COMPONENT}_CLASSPATH} 
                    -d  ${CMAKE_BINARY_DIR}/documentation/java/${PROJECT_NAME}  
                    -sourcepath ${CMAKE_CURRENT_BINARY_DIR} bindings.java *.java
                    DEPENDS ${${COMPONENT}_JAVA_BINDING_LIB})
    
        # Python 
        set(CMAKE_SWIG_FLAGS -c++ )
        include_directories(${PYTHON_INCLUDE_DIRS})
        include_directories(${SHEAVES_PYTHON_BINDING_SRC_DIR})
        include_directories(${FIBER_BUNDLES_PYTHON_BINDING_SRC_DIR})
        include_directories(${GEOMETRY_PYTHON_BINDING_SRC_DIR})
        include_directories(${FIELDS_PYTHON_BINDING_SRC_DIR})
                        
        set_source_files_properties(${${COMPONENT}_PYTHON_BINDING_SRC_DIR}/${${COMPONENT}_SWIG_PYTHON_INTERFACE} PROPERTIES CPLUSPLUS ON)
        swig_add_module(${${COMPONENT}_PYTHON_BINDING_LIB} python ${${COMPONENT}_PYTHON_BINDING_SRC_DIR}/${${COMPONENT}_SWIG_PYTHON_INTERFACE})
        add_dependencies(${${COMPONENT}_PYTHON_BINDING_LIB} ${FIELDS_PYTHON_BINDING_LIB} ${${COMPONENT}_SHARED_LIB})
        set_target_properties(${${COMPONENT}_PYTHON_BINDING_LIB} PROPERTIES LINKER_LANGUAGE CXX)
    
        # Define the library version.
        set_target_properties(${${COMPONENT}_PYTHON_BINDING_LIB} PROPERTIES VERSION ${LIB_VERSION})  

        if(${USE_VTK})  
            target_link_libraries(${${COMPONENT}_PYTHON_BINDING_LIB} ${HDF5_LIBRARIES} ${VTK_LIBS} ${FIELDS_JAVA_BINDING_LIB} ${${COMPONENT}_SHARED_LIB}) 
        else()
            target_link_libraries(${${COMPONENT}_PYTHON_BINDING_LIB} ${HDF5_LIBRARIES} ${FIELDS_JAVA_BINDING_LIB} ${${COMPONENT}_SHARED_LIB})
        endif()

        add_custom_command(TARGET ${${COMPONENT}_PYTHON_BINDING_LIB} 
                       POST_BUILD
                       COMMAND cmake -E echo "Compiling Python files..."
                       COMMAND ${PYTHON_COMPILE_BIN} ${PROJECT_NAME}_python_binding.py
                       COMMAND cmake -E copy ${PROJECT_NAME}_python_binding.pyc ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
                       COMMAND cmake -E remove -f ${PROJECT_NAME}_python_binding.pyc
        )  
        # bindings target aliases already declared at system level. Add dependencies here.
        add_dependencies(bindings ${${COMPONENT}_JAVA_BINDING_LIB} ${${COMPONENT}_PYTHON_BINDING_LIB})
        add_dependencies(java-binding ${${COMPONENT}_JAVA_BINDING_LIB})
        add_dependencies(python-binding ${${COMPONENT}_PYTHON_BINDING_LIB})
   
    endif()

endfunction(add_bindings_targets)

# 
# Set the commands for the install target
#
function(add_install_target)

        install(TARGETS ${${COMPONENT}_SHARED_LIB} LIBRARY DESTINATION lib)
        install(TARGETS ${${COMPONENT}_STATIC_LIB} ARCHIVE DESTINATION lib)

        # Include files are independent of build type. Includes and docs install at top level.
        # See system level CMakeLists.txt for "documentation" install directive.
        install(FILES ${${COMPONENT}_INCS} ${ADDITIONAL_INCS} DESTINATION include)
        #install(TARGETS ${${COMPONENT}_CHECK_EXECS} RUNTIME DESTINATION bin)
        
endfunction(add_install_target)





