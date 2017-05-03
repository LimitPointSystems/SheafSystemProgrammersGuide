
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

/// @example Example14
/// SheafSystem Programmer's Guide Example 14: Depth first iterators. 

#include "SheafSystem/poset.h"
#include "SheafSystem/postorder_itr.h"
#include "SheafSystem/preorder_itr.h"
#include "SheafSystem/sheaves_namespace.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/storage_agent.h"
#include "SheafSystem/total_poset_member.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example14:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example14");

  // Populate the namespace from the file we wrote in example10.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example10.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Create a postorder iterator for the down set of top.
  // Filter with the jims subposet.
  // DOWN and UP are enums for true and false, respectively.
  // Include the anchor itself in the search.

  zn_to_bool_postorder_itr lpost_itr(lposet.top(), JIMS_INDEX, DOWN, NOT_STRICT);
  
  // Find all the jims.

  while(!lpost_itr.is_done())
  {
    cout << lposet.member_name(lpost_itr.index(), false) << " is a jim" << endl;
    lpost_itr.next();
  }
  
  // Find just the minimal jims (atoms).
  // Iterate up from the bottom and truncate when we find something.

  zn_to_bool_preorder_itr lpre_itr(lposet.bottom(), JIMS_INDEX, UP, NOT_STRICT);  
  while(!lpre_itr.is_done())
  {
    cout << lposet.member_name(lpre_itr.index(), false) << " is an atom" << endl;
    lpre_itr.truncate();
  }

  // Exit:

  return 0;
}

  
