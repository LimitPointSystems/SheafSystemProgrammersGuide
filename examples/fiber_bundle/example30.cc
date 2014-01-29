
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

/// @example Example30
/// SheafSystem Programmer's Guide Example 30: Creating coordinate sections.

#include "e2.h"
#include "fiber_bundles_namespace.h"
#include "index_space_handle.h"
#include "index_space_iterator.h"
#include "sec_at1_space.h"
#include "sec_e1.h"
#include "sec_e1_uniform.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "structured_block_1d.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example30:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example30");

  // Create a new base space with structured_block_1d with 4 segments.
  // (We'll need that many segments for example31.)

  base_space_poset& lbase_host = structured_block_1d::standard_host(lns, "mesh2", true);
  
  structured_block_1d lblock(&lbase_host, 4, true);
  lblock.put_name("block", true, true);

  // Create a section space for uniform coordinates

  poset_path lbase_path("mesh2/block");

  sec_e1_uniform::host_type& le1u_host = 
    sec_e1_uniform::standard_host(lns, lbase_path, "", "", "", true);

  // Create the coordinates section. 
  // Uniform coordinates are initialized by the constructor.

  sec_e1_uniform le1u_coords(&le1u_host, -1.0, 1.0, true);
  le1u_coords.put_name("uniform_coordinates", true, true);
  
  // Create a section space for general coordinates;
  // use the default vertex_element_dlinear rep.

  sec_e1::host_type& le1_host = sec_e1::standard_host(lns, lbase_path, "", "", "", true);
  
  // Create a general coordinates section.

  sec_e1 le1_coords(&le1_host);
  le1_coords.put_name("general_coordinates", true, true);
  
  // Have to explicitly initialize general coordinates.
  // In a more realitistic case, the coordinate values
  // would come from some external source such as a mesher.
  // But this mesh only has 5 vertices, so we'll just make
  // something up that's definitely not uniform..

  sec_e1::dof_type lcoord_values[5] = {1.0, 2.0, 4.0, 8.0, 16.0};

  sec_e1::fiber_type::volatile_type lfiber;
  index_space_handle& ldisc_id_space = le1_coords.schema().discretization_id_space();
  index_space_iterator&  ldisc_itr = ldisc_id_space.get_iterator();
  while(!ldisc_itr.is_done())
  {
    lfiber = lcoord_values[ldisc_itr.pod()];
    le1_coords.put_fiber(ldisc_itr.pod(), lfiber);
    ldisc_itr.next();
  }
  ldisc_id_space.release_iterator(ldisc_itr);
  
  // Print the finished posets.

  cout << le1u_host << endl;
  cout << le1_host << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example30.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
