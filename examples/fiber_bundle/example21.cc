// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example21
/// SheafSystem Programmer's Guide Example 21: Creating a base_space_poset. 

#include "base_space_member.h"
#include "base_space_poset.h"
#include "fiber_bundles_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example21:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example21");

  // Create the poset.
  
  base_space_poset& lposet = base_space_member::standard_host(lns, "mesh", 1, true);

  // Print the poset to cout.

  cout << lposet << endl;

  // Write the namespace to a sheaf file.

  storage_agent lsa("example21.hdf");
  lsa.write_entire(lns);
  
  // Exit:

  return 0;
}

  
