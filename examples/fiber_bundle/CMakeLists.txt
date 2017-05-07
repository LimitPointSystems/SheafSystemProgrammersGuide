#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#

#------------------------------------------------
# Programmer Filename Entry Section
#------------------------------------------------

set(CLUSTER ${CMAKE_CURRENT_BINARY_DIR})

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
#    example27.cc
    example28.cc
    example29.cc
    example30.cc
    example31.cc
    )

SSPG_collect_example_sources(fiber_bundle "${EXAMPLE_SRCS}")

