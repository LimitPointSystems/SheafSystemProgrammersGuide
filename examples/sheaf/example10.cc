// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example10
/// SheafSystem Programmer's Guide Example 10: Creating, accessing, and deleting poset members. 

#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example10:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example10");

  // Populate the namespace from the file we wrote in example9.
  // Retrieves the simple_poset example.

  storage_agent lsa("example9.hdf", sheaf_file::READ_ONLY);
  lsa.read_entire(lns);

  // Get a reference to the poset "simple_poset".
  
  poset& lposet = lns.member_poset<poset>("simple_poset", true);

  // Allow creation of jims.

  lposet.begin_jim_edit_mode(true);

  // Create jims for the two vertices and the segment.

  pod_index_type lv0_id = lposet.new_member(true);
  pod_index_type lv1_id = lposet.new_member(true);
  pod_index_type ls0_id = lposet.new_member(true);

  // Make the segment cover the vertices.

  lposet.new_link(ls0_id, lv0_id);
  lposet.new_link(ls0_id, lv1_id);

  // Top covers the segment.

  lposet.new_link(TOP_INDEX, ls0_id);

  // The vertices cover bottom.

  lposet.new_link(lv0_id, BOTTOM_INDEX);
  lposet.new_link(lv0_id, lposet.bottom().index().pod());

  // We're finished creating and linking jims.

  lposet.end_jim_edit_mode();

  // Give each jim a name..

  lposet.put_member_name(lv0_id, "v0", true);
  lposet.put_member_name(lv1_id, "v1", true);
  lposet.put_member_name(ls0_id, "s0", true);

  // Pirnt the names to cout.

  cout << lposet.member_name(lv0_id) << endl;
  cout << lposet.member_name(lv1_id) << endl;
  cout << lposet.member_name(ls0_id) << endl;

  
  // Set the only attribute of v0 to its dimension, 0.
  // Do the first one explicitly, without any automatic conversion.

  // Create a primtive value wrapper.

  primitive_value lv0_d(int(0));

  // Get a reference to the attribute tuple for v0.

  poset_dof_map& lv0_tuple = lposet.member_dof_map(lv0_id, true);

  // Set the attribute.

  lv0_tuple.put_dof("INT", lv0_d);
  
  // Set attributes for v1 and s0 relying on conversions.

  lposet.member_dof_tuple(lv1_id, true).put_dof("INT", int(0));
  lposet.member_dof_tuple(ls0_id, true).put_dof("INT", int(1));


  
  // Exit:

  return 0;
}

  
