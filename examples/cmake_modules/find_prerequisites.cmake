#
#
#
# Copyright (c) 2013 Limit Point Systems, Inc.
#
#

#
# Prerequisite Discovery
#
# This file is included in the top level CmakeLists.txt file, hence any prereq
# discovered and included here will be visible to the entire system.
#

#
# Set the location of the sheaf system top level.
#
set(SHEAFSYSTEM_HOME CACHE PATH "Sheaf_system top level directory.")

find_package(Sheaf)

#
# Find Git
# Needed for "archive" target
#
find_package(Git)
    

