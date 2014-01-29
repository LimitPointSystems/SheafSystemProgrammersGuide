
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

/// @example Example13
/// SheafSystem Programmer's Guide Example 13: Cover id spaces and iterators. 

#include "index_space_handle.h"
#include "index_space_iterator.h"
#include "poset.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "total_poset_member.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example13:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example13");

  // Populate the namespace from the file we wrote in example10.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example10.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Get the hub id for member "c0".

  pod_index_type lc0_pod = lposet.member_id("c0", false);

  // Get an iterator for the lower cover to member "c0".

  index_space_handle& lc0_lc1 = lposet.get_cover_id_space(true, lc0_pod);
  index_space_iterator& lc0_lc_itr1 = lc0_lc1.get_iterator();
  
  // Iterate over the members of the lower cover.

  cout << "Lower cover of c0 is:";
  while(!lc0_lc_itr1.is_done())
  {
    cout << "  " << lposet.member_name(lc0_lc_itr1.hub_pod());
    lc0_lc_itr1.next();
  }
  cout << endl;

  // We're finished with the iterator, release it.

  lc0_lc1.release_iterator(lc0_lc_itr1);
  
  // Get an iterator for the upper cover of c0.
  // The enums LOWER and UPPER are defined in the sheaf namespace
  // true and false, respectively.

  index_space_iterator& lc0_uc_itr1 = lposet.get_cover_id_space_iterator(UPPER, lc0_pod);  
  
  // Iterate over the members of the upper cover.

  cout << "Upper cover of c0 is:";
  while(!lc0_uc_itr1.is_done())
  {
    cout << "  " << lposet.member_name(lc0_uc_itr1.hub_pod());
    lc0_uc_itr1.next();
  }
  cout << endl;

  // We're finished with the iterator, release it.

  lposet.release_cover_id_space_iterator(lc0_uc_itr1);

  // Repeat all the above using the poset member handle interface.

  // Get a handle for member c0.

  total_poset_member lc0_mbr(&lposet, "c0");

  // Get an iterator for the lower cover to member "c0".

  index_space_handle& lc0_lc2 = lc0_mbr.get_cover_id_space(true);
  index_space_iterator& lc0_lc_itr2 = lc0_lc2.get_iterator();
  
  // Iterate over the members of the lower cover.

  cout << "Lower cover of c0 is:";
  while(!lc0_lc_itr2.is_done())
  {
    cout << "  " << lposet.member_name(lc0_lc_itr2.hub_pod());
    lc0_lc_itr2.next();
  }
  cout << endl;

  // We're finished with the iterator, release it.

  lc0_lc2.release_iterator(lc0_lc_itr2);
  
  // Get an iterator for the upper cover of c0.
  // The enums LOWER and UPPER are defined in the sheaf namespace
  // true and false, respectively.

  index_space_iterator& lc0_uc_itr2 = lc0_mbr.get_cover_id_space_iterator(UPPER);  
  
  // Iterate over the members of the upper cover.

  total_poset_member luc_mbr;
  cout << "Upper cover of c0 is:";
  while(!lc0_uc_itr2.is_done())
  {
    luc_mbr.attach_to_state(&lposet, lc0_uc_itr2.hub_pod());
    cout << "  " << luc_mbr.name();
    lc0_uc_itr2.next();
  }
  cout << endl;

  // We're finished with the iterator, release it.

  luc_mbr.release_cover_id_space_iterator(lc0_uc_itr2);

  // Exit:

  return 0;
}

  
