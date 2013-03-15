// $RCSfile: main.t.cc,v $ $Revision: 1.1 $ $Date: 2009/07/31 18:01:41 $

// $Name:  $
//
// Copyright (c) 2013 Limit Point Systems, Inc. 
//

/// @example Example26
/// SheafSystem Programmer's Guide Example 26: Creating fiber space members.

#include "at1_space.h"
#include "e3.h"
#include "fiber_bundles_namespace.h"
#include "poset.h"
#include "std_iostream.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;
using namespace fiber_bundle::e3_algebra;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example26:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example26");
  
  // Create a space for e3 objects; use all the defaults.

  at1_space& le3_space = lns.new_fiber_space<e3>();
  
  // Create some vectors.

  e3 i_hat(&le3_space, true);
  e3 j_hat(&le3_space, true);
  e3 k_hat(&le3_space, true);
  
  // Set the components of i_hat individually.

  i_hat.put_component(0, 1.0, false);
  i_hat.put_component(1, 0.0, false);
  i_hat.put_component(2, 0.0, false);

  // Set the components of j_hat all at once.

  j_hat.put_components(0.0, 1.0, 0.0);

  // "Auto-allocated" add creates result on heap.

  e3* v1 = add(i_hat, j_hat);

  // "Pre -allocated" cross product takes result as argument.

  cross(i_hat, *v1, k_hat, true);

  // Another way to compute the auto_allocated sum.

  e3* v2 = i_hat + j_hat;

  // Or the "self-allocated" sum.

  i_hat += j_hat;


  // Exit:

  return 0;
}

  
