
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

/// @example Example4
/// SheafSystem Programmer's Guide Example 4. Iterates over the member poset id space. 

#include "SheafSystem/index_space_handle.h"
#include "SheafSystem/index_space_iterator.h"
#include "SheafSystem/sheaves_namespace.h"
#include "SheafSystem/std_iostream.h"

using namespace sheaf;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example4:" << endl;

  sheaves_namespace lns("Example4");
  
  // Get a handle for the member poset id space;
  // has one member for each poset in the namespace.

  const index_space_handle& lmbr_ids = lns.get_member_poset_id_space(true);

  // Print out the same info we did for the hub id space.

  cout << lmbr_ids.name() << " has " << lmbr_ids.ct() << " ids." << endl;
  
  cout << "beginning at " << lmbr_ids.begin();
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
    cout << " hub id: " << lhub_pod;
    cout << " name: " << lns.member_name(lhub_pod, true);
    cout << (lns.is_jim(lhub_pod) ? " is a jim." : " is a jrm.");
    cout << endl;
    
    // Move on.

    lmbr_itr.next();
  }

  // Most member functions are available with two signatures, one
  // that takes a pod_index_type and one that takes a scoped_index.
  // If you don't want to think about what the scope for an argument
  // should be, you can use the scoped_index signature.

  // Create a scoped id with scope = member poset id space.

  scoped_index lscoped_id(lmbr_ids);

  // The value sheaf::invalid_pod_index() is reserved as a
  // "null" value for index types. It is currently set to
  // numeric_limits<pod_index_type>::max(), but don't count on it.

  cout << endl << "sheaf::invalid_pod_index()= " << sheaf::invalid_pod_index() << endl;

  // When a scoped id is created without a specific pod value, 
  // it is invalid by default.

  cout << "lscoped_id= " << lscoped_id;
  cout << " is_valid() " << boolalpha << lscoped_id.is_valid() << noboolalpha;
  cout << endl;

  // Reset the iterator and re-iterate using 
  // the scoped_index signature for member_name.

  lmbr_itr.reset();
  cout << endl << "Reiterate:" << endl;
  while(!lmbr_itr.is_done())
  {
    // Set the scoped id for the current member of the iteration.

    lscoped_id.put_pod(lmbr_itr.pod());
    
    // Assigment is overloaded, so you can also say:

    lscoped_id = lmbr_itr.pod();
    
    // Use the scoped_index signature to get the member name.
    
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

  
