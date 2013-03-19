// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example15
/// SheafSystem Programmer's Guide Example 15: Schema posets. 

#include "index_space_iterator.h"
#include "poset_path.h"
#include "schema_descriptor.h"
#include "schema_poset_member.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "wsv_block.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example15:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example15");

  // Create the cell schema poset.
  
  poset& lposet = lns.new_schema_poset("cell_schema_poset", true);

  // Create the schema for spatial_structure. It doesn't inherit anything,
  // so specify bottom as the parent. It has one data member, name "d", type "INT", 
  // not a table attribute.

  schema_poset_member lspatial(lns, "spatial_structure", "cell_schema_poset/bottom", "d INT false", true);

  // Cell inherits spatial_structure and adds one data member, 
  // name cell_type, type C_STRING, not a table attribute.

  schema_poset_member lcell(lns, "cell", lspatial.path(), "cell_type C_STRING false", true);

  // Test cell for conformance to spatial_structure.

  cout << endl;
  cout << "cell conforms to spatial_structure= ";
  cout << boolalpha << lcell.conforms_to(lspatial);
  cout << endl;
  cout << endl;

  // Get an iterator for the row attribute id space of the cell schema.

  index_space_iterator& litr = lcell.dof_id_space(false).get_iterator();
  while(!litr.is_done())
  {
    // Print attribute info.

    pod_index_type latt_pod = litr.pod();

    cout << "name: " << lcell.name(latt_pod, false);
    cout << " size: " << lcell.size(latt_pod, false);
    cout << " alignment: " << lcell.alignment(latt_pod, false);
    cout << " type: " << lcell.type(latt_pod, false);
    cout << " offset: " << lcell.offset(latt_pod, false);
    cout << endl;

    litr.next();
  }
  lcell.dof_id_space(false).release_iterator(litr);

  // Print out the schema.

  cout << lposet << endl;

  // Test the schema by creating a poset using it.

  poset& ltest = lns.new_member_poset<poset>("test", lcell.path(), "", true);

  ltest.begin_jim_edit_mode(true);
  pod_index_type lmbr0 = ltest.new_member(true);
  pod_index_type lmbr1 = ltest.new_member(true);
  pod_index_type lmbr2 = ltest.new_member(true);
  ltest.end_jim_edit_mode(true, true);

  ltest.put_member_name(lmbr0, "v0", true, false);
  ltest.member_dof_map(lmbr0, true).put_dof("d", int(0));
  ltest.member_dof_map(lmbr0, true).put_dof("cell_type", "vertex");

  ltest.put_member_name(lmbr1, "v1", true, false);
  ltest.member_dof_map(lmbr1, true).put_dof("d", int(0));
  ltest.member_dof_map(lmbr1, true).put_dof("cell_type", "vertex");

  ltest.put_member_name(lmbr2, "s0", true, false);
  ltest.member_dof_map(lmbr2, true).put_dof("d", int(1));
  ltest.member_dof_map(lmbr2, true).put_dof("cell_type", "segment");

  cout << ltest << endl;  
  
  // Exit:

  return 0;
}

  
