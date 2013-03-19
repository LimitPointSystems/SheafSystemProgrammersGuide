// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example28
/// SheafSystem Programmer's Guide Example 28: Creating a section space.

#include "fiber_bundles_namespace.h"
#include "sec_at1_space.h"
#include "sec_e2.h"
#include "std_iostream.h"
#include "storage_agent.h"

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

  // Create a section space for sec_e2 sections on the line segment mesh
  // using default values for fiber space, rep, and schema.

  poset_path lbase_path("mesh/block");
  poset_path lssp_path("e2_on_block");

  sec_e2::host_type& lhost = lns.new_section_space<sec_e2>(lssp_path, lbase_path);
  
  // Print the finished poset.

  cout << lhost << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example28.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
