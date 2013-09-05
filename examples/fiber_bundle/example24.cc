// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
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

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example24:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example24");

  // Get a handle to the fiber space schema poset.

  poset& lfiber_schema = lns.member_poset<poset>(tuple::standard_schema_path(), true);

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

  
