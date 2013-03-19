// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example11
/// SheafSystem Programmer's Guide Example 11: Manipulating poset members 
/// with the poset_member interface. 

#include "sheaves_namespace.h"
#include "poset.h"
#include "poset_dof_map.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "total_poset_member.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example11:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example11");

  // Populate the namespace from the file we wrote in example9.
  // Retrieves the simple_poset example.

  storage_agent lsa("example9.hdf", sheaf_file::READ_ONLY);
  lsa.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Create an unattached handle.

  total_poset_member lmbr;
  cout << "lmbr is_attached() = " << boolalpha << lmbr.is_attached() << endl;
  
  // Attach it to the top member of our poset.

  lmbr.attach_to_state(&lposet, TOP_INDEX);
  cout << "lmbr attached to " << lmbr.name() << endl;

  // Reattach it to the bottom member.
  
  lmbr.attach_to_state(&lposet, BOTTOM_INDEX);
  cout << "lmbr attached to " << lmbr.name() << endl;

  // Unattach it.

  lmbr.detach_from_state();
  cout << "lmbr is_attached() = " << lmbr.is_attached() << endl;

  // Allow creation of jims.

  lposet.begin_jim_edit_mode(true);

  // Create jims for the two vertices and the segment.

  total_poset_member lv0(&lposet);
  total_poset_member lv1(&lposet);
  total_poset_member ls0(&lposet);  

  // Make the segment cover the vertices.

  ls0.create_cover_link(&lv0);
  ls0.create_cover_link(&lv1);

  // Top covers the segment.

  lposet.top().create_cover_link(&ls0);

  // The vertices cover bottom.

  lv0.create_cover_link(&lposet.bottom());
  lv1.create_cover_link(&lposet.bottom());

  // We're finished creating and linking jims.

  lposet.end_jim_edit_mode();

  // Give each jim a name..

  lv0.put_name("v0", true, true);
  lv1.put_name("v1", true, true);
  ls0.put_name("s0", true, true);  

  // Print the names to cout.

  cout << lv0.name() << endl;
  cout << lv1.name() << endl;
  cout << ls0.name() << endl;

  // Get the row attribute id space and pod and scoped ids for the only attribute.

  const index_space_handle& latt_id_space = lposet.schema().dof_id_space(false); 
  pod_index_type latt_pod = lposet.schema().dof_id_space(false).begin();
  scoped_index latt_id(lposet.schema().dof_id_space(false), latt_pod);

  // Set attributes for v0, v1, and s0 relying on conversions.

  lv0.dof_map(true).put_dof(latt_pod, int(0));
  lv1.dof_map(true).put_dof(latt_pod, int(0));
  ls0.dof_map(true).put_dof(latt_pod, int(1));

  // Get attributes back and write them to cout.

  int lv0_dim = lv0.dof_map(false).dof(latt_pod);
  int lv1_dim = lv1.dof_map(false).dof(latt_pod);
  int ls0_dim = ls0.dof_map(false).dof(latt_pod);
  
  cout << "v0 dim= " << lv0_dim;
  cout << " v1 dim= " << lv1_dim;
  cout << " s0 dim= " << ls0_dim;
  cout << endl;

  // Create a jrm named c0.
  // C0 is the join of v0 and v1, so we can create it
  // and link it up in a single step using the join operator.

  total_poset_member* lc0 = lv0.l_join(&lv1, false);
  lc0->put_name("c0", true, true);

  // Create a jem; a copy of c0, Call it c1.

  total_poset_member lc1(*lc0, true);
  lc1.put_name("c1", true, true);

  // Output the finished poset to cout:

  cout << lposet << endl;
  
  // Delete c1.

  lc1.delete_state(true);

  cout << "c1 is_attached() = " << boolalpha << lc1.is_attached() << endl;

  // Exit:

  return 0;
}

  
