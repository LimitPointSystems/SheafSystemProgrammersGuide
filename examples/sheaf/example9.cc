// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example9
/// SheafSystem Programmer's Guide Example 5. Write a namespace to a file. 

#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example9:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example9");

  // We use a schema with a single integer attribute.

  poset_path lschema_path("primitives", "INT");

  // The contructor for the ordinary poset class doesn't need any arguments.

  arg_list largs = poset::make_args();

  // Create the poset.
  
  poset& lposet = 
    lns.new_member_poset<poset>("simple_poset", lschema_path, largs, true);

  // Print the id of the poset.

  cout << "Id: " << lposet.index().hub_pod() << endl;
  
  // Print the poset to cout.

  cout << lposet << endl;

  // Get another reference to the poset by id:

  poset_state_handle* lprim1 = lns.member_poset(6, true);
  
  // and by path:

  poset_state_handle* lprim2 = lns.member_poset("simple_poset", true);

  // Delete the poset by path. 
  // Invalidates all the above references.

  lns.delete_poset(lposet.path(), true);
  
  // Exit:

  return 0;
}

  
