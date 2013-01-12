#
# $RCSfile: target_declarations.cmake,v $ $Revision: 1.11 $ $Date: 2012/07/07 18:27:55 $
#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#


#
# Library targets
#
if(LINUX64GNU OR LINUX64INTEL)

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

    #
    # Help targets
    # 
    add_custom_target(help
        COMMAND ${CMAKE_COMMAND} -E echo "" 
        COMMAND ${CMAKE_COMMAND} -E echo "The following top level help targets are available: "
        COMMAND ${CMAKE_COMMAND} -E echo "    help-targets"
        COMMAND ${CMAKE_COMMAND} -E echo "    help-options"
        COMMAND ${CMAKE_COMMAND} -E echo "")
        
    add_custom_target(help-options
        COMMAND ${CMAKE_COMMAND} -E echo "" 
        COMMAND ${CMAKE_COMMAND} -E echo "NOT IMPLEMENTED "
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "")
        
    add_custom_target(help-targets
        COMMAND ${CMAKE_COMMAND} -E echo "" 
        COMMAND ${CMAKE_COMMAND} -E echo "The fundamental targets are: "
        COMMAND ${CMAKE_COMMAND} -E echo "    all"
        COMMAND ${CMAKE_COMMAND} -E echo "    bin" 
        COMMAND ${CMAKE_COMMAND} -E echo "    check"
        COMMAND ${CMAKE_COMMAND} -E echo "    coverage"
        COMMAND ${CMAKE_COMMAND} -E echo "    doc"


        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "all [default]:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds and runs all unit tests. "
        COMMAND ${CMAKE_COMMAND} -E echo "    Provided make -j1, execution will be in component order. That is -- all "
        COMMAND ${CMAKE_COMMAND} -E echo "    tests for a component will be built and executed in serial order before moving "
        COMMAND ${CMAKE_COMMAND} -E echo "    on to the next component. If value of j is greater than 1, behavior may vary."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: check."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "bin:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds all unit test routines and examples." 
        COMMAND ${CMAKE_COMMAND} -E echo "    Does not execute any compiled code."
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        Bin targets can be invoked per component. All prerequisite libraries "
        COMMAND ${CMAKE_COMMAND} -E echo "        and executables will be constructed in dependency order if needed."
        COMMAND ${CMAKE_COMMAND} -E echo "    " 
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields_test-bin"
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make sheaves_test-bin"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
    
        COMMAND ${CMAKE_COMMAND} -E echo "check:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds and runs all unit tests. "
        COMMAND ${CMAKE_COMMAND} -E echo "    Provided make -j1, execution will be in component order. That is -- all "
        COMMAND ${CMAKE_COMMAND} -E echo "    tests for a component will be built and executed in serial order before moving "
        COMMAND ${CMAKE_COMMAND} -E echo "    on to the next component. If value of j is greater than 1, behavior may vary."
        COMMAND ${CMAKE_COMMAND} -E echo "    "            
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        Check targets can be invoked per component. All prerequisite libraries "
        COMMAND ${CMAKE_COMMAND} -E echo "        will be constructed in dependency order if needed."
        COMMAND ${CMAKE_COMMAND} -E echo "    " 
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields_test-check"
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make sheaves_test-check"
        COMMAND ${CMAKE_COMMAND} -E echo "    " 
        COMMAND ${CMAKE_COMMAND} -E echo "coverage:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Only available if C++ compiler is Intel"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds all unit test routines using '-prof-gen=srcpos' on  " 
        COMMAND ${CMAKE_COMMAND} -E echo "    linux, or '/Qprof-gen:srcpos' on Windows , executes the unit tests, and generates coverage documentation"
        COMMAND ${CMAKE_COMMAND} -E echo "    Provided make -j1, execution will be in component order. That is -- all"
        COMMAND ${CMAKE_COMMAND} -E echo "    tests for a component will be built and executed in serial order before moving"
        COMMAND ${CMAKE_COMMAND} -E echo "    on to the next component. If value of j is greater than 1, behavior may vary."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    NOTE: The SheafSystem must be built '-prof-gen=srcpos' on linux. or "
        COMMAND ${CMAKE_COMMAND} -E echo "    '/Qprof-gen:srcpos' on Windows for this target to produce coverage results. "
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        Coverage targets can be invoked per component. All prerequisite libraries "
        COMMAND ${CMAKE_COMMAND} -E echo "        and executables will be constructed in dependency order if needed."
        COMMAND ${CMAKE_COMMAND} -E echo "    " 
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields_test-coverage"
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make sheaves_test-coverage"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "doc:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Constructs system-scope C++ library documentation, placing the output in CMAKE_BINARY_DIR/documentation"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands:"                    
        COMMAND ${CMAKE_COMMAND} -E echo "        java-docs -- Builds the system bindings and constructs java documentation for same."
        COMMAND ${CMAKE_COMMAND} -E echo "                     Does not construct the C++ library docs."
        COMMAND ${CMAKE_COMMAND} -E echo "        alldocs   -- Contructs C++ and java documentation    "
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "[test].t.log:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds and runs [test].t. Redirects output from run into bin/[test].t.log"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands: check"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "       example: make poset.t.log"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    "                                        
  
    )


endif()

#
# $$HACK:
# Convenience targets to abstract away the _test nomenclature
#

    add_custom_target(sheaves-coverage DEPENDS sheaves_test-coverage)
    add_custom_target(fiber_bundles-coverage DEPENDS fiber_bundles_test-coverage)
    add_custom_target(geometry-coverage DEPENDS geometry_test-coverage)
    add_custom_target(fields-coverage DEPENDS fields_test-coverage)            
