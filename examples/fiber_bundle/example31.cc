// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example31
/// SheafSystem Programmer's Guide Example 31: Multisections.

#include "e2.h"
#include "fiber_bundles_namespace.h"
#include "index_space_handle.h"
#include "index_space_iterator.h"
#include "sec_at1_space.h"
#include "sec_e2.h"
#include "std_iostream.h"
#include "std_sstream.h"
#include "storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example31:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example31");

  // Populate the namespace from the file we wrote in example30.

  storage_agent lsa_read("example30.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Create a section space for sec_e2;
  // use the default vertex_element_dlinear rep.

  poset_path le2_path("e2_on_block");
  poset_path lbase_path("mesh2/block");
  
  sec_e2::host_type& le2_host =
    lns.new_section_space<sec_e2>(le2_path, lbase_path);

  // Create a multisection.
  // We'll use the evaluation subposet for the xbase_parts arg, 
  // create one branch on each segment.

  sec_e2 lmulti(&le2_host, le2_host.schema().evaluation(), true);

  // Set the attributes of the branches.
  // Because lfiber is incremented every time
  // and middle vertex is in both branches,
  // multisection will be discontinuous at middle vertex.

  e2_lite lfiber(0.0, 0.0);
  e2_lite lfiber_inc(1.0, 1.0);
  
  // Get a branch iterator for the multisection.

  index_space_iterator& lbranch_itr = 
    lmulti.get_branch_id_space_iterator(false);
  while(!lbranch_itr.is_done())
  {
    // Attach a handle to the current branch.
    // Note that arg has to be in the hub id space.

    sec_e2 lbranch(&le2_host, lbranch_itr.hub_pod());

    // Give the branch a name.

    stringstream lstr;
    lstr << "branch" << lbranch_itr.pod();
    lbranch.put_name(lstr.str(), true, false);

    // Get discretization iterator for the current branch
    // and iterate over fibers, setting the section.

    index_space_handle& ldisc_id_space = lbranch.schema().discretization_id_space();
    index_space_iterator& ldisc_itr = ldisc_id_space.get_iterator();
    while(!ldisc_itr.is_done())
    {
      lbranch.put_fiber(ldisc_itr.pod(), lfiber);
      lfiber += lfiber_inc;
      ldisc_itr.next();
    }
    ldisc_id_space.release_iterator(ldisc_itr);
    lbranch_itr.next();
    lbranch.detach_from_state();
  }
  lmulti.release_branch_id_space_iterator(lbranch_itr, false);
  
  // Print the finished section space.

  cout << le2_host << endl;

  // Exit:

  return 0;
}

  
