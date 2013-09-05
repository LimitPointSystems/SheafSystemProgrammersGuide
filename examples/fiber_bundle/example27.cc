
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

/// @example Example27
/// SheafSystem Programmer's Guide Example 27: Creating a section space schema

#include "at1_space.h"
#include "base_space_poset.h"
#include "e2.h"
#include "fiber_bundles_namespace.h"
#include "index_space_iterator.h"
#include "poset_dof_map.h"
#include "binary_section_space_schema_poset.h"
#include "std_iostream.h"
#include "std_sstream.h"
#include "storage_agent.h"
#include "structured_block_1d.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example27:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example27");

  // Populate the namespace from the file we wrote in example23.
  // Retrieves the mesh poset example.

  storage_agent lsa_read("example23.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Create a space for e2 objects; use all the defaults.

  at1_space& le2_space = lns.new_fiber_space<e2>();

  // Create a section space schema 
  // named "e2_on_mesh/e2_on_block" 
  // using 
  // "vertex_cells_dlinear" sec_rep_descriptor,
  // the "block" member in the "mesh" poset as the base space,
  // and the fiber space we just created.
  // Specify xauto_access = true to allow begin/end jim edit mode.

  poset_path lsssp_path = 
    lns.new_section_space_schema("e2_on_mesh_schema/e2_on_block_schema",
                                 "sec_rep_descriptors/vertex_cells_dlinear",
                                 "mesh/block",
                                 le2_space.path(),
                                 true);

  // Get a handle to the poset

  binary_section_space_schema_poset& lsssp = 
    lns.member_poset<binary_section_space_schema_poset>(lsssp_path, false);
  
  // Print the finished poset.

  cout << lsssp << endl;  

  // Write it to a file for later use.

  storage_agent lsa_write("example27.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
