
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
# Path to C++ compiler; set this to wherever your compiler is.
#
CXX = 

#
# Path the SheafSystem installation; set this to where you've installed the SheafSystem.
#
SHEAF_INSTALL_DIR = 

#
# Some internal variables; leave these alone.
#
CXX_FLAGS = -std=c++11 -m64 -Wno-deprecated -Wno-abi
SHEAF_LIB_DIR = $(SHEAF_INSTALL_DIR)/Debug_contracts/lib
SHEAF_INC_DIR = $(SHEAF_INSTALL_DIR)/include

example30.hdf: ../fiber_bundle/example30.hdf
	cp ../fiber_bundle/example30.hdf .

example32: example32.cc example30.hdf
	$(CXX) $(CXX_FLAGS) -g -o example32 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example32.cc \
                      -lfields_debug -lgeometry_debug -lfiber_bundles_debug -lsheaves_debug

clean:
	rm -f example32 example30.hdf

clean-cout:
	rm *.cout

update-cout: example32
	./example32 > example32.cout
