// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example25
/// SheafSystem Programmer's Guide Example 25: Creating a fiber space.

#include "at1_space.h"
#include "e3.h"
#include "fiber_bundles_namespace.h"
#include "std_iostream.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example25:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example25");
  
  // Create a space for e3 objects; empty suffix
  // e3::host_type is at1_space

  at1_space& le3_space = e3::standard_host(lns, "", true);
  
  cout << "e3 space name: " << le3_space.name() << endl;
  cout << "e3 space schema name: " << le3_space.schema().name() << endl;
  cout << "e3 space scalar space path: " << le3_space.scalar_space_path() << endl;

  // Create another space for e3 objects, suffix "_other".

  at1_space& le3_other_space = e3::standard_host(lns, "_other", true);
  
  cout << endl;
  cout << "another e3 space name: " << le3_other_space.name() << endl;
  cout << "another e3 space schema name: " << le3_other_space.schema().name() << endl;
  cout << "another e3 space scalar space path: " << le3_other_space.scalar_space_path() << endl;
  
  // Exit:

  return 0;
}

  
