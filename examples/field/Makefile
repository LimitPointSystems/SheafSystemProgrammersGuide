
#
# Path to your C++ compiler
#
CXX =  

#
# Path the SheafSystem installation
#
SHEAF_INSTALL_DIR = 
SHEAF_LIB_DIR = $(SHEAF_INSTALL_DIR)/Debug-contracts/lib 
SHEAF_INC_DIR = $(SHEAF_INSTALL_DIR)/include

example30.hdf: ../fiber_bundle/example30.hdf
	cp ../fiber_bundle/example30.hdf .

example32: example32.cc example30.hdf
	$(CXX) -g -o example32 -I$(SHEAF_INC_DIR) -L$(SHEAF_LIB_DIR) example32.cc \
                      -lfields_debug -lgeometry_debug -lfiber_bundles_debug -lsheaves_debug

clean:
	rm -f example32 example30.hdf

clean-cout:
	rm *.cout

update-cout: example32
	./example32 > example32.cout