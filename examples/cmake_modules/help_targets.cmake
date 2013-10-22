
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
# Help targets


add_custom_target(help
    COMMAND ${CMAKE_COMMAND} -E echo "    "     
    COMMAND ${CMAKE_COMMAND} -E echo "    "  
    COMMAND ${CMAKE_COMMAND} -E echo "The following help targets are available: "
    COMMAND ${CMAKE_COMMAND} -E echo "    "        
    COMMAND ${CMAKE_COMMAND} -E echo "    help-targets -- lists available system targets."
    COMMAND ${CMAKE_COMMAND} -E echo "    help-cmake-options -- Things you can say to cmake to affect the build system state."
    COMMAND ${CMAKE_COMMAND} -E echo "    "        
    COMMAND ${CMAKE_COMMAND} -E echo "")
    
add_custom_target(help-cmake-options
    COMMAND ${CMAKE_COMMAND} -E echo "" 
    COMMAND ${CMAKE_COMMAND} -E echo "CMAKE_BUILD_TYPE:"
    COMMAND ${CMAKE_COMMAND} -E echo "    "         
    COMMAND ${CMAKE_COMMAND} -E echo "    Sets the default build type for this run. Only meaningful in Linux "
    COMMAND ${CMAKE_COMMAND} -E echo "    as build type is chosen at compile time in Visual Studio."
    COMMAND ${CMAKE_COMMAND} -E echo "    " 
    COMMAND ${CMAKE_COMMAND} -E echo "    Type: string"         
    COMMAND ${CMAKE_COMMAND} -E echo "    " 
    COMMAND ${CMAKE_COMMAND} -E echo "    Default Value: Debug_contracts"
    COMMAND ${CMAKE_COMMAND} -E echo "    " 
    COMMAND ${CMAKE_COMMAND} -E echo "        example: ./cmboot -DCMAKE_BUILD_TYPE=Release_contracts"
    COMMAND ${CMAKE_COMMAND} -E echo "        example -- from build directory: cmake -DCMAKE_BUILD_TYPE=Release_contracts .."        
    COMMAND ${CMAKE_COMMAND} -E echo "    ")
    
add_custom_target(help-targets
    COMMAND ${CMAKE_COMMAND} -E echo "" 
        COMMAND ${CMAKE_COMMAND} -E echo "" 
        COMMAND ${CMAKE_COMMAND} -E echo "The fundamental targets are: "
        COMMAND ${CMAKE_COMMAND} -E echo "    \\<target_name\\> example: exampleA1"
        COMMAND ${CMAKE_COMMAND} -E echo "    examples" 

        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "\\<target_name\\>:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds only \\<target_name\\>. "
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "examples:"
        COMMAND ${CMAKE_COMMAND} -E echo "    Builds all examples in the system. Does not execute any compiled code."
        COMMAND ${CMAKE_COMMAND} -E echo ""
        COMMAND ${CMAKE_COMMAND} -E echo "    Aliases: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "
        COMMAND ${CMAKE_COMMAND} -E echo "    Related commands: none."
        COMMAND ${CMAKE_COMMAND} -E echo "    "


 
)