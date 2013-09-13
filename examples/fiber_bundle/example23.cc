
//
// Copyright (c) 2013 Limit Point Systems, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
  // Retrieves the "mesh" base space poset example.

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

  
