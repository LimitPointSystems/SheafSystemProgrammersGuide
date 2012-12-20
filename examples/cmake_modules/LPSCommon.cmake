#
# $RCSfile: LPSCommon.cmake,v $ $Revision: 1.18.6.1 $ $Date: 2012/04/25 18:11:32 $
#
# Copyright (c) 2011 Limit Point Systems, Inc.
#
# Contains all that is LPS specific; all flags, all macros, etc.
#

#------------------------------------------------------------------------------ 
# Variable Definition Section
#------------------------------------------------------------------------------

#
# Set the location of the python compile script
#
set(PYTHON_COMPILE_BIN ${CMAKE_HOME_DIRECTORY}/bindings/python/bin/compile.py CACHE STRING "Python byte-compile script")
#
# Turn on project folders for Visual Studio.
#
if(WIN64)
    set_property(GLOBAL PROPERTY USE_FOLDERS On)
endif()

#
# Comvert the project name to UC
#
string(TOUPPER ${PROJECT_NAME} COMPONENT)

#
# Tell the compiler where to find the std_headers.
#
include_directories(${CMAKE_BINARY_DIR}/include)
 
#
# Tell the linker where to look for COMPONENT libraries.
#
link_directories(${CMAKE_BINARY_DIR}/lib)

#------------------------------------------------------------------------------
# Function Definition Section.
#------------------------------------------------------------------------------

#
# Check for and configure system cxx includes.
#
function(check_cxx_includes)

   include(CheckIncludeFileCXX)

    # C++ Headers for C Library Facilities

    if(NOT HAVE_CASSERT)
        status_message("Looking for C++ Headers For C Library Functions")   
    endif()

    check_include_file_cxx(cassert HAVE_CASSERT)
    check_include_file_cxx(cctype HAVE_CCTYPE)
    check_include_file_cxx(cerrno HAVE_CERRNO)
    check_include_file_cxx(cfloat HAVE_CFLOAT)
    check_include_file_cxx(ciso646 HAVE_CISO646)
    check_include_file_cxx(climits HAVE_CLIMITS)
    check_include_file_cxx(clocale HAVE_CLOCALE)
    check_include_file_cxx(cmath HAVE_CMATH)
    check_include_file_cxx(csetjmp HAVE_CSETJMP)
    check_include_file_cxx(csignal HAVE_CSIGNAL)
    check_include_file_cxx(cstdarg HAVE_CSTDARG)
    check_include_file_cxx(cstddef HAVE_CSTDDEF)
    check_include_file_cxx(cstdio HAVE_CSTDIO)
    check_include_file_cxx(cstdlib HAVE_CSTDLIB)
    check_include_file_cxx(cstring HAVE_CSTRING)
    check_include_file_cxx(ctime HAVE_CTIME)
    check_include_file_cxx(cwchar HAVE_CWCHAR)
    check_include_file_cxx(cwctype HAVE_CWCTYPE)                        


    # C++ Library Headers

    if(NOT HAVE_ALGORITHM)
        status_message("Looking for C++ Standard Library Headers")    
    endif()

    check_include_file_cxx(algorithm HAVE_ALGORITHM)
    check_include_file_cxx(bitset HAVE_BITSET)
    check_include_file_cxx(complex HAVE_COMPLEX)    
    check_include_file_cxx(deque HAVE_DEQUE)
    check_include_file_cxx(exception HAVE_EXCEPTION)    
    check_include_file_cxx(fstream HAVE_FSTREAM)
    check_include_file_cxx(functional HAVE_FUNCTIONAL)
    check_include_file_cxx(iomanip HAVE_IOMANIP)
    check_include_file_cxx(ios HAVE_IOS)
    check_include_file_cxx(iosfwd HAVE_IOSFWD)
    check_include_file_cxx(iostream HAVE_IOSTREAM)
    check_include_file_cxx(iterator HAVE_ITERATOR)
    check_include_file_cxx(limits HAVE_LIMITS)
    check_include_file_cxx(list HAVE_LIST)
    check_include_file_cxx(locale HAVE_LOCALE)
    check_include_file_cxx(map HAVE_MAP)
    check_include_file_cxx(memory HAVE_MEMORY)
    check_include_file_cxx(new HAVE_NEW)
    check_include_file_cxx(numeric HAVE_NUMERIC)
    check_include_file_cxx(ostream HAVE_OSTREAM)
    check_include_file_cxx(queue HAVE_QUEUE)
    check_include_file_cxx(set HAVE_SET)
    check_include_file_cxx(sstream HAVE_SSTREAM)
    check_include_file_cxx(stack HAVE_STACK)
    check_include_file_cxx(stdexcept HAVE_STDEXCEPT)
    check_include_file_cxx(strtream HAVE_STRSTREAM)
    check_include_file_cxx(streambuf HAVE_STREAMBUF)
    check_include_file_cxx(string HAVE_STRING)
    check_include_file_cxx(typeinfo HAVE_TYPEINFO)
    check_include_file_cxx(utility HAVE_UTILITY)
    check_include_file_cxx(valarray HAVE_VALARRAY)
    check_include_file_cxx(vector HAVE_VECTOR)

    # STL

    if(NOT (HAVE_HASH_MAP OR HAVE_EXT_HASH_MAP))
        status_message("Looking for C++ STL Headers")
    endif()

    check_include_file_cxx(hash_map HAVE_HASH_MAP)
    check_include_file_cxx(ext/hash_map HAVE_EXT_HASH_MAP)
    check_include_file_cxx(hash_set HAVE_HASH_SET)
    check_include_file_cxx(ext/hash_set HAVE_EXT_HASH_SET)    
    check_include_file_cxx(slist HAVE_SLIST)
    check_include_file_cxx(ext/slist HAVE_EXT_SLIST)
    
    # C++ TR1 Extensions

    if(NOT (HAVE_UNORDERED_MAP OR HAVE_TR1_UNORDERED_MAP))
        status_message("Looking for C++ TR1 Headers") 
    endif()

    check_include_file_cxx(unordered_map HAVE_UNORDERED_MAP) 
    check_include_file_cxx(tr1/unordered_map HAVE_TR1_UNORDERED_MAP) 
    check_include_file_cxx(unordered_set HAVE_UNORDERED_SET)
    check_include_file_cxx(tr1/unordered_set HAVE_TR1_UNORDERED_SET)

endfunction(check_cxx_includes)

#
# Check for C++ headers and configure the STD wrappers 
# for this development environment.
#
function(configure_std_headers)

    status_message("Configuring STD include files")

    # Glob all the .h.cmake.in files in std
    file(GLOB STD_INC_INS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/std ${CMAKE_CURRENT_SOURCE_DIR}/std/*.h.cmake.in)
    # Configure the .h file from each .h.cmake.in
    foreach(input_file ${STD_INC_INS})
        # Strip .cmake.in from globbed filenames for output filenames
        string(REGEX REPLACE ".cmake.in$" ""  std_h ${input_file})
        message(STATUS "Creating ${CMAKE_BINARY_DIR}/include/${std_h} from std/${input_file}")
        list(APPEND std_incs ${CMAKE_BINARY_DIR}/include/${std_h})
        set(STD_HEADERS ${std_incs} CACHE STRING "STD Includes" FORCE)          
        # Configure the .h files
        configure_file(std/${input_file} ${CMAKE_BINARY_DIR}/include/${std_h})
    endforeach()

endfunction(configure_std_headers)

#
# Set the compiler flags per build configuration
#
function(set_compiler_flags)
    
    if(WIN64)
       # Clear all cmake's intrinsic vars. If we don't, then their values will be appended to our
       # compile and link lines.
       set(CMAKE_CXX_FLAGS "" CACHE STRING "CXX Flags" FORCE)
       set(CMAKE_SHARED_LINKER_FLAGS "" CACHE STRING "Shared Linker Flags" FORCE)
       set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "" CACHE STRING "Debug Shared Linker Flags" FORCE)
       set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "" CACHE STRING "Debug Shared Linker Flags" FORCE)
       set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "" CACHE STRING "Debug Shared Linker Flags" FORCE)
       set(CMAKE_EXE_LINKER_FLAGS "" CACHE STRING "Exe Linker Flags" FORCE)
       set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE STRING "Exe Linker Flags" FORCE)
       set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "" CACHE STRING "Exe Linker Flags" FORCE)
       set(CMAKE_MODULE_LINKER_FLAGS "" CACHE STRING "Module Linker Flags" FORCE)
       set(CMAKE_MODULE_LINKER_FLAGS_DEBUG "" CACHE STRING "Module Linker Flags" FORCE)
       set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO "" CACHE STRING "Module Linker Flags" FORCE)
       
       set(LPS_CXX_FLAGS "/D_USRDLL /MP /GR /nologo /DWIN32 /D_WINDOWS /W1 /EHsc ${OPTIMIZATION} /D_HDF5USEDLL_" CACHE STRING "C++ Compiler Flags" FORCE)
       set(LPS_SHARED_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /OPT:REF /OPT:ICF /DYNAMICBASE /NXCOMPAT /MACHINE:X64"  CACHE STRING "Linker Flags" FORCE)

    elseif(LINUX64)
       set(LPS_CXX_FLAGS "-ansi -m64 -Wno-deprecated ${OPTIMIZATION}")
    else() # Assume 32-bit i686 linux for the present
       set(LPS_CXX_FLAGS "-ansi -m32 -Wno-deprecated ${OPTIMIZATION}")
    endif()
    
    #                 
    # DEBUG_CONTRACTS section
    #
        
    # Configuration specific flags 
    if(WIN64)
        if(${USE_VTK})     
            set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 1\" /MDd /DUSE_VTK" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
        else()
             set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 1\" /MDd" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)       
        endif()
    else()
        if(${USE_VTK})
            set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g -DUSE_VTK" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
        else()         
            set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
        endif()
    endif()
    
    # True for all currently supported platforms    
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG-CONTRACTS ${CMAKE_EXE_LINKER_FLAGS} CACHE
        STRING "Flags used by the linker for executables for Debug-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG-CONTRACTS ${LPS_SHARED_LINKER_FLAGS} CACHE
        STRING "Flags used by the linker for shared libraries for Debug-contracts builds" FORCE)
    mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS
                     CMAKE_EXE_LINKER_FLAGS_DEBUG-CONTRACTS CMAKE_SHARED_LINKER_FLAGS_DEBUG-CONTRACTS)

    #                 
    # DEBUG_NO_CONTRACTS section
    #      

    # Configuration specific flags 
    if(WIN64)
        if(${USE_VTK}) 
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 1\" /MDd /DUSE_VTK /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Debug-no-contracts builds" FORCE)
         else()   
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 1\" /MDd /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Debug-no-contracts builds" FORCE)
         endif()
    else()
        if(${USE_VTK})    
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} -g -DNDEBUG -DUSE_VTK" CACHE
                STRING "Flags used by the C++ compiler for Debug-no-contracts builds" FORCE)
        else()
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} -g -DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Debug-no-contracts builds" FORCE)
        endif()
    endif()

    # True for all currently supported platforms       
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG-NO-CONTRACTS ${CMAKE_EXE_LINKER_FLAGS} CACHE
        STRING "Flags used by the linker for executables for Debug-no-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG-NO-CONTRACTS ${LPS_SHARED_LINKER_FLAGS} CACHE
        STRING "Flags used by the linker for shared libraries for Debug-no-contracts builds" FORCE)
    mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS
                     CMAKE_EXE_LINKER_FLAGS_DEBUG-NO-CONTRACTS CMAKE_SHARED_LINKER_FLAGS_DEBUG-NO-CONTRACTS)
    #                 
    # RELEASE_CONTRACTS section
    #

    # Configuration specific flags 
    if(WIN64)
     if(${USE_VTK})
        set(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 0\" /DUSE_VTK /MD" CACHE
            STRING "Flags used by the C++ compiler for Release-contracts builds" FORCE)
      else()   
        set(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 0\" /MD" CACHE
            STRING "Flags used by the C++ compiler for Release-contracts builds" FORCE)
     endif()
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE-CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD"  CACHE
        STRING "Flags used by the linker for executables for Release-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE-CONTRACTS "${LPS_SHARED_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD" CACHE
        STRING "Flags used by the linker for shared libraries for Release-contracts builds" FORCE)   
    else()
        set(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS "${LPS_CXX_FLAGS}" CACHE
            STRING "Flags used by the C++ compiler for Release-contracts builds" FORCE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE-CONTRACTS "${CMAKE_EXE_LINKER_FLAGS}"  CACHE
        STRING "Flags used by the linker for executables for Release-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE-CONTRACTS "${LPS_SHARED_LINKER_FLAGS}" CACHE
        STRING "Flags used by the linker for shared libraries for Release-contracts builds" FORCE)
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS
                     CMAKE_EXE_LINKER_FLAGS_RELEASE-CONTRACTS CMAKE_SHARED_LINKER_FLAGS_RELEASE-CONTRACTS
                    )
    #                 
    # RELEASE_NO_CONTRACTS section
    #

    # Configuration specific flags         
    if(WIN64)
        if(${USE_VTK})
            set(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 0\" /MD /DUSE_VTK /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Release-no-contracts builds" FORCE)
       else()        
            set(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL 1\" /D\"_HAS_ITERATOR_DEBUG 0\" /MD /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Release-no-contracts builds" FORCE)
      endif()               
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE-NO-CONTRACTS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD" CACHE
        STRING "Flags used by the linker for executables for Release-no-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE-NO-CONTRACTS "${LPS_SHARED_LINKER_FLAGS} /NODEFAULTLIB:MSVCRTD" CACHE
        STRING "Flags used by the linker for shared libraries for Release-no-contracts builds" FORCE)
    else()
        set(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS "${LPS_CXX_FLAGS} -DNDEBUG" CACHE
            STRING "Flags used by the C++ compiler for Release-no-contracts builds" FORCE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE-NO-CONTRACTS "${CMAKE_EXE_LINKER_FLAGS}" CACHE
        STRING "Flags used by the linker for executables for Release-no-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE-NO-CONTRACTS "${LPS_SHARED_LINKER_FLAGS}" CACHE
        STRING "Flags used by the linker for shared libraries for Release-no-contracts builds" FORCE)
    endif()
    
    # True for all currently supported platforms        
    mark_as_advanced(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS
                     CMAKE_EXE_LINKER_FLAGS_RELEASE-NO-CONTRACTS CMAKE_SHARED_LINKER_FLAGS_RELEASE-NO-CONTRACTS
                  )

endfunction(set_compiler_flags)

#
# Create the  build output directories.
#
function(create_output_dirs)

    # Create build/include for STD header files.
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
    # Create build/lib for libraries.
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
    # Create build/bin for executables.
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
    
    # These uber-verbose variable names have special meaning to cmake --
    # the cmake counterpart to what GNU autotools calls a "precious" variable.
    # Not a good idea to change them to anything shorter and sweeter; so don't.

    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin PARENT_SCOPE)

endfunction()

#
# Create per-configuration snapshot target for VS.
#
# # $$TODO: Add install target for win64
function(create_vswin64_snapshot_target)

    if(WIN64)
       # Set this for your system. Finding dumpbin is very tedious as there are 3 versions in a VS install. 
       set(DUMPBIN "C:/Program Files (x86)/Microsoft Visual Studio 9.0/VC/bin/amd64/dumpbin.exe")
       file(TO_NATIVE_PATH "$ENV{RELEASE_DIR}/Components-Win64/lib/$(ConfigurationName)" RELEASE_DIR)
       file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}/lib/$(ConfigurationName)" VS_LIBRARY_OUTPUT_DIR)
       file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}/bin/$(ConfigurationName)" VS_RUNTIME_OUTPUT_DIR)
        # Add the target
       set(SNAPSHOT_TARGET_NAME system_snapshot)        
       add_custom_target(${SNAPSHOT_TARGET_NAME} DEPENDS ${FIELDS_DYNAMIC_LIB})
    
       add_custom_command(TARGET ${SNAPSHOT_TARGET_NAME} PRE_BUILD
                          COMMAND ${CMAKE_COMMAND} -E make_directory ${RELEASE_DIR}
                          )
       set_target_properties(${SNAPSHOT_TARGET_NAME} PROPERTIES FOLDER "Release Targets")   
        # Create a post-build action associated with the VS snapshot target.
        # Copy the files to the release dir.
        # Create the release text file and populate it with pertinent info regarding the release.

       add_custom_command(TARGET ${SNAPSHOT_TARGET_NAME} POST_BUILD
            COMMAND copy "${VS_LIBRARY_OUTPUT_DIR}\\*.*" "${RELEASE_DIR}"
            COMMAND copy "${VS_RUNTIME_OUTPUT_DIR}\\*.*" "${RELEASE_DIR}"
            COMMAND ${DUMPBIN} "/OUT:${RELEASE_DIR}\\$(ConfigurationName).txt" "/DEPENDENTS" "${RELEASE_DIR}\\fieldsdll.dll"
            COMMAND echo: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo Configuration: >> "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo $(ConfigurationName) >> "${RELEASE_DIR}" "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo Platform: >> "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo $(PlatformName) >> "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo Date: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND date /T >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo Time: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND time /T >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo .NET Version: >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
            COMMAND echo $(FrameworkVersion) >>  "${RELEASE_DIR}\\$(ConfigurationName).txt"
           )
    endif(WIN64)

endfunction(create_vswin64_snapshot_target)

#
# Add the documentation targets.
#
function(add_doc_targets)

    if(DOXYGEN_FOUND)
        if(LPS_DOC_STATE MATCHES Dev)
            add_custom_target(doc ALL
                    COMMAND ${CMAKE_COMMAND} -E echo "Generating Developer Documentation ... " 
                    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/documentation/c++/${PROJECT_NAME}
                    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/dev_doxyfile
                            )
        else()
            add_custom_target(doc ALL
                     COMMAND ${CMAKE_COMMAND} -E echo "Generating User Documentation ... "  
                     COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/documentation/c++/${PROJECT_NAME}
                     COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/user_doxyfile
                             )
        endif()
                set_target_properties(doc PROPERTIES FOLDER "Documentation Targets")    
    endif()
                    
endfunction(add_doc_targets)

# 
#  Append file types to CMake's default clean list.
#
function(add_clean_files)

    file(GLOB HDF_FILES ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/*.hdf)
    file(GLOB JAR_FILES ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/*.jar)
    list(APPEND CLEAN_FILES ${HDF_FILES})
    list(APPEND CLEAN_FILES ${JAR_FILES})
    list(APPEND CLEAN_FILES TAGS)
    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${CLEAN_FILES}")

endfunction(add_clean_files) 

# 
# Establish a system "check" target
#
function(add_check_target)

    if(WIN64)
        add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} -C ${CMAKE_CFG_INTDIR} DEPENDS ${ALL_CHECK_TARGETS})
    else()
        add_custom_target(check DEPENDS ${ALL_CHECK_TARGETS})
    endif()
    set_target_properties(check PROPERTIES FOLDER "Check Targets")
        
endfunction(add_check_target)

#
# Add component specific check targets. e.g., "sheaves-check", "tools-check", etc.
#
function(add_component_check_target)

    add_custom_target(${PROJECT_NAME}-check COMMAND ${CMAKE_CTEST_COMMAND} DEPENDS ${${COMPONENT}_SHARED_LIB} ${${COMPONENT}_CHECK_EXECS})
    # Add a check target for this component to the system list. "make check" will invoke this list.
    set(ALL_CHECK_TARGETS ${ALL_CHECK_TARGETS} ${PROJECT_NAME}-check CACHE STRING "Aggregate list of component check targets" FORCE)
        set_target_properties(${PROJECT_NAME}-check PROPERTIES FOLDER "Check Targets")
    mark_as_advanced(ALL_CHECK_TARGETS) 

endfunction(add_component_check_target)

# 
# Create a cmake test for each unit test executable.
#
function(add_test_targets)

    if(${USE_VTK})
        link_directories(${VTK_LIB_DIR})
    endif()
    # link_directories only applies to targets created after it is called.
    if(LINUX64)
        link_directories(${${COMPONENT}_OUTPUT_DIR} ${HDF5_LIBRARY_DIRS} ${TETGEN_DIR})
    else()
        link_directories(${${COMPONENT}_OUTPUT_DIR}/${CMAKE_BUILD_TYPE} ${HDF5_LIBRARY_DIRS} ${TETGEN_DIR})
    endif()    
    # Let the user know what's being configured
    status_message("Configuring Unit Tests for ${PROJECT_NAME}")   
    foreach(t_cc_file ${${COMPONENT}_CHECK_EXEC_SRCS})

        # Extract name of executable from source filename
        string(REPLACE .t.cc .t t_file_with_path ${t_cc_file})
        # Remove path information  
        get_filename_component(t_file ${t_file_with_path} NAME)

        set(${COMPONENT}_CHECK_EXECS ${${COMPONENT}_CHECK_EXECS} ${t_file} CACHE STRING "List of unit test routines" FORCE)
        mark_as_advanced(${COMPONENT}_CHECK_EXECS)
        # If the target already exists, don't try to create it.
        if(NOT TARGET ${t_file})

             message(STATUS "Creating ${t_file} from ${t_cc_file}")
             add_executable(${t_file} EXCLUDE_FROM_ALL ${t_cc_file})
     
            # Make sure the library is up to date
            if(WIN64)
                # Supply the *_DLL_IMPORTS directive to preprocessor
                set_target_properties(${t_file} PROPERTIES COMPILE_DEFINITIONS "SHEAF_DLL_IMPORTS")
                add_dependencies(${t_file} ${FIELDS_IMPORT_LIB})
            else()
                add_dependencies(${t_file} ${${COMPONENT}_SHARED_LIB})
            endif()

            if(LINUX64)
                target_link_libraries(${t_file} ${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES})
            elseif(WIN64)
                if(${USE_VTK})
                    target_link_libraries(${t_file} ${FIELDS_IMPORT_LIB} ${HDF5_LIBRARIES} ${VTK_LIBS}) 
                else()
                    target_link_libraries(${t_file} ${FIELDS_IMPORT_LIB} ${HDF5_LIBRARIES})                                         
                endif()
                # Insert the unit tests into the VS folder "unit test targets"
                set_target_properties(${t_file} PROPERTIES FOLDER "Unit Test Targets")
            endif()

            # Add a test target for ${t_file}
         
            add_test(${t_file} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${t_file})
            # Tag the test with the name of the current component.
            set_property(TEST ${t_file} PROPERTY LABELS "${PROJECT_NAME}")

            if(WIN64)
                # Set the PATH environment variable for CTest so the HDF5 and Fields dlls lie in it.
                set_tests_properties(${t_file} PROPERTIES ENVIRONMENT
                                     "PATH=${HDF5_LIBRARY_DIRS};${${COMPONENT}_OUTPUT_DIR}:${CMAKE_CFG_INTDIR}")
            endif()
        endif()
    endforeach()

endfunction(add_test_targets)

# 
# Add any executable targets that are NOT unit tests.
#
function(add_example_targets)

    if(${USE_VTK})
        link_directories(${VTK_LIB_DIR})
    endif()

    foreach(t_cc_file ${${COMPONENT}_EXEC_SRCS})
        # link_directories only applies to targets created after it is called.
        if(LINUX64)
            link_directories(${${COMPONENT}_OUTPUT_DIR} ${HDF5_LIBRARY_DIRS} ${TETGEN_DIR})
        else()
            link_directories(${${COMPONENT}_OUTPUT_DIR}/${CMAKE_BUILD_TYPE} ${HDF5_LIBRARY_DIRS} ${TETGEN_DIR})
        endif()    
        # Let the user know what's being configured
        status_message("Configuring example executables for ${PROJECT_NAME}")   
        # Deduce name of executable from source filename
        string(REPLACE .cc "" t_file_with_path ${t_cc_file})
        # Remove path information so the executable goes into build/bin (or build/VisualStudio)
        # and not into build/bin/examples (or build/VisualStudio/examples)
        get_filename_component(t_file ${t_file_with_path} NAME)
    
        # Add building of executable and link with shared library
        message(STATUS "Creating ${t_file} from ${t_cc_file}")
        add_executable(${t_file}  EXCLUDE_FROM_ALL ${t_cc_file})
    
        # Make sure the library is up to date
        if(WIN64)
            add_dependencies(${t_file} ${FIELDS_IMPORT_LIB})
            if(${USE_VTK})
                target_link_libraries(${t_file} ${FIELDS_IMPORT_LIB} ${HDF5_LIBRARIES} ${VTK_LIBS})
            else()
                target_link_libraries(${t_file} ${FIELDS_IMPORT_LIB} ${HDF5_LIBRARIES})
            endif()
            # Insert the unit tests into the VS folder "unit_tests"
            set_target_properties(${t_file} PROPERTIES FOLDER "Standalone Exec Targets")
        else()
            add_dependencies(${t_file} ${${COMPONENT}_SHARED_LIB})
            target_link_libraries(${t_file} ${${COMPONENT}_SHARED_LIB} ${HDF5_LIBRARIES})
        endif()
    
        # Supply the *_DLL_IMPORTS directive to preprocessor
        set_target_properties(${t_file} PROPERTIES COMPILE_DEFINITIONS "SHEAF_DLL_IMPORTS")
  
    endforeach()

endfunction(add_example_targets)

#
# Add the list of clusters to this component.
#
function(add_clusters clusters)

    foreach(cluster ${clusters})
        #Add each cluster subdir to the project. 
        add_subdirectory(${cluster})
        #Add each cluster to the compiler search path.
        include_directories(${cluster})
        # Add the fully-qualified cluster names to this component's ipath var
        set(${COMPONENT}_IPATH ${${COMPONENT}_IPATH} ${CMAKE_CURRENT_SOURCE_DIR}/${cluster} CACHE STRING "test" FORCE)
    endforeach()

endfunction(add_clusters)

# 
# Declare and initialize all variables that are component-specific.
#
function(set_component_vars)

    if(WIN64)
        # Fields import lib won't exist when it's antecedents are configured. Force it.
        set(FIELDS_IMPORT_LIB fieldsdll CACHE STRING "${PROJECT_NAME} import library")
        set(${COMPONENT}_DYNAMIC_LIB ${PROJECT_NAME}dll CACHE STRING "${PROJECT_NAME} dynamic link library")
        set(${COMPONENT}_IMPORT_LIB ${PROJECT_NAME}dll CACHE STRING "${PROJECT_NAME} import library")
    else()
        set(${COMPONENT}_SHARED_LIB lib${PROJECT_NAME}.so CACHE STRING "${PROJECT_NAME} shared library")
        set(${COMPONENT}_STATIC_LIB lib${PROJECT_NAME}.a CACHE STRING "${PROJECT_NAME} static library")
    endif()

    set(${COMPONENT}_COMMON_BINDING_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bindings/common/src CACHE STRING "${PROJECT_NAME} common binding source directory")

    set(${COMPONENT}_JAVA_BINDING_LIB ${PROJECT_NAME}_java_binding CACHE STRING "${PROJECT_NAME} java binding library basename")
    set(${COMPONENT}_JAVA_BINDING_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bindings/java/src CACHE STRING "${PROJECT_NAME} java binding source directory")
    set(${COMPONENT}_SWIG_JAVA_INTERFACE ${PROJECT_NAME}_java_binding.i CACHE STRING "${PROJECT_NAME} java binding interface file")

    set(${COMPONENT}_JAVA_BINDING_JAR ${PROJECT_NAME}_java_binding.jar CACHE STRING "${PROJECT_NAME} java binding jar name")
    
    set(${COMPONENT}_PYTHON_BINDING_LIB _${PROJECT_NAME}_python_binding CACHE STRING "${PROJECT_NAME} python binding library name")
    set(${COMPONENT}_PYTHON_BINDING_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bindings/python/src CACHE STRING "${PROJECT_NAME} python source directory")
    set(${COMPONENT}_SWIG_PYTHON_INTERFACE ${PROJECT_NAME}_python_binding.i CACHE STRING "${PROJECT_NAME} python binding interface file")

    # Mark all the above as "advanced"
    mark_as_advanced(FORCE ${COMPONENT}_BINARY_DIR)
    mark_as_advanced(FORCE ${COMPONENT}_LIB_DIR)
    mark_as_advanced(FORCE ${COMPONENT}_DYNAMIC_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_IMPORT_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_SHARED_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_STATIC_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_COMMON_BINDING_SRC_DIR)
    mark_as_advanced(FORCE ${COMPONENT}_JAVA_BINDING_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_JAVA_BINDING_SRC_DIR)
    mark_as_advanced(FORCE ${COMPONENT}_SWIG_JAVA_INTERFACE)
    mark_as_advanced(FORCE ${COMPONENT}_JAVA_BINDING_JAR)
    mark_as_advanced(FORCE ${COMPONENT}_PYTHON_BINDING_LIB)
    mark_as_advanced(FORCE ${COMPONENT}_PYTHON_BINDING_SRC_DIR)
    mark_as_advanced(FORCE ${COMPONENT}_SWIG_PYTHON_INTERFACE)

endfunction(set_component_vars)

#
# Export this component's library targets
#
function(export_targets)

    status_message("Writing ${PROJECT_NAME} detail to ${CMAKE_BINARY_DIR}/${EXPORTS_FILE}")
    if(WIN64)
        export(TARGETS ${${COMPONENT}_DYNAMIC_LIB} APPEND FILE ${CMAKE_BINARY_DIR}/${EXPORTS_FILE})
    else()
        export(TARGETS ${${COMPONENT}_SHARED_LIB} ${${COMPONENT}_STATIC_LIB} APPEND FILE ${CMAKE_BINARY_DIR}/${EXPORTS_FILE})
    endif()

endfunction(export_targets)

#
# Export this component's variables
#
function(export_variables)

    status_message("Writing ${PROJECT_NAME} variable detail to ${CMAKE_BINARY_DIR}/${EXPORTS_FILE}")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_INCS ${${COMPONENT}_INCS} CACHE STRING \"${PROJECT_NAME} includes\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_IPATH ${${COMPONENT}_IPATH} CACHE STRING \"${PROJECT_NAME} include path\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_CLASSPATH ${${COMPONENT}_CLASSPATH} CACHE STRING \"${PROJECT_NAME} Java classpath\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_BIN_OUTPUT_DIR ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} CACHE STRING \"${PROJECT_NAME} binary output directory\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_LIB_OUTPUT_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} CACHE STRING \"${PROJECT_NAME} library output directory\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")

    # Swig java interface vars
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_JAVA_BINDING_LIB ${${COMPONENT}_JAVA_BINDING_LIB} CACHE STRING \"${PROJECT_NAME} java binding library\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_JAVA_BINDING_SRC_DIR ${${COMPONENT}_JAVA_BINDING_SRC_DIR} CACHE STRING \"${PROJECT_NAME} java binding source directory\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_SWIG_JAVA_INTERFACE ${${COMPONENT}_SWIG_JAVA_INTERFACE} CACHE STRING \"${PROJECT_NAME} java-swig interface\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_JAVA_BINDING_JAR ${${COMPONENT}_JAVA_BINDING_JAR} CACHE STRING \"${PROJECT_NAME} java binding jar file\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")

    # Swig python interface vars
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_PYTHON_BINDING_LIB ${${COMPONENT}_PYTHON_BINDING_LIB} CACHE STRING \"${PROJECT_NAME} python binding library\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_PYTHON_BINDING_SRC_DIR ${${COMPONENT}_PYTHON_BINDING_SRC_DIR} CACHE STRING \"${PROJECT_NAME} python binding source directory\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_SWIG_PYTHON_INTERFACE ${${COMPONENT}_SWIG_PYTHON_INTERFACE} CACHE STRING \"${PROJECT_NAME} python-swig interface\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")

    # Swig common interface vars
    file(APPEND ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "set(${COMPONENT}_COMMON_BINDING_SRC_DIR ${${COMPONENT}_COMMON_BINDING_SRC_DIR} CACHE STRING \"${PROJECT_NAME} common binding source directory\")\n")
    file(APPEND  ${CMAKE_BINARY_DIR}/${EXPORTS_FILE} "\n")

endfunction(export_variables)

#
# Append sources to their respective component variables
# Used in cluster level CMakeLists.txt
#
function(collect_sources)

    # Prepend the cluster name to each member of the srcs list
    foreach(src ${SRCS})
        list(APPEND lsrcs ${CMAKE_CURRENT_SOURCE_DIR}/${src})
    endforeach()
        
    set(${COMPONENT}_SRCS ${${COMPONENT}_SRCS} ${lsrcs} CACHE STRING "${PROJECT} sources." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_SRCS)

endfunction()

#
# Append incs to their respective component variables
# Used in cluster level CMakeLists.txt
#
function(collect_includes)

    # Prepend the cluster name to each member of the srcs list
    foreach(src ${SRCS})
        string(REGEX REPLACE ".cc$" ".h"  inc ${src})
        list(APPEND lincs ${CMAKE_CURRENT_SOURCE_DIR}/${inc})
    endforeach()

    # Prepend the cluster name to each member of the additional_incs list
    foreach(inc ${ADDITIONAL_INCS})
        list(APPEND lincs ${CMAKE_CURRENT_SOURCE_DIR}/${inc})
    endforeach()

    set(${COMPONENT}_INCS ${${COMPONENT}_INCS} ${lincs} CACHE STRING "${PROJECT} includes." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_INCS)

endfunction(collect_includes)

#
# Append unit test executables to their respective component variables
# Used in cluster level CMakeLists.txt
#
function(collect_unit_test_sources)

    # Prepend the path to each member of the check_execs list
    foreach(src ${UNIT_TEST_SRCS})
        list(APPEND chksrcs ${CMAKE_CURRENT_SOURCE_DIR}/${src})
    endforeach()
    
    set(${COMPONENT}_CHECK_EXEC_SRCS ${${COMPONENT}_CHECK_EXEC_SRCS} ${chksrcs} CACHE STRING "Unit test sources." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_CHECK_EXEC_SRCS)
    
endfunction(collect_unit_test_sources)

#
# Append standalone executables to their respective component variables
# Used in cluster level CMakeLists.txt
#
function(collect_example_sources)

    # Prepend the path to each member of the execs list
    foreach(src ${EXAMPLE_SRCS})
        list(APPEND execsrcs ${CMAKE_CURRENT_SOURCE_DIR}/${src})
    endforeach()

    set(${COMPONENT}_EXEC_SRCS ${${COMPONENT}_EXEC_SRCS} ${execsrcs} CACHE STRING "EXEC sources." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_EXEC_SRCS)

endfunction(collect_example_sources)

# 
# Convenience routine for text output during configure phase.
#
function(status_message txt)

    # Let the user know what's being configured
    message(STATUS " ")
    message(STATUS "${txt} - ")
    message(STATUS " ")

endfunction()



