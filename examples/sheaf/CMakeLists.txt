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

set(CLUSTER sheaf)

#
# Library sources.
#
set(SRCS
    example1.cc
)

collect_sources()

#
# Headers that are NOT associated with a .cc file.
#
set(ADDITIONAL_INCS
    abstract_poset_member.impl.h 
    namespace_poset.impl.h 
    poset_crg_state.impl.h 
    namespace_poset.impl.h 
    poset_state_handle.impl.h
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

 )

collect_example_sources()

