// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example28
/// SheafSystem Programmer's Guide Example 28: Section space schema

#include "at1_space.h"
#include "base_space_poset.h"
#include "binary_section_space_schema_member.h"
#include "e2.h"
#include "fiber_bundles_namespace.h"
#include "index_space_iterator.h"
#include "poset_dof_map.h"
#include "binary_section_space_schema_poset.h"
#include "sec_at1_space.h"
#include "sec_e2.h"
#include "std_iostream.h"
#include "std_sstream.h"
#include "storage_agent.h"
#include "structured_block_1d.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example28:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example28");

  // Populate the namespace from the file we wrote in example27.
  // Retrieves the base space, fiber space and section space schema.

  storage_agent lsa_read("example27.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a handle to the poset

  binary_section_space_schema_poset& lsssp = 
    lns.member_poset<binary_section_space_schema_poset>(poset_path("e2_on_mesh_schema"), false);
  

  // $$ERROR: schema poset doesn't seem to contain schema member after read from disk,
  // Does contain it before writing.

  binary_section_space_schema_member lmbr;
  lmbr.attach_to_state(&lsssp, "mesh/block", "fiber_space_schema/e2_schema");

  cout << boolalpha << lns.contains_poset_member(lmbr.path(), true) << endl;

  // Specify name and schema, let args default.

  sec_e2::host_type& lhost = 
    lns.new_section_space<sec_e2>("e2_on_block",
                                  arg_list(""),
                                  //                                  "e2_on_mesh_schema/e2_on_block_schema",
                                  lmbr.path(),
                                  true);
  
  // Print the finished poset.

  cout << lhost << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example28.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
