
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

/// @example Example9
/// SheafSystem Programmer's Guide Example 9: 
/// Creating, accessing and deleting posets. 

#include "SheafSystem/sheaves_namespace.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/storage_agent.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example9:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example9");

  // Create a path for the poset.

  poset_path lposet_path("simple_poset", "");

  // Use the INT member of the primtives poset as the schema for the simple poset.

  poset_path lschema_path("primitives", "INT");

  // Create the poset, will be id 6.
  
  poset& lposet = abstract_poset_member::new_host(lns, lposet_path, lschema_path, true);

  cout << "poset id: " << lposet.index().hub_pod() << endl;

  // Print the poset to cout.

  cout << lposet << endl;

  // Get another reference to the poset by id:

  poset_state_handle& lpsh1 = lns.member_poset(6, true);
  
  // and by path (string literal invokes conversion to poset_path):

  poset_state_handle& lpsh2 = lns.member_poset("simple_poset", true);

  // Get a reference to type poset:

  poset& lposet2 = lns.member_poset<poset>("simple_poset", true);

  // Write the namespace to a sheaf file.

  storage_agent lsa("example9.hdf");
  lsa.write_entire(lns);

  // Delete the poset by path. 
  // Invalidates all the above references.

  lns.delete_poset(lposet.path(), true);
  
  // Exit:

  return 0;
}

  
