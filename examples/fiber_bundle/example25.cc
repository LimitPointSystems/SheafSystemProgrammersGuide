
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

/// @example Example25
/// SheafSystem Programmer's Guide Example 25: Creating a fiber space.

#include "at1_space.h"
#include "e3.h"
#include "fiber_bundles_namespace.h"
#include "std_iostream.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example25:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example25");
  
  // Create a space for e3 objects; empty suffix
  // e3::host_type is at1_space

  at1_space& le3_space = e3::standard_host(lns, "", true);
  
  cout << "e3 space name: " << le3_space.name() << endl;
  cout << "e3 space schema name: " << le3_space.schema().name() << endl;
  cout << "e3 space scalar space path: " << le3_space.scalar_space_path() << endl;

  // Create another space for e3 objects, suffix "_other".

  at1_space& le3_other_space = e3::standard_host(lns, "_other", true);
  
  cout << endl;
  cout << "another e3 space name: " << le3_other_space.name() << endl;
  cout << "another e3 space schema name: " << le3_other_space.schema().name() << endl;
  cout << "another e3 space scalar space path: " << le3_other_space.scalar_space_path() << endl;
  
  // Exit:

  return 0;
}

  
