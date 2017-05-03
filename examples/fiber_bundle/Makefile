
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
CXX = /usr/local/gcc/bin/g++

#
# Path the SheafSystem installation; set this to where you've installed the SheafSystem.
#
SHEAF_INSTALL_DIR = /home/dmbutler/SheafSystem-github-lps/install

#
# Some internal variables; leave these alone.
#
CXX_FLAGS = -std=c++11 -m64 -Wno-deprecated -Wno-abi
SHEAF_LIB_DIR = $(SHEAF_INSTALL_DIR)/Debug_contracts/lib
SHEAF_INC_DIR = $(SHEAF_INSTALL_DIR)/include

example21: example21.cc
	$(CXX) $(CXX_FLAGS) -g -o example21 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example21.cc -lfiber_bundles_debug -lsheaves_debug	

example22: example22.cc
	$(CXX) $(CXX_FLAGS) -g -o example22 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example22.cc -lfiber_bundles_debug -lsheaves_debug	

example23: example23.cc
	$(CXX) $(CXX_FLAGS) -g -o example23 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example23.cc -lfiber_bundles_debug -lsheaves_debug	

example24: example24.cc
	$(CXX) $(CXX_FLAGS) -g -o example24 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example24.cc -lfiber_bundles_debug -lsheaves_debug	

example25: example25.cc
	$(CXX) $(CXX_FLAGS) -g -o example25 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example25.cc -lfiber_bundles_debug -lsheaves_debug	

example26: example26.cc
	$(CXX) $(CXX_FLAGS) -g -o example26 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example26.cc -lfiber_bundles_debug -lsheaves_debug	

example28: example28.cc
	$(CXX) $(CXX_FLAGS) -g -o example28 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example28.cc -lfiber_bundles_debug -lsheaves_debug	

example29: example29.cc
	$(CXX) $(CXX_FLAGS) -g -o example29 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example29.cc -lfiber_bundles_debug -lsheaves_debug	

example30: example30.cc
	$(CXX) $(CXX_FLAGS) -g -o example30 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example30.cc -lfiber_bundles_debug -lsheaves_debug	

example31: example31.cc
	$(CXX) $(CXX_FLAGS) -g -o example31 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example31.cc -lfiber_bundles_debug -lsheaves_debug	

clean:
	rm -f example21 example21.hdf
	rm -f example22 example22.hdf
	rm -f example23 example23.hdf
	rm -f example24
	rm -f example25 
	rm -f example26
	rm -f example28 example28.hdf
	rm -f example29 example29.hdf 
	rm -f example30 example30.hdf 
	rm -f example31

clean-cout:
	rm *.cout

update-cout: example21 example22 example23 example24 example25 example26 \
             example28 example29 example30 example31 

	./example21 > example21.cout
	./example22 > example22.cout
	./example23 > example23.cout
	./example24 > example24.cout
	./example25 > example25.cout
	./example26 > example26.cout
	./example28 > example28.cout
	./example29 > example29.cout
	./example30 > example30.cout
	./example31 > example31.cout
