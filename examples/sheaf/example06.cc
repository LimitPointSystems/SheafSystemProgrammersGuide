
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

/// @example Example06
/// SheafSystem Programmer's Guide Example 6. Write a namespace to a stream. 

#include "SheafSystem/sheaves_namespace.h"
#include "SheafSystem/std_iostream.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example06:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example06");

  // Write the namespace to cout.

  cout << lns << endl;
  
  // Exit:

  return 0;
}

  
