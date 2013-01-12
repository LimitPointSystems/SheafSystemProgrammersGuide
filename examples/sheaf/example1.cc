// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2008 Limit Point Systems, Inc. 
//

/// @example Example1: Hello, sheaf!
/// SheafSystem Programmer's Guide Example 1. Creates a sheaf namespace. 

#include "assert_contract.h"
#include "error_message.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{
  // Preconditions:
  
  // Body:

  // Disable the concurrency access control mechanism;
  // will explain this shortly!

  read_write_monitor::disable_access_control();
  
  // Create a standard sheaves namespace.

  sheaves_namespace lns("Hello-sheaf!");

  // Write its name to cout.
  
  cout << lns.name();
  
  // Postconditions:
  
  // Exit:

  return 0;
}

  
