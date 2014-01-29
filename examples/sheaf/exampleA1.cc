
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

/// @example Example A1: Manual concurrency access control.
/// SheafSystem Programmer's Guide Example A1: Manual concurrency access control. 

#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{
  cout << "SheafSystemProgrammersGuide ExampleA1:" << endl;

  // Enable concurrency control; must be called
  // before any other library call.

  read_write_monitor::enable_access_control();

  // Create a standard sheaves namespace.

  sheaves_namespace* lns = new sheaves_namespace("ExampleA1A");

  // Write its name to cout.
  // Requires read access to the namespace.
  
  // Be polite, request access.
  // If and threads are enabled and another thread has 
  // read-write access, execution will block until it 
  // releases access. Otherwise, the request will succeed 
  // immediately.

  // Can nest requests as deep as you want, or at least 
  // until the integer depth counter overflows.

  cout << "access request depth " << lns->access_request_depth() << endl;
  lns->get_read_access();
  cout << "access request depth " << lns->access_request_depth() << endl;
  lns->get_read_access();
  cout << "access request depth " << lns->access_request_depth() << endl;

  // Invoke the operation.

  cout << lns->name() << endl;

  // Be proper, release access so this thread
  // or another can get write access.
  // Have to match every request with a release.
 
  cout << "access request depth " << lns->access_request_depth() << endl;
  lns->release_access();
  cout << "access request depth " << lns->access_request_depth() << endl;
  lns->release_access();
  cout << "access request depth " << lns->access_request_depth() << endl;

  // Delete the namespace, requires read-write access.
  // Be polite, request access. If threads are enabled
  // and another thread has either read or read-write 
  // access, execution will block until it releases access. 
  // Otherwise, the request will succeed immediately.
  // This client must not already have read-only access,
  // see precondition for details.

  lns->get_read_write_access(false);
  
  // Invoke the operation.
  
  delete lns;
  
  // Deletion is the only case where the client
  // can not be proper and release access.
  
  // Create another namespace.

  lns = new sheaves_namespace("ExampleA1B");

  // Invoking a function that requires access
  // without first getting access violates the
  // precondition of the function.
  // The following will throw an exception and abort.

  cout << lns->name() << endl;
  
  return 0;
}

  
