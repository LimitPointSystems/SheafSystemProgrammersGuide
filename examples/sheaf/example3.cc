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
  // Preconditions:
  
  // Body:

  // Concurrency control enabled by default.

  // Create a standard sheaves namespace.

  sheaves_namespace lns("Hello-sheaf!");

  // Write its name to cout.
  // Requires read access to the namespace.
  
  // Be polite, request access.

  lns.get_read_access();

  // Invoke the operation.

  cout << lns.name();

  // Be proper, release access.
 
  lns.release_access();
  
  // Alternately can use version with auto access.
  // Will request and release access internally, 
  // if client requests it by setting auto access
  // argument to true.
  
  cout << lns.name(true);

  // Invoking a function that requires access
  // without first getting access violates the
  // precondition of the function.
  // the following will throw an exception and abort.

  cout << lns.name();
  
  // Postconditions:
  
  // Exit:

  return 0;
}

  
