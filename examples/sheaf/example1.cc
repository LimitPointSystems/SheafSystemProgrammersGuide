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

  sheaves_namespace lns("hello-sheaf!");
  
  cout << lns.name(true);
  
  // Namespace will be deleted when lns goes out of scope,
  // but destructor requires write access:

  lns.get_read_write_access();
  
  // Done.

  return 0;
}

  
