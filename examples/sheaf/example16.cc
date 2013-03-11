// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example16
/// SheafSystem Programmer's Guide Example 16: Schema posets. 

#include "schema_poset_member.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "wsv_block.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example16:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example16");

  // Create the cell schema poset.
  
  poset& lposet = lns.new_schema_poset("cell_schema_poset", true);

  // Create the schema for spatial_structure. It doesn't inherit anything,
  // so specify bottom as the parent. It has one data member, name "d", type "INT", 
  // not a table attribute.

  schema_poset_member lspatial(lns, "spatial_structure", "cell_schema_poset/bottom", "d INT false", false, true);

  // Cell inherits spatial_structure and adds one string data member.

  schema_poset_member lcell(lns, "cell", lspatial.path(), "cell_type C_STRING false", false, true);

  // Print out the schema.

  cout << lposet << endl;

  lspatial.detach_from_state();
  lcell.detach_from_state();
  
  // Exit:

  return 0;
}

  
