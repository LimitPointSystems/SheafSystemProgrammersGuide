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

  // Populate the namespace from the file we wrote in example25.
  // Retrieves the base space.

  storage_agent lsa_read("example23.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Create a section space for sec_e2 sections on the line segment mesh
  // using standard rep and no suffixes.

  poset_path lbase_path("mesh/block");

  sec_e2::host_type& lsec_e2_host = sec_e2::standard_host(lns, lbase_path, "", "", "", true);

  cout << endl;
  cout << "sec_e2 space path: " << lsec_e2_host.path() << endl;
  cout << "sec_e2 space schema path: " << lsec_e2_host.schema().path() << endl;
  cout << "sec_e2 space scalar space path: " << lsec_e2_host.scalar_space_path() << endl;
  
  // Print the finished poset.

  cout << lsec_e2_host << endl;


  // Create a section space for sec_e2 sections on the line segment mesh
  // using rep "elelment_element_constant" and both section and fiber suffixes.

  poset_path lrep_path("sec_rep_descriptors", "element_element_constant");
  
  sec_e2::host_type& lsec_e2_other_host = 
    sec_e2::standard_host(lns, lbase_path, lrep_path, "_other", "_new", true);
  
  cout << endl;
  cout << "other sec_e2 space path: " << lsec_e2_other_host.path() << endl;
  cout << "other sec_e2 space schema path: " << lsec_e2_other_host.schema().path() << endl;
  cout << "other sec_e2 space scalar space path: " << lsec_e2_other_host.scalar_space_path() << endl;


  // Write the namespace to a file for later use.

  storage_agent lsa_write("example28.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
