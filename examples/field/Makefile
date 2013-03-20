
#
# Path to your C++ compiler
#
CXX = /home/dmbutler/LPS/prerequisites/gcc/bin/g++

#
# Path the SheafSystem installation
#
SHEAF_INSTALL_DIR = 
SHEAF_LIB_DIR = $(SHEAF_INSTALL_DIR)/Debug-contracts/lib 
SHEAF_INC_DIR = $(SHEAF_INSTALL_DIR)/include

example32: example32.cc
	$(CXX) -o example32 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example32.cc -lfields -lgeometry -lfiber_bundles -lsheaves
	@echo !!!!!!!!!!!!!!!!!!!!!!!!
	@echo "Don't forget to copy ../fiber_bundle/example30.hdf to this directory before running example32"
	@echo !!!!!!!!!!!!!!!!!!!!!!!!
