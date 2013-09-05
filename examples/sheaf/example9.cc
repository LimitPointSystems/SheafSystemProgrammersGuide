
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
/// SheafSystem Programmer's Guide Example 9: Creating, accessing and deleting posets. 

#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example9:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example9");

  // We use a schema with a single integer attribute.

  poset_path lschema_path("primitives", "INT");

  // The contructor for the ordinary poset class doesn't need any arguments.

  arg_list largs = poset::make_args();

  // Create the poset.
  
  poset& lposet = 
    lns.new_member_poset<poset>("simple_poset", lschema_path, largs, true);

  // Print the poset to cout.

  cout << lposet << endl;

  // Write the namespace to a sheaf file.

  storage_agent lsa("example9.hdf");
  lsa.write_entire(lns);

  // Get another reference to the poset by id:

  poset_state_handle& lpsh1 = lns.member_poset(6, true);
  
  // and by path:

  poset_state_handle& lpsh2 = lns.member_poset("simple_poset", true);

  // Delete the poset by path. 
  // Invalidates all the above references.

  lns.delete_poset(lposet.path(), true);
  
  // Exit:

  return 0;
}

  
