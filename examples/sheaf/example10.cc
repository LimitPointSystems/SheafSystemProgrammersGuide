// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example10
/// SheafSystem Programmer's Guide Example 10: Reading a sheaf file; 
/// manipulating poset members with the poset interface. 

#include "sheaves_namespace.h"
#include "poset.h"
#include "poset_dof_map.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example10:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example10");

  // Populate the namespace from the file we wrote in example9.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example9.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Allow creation of jims.

  lposet.begin_jim_edit_mode(true);

  // Create jims for the two vertices and the segment.

  pod_index_type lv0_pod = lposet.new_member(true);
  pod_index_type lv1_pod = lposet.new_member(true);
  pod_index_type ls0_pod = lposet.new_member(true);

  // Make the segment cover the vertices.

  lposet.new_link(ls0_pod, lv0_pod);
  lposet.new_link(ls0_pod, lv1_pod);

  // Top covers the segment.

  lposet.new_link(TOP_INDEX, ls0_pod);

  // The vertices cover bottom.

  lposet.new_link(lv0_pod, BOTTOM_INDEX);
  lposet.new_link(lv1_pod, lposet.bottom().index().pod());

  // We're finished creating and linking jims.

  lposet.end_jim_edit_mode();

  // Give each jim a name..

  lposet.put_member_name(lv0_pod, "v0", true);
  lposet.put_member_name(lv1_pod, "v1", true);
  lposet.put_member_name(ls0_pod, "s0", true);

  // Print the names to cout.

  cout << lposet.member_name(lv0_pod) << endl;
  cout << lposet.member_name(lv1_pod) << endl;
  cout << lposet.member_name(ls0_pod) << endl;

  // Get the row attribute id space and pod and scoped ids for the only attribute.

  const index_space_handle& latt_id_space = lposet.schema().dof_id_space(false); 
  pod_index_type latt_pod = lposet.schema().dof_id_space(false).begin();
  scoped_index latt_id(lposet.schema().dof_id_space(false), latt_pod);

  // Get the attribute tuple for vertex 0.

  poset_dof_map& ltuple = lposet.member_dof_map(lv0_pod, true);

  // Set the only attribute of v0 to its dimension, 0.
  // Do the first one explicitly, without any automatic conversion.

  primitive_value lpv(int(0));
  ltuple.put_dof(latt_pod, lpv);
  
  // Set attributes for v1 and s0 relying on conversions.

  lposet.member_dof_map(lv1_pod, true).put_dof(latt_pod, int(0));
  lposet.member_dof_map(ls0_pod, true).put_dof(latt_pod, int(1));

  // Get attributes back and write them to cout.

  int lv0_dim = lposet.member_dof_map(lv0_pod, false).dof(latt_pod);
  int lv1_dim = lposet.member_dof_map(lv1_pod, false).dof(latt_pod);
  int ls0_dim = lposet.member_dof_map(ls0_pod, false).dof(latt_pod);
  
  cout << "v0 dim= " << lv0_dim;
  cout << " v1 dim= " << lv1_dim;
  cout << " s0 dim= " << ls0_dim;
  cout << endl;

  // Create a jrm named c0.

  pod_index_type lc0_pod = lposet.new_member(false);
  lposet.put_member_name(lc0_pod, "c0", true);

  //  Link it up:

  lposet.new_link(ls0_pod, lc0_pod);
  lposet.new_link(lc0_pod, lv0_pod);
  lposet.new_link(lc0_pod, lv1_pod);

  // Delete the now obsolete links from s0 to the vertices.

  lposet.delete_link(ls0_pod, lv0_pod);
  lposet.delete_link(ls0_pod, lv1_pod);

  // Create a jem; a copy of c0, call it c1.

  pod_index_type lc1_pod = lposet.new_member(false);
  lposet.put_member_name(lc1_pod, "c1", true);
  lposet.delete_link(ls0_pod, lc0_pod);
  lposet.new_link(ls0_pod, lc1_pod);
  lposet.new_link(lc1_pod, lc0_pod);  

  // Output the finished poset to cout:

  cout << lposet << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example10.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);
  
  // Delete c1.

  lposet.delete_link(lc1_pod, lc0_pod);
  lposet.delete_link(ls0_pod, lc1_pod);
  lposet.new_link(ls0_pod, lc0_pod);
  lposet.delete_member(lc1_pod);

  // Exit:

  return 0;
}

  
