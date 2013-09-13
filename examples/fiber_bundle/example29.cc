// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example29
/// SheafSystem Programmer's Guide Example 29: Creating and accessing sections.

#include "e2.h"
#include "fiber_bundles_namespace.h"
#include "index_space_handle.h"
#include "index_space_iterator.h"
#include "sec_at1_space.h"
#include "sec_e2.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example29:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example29");

  // Populate the namespace from the file we wrote in example28.
  // Retrieves the section space.

  storage_agent lsa_read("example28.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a handle for the section space.

  poset_path lssp_path("e2_on_mesh_block_vertex_element_dlinear");

  sec_e2::host_type& lhost = lns.member_poset<sec_e2::host_type>(lssp_path, true);

  // Create a section.

  sec_e2 lsec1(&lhost);
  
  // Initialize the first section using the disc id interface.

  // First, get an instance of the lite fiber type (e2_lite in this case).

  sec_e2::fiber_type::volatile_type lfiber(0.0, 1.0);

  // Iterate over the discretization setting the fibers.

  index_space_handle& ldisc_id_space = lsec1.schema().discretization_id_space();
  
  index_space_iterator& ldisc_itr = ldisc_id_space.get_iterator();
  while(!ldisc_itr.is_done())
  {
    // Note that we use the pod id, not the hub pod id,
    // the id has to be in the disc id space.

    lsec1.put_fiber(ldisc_itr.pod(), lfiber);
    ldisc_itr.next();
  }

  // Create a second section and initialize it
  // from the first section using disc id interface.

  sec_e2 lsec2(&lhost);

  sec_e2::value_type lval = 1.0;
  ldisc_itr.reset();
  while(!ldisc_itr.is_done())
  {
    lsec1.get_fiber(ldisc_itr.pod(), lfiber);

    lfiber *= lval;
    lval *= 2;

    lsec2.put_fiber(ldisc_itr.pod(), lfiber);
    ldisc_itr.next();
  }

  // Create a third section and initialize it
  // from the first section using section attribute id interface.

  sec_e2 lsec3(&lhost);

  const index_space_handle& lsec_id_space = lsec1.schema().row_dof_id_space();
  index_space_iterator& lsec_id_itr = lsec_id_space.get_iterator();
  while(!lsec_id_itr.is_done())
  {
    lval = lsec1.dof(lsec_id_itr.pod());
    lval *= 2.0;
    lsec3.put_dof(lsec_id_itr.pod(), lval);
    lsec_id_itr.next();
  }
  lsec_id_space.release_iterator(lsec_id_itr);

  // Create a fourth section and initialize it
  // from the first section using disc id, fiber id interface.

  sec_e2 lsec4(&lhost);

  const index_space_handle& lfiber_id_space = lsec1.schema().fiber_schema().row_dof_id_space();
  index_space_iterator& lfiber_id_itr = lfiber_id_space.get_iterator();

  ldisc_itr.reset();
  while(!ldisc_itr.is_done())
  {
    while(!lfiber_id_itr.is_done())
    {
      lsec1.get_dof(ldisc_itr.pod(), lfiber_id_itr.pod(), &lval, sizeof(lval));

      lval *= 3;

      lsec4.put_dof(ldisc_itr.pod(), lfiber_id_itr.pod(), &lval, sizeof(lval));

      lfiber_id_itr.next();
    }
    lfiber_id_itr.reset();
    ldisc_itr.next();
  }

  // Create a fifth section

  sec_e2 lsec5(&lhost);
  
  // Allocate a buffer to store a section component
  // All the components are the same size for a sec_e2.

  size_type lcomp_size = lsec1.schema().component_size(0);
  
  sec_e2::dof_type* lcomp = new sec_e2::dof_type[lcomp_size];

  // Initialize the 5th section using component access.
  
  lfiber_id_itr.reset();
  while(!lfiber_id_itr.is_done())
  {
    lsec1.get_component(lfiber_id_itr.pod(), lcomp, lcomp_size);
    lsec5.put_component(lfiber_id_itr.pod(), lcomp, lcomp_size);
    lfiber_id_itr.next();
  }
  
  lfiber_id_space.release_iterator(lfiber_id_itr);
  ldisc_id_space.release_iterator(ldisc_itr);

  // Print the finished poset.

  cout << lhost << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example29.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
