#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
# Contains all that is LPS specific; all flags, all macros, etc.
#


#------------------------------------------------------------------------------ 
# Variable Definition Section
#------------------------------------------------------------------------------

#
# Turn on project folders for Visual Studio.
#
if(WIN64MSVC OR WIN64INTEL)
    set_property(GLOBAL PROPERTY USE_FOLDERS On)
endif()

#
# Comvert the project name to UC
#
string(TOUPPER ${PROJECT_NAME} COMPONENT)

#
# Tell the linker where to look for COMPONENT libraries.
#
link_directories(${SHEAVES_LIB_OUTPUT_DIR})

#
# Set the location and name of the Intel coverage utilities
# Linux only for now.
#

if(LINUX64INTEL)
    # Lop the compiler name off the end of the CXX string
    string(REPLACE "/icpc" "" INTELPATH ${CMAKE_CXX_COMPILER})
    set(INTEL_LIBPATH "${INTELPATH}/lib/intel64" CACHE STRING "Intel C++ compiler library path." )

elseif(LINUX64GNU)

    # Lop the compiler name off the end of the CXX string to get the gnu root.
    string(REPLACE "bin/g++" "" GNUPATH ${CMAKE_CXX_COMPILER})
    # The compiler library path.
    set(GNU_LIBPATH "${GNUPATH}lib64" CACHE STRING "GNU C++ compiler library path." )

endif()

#
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
# Set the compiler flags per build configuration
#
function(set_compiler_flags)
   
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

        # Toggle multi-process compilation in Windows
        # Set in system_definitions.cmake
        if(ENABLE_WIN32_MP)
            set(MP "/MP")
        else()
            set(MP "")
        endif()

    if(WIN64MSVC)
       message(STATUS "Weve got WINDOWS")
       # Clear all cmake's intrinsic vars. If we don't, then their values will be appended to our
       # compile and link lines.
       set(LPS_CXX_FLAGS "/D_USRDLL ${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /EHsc ${OPTIMIZATION} /D_HDF5USEDLL_" CACHE STRING "C++ Compiler Flags" FORCE)
       set(LPS_SHARED_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /OPT:REF /OPT:ICF /DYNAMICBASE /NXCOMPAT /MACHINE:X64"  CACHE STRING "Linker Flags" FORCE)

    elseif(WIN64INTEL)
       set(LPS_CXX_FLAGS "/D_USRDLL ${MP} /GR /nologo /DWIN32 /D_WINDOWS /W1 /wd2651 /EHsc ${OPTIMIZATION} /Qprof-gen:srcpos /D_HDF5USEDLL_" CACHE STRING "C++ Compiler Flags" FORCE)
       set(LPS_SHARED_LINKER_FLAGS "/INCREMENTAL:NO /NOLOGO /DLL /SUBSYSTEM:CONSOLE /OPT:REF /OPT:ICF /DYNAMICBASE /NXCOMPAT /MACHINE:X64"  CACHE STRING "Linker Flags" FORCE) 
       
    elseif(LINUX64INTEL)

        if(ENABLE_COVERAGE)
            if(INTELWARN)
               set(LPS_CXX_FLAGS "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated ${OPTIMIZATION} -prof-gen=srcpos")
            else()
               set(LPS_CXX_FLAGS "-ansi -m64 -w0 -Wno-deprecated ${OPTIMIZATION} -prof-gen=srcpos")
            endif()
        else()
            if(INTELWARN)
               set(LPS_CXX_FLAGS "-ansi -m64 -w1 -wd186,1125 -Wno-deprecated ${OPTIMIZATION}")
            else()
               set(LPS_CXX_FLAGS "-ansi -m64 -w0 -Wno-deprecated ${OPTIMIZATION}")
            endif()
        endif() # ENABLE_COVERAGE          

     elseif(LINUX64GNU)
         set(LPS_CXX_FLAGS "-ansi -m64 -Wno-deprecated ${OPTIMIZATION}")
             
    #$$TODO: A 32 bit option is not needed. Do away with this case.
    else() # Assume 32-bit i686 linux for the present
       set(LPS_CXX_FLAGS "-ansi -m32 -Wno-deprecated ${OPTIMIZATION}")
    endif()

    #                 
    # DEBUG_CONTRACTS section
    #
        
    # Configuration specific flags 
    if(WIN64MSVC OR WIN64INTEL)
        if(${USE_VTK})     
            set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=1\" /MDd /DUSE_VTK" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
        else()
             set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=1\" /MDd" CACHE
                STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)       
        endif()
    else()
        if(${USE_VTK})
                if(LINUX64INTEL)
                    set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g -DUSE_VTK -limf" CACHE
                        STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
                else()
                    set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g -DUSE_VTK" CACHE
                        STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
                endif()                
        else()         
                if(LINUX64INTEL)
                    set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g -limf" CACHE
                        STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
                else()
                    set(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS "${LPS_CXX_FLAGS} -g " CACHE
                        STRING "Flags used by the C++ compiler for Debug-contracts builds" FORCE)
                endif() 
        endif()
    endif()
    
    # True for all currently supported platforms    
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG-CONTRACTS ${CMAKE_EXE_LINKER_FLAGS}  CACHE
        STRING "Flags used by the linker for executables for Debug-contracts builds" FORCE)
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG-CONTRACTS ${LPS_SHARED_LINKER_FLAGS} CACHE
        STRING "Flags used by the linker for shared libraries for Debug-contracts builds" FORCE)
    mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG-CONTRACTS
                     CMAKE_EXE_LINKER_FLAGS_DEBUG-CONTRACTS CMAKE_SHARED_LINKER_FLAGS_DEBUG-CONTRACTS)

    #                 
    # DEBUG_NO_CONTRACTS section
    #      

    # Configuration specific flags 
    if(WIN64MSVC OR WIN64INTEL)
        if(${USE_VTK}) 
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=1\" /MDd /DUSE_VTK /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Debug-no-contracts builds" FORCE)
         else()   
            set(CMAKE_CXX_FLAGS_DEBUG-NO-CONTRACTS "${LPS_CXX_FLAGS} /Zi /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=1\" /MDd /DNDEBUG" CACHE
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
    if(WIN64MSVC OR WIN64INTEL)
     if(${USE_VTK})
        set(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=0\" /DUSE_VTK /MD" CACHE
            STRING "Flags used by the C++ compiler for Release-contracts builds" FORCE)
      else()   
        set(CMAKE_CXX_FLAGS_RELEASE-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=0\" /MD" CACHE
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
    if(WIN64MSVC OR WIN64INTEL)
        if(${USE_VTK})
            set(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=0\" /MD /DUSE_VTK /DNDEBUG" CACHE
                STRING "Flags used by the C++ compiler for Release-no-contracts builds" FORCE)
       else()        
            set(CMAKE_CXX_FLAGS_RELEASE-NO-CONTRACTS "${LPS_CXX_FLAGS} /D\"_SECURE_SCL=1\" /D\"_HAS_ITERATOR_DEBUG=0\" /MD /DNDEBUG" CACHE
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
# Create the build output directories.
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
#  Append file types to CMake's default clean list.
#
function(add_clean_files)

    #Define the file types to be included in the clean operation.
    file(GLOB HDF_FILES ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/*.hdf)
    file(GLOB LOG_FILES ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/*.log)
    file(GLOB JAR_FILES ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/*.jar)

    # Append them to the list
    list(APPEND CLEAN_FILES ${HDF_FILES})
    list(APPEND CLEAN_FILES ${LOG_FILES})    
    list(APPEND CLEAN_FILES ${JAR_FILES})
    list(APPEND CLEAN_FILES "TAGS")
    
    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${CLEAN_FILES}")

endfunction(add_clean_files) 

# 
# Create a target for each example.
#
function(add_example_targets)

    include_directories(${FIELDS_IPATHS})

    if(${USE_VTK})
        link_directories(${VTK_LIB_DIR})
    endif()

    foreach(t_cc_file ${${COMPONENT}_EXAMPLE_SRCS})
        # link_directories only applies to targets created after it is called.
        if(LINUX64GNU OR LINUX64INTEL)
            link_directories(${${COMPONENT}_OUTPUT_DIR} ${SHEAVES_LIB_OUTPUT_DIR})
        else()
            link_directories(${${COMPONENT}_OUTPUT_DIR}/${CMAKE_BUILD_TYPE} ${SHEAVES_LIB_OUTPUT_DIR})
        endif()    
        
        # Let the user know what's being configured
        status_message("Configuring example executables for ${PROJECT_NAME}")   
        
        # Deduce name of executable from source filename
        string(REPLACE .cc "" t_file_with_path ${t_cc_file})
        
        # Remove path information so the executable goes into build/bin (or build/VisualStudio)
        # and not into build/bin/examples (or build/VisualStudio/examples)
        get_filename_component(t_file ${t_file_with_path} NAME)
        set(${COMPONENT}_EXAMPLES ${${COMPONENT}_EXAMPLES} ${t_file} CACHE STRING "List of example binaries" FORCE)
        mark_as_advanced(${COMPONENT}_EXAMPLES)
            
        # Add building of executable and link with shared library
        message(STATUS "Creating ${t_file} from ${t_cc_file}")
        add_executable(${t_file}  EXCLUDE_FROM_ALL ${t_cc_file})
    
        # Make sure the library is up to date
        if(WIN64MSVC OR WIN64INTEL)
            if(${USE_VTK})
                target_link_libraries(${t_file} ${FIELDS_IMPORT_LIBS} ${VTK_LIBS})
            else()
                target_link_libraries(${t_file} ${FIELDS_IMPORT_LIBS})
            endif()
            # Insert the unit tests into the VS folder "unit_tests"
            set_target_properties(${t_file} PROPERTIES FOLDER "Example Targets")
        else()
          # add_dependencies(${t_file})
           target_link_libraries(${t_file} ${FIELDS_SHARED_LIBS})
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
        # Add the fully-qualified cluster names to this component's ipath var
        set(${COMPONENT}_IPATH ${${COMPONENT}_IPATH} ${CMAKE_CURRENT_SOURCE_DIR}/${cluster} CACHE STRING "test" FORCE)
    endforeach()

endfunction(add_clusters)

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
    
    set(${COMPONENT}_UNIT_TEST_SRCS ${${COMPONENT}_UNIT_TEST_SRCS} ${chksrcs} CACHE STRING "Unit test sources." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_UNIT_TEST_SRCS)
    
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

    set(${COMPONENT}_EXAMPLE_SRCS ${${COMPONENT}_EXAMPLE_SRCS} ${execsrcs} CACHE STRING "EXEC sources." FORCE)
    mark_as_advanced(FORCE ${COMPONENT}_EXAMPLE_SRCS)

endfunction(collect_example_sources)

# 
# Convenience routine for diagnostic output during configure phase.
#
function(status_message txt)

    # Let the user know what's being configured
    message(STATUS " ")
    message(STATUS "${txt} - ")
    message(STATUS " ")

endfunction()

# 
# Convenience routine for diagnostic output during configure phase.
# Displays list of included directories for module it is called in.
#
function(showincs)
    message(STATUS "Displaying include directories for ${PROJECT_NAME}:")
    message(STATUS "===================================================")    
    get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
    foreach(dir ${dirs})
        message(STATUS "dir='${dir}'")
    endforeach() 
    message(STATUS "===================================================")       
endfunction()
  
#
# Create an archive target. Only applicable when using git.
#
if(GIT_FOUND)
    function(add_archive_target)
    
        add_custom_target(archive 
                          COMMAND ${GIT_EXECUTABLE} archive --output ${PROJECT_NAME}.zip master
                          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/.. )
    
    endfunction()
endif()
