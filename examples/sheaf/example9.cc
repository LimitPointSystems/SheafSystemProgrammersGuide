// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example9
/// SheafSystem Programmer's Guide Example 9: 
/// Creating, accessing and deleting posets. 

#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example9:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example9");

  // Create a path for the poset.

  poset_path lposet_path("simple_poset", "");

  // Use the INT member of the primtives poset as the schema for the simple poset.

  poset_path lschema_path("primitives", "INT");

  // Create the cell poset, will be id 6.
  
  poset& lposet = poset::new_table(lns, lposet_path, lschema_path, true);

  cout << "poset id: " << lposet.index().hub_pod() << endl;

  // Print the poset to cout.

  cout << lposet << endl;

  // Get another reference to the poset by id:

  poset_state_handle& lpsh1 = lns.member_poset(6, true);
  
  // and by path (string literal invokes conversion to poset_path):

  poset_state_handle& lpsh2 = lns.member_poset("simple_poset", true);

  // Get a reference to type poset:

  poset& lposet2 = lns.member_poset<poset>("simple_poset", true);

  // Write the namespace to a sheaf file.

  storage_agent lsa("example9.hdf");
  lsa.write_entire(lns);

  // Delete the poset by path. 
  // Invalidates all the above references.

  lns.delete_poset(lposet.path(), true);
  
  // Exit:

  return 0;
}

  
