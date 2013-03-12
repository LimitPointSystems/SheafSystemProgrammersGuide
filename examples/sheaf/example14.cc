// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example14
/// SheafSystem Programmer's Guide Example 14: Depth first iterators. 

#include "poset.h"
#include "postorder_itr.h"
#include "preorder_itr.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "total_poset_member.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example14:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example14");

  // Populate the namespace from the file we wrote in example10.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example10.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Create a postorder iterator for the down set of top.
  // Filter with the jims subposet.
  // DOWN and UP are enums for true and false, respectively.
  // Include the anchor itself in the search.

  zn_to_bool_postorder_itr lpost_itr(lposet.top(), JIMS_INDEX, DOWN, NOT_STRICT);
  
  // Find all the jims.

  while(!lpost_itr.is_done())
  {
    cout << lposet.member_name(lpost_itr.index(), false) << " is a jim" << endl;
    lpost_itr.next();
  }
  
  // Find just the minimal jims (atoms).
  // Iterate up from the bottom and truncate when we find something.

  zn_to_bool_preorder_itr lpre_itr(lposet.bottom(), JIMS_INDEX, UP, NOT_STRICT);  
  while(!lpre_itr.is_done())
  {
    cout << lposet.member_name(lpre_itr.index(), false) << " is an atom" << endl;
    lpre_itr.truncate();
  }

  // Exit:

  return 0;
}

  
