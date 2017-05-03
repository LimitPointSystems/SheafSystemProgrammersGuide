
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

/// @example Example31
/// SheafSystem Programmer's Guide Example 31: Multisections.

#include "SheafSystem/base_space_member.h"
#include "SheafSystem/base_space_poset.h"
#include "SheafSystem/e2.h"
#include "SheafSystem/fiber_bundles_namespace.h"
#include "SheafSystem/index_space_handle.h"
#include "SheafSystem/index_space_iterator.h"
#include "SheafSystem/sec_at1_space.h"
#include "SheafSystem/sec_e2.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/std_sstream.h"
#include "SheafSystem/storage_agent.h"
#include "SheafSystem/subposet.h"
#include "SheafSystem/tern.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example31:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example31");

  // Populate the namespace from the file we wrote in example30.

  storage_agent lsa_read("example30.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get the base space.

  base_space_poset& lbase_host = lns.member_poset<base_space_poset>("mesh2", true);
  
  // Create some patches in the base space:
  // First get elements id space.
  
  index_space_handle& lseg_id_space = lbase_host.elements().id_space();
  
  // Create the first patch - a jrm that contains the first two segments.

  scoped_index lpatch_segs[2];
  
  lpatch_segs[0].put(lseg_id_space, 0);
  lpatch_segs[1].put(lseg_id_space, 1);
  base_space_member lpatch0(&lbase_host, lpatch_segs, 2, tern::TRUE, true);
  lpatch0.put_name("patch0", true, true);  

  // Create the second patch.

  lpatch_segs[0].put(lseg_id_space, 2);
  lpatch_segs[1].put(lseg_id_space, 3);
  base_space_member lpatch1(&lbase_host, lpatch_segs, 2, tern::TRUE, true);
  lpatch1.put_name("patch1", true, true);

  // Create a subposet for the patches.

  subposet lpatches(&lbase_host);
  lpatches.put_name("patches", true, true);
  lpatches.insert_member(lpatch0.index());
  lpatches.insert_member(lpatch1.index());

  // Print the base space with the patches.

  cout << lbase_host << endl;

  // Create a section space for sec_e2.

  sec_e2::host_type& le2_host =
    sec_e2::standard_host(lns, "mesh2/block", "", "", "", true);

  // Create a multisection on the patches.

  sec_e2 lmulti(&le2_host, lpatches, true);

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

  
