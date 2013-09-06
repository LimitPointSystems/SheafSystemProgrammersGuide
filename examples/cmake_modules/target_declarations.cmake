
#
# Copyright (c) 2013 Limit Point Systems, Inc. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


#
# Library targets
#
if(LINUX64GNU OR LINUX64INTEL)
    
    include(${CMAKE_MODULE_PATH}/help_targets.cmake)
    
    add_custom_target(realclean 
            COMMAND ${CMAKE_COMMAND} --build  ${CMAKE_BINARY_DIR} --target clean
            COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/documentation)   

    # build and run the executables, redirecting their output to a .out file.
    # copy the file(s) to their source origin.
    # Source files will need to know their cluster, or since they are numbered
    # then perhaps we can make the decision of where to copy the output
    # by parsing their name
    add_custom_target(outfiles DEPENDS 
 
endif()

