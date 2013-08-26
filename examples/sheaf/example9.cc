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

  // Create a path for the cell poset.

  poset_path lcell_path("cell", "");

  // Use the primitives schema as the schema for the cell poset.

  poset_path lcell_schema_path(xns.primitives_schema_path());

  // Create the cell poset, will be id 6.
  
  poset& lcell_poset = 
    poset::new_table(xns, lcell_path, lcell_schema_path, true);

  // Print the poset to cout.

  cout << lcell_poset << endl;

  // Write the namespace to a sheaf file.

  storage_agent lsa("example9.hdf");
  lsa.write_entire(lns);

  // Get another reference to the poset by id:

  poset_state_handle& lpsh1 = lns.member_poset(6, true);
  
  // and by path:

  poset_state_handle& lpsh2 = lns.member_poset("cell", true);

  // Delete the poset by path. 
  // Invalidates all the above references.

  lns.delete_poset(lcell_poset.path(), true);
  
  // Exit:

  return 0;
}

  
