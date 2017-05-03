
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

/// SheafSystem Programmer's Guide Example 22: Base space members using
/// base_space_poset interface.  

#include "SheafSystem/base_space_poset.h"
#include "SheafSystem/fiber_bundles_namespace.h"
#include "SheafSystem/poset_dof_map.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example22:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example22");

  // Populate the namespace from the file we wrote in example21.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example21.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "mesh".

  poset_path lpath("mesh");
  base_space_poset& lposet = lns.member_poset<base_space_poset>(lpath, true);

  // Allow creation of jims.

  lposet.begin_jim_edit_mode(true);

  // Create the vertices as copies of the point prototype.
  // Initializes all member attributes to be same as point prototype.

  pod_index_type lv0_pod = lposet.new_member("point", false);
  lposet.put_member_name(lv0_pod, "v0", true);

  pod_index_type lv1_pod = lposet.new_member("point", false);
  lposet.put_member_name(lv1_pod, "v1", true);

  // Create the segment as a copy of the segment prototype.

  pod_index_type ls0_pod = lposet.new_member("segment", false);
  lposet.put_member_name(ls0_pod, "s0", true);

  // Print the attribute tuples for the members.

  cout << "v0 tuple: " << lposet.member_dof_map(lv0_pod, false) << endl;
  cout << "v1 tuple: " << lposet.member_dof_map(lv1_pod, false) << endl;
  cout << "s0 tuple: " << lposet.member_dof_map(ls0_pod, false) << endl;

  // Make the segment cover the vertices.

  lposet.new_link(ls0_pod, lv0_pod);
  lposet.new_link(ls0_pod, lv1_pod);

  // Top covers the segment.

  lposet.new_link(TOP_INDEX, ls0_pod);

  // The vertices cover bottom.

  lposet.new_link(lv0_pod, BOTTOM_INDEX);
  lposet.new_link(lv1_pod, lposet.bottom().index().pod());

  // We're finished creating and linking jims.

  lposet.end_jim_edit_mode();

  // Print the finished poset.

  cout << lposet << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example22.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
