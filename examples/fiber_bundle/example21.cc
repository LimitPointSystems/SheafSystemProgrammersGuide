
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

/// @example Example21
/// SheafSystem Programmer's Guide Example 21: Creating a base_space_poset. 

#include "base_space_member.h"
#include "base_space_poset.h"
#include "fiber_bundles_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example21:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example21");

  // Create the poset.
  
  base_space_poset& lposet = base_space_member::standard_host(lns, "mesh", 1, true);

  // Print the poset to cout.

  cout << lposet << endl;

  // Write the namespace to a sheaf file.

  storage_agent lsa("example21.hdf");
  lsa.write_entire(lns);
  
  // Exit:

  return 0;
}

  
