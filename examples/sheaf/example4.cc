// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example4
/// SheafSystem Programmer's Guide Example 4. Iterates over the member poset id space. 

#include "index_space_handle.h"
#include "index_space_iterator.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example4:" << endl;

  sheaves_namespace lns("Example4");
  
  // Get a handle for the member poset id space;
  // has one member for each poset in the namespace.

  const index_space_handle& lmbr_ids = lns.get_member_poset_id_space(true);

  // Print out the same info we did for the hub id space.

  cout << lmbr_ids.name() << " has " << lmbr_ids.ct() << " ids." << endl;
  
  cout << "begining at " << lmbr_ids.begin();
  cout << " and ending at " << lmbr_ids.end();
  cout << " " << (lmbr_ids.is_gathered() ? "gathered" : "scattered");
  cout << endl;

  index_space_iterator& lmbr_itr = lmbr_ids.get_iterator();
  cout << endl << "Iterate:" << endl;
  while(!lmbr_itr.is_done())
  {
    index_space_iterator::pod_type lpod = lmbr_itr.pod();
    
    // Use the id to get the member name.
    // Member name requires a hub id which we can get in two ways.
    // The id space will use the map from the id space to the hub
    // to translate any id in the id space to its equivalent in the hub:

    index_space_iterator::pod_type lhub_pod = lmbr_ids.hub_pod(lpod);

    // The iterator can provide the hub id equivalent for the current id,
    // and it can be faster because for some id space types it can
    // avoid the map lookup.

    lhub_pod = lmbr_itr.hub_pod();
    
    cout << "id: " << lpod;
    cout << " hub id: " << lmbr_itr.hub_pod();
    cout << " name: " << lns.member_name(lmbr_itr.hub_pod(), true);
    cout << (lns.is_jim(lhub_pod) ? " is a jim." : " is a jrm.");
    cout << endl;
    
    // Move on.

    lmbr_itr.next();
  }

  // Most member functions are available with two signatures, one
  // that takes a pod_index_type and one that takes a scoped_index.
  // If you don't want to think about what the scope for an argument
  // should be, you can use the scoped_index signature.

  // Reset the iterator and re-iterate using 
  // the scoped_index signature for member_name.

  lmbr_itr.reset();
  cout << endl << "Reiterate:" << endl;
  while(!lmbr_itr.is_done())
  {
    // Create a scoped id for the current member of the iteration.

    scoped_index lscoped_id(lmbr_ids, lmbr_itr.pod());
    
    // Use the scoped_index signature id to get the member name.
    
    cout << "scoped_id: " << lscoped_id;
    cout << " name: " << lns.member_name(lscoped_id, true);
    cout << (lns.is_jim(lscoped_id) ? " is a jim." : " is a jrm.");
    cout << endl;
    
    // Move on.

    lmbr_itr.next();
  }
  
  lmbr_ids.release_iterator(lmbr_itr);
  
  // Exit:

  return 0;
}

  
