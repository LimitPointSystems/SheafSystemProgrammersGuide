// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
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

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example30:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example30");

  // Create a new base space with structured_block_1d with 2 segments.

  arg_list largs = base_space_poset::make_args(1);
  base_space_poset& lbase_host = lns.new_base_space<structured_block_1d>("mesh2", largs);
  structured_block_1d lblock(&lbase_host, 2, true);
  lblock.put_name("block", true, true);

  // Create a section space for uniform coordinates

  poset_path le1u_path("e1_uniform_on_block");
  poset_path lbase_path("mesh2/block");
  poset_path le1u_rep_path("sec_rep_descriptors/vertex_block_uniform");
  
  sec_e1_uniform::host_type& le1u_host =
    lns.new_section_space<sec_e1_uniform>(le1u_path, lbase_path, le1u_rep_path, true);

  // Create the coordinates section. 
  // Uniform coordinates are initialized by the constructor.

  sec_e1_uniform le1u_coords(&le1u_host, -1.0, 1.0, true);
  le1u_coords.put_name("uniform_coordinates", true, true);
  
  // Create a section space for general coordinates;
  // use the default vertex_element_dlinear rep.

  poset_path le1_path("e1_on_block");
  
  sec_e1::host_type& le1_host =
    lns.new_section_space<sec_e1>(le1_path, lbase_path);
  
  // Create a general coordinates section.

  sec_e1 le1_coords(&le1_host);
  le1_coords.put_name("general_coordinates", true, true);
  
  // Have explicitly initialize general coordinates.
  // In a more realitistic case, the coordinate values
  // would come from some external source such as a mesher.
  // But this mesh only has 3 vertices, so we'll just make
  // something up that's definitely not uniform..

  sec_e1::dof_type lcoord_values[3] = { 0.0, 1.0, 10.0};

  sec_e1::fiber_type::volatile_type lfiber;
  index_space_handle& ldisc_id_space = 
    le1_coords.schema().discretization_id_space();
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

  
