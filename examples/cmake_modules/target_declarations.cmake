#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

#
# Library targets
#

#shared-libs <lib>
#    - <comp>-shared-lib
#
#static-libs
#    - <comp>-static-lib
#    
#bindings
#    java-bindings
#        - <comp>-java-binding
#    python-bindings
#        <comp>-python-binding
#

if(LINUX64)
     # "shared-libs" builds solely shared libs
    add_custom_target(shared-lib)

    # Alias for shared lib; backward naming compatability with gnu system
    add_custom_target(lib)
    add_dependencies(lib shared-lib)
    
    # "static-libs" builds solely static libs
    add_custom_target(static-lib)

    # Add a shared and static library target for each component
#    add_custom_target(${PROJECT_NAME}-shared-lib)
#    add_custom_target(${PROJECT_NAME}-static-lib)   
endif()

#
# Bindings targets
#

# "make bindings" builds the entire system.
# <component>-bindings builds all for <component>

if(LINUX64)

    add_custom_target(bindings)
    add_custom_target(java-binding)
    add_custom_target(python-binding)    

    # Because the library dependencies are correct, we only
    # need to list the leaf nodes in the dependency list for bindings.
    add_dependencies(bindings ${PROJECT_NAME}-bindings)
    
    # Aggregate java bindings target
    add_custom_target(java-bindings)
    list(APPEND JAVA_BINDING_TARGETS java-binding)
    add_dependencies(java-bindings ${JAVA_BINDING_TARGETS})

    # Aggregate python bindings target
    add_custom_target(python-bindings)
    list(APPEND PYTHON_BINDING_TARGETS python-binding)
    add_dependencies(python-bindings ${PYTHON_BINDING_TARGETS})

endif()

#
# clean targets
#
if(LINUX64)
    add_custom_target(docclean 
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)
        
    add_custom_target(realclean 
            COMMAND ${CMAKE_COMMAND} --build  ${CMAKE_BINARY_DIR} --target clean
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)   
endif()  
#
# Documentation targets
#

if(LINUX64)
    add_custom_target(java-docs)
    add_dependencies(java-docs sheaves-java-docs fiber_bundles-java-docs geometry-java-docs
                     fields-java-docs solvers-java-docs tools-java-docs)
                 
    add_custom_target(alldocs DEPENDS doc java-docs)
endif()

#
# Help targets
# $$TODO: format output to 80 chars
if(LINUX64)
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
        COMMAND ${CMAKE_COMMAND} -E echo "    bindings"
        COMMAND ${CMAKE_COMMAND} -E echo "    check"
        COMMAND ${CMAKE_COMMAND} -E echo "    doc"        
        COMMAND ${CMAKE_COMMAND} -E echo "    shared-libs"
        COMMAND ${CMAKE_COMMAND} -E echo "    static-libs"
        COMMAND ${CMAKE_COMMAND} -E echo "    SheafScope"


        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "all [default]:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds the entire system -- shared libraries, static libraries, bindings, and all docs "
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "bindings:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds the shared libraries, bindings libraries and associated jar files for all"
        COMMAND ${CMAKE_COMMAND} -E echo "    system components -- also builds the SheafScope"
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: SheafScope."
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "    Sub-commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        Bindings targets can be invoked per component as well as per component-language"
        COMMAND ${CMAKE_COMMAND} -E echo "        All prerequisite libraries will be constructed in dependency order if needed."
        COMMAND ${CMAKE_COMMAND} -E echo "    " 
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields-bindings"
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields-java-binding"
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields-python-binding"                     
        COMMAND ${CMAKE_COMMAND} -E echo "    "            
        COMMAND ${CMAKE_COMMAND} -E echo "check:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds all shared libraries and unit test routines, then executes the unit " 
        COMMAND ${CMAKE_COMMAND} -E echo "    tests. Provided make -j1, execution will be in component order. That is -- all"
        COMMAND ${CMAKE_COMMAND} -E echo "    tests for a component will be built and executed in serial order before moving on the next"
        COMMAND ${CMAKE_COMMAND} -E echo "    on to the next component. If make -j greater than 1, behavior may vary."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "doc:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Constructs system-scope C++ library documentation, placing the output in CMAKE_BINARY_DIR/documentation"
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Sub-commands:"                    
        COMMAND ${CMAKE_COMMAND} -E echo "        java-docs -- Builds the system bindings and constructs java documentation for same."
        COMMAND ${CMAKE_COMMAND} -E echo "                     Does not construct the C++ library docs."
        COMMAND ${CMAKE_COMMAND} -E echo "        alldocs   -- Contructs C++ and java documentation    "
        COMMAND ${CMAKE_COMMAND} -E echo ""              
        COMMAND ${CMAKE_COMMAND} -E echo "shared-libs:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds the shared libraries, and only the shared libraries, for all system components."
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: lib"
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Sub-commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        [comp]-shared-lib will invoke the shared library target for [comp], dealing"
        COMMAND ${CMAKE_COMMAND} -E echo "        with dependencies in order."
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields-shared-lib"   
        COMMAND ${CMAKE_COMMAND} -E echo ""        
        COMMAND ${CMAKE_COMMAND} -E echo "static-libs:    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds the static libraries, and only the static libraries, for all system components.     "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Sub-commands:"
        COMMAND ${CMAKE_COMMAND} -E echo "        \"<comp>\"-static-lib will invoke the static library target for \"<comp>\", dealing"
        COMMAND ${CMAKE_COMMAND} -E echo "        with dependencies in order."
        COMMAND ${CMAKE_COMMAND} -E echo "        example: make fields-static-lib"   
        COMMAND ${CMAKE_COMMAND} -E echo "    "

    )
      

endif()

#$$TODO: add an "examples" target

