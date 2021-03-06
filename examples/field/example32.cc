
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

/// @example Example32
/// SheafSystem Programmer's Guide Example 32: Fields.


#include "SheafSystem/at0.h"
#include "SheafSystem/e1.h"
#include "SheafSystem/fiber_bundles_namespace.h"
#include "SheafSystem/field_at0.h"
#include "SheafSystem/index_space_handle.h"
#include "SheafSystem/index_space_iterator.h"
#include "SheafSystem/sec_at0.h"
#include "SheafSystem/sec_at0_space.h"
#include "SheafSystem/sec_at1_space.h"
#include "SheafSystem/sec_e1.h"
#include "SheafSystem/sec_e1_uniform.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/std_sstream.h"
#include "SheafSystem/storage_agent.h"
#include "SheafSystem/structured_block_1d.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fields;
using namespace std;

namespace
{

// Function to compute the property dofs as a function of the coordinates.
// As an example, assume the property is scalar and set it to 
// the distance from the coordinate origin.
// For the 1d case we will use, this will just give us the
// coordinate back again, so it will be easy to see if we get
// the right answer.

void
property_dof_function_example(block<sec_vd_value_type>& xglobal_coords,
                              block<sec_vd_dof_type>& xproperty_dofs)
{
  sec_vd_value_type dist = 0.0;
  for(int i= 0; i<xglobal_coords.ct(); ++i)
  {
    dist += xglobal_coords[i]* xglobal_coords[i];
  }
  
  dist = sqrt(dist);
  xproperty_dofs[0] = dist;
  return;
}
  
} // end unnamed namespace.


int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example32:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example32");

  // Populate the namespace from the file we wrote in example30.

  storage_agent lsa_read("example30.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get the coordinates space. We created it with standard_host in example30 and
  // now retrieved it from the file, so standard_host will find it rather than
  // creating a new host.

  sec_e1::host_type& le1_host = sec_e1::standard_host(lns, "mesh2/block", "", "", "", true);

  // Get a handle for the coordinates section

  sec_e1 le1_coords(&le1_host, "general_coordinates");
  
  // Create a scalar section space.

  poset_path lbase_path1("mesh2/block");
  
  sec_at0::host_type& lat0_space1 = sec_at0::standard_host(lns, lbase_path1, "", "", "", true);  
  
  // Create a scalar section for the property

  sec_at0 lprop1(&lat0_space1);

  // Create a scalar field

  field_at0 lscalar_field1(le1_coords, lprop1, true);

  // Set the property to the value defined by 
  // the put_property_dofs_example function above.

  lscalar_field1.put_property_dofs(property_dof_function_example, true);

  // Get the property value at coordinate = 5.0.

  sec_e1::value_type lx = 5.0;
  sec_at0::value_type lp;
  
  lscalar_field1.property_at_coordinates(&lx, 1, &lp, 1);

  cout << endl << "property at x= 5.0 is " << lp << endl;

  // Print the finished section space.

  cout << lat0_space1 << endl;

  // Create a different base space with 3 segments

  base_space_poset& lbase_host = structured_block_1d::standard_host(lns, "mesh3", true);
  structured_block_1d lblock3(&lbase_host, 3, true);
  lblock3.put_name("block3", true, true);

  // Create a section space for uniform coordinates on the new base space.

  poset_path lbase_path2("mesh3/block3");

  sec_e1_uniform::host_type& le1u_host =
    sec_e1_uniform::standard_host(lns, lbase_path2, "", "", "", true);  

  // Create the coordinates section for the new base space. 
  // Uniform coordinates are initialized by the constructor.

  sec_e1_uniform le1u_coords(&le1u_host, 0.0, 3.0, true);
  le1u_coords.put_name("uniform_coordinates", true, true);
  
  // Create a scalar section space on the new base space.

  poset_path lat0_path2("at0_on_block3");

  sec_at0::host_type& lat0_space2 = 
    sec_at0::standard_host(lns, lbase_path2, "", "", "", true);  
  
  // Create a scalar section for the property

  sec_at0 lprop2(&lat0_space2);

  // Create a scalar field on the new base space.

  field_at0 lscalar_field2(le1u_coords, lprop2, true);

  // Push the property from the first base space to the second.

  push(lscalar_field1, lscalar_field2, true);
  
  // Print out the property section space on the new base space.

  cout << lat0_space2 << endl;

  // Exit:

  return 0;
}

  
