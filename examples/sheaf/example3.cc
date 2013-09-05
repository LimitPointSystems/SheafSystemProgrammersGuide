
//
// Copyright (c) 2013 Limit Point Systems, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

/// @example Example3
/// SheafSystem Programmer's Guide Example 3. Iterates over the member hub id space. 

#include "hub_index_space_handle.h"
#include "index_space_iterator.h"
#include "sheaves_namespace.h"
#include "std_iostream.h"

using namespace sheaf;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example3:" << endl;

  // Create a standard sheaves namespace.

  sheaves_namespace lns("Example3");
  
  // Get a handle for the member hub id space.

  const index_space_handle& lmbr_ids = lns.member_hub_id_space(true);

  // Find out how many ids are in the id space.
  
  cout << lmbr_ids.name() << " has " << lmbr_ids.ct() << " ids." << endl;
  
  // Id spaces are defined as half open intervals, like STL iterators.
  // If the space is "gathered", begin() == 0 and end() = ct().
  // If the space is not gathered, it's "scattered". 

  cout << "beginning at " << lmbr_ids.begin();
  cout << " and ending at " << lmbr_ids.end();
  cout << " " << (lmbr_ids.is_gathered() ? "gathered" : "scattered");
  cout << endl;

  // The main thing one does with id spaces is iterate over them.
  // Get an iterator from the iterator pool.

  index_space_iterator& lmbr_itr = lmbr_ids.get_iterator();
  cout << endl << "Iterate:" << endl;
  while(!lmbr_itr.is_done())
  {
    // The current member of the iteration is "pod()".
    // "POD" is an ISO C++ acronym for "plain old data".
    // A pod is an ordinary integer id, in contrast with 
    // a "scoped_index" id, to be discussed shortly.

    index_space_iterator::pod_type lpod = lmbr_itr.pod();
    
    // Use the id to get the member name.
    // Member name requires a hub id, but since we're using
    // the hub id space, pod and hub pod are the same thing.
    
    cout << "id: " << lpod;
    cout << " hub id: " << lmbr_itr.hub_pod();
    cout << " name: " << lns.member_name(lpod, true);
    cout << (lns.is_jim(lpod) ? " is a jim." : " is a jrm.");
    cout << endl;
    
    // Move on.

    lmbr_itr.next();
  }

  // You can reuse an iterator by resetting it.

  lmbr_itr.reset();
  cout << endl << "Reiterate:" << endl;
  while(!lmbr_itr.is_done())
  {
    index_space_iterator::pod_type lpod = lmbr_itr.pod();
    
    cout << "id: " << lpod;
    cout << " hub id: " << lmbr_itr.hub_pod();
    cout << " name: " << lns.member_name(lpod, true);
    cout << (lns.is_jim(lpod) ? " is a jim." : " is a jrm.");
    cout << endl;
    
    // Move on.

    lmbr_itr.next();
  }
  
  // If you got an id space or iterator from the pool with get_ 
  // you have to return it to the pool with release_.
    
  lmbr_ids.release_iterator(lmbr_itr);

  // The id space itself is a data member of the id space family,
  // we didn't get it from the pool with get_, so we don't have to release it.
  
  // Exit:

  return 0;
}

  
