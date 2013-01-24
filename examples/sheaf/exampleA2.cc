// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2008 Limit Point Systems, Inc. 
//

/// @example ExampleA2: Auto concurrency access control.
/// SheafSystem Programmer's Guide Example A2: Auto concurrency access control. 

#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

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

  
