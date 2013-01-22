// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example2: Design By Contract
/// SheafSystem Programmer's Guide Example 2. Design By Contract 

#include "sheaves_namespace.h"

using namespace sheaf;

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

  
