
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

/// @example ExampleA2: Auto concurrency access control.
/// SheafSystem Programmer's Guide Example A2: Auto concurrency access control. 

#include "SheafSystem/sheaves_namespace.h"
#include "SheafSystem/std_iostream.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{
  cout << "SheafSystemProgrammersGuide ExampleA2:" << endl;

  // Enable concurrency control; must be called
  // before any other library call.

  read_write_monitor::enable_access_control();

  // Create a standard sheaves namespace.

  sheaves_namespace* lns = new sheaves_namespace("ExampleA2");

  // Write its name to cout.
  // Requires read access to the namespace.
  // Invoke the auto-access version of the operation with auto-access set to true.
  // Operation will request and release access as needed.

  cout << lns->name(true) << endl;
  
  return 0;
}

  
