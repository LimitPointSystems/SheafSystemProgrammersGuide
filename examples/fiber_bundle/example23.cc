// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example23
/// SheafSystem Programmer's Guide Example 23: Blocks

#include "base_space_poset.h"
#include "index_space_iterator.h"
#include "fiber_bundles_namespace.h"
#include "poset_dof_map.h"
#include "std_iostream.h"
#include "std_sstream.h"
#include "storage_agent.h"
#include "structured_block_1d.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example23:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example23");

  // Populate the namespace from the file we wrote in example21.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example21.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "mesh".

  poset_path lpath("mesh");
  base_space_poset& lposet = lns.member_poset<base_space_poset>(lpath, true);

  // Create the line segment mesh as a structured block.
  // Set xauto_access to true so it will invoke begin_jim_edit_mode
  // and end_jim_edit_mode as needed, so we don't have to do it
  // ourselves. See the precondition for details.

  structured_block_1d lblock(&lposet, 1, true);
  lblock.put_name("block", true, true);

  // Iterate over the zones and give them names. (There's only 1).

  index_space_iterator& lzitr = lblock.get_zone_id_space_iterator(true);
  while(!lzitr.is_done())
  {
    stringstream lstr;
    lstr << "s" << lzitr.pod();
    lposet.put_member_name(lzitr.hub_pod(), lstr.str(), true, false);
    lzitr.next();
  }
  lblock.release_zone_id_space_iterator(lzitr, true);  

  // Iterate over the vertices and give them names.

  index_space_iterator& lvitr = lblock.get_vertex_id_space_iterator(true);
  while(!lvitr.is_done())
  {
    stringstream lstr;
    lstr << "v" << lvitr.pod();
    lposet.put_member_name(lvitr.hub_pod(), lstr.str(), true, false);
    lvitr.next();
  }
  lblock.release_vertex_id_space_iterator(lvitr, true);

  // Print the finished poset.

  cout << lposet << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example23.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
