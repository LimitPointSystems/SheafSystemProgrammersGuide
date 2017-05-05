
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


example1: example1.cc
	$(CXX) $(CXX_FLAGS) -g -o example1 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example1.cc -lsheaves_debug	

example2: example2.cc
	$(CXX) $(CXX_FLAGS) -g -o example2 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example2.cc -lsheaves_debug	

example3: example3.cc
	$(CXX) $(CXX_FLAGS) -g -o example3 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example3.cc -lsheaves_debug	

example4: example4.cc
	$(CXX) $(CXX_FLAGS) -g -o example4 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example4.cc -lsheaves_debug	

example5: example5.cc
	$(CXX) $(CXX_FLAGS) -g -o example5 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example5.cc -lsheaves_debug	

example6: example6.cc
	$(CXX) $(CXX_FLAGS) -g -o example6 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example6.cc -lsheaves_debug	

example7: example7.cc
	$(CXX) $(CXX_FLAGS) -g -o example7 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example7.cc -lsheaves_debug	

example8: example8.cc
	$(CXX) $(CXX_FLAGS) -g -o example8 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example8.cc -lsheaves_debug	

example9: example9.cc
	$(CXX) $(CXX_FLAGS) -g -o example9 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example9.cc -lsheaves_debug	

example10: example10.cc
	$(CXX) $(CXX_FLAGS) -g -o example10 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example10.cc -lsheaves_debug	

example11: example11.cc
	$(CXX) $(CXX_FLAGS) -g -o example11 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example11.cc -lsheaves_debug	

example12: example12.cc
	$(CXX) $(CXX_FLAGS) -g -o example12 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example12.cc -lsheaves_debug	

example13: example13.cc
	$(CXX) $(CXX_FLAGS) -g -o example13 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example13.cc -lsheaves_debug	

example14: example14.cc
	$(CXX) $(CXX_FLAGS) -g -o example14 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example14.cc -lsheaves_debug	

example15: example15.cc
	$(CXX) $(CXX_FLAGS) -g -o example15 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example15.cc -lsheaves_debug	

exampleA1: exampleA1.cc
	$(CXX) $(CXX_FLAGS) -g -o exampleA1 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) exampleA1.cc -lsheaves_debug	

exampleA2: exampleA2.cc
	$(CXX) $(CXX_FLAGS) -g -o exampleA2 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) exampleA2.cc -lsheaves_debug

clean:
	rm -f example1
	rm -f example2
	rm -f example3
	rm -f example4
	rm -f example5 example5.hdf
	rm -f example6
	rm -f example9 example9.hdf
	rm -f example10 example10.hdf
	rm -f example11
	rm -f example12
	rm -f example13
	rm -f example14
	rm -f example15
	rm -f exampleA1
	rm -f exampleA2

clean-cout:
	rm *.cout

update-cout: example1 example2 example3 example4 example5 example6 example9 \
             example10 example11 example12 example13 example14 example15 exampleA1 exampleA2

	./example1 > example1.cout
	-./example2 >& example2.cout
	./example3 > example3.cout
	./example4 > example4.cout
	./example5 > example5.cout
	./example6 > example6.cout
	./example9 > example9.cout
	./example10 > example10.cout
	./example11 > example11.cout
	./example12 > example12.cout
	./example13 > example13.cout
	./example14 > example14.cout
	./example15 > example15.cout
	-./exampleA1 >& exampleA1.cout
	./exampleA2 > exampleA2.cout
