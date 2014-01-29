
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

/// @example Example2: Design By Contract
/// SheafSystem Programmer's Guide Example 2. Design By Contract 

#include "sheaves_namespace.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{
  cout << "SheafSystemProgrammersGuide Example2:" << endl;

  // Attempt to create a standard sheaves namespace
  // with an empty name. This violates the preconditions
  // of the constructor and will throw an exception and abort.

  sheaves_namespace lns("");

  // Done.

  return 0;
}

  
