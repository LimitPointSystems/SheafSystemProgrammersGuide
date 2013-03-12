// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example12
/// SheafSystem Programmer's Guide Example 12: Subposets

#include "sheaves_namespace.h"
#include "poset.h"
#include "poset_dof_map.h"
#include "std_iostream.h"
#include "storage_agent.h"
#include "subposet.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example12:" << endl;

  // Create a namespace.

  sheaves_namespace lns("Example12");

  // Populate the namespace from the file we wrote in example9.
  // Retrieves the simple_poset example.

  storage_agent lsa_read("example10.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Get a reference to the poset "simple_poset".

  poset_path lpath("simple_poset");
  poset& lposet = lns.member_poset<poset>(lpath, true);

  // Create a subposet called "jrms".

  subposet ljrms(&lposet);
  ljrms.put_name("jrms", true, false);  

  // Test to see if it is empty (constructor ensures that it is).

  cout << "subposet " << ljrms.name();
  cout << " is empty()= " << boolalpha << ljrms.is_empty();
  cout << endl;

  // Put top, c1, c0, and bottom into the subposet.
  // Use all the different signatures for insert_member.

  scoped_index ltop_id(lposet.top().index());
  ljrms.insert_member(ltop_id);

  pod_index_type lc1_pod = lposet.member_id("c1", false);
  ljrms.insert_member(lc1_pod);

  pod_index_type lc0_pod = lposet.member_id("c0", false);
  ljrms.insert_member(lc0_pod);

  abstract_poset_member* lbot = &lposet.bottom();
  ljrms.insert_member(lbot);

  // Check if it contains the member we just put in.

  cout << "contains top: " << ljrms.contains_member(ltop_id) << endl;
  cout << "contains c1: " << ljrms.contains_member(lc1_pod) << endl;
  cout << "contains c0: " << ljrms.contains_member(lc0_pod) << endl;
  cout << "contains bottom: " << ljrms.contains_member(lbot) << endl;

  // Get an iterator for the members and print out their names.

  cout << "Subposet jrms contains:";
  index_iterator litr = ljrms.indexed_member_iterator();
  while(!litr.is_done())
  {
    // Print out the member name.

    cout << "  " << lposet.member_name(litr.index(), false);
    litr.next();
  }
  cout << endl;

  // Remove top and bottom.

  ljrms.remove_member(lposet.top().index());
  ljrms.remove_member(&lposet.bottom());  

  // Print out the member names again.

  cout << "Subposet jrms contains:";
  litr.reset();
  while(!litr.is_done())
  {
    // Print out the member name.

    cout << "  " << lposet.member_name(litr.index(), false);
    litr.next();
  }
  cout << endl;

  // Exit:

  return 0;
}

  
