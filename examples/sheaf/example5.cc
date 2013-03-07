// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example5
/// SheafSystem Programmer's Guide Example 5. Write a namespace to a sheaf file. 

#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example5:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example5");

  // Write the namespace to a sheaf file.

  storage_agent lsa("example5.hdf");
  lsa.write_entire(lns);
  
  // Exit:

  return 0;
}

  
