
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

bin: example01 example02 example03 example04 example05 example06 example09 \
	example10 example11 example12 example13 example14 example15 exampleA1 exampleA2

example01: example01.cc
	$(CXX) $(CXX_FLAGS) -g -o example01 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example01.cc -lsheaves_debug	

example02: example02.cc
	$(CXX) $(CXX_FLAGS) -g -o example02 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example02.cc -lsheaves_debug	

example03: example03.cc
	$(CXX) $(CXX_FLAGS) -g -o example03 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example03.cc -lsheaves_debug	

example04: example04.cc
	$(CXX) $(CXX_FLAGS) -g -o example04 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example04.cc -lsheaves_debug	

example05: example05.cc
	$(CXX) $(CXX_FLAGS) -g -o example05 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example05.cc -lsheaves_debug	

example06: example06.cc
	$(CXX) $(CXX_FLAGS) -g -o example06 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example06.cc -lsheaves_debug	

example09: example09.cc
	$(CXX) $(CXX_FLAGS) -g -o example09 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example09.cc -lsheaves_debug	

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
	rm -f example01
	rm -f example02
	rm -f example03
	rm -f example04
	rm -f example05 example05.hdf
	rm -f example06
	rm -f example09 example09.hdf
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

update-cout: bin

	# Examples 2 and A1 deliberately blow preconditions, causing an abort; ignore the error messages.
	# "-" preceding commands tells make to keep going.
	./example01 > example01.cout
	- ./example02  >& example02.cout
	./example03 > example03.cout
	./example04 > example04.cout
	./example05 > example05.cout
	./example06 > example06.cout
	./example09 > example09.cout
	./example10 > example10.cout
	./example11 > example11.cout
	./example12 > example12.cout
	./example13 > example13.cout
	./example14 > example14.cout
	./example15 > example15.cout
	- ./exampleA1 >& exampleA1.cout
	./exampleA2 > exampleA2.cout
