#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#

#------------------------------------------------
# Programmer Filename Entry Section
#------------------------------------------------

set(CLUSTER ${CMAKE_CURRENT_BINARY_DIR})

#
# Library sources.
#
set(SRCS
    )

collect_sources()

#
# Headers that are NOT associated with a .cc file.
#
set(ADDITIONAL_INCS
    )

collect_includes()  

#
# Source for unit test executables.
#
set(UNIT_TEST_SRCS
    )

collect_unit_test_sources()

#
# Source for example executables.
#
set(EXAMPLE_SRCS
    example21.cc
    example22.cc
    example23.cc
    example24.cc
    example25.cc
    example26.cc
    example27.cc
    example28.cc
    example29.cc
    example30.cc
    example31.cc
    )

collect_example_sources()

