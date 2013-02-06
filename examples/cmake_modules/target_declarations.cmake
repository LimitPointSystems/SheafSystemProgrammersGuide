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
    
    # Add a shared and static library target for each component
    foreach(comp ${COMPONENTS})
        message(STATUS "Adding lib target: ${comp}-shared-lib")
        add_custom_target(${comp}-shared-lib)
        add_custom_target(${comp}-static-lib)   
    endforeach() 
    
     # "shared-libs" builds solely shared libs
    add_custom_target(shared-libs)
    
    # Because the library dependencies are correct, we only
    # need to list the leaf nodes in the dependency list for shared libs.
    add_dependencies(shared-libs fields_test-shared-lib)

    # Alias for shared lib; backward naming compatability with gnu system
    add_custom_target(lib)
    add_dependencies(lib shared-libs)
    
    # "static-libs" builds solely static libs
    add_custom_target(static-libs)
    
    # Because the library dependencies are correct, we only
    # need to list the leaf nodes in the dependency list for static libs.
    add_dependencies(static-libs fields_test-static-lib)

    #
    # clean targets
    #
    add_custom_target(docclean 
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)
        
    add_custom_target(realclean 
            COMMAND ${CMAKE_COMMAND} --build  ${CMAKE_BINARY_DIR} --target clean
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)   
    # Remove html dpi CodeCoverage dir and .lock files for coverage dir
    add_custom_target(covclean 
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${COVERAGE_DIR}/CodeCoverage
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.dpi
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.lock
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.HTML
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.dyn
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.spi
            COMMAND ${CMAKE_COMMAND} -E remove -f ${COVERAGE_DIR}/*.spl 
    )
    #
    # Documentation targets
    #
    add_custom_target(java-docs)
    add_dependencies(java-docs sheaves-java-docs fiber_bundles-java-docs geometry-java-docs
                     fields-java-docs solvers-java-docs tools-java-docs)
                 
    add_custom_target(alldocs DEPENDS doc java-docs)

endif()

