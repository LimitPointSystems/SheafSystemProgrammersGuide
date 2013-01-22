#
# $RCSfile: CMakeLists.txt,v $ $Revision: 1.7 $ $Date: 2012/12/18 21:41:35 $
#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

#------------------------------------------------
# Programmer Filename Entry Section
#------------------------------------------------
#/home/jebutler/cvs-modules/components-head

set(CLUSTER sheaf)

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
    example1.cc
    example2.cc
    example3.cc
    example4.cc
 )

collect_example_sources()

