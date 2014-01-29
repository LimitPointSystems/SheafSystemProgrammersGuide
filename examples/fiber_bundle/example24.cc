
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

/// @example Example24
/// SheafSystem Programmer's Guide Example 24: Fiber schema subobject hierarchy.

#include "biorder_itr.h"
#include "fiber_bundles_namespace.h"
#include "poset.h"
#include "std_iostream.h"
#include "tuple.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example24:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example24");

  // Get a handle to the fiber space schema poset.

  poset& lfiber_schema = lns.member_poset<poset>(fiber_bundle::tuple::standard_schema_path(), true);

  // Use a biorder_itr to print out the subobject hierarchy.
  
  cout << endl << "Subobject hierarchy in " << lfiber_schema.name(true) << endl << endl;
  cout << boolalpha;
  
  schema_poset_member lschema(lfiber_schema.top());
    
  int ltab_ct = 0;
  set_biorder_itr litr(lfiber_schema.top(), true, true);
  while(!litr.is_done())
  {
    pod_index_type lhub_pod = litr.index().hub_pod();
    switch(litr.action())
    {
      case set_biorder_itr::PREVISIT_ACTION:
        if(lhub_pod != BOTTOM_INDEX)
        {
          if(lfiber_schema.is_jim(lhub_pod))
          {
            for(int i=0; i<ltab_ct; i++) cout << "   ";
            cout << lfiber_schema.member_name(lhub_pod, true);
            if(lfiber_schema.is_atom(lhub_pod))
            {
              lschema.attach_to_state(lhub_pod);
              cout << ": " << lschema.type();
              cout << (lschema.is_table_dof() ? "  table" : "  row");
            }
            cout << endl;
            ltab_ct++;
          }
        }
        break;
      case set_biorder_itr::POSTVISIT_ACTION:
        if(lhub_pod != BOTTOM_INDEX)
        {
          if(lfiber_schema.is_jim(lhub_pod))
          {
            ltab_ct--;
            if(ltab_ct == 0)
            {
              cout << endl;
            }
            litr.put_has_visited(lhub_pod, false);
          }
        }
        break;
      default:
        break;
    }
    litr.next();
  }
  
  // Exit:

  return 0;
}

  
