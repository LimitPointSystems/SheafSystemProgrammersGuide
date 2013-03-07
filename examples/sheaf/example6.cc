// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example6
/// SheafSystem Programmer's Guide Example 5. Write a namespace to a stream. 

#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example6:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example6");

  // Write the namespace to cout.

  cout << lns << endl;
  
  // Exit:

  return 0;
}

  
