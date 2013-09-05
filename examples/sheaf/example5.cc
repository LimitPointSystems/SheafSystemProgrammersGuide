
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

/// @example Example5
/// SheafSystem Programmer's Guide Example 5. Write a namespace to a sheaf file. 

#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example5:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example5");

  // Write the namespace to a sheaf file.

  storage_agent lsa("example5.hdf");
  lsa.write_entire(lns);
  
  // Exit:

  return 0;
}

  
