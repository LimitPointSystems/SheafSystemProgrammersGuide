// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2008 Limit Point Systems, Inc. 
//

/// @example Example3: Concurrency access control enforced by preconditions.
/// SheafSystem Programmer's Guide Example 3. Concurrency access control enforced by preconditions

#include "assert_contract.h"
#include "error_message.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{
  // Concurrency control enabled by default.

  // Create a standard sheaves namespace.

  sheaves_namespace* lns = new sheaves_namespace("Hello-sheaf");

  // Write its name to cout.
  // Requires read access to the namespace.
  
  // Be polite, request access.
  // If another client has read-write access, execution will block
  // until it releases access, if threads are enabled. Otherwise,
  // the request will succeed immediately.

  lns->get_read_access();

  // Can nest requests as deep as you want,
  // or at least until the integer depth counter
  // overflows.

  cout << "access request depth " << lns->access_request_depth() << endl;
  lns->get_read_access();
  cout << "access request depth " << lns->access_request_depth() << endl;

  // Invoke the operation.

  cout << lns->name();

  // Be proper, release access so this client
  // or another can get write access.
  // Have to match every request with a release.
 
  lns->release_access();
  lns->release_access();

  // Delete the namespace, requires read-write access.
  // Be polite, request access. If another client has 
  // either read or read-write access, execution will 
  // block until it releases access, if threads are enabled. 
  // Otherwise, the request will succeed immediately.
  // This client must not already have read-only access,
  // see precondition for details.

  lns->get_read_write_access(false);
  
  // Invoke the operation.
  
  delete lns;
  
  // Deletion is the only case where the client
  // can not be proper and release access.
  
  // Create another namespace.

  lns = new sheaves_namespace("Hello-sheaf");

  // Invoking a function that requires access
  // without first getting access violates the
  // precondition of the function.
  // the following will throw an exception and abort.

  cout << lns->name();
  
  return 0;
}

  
