
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

/// @example Example26
/// SheafSystem Programmer's Guide Example 26: Persistent and volatile types.

#include "at1_space.h"
#include "e3.h"
#include "fiber_bundles_namespace.h"
#include "poset.h"
#include "std_iostream.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace fiber_bundle::vd_algebra;
using namespace fiber_bundle::ed_algebra;
using namespace fiber_bundle::e3_algebra;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example26:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example26");
  
  // Create a standard space for e3 objects; empty suffix
  // e3::host_type is at1_space

  at1_space& le3_space = e3::standard_host(lns, "", true);
  
  // Create some persistent vectors.

  e3 i_hat(&le3_space, true);
  e3 j_hat(&le3_space, true);
  
  // Set the components of i_hat individually.

  i_hat.put_component(0, 1.0, false);
  i_hat.put_component(1, 0.0, false);
  i_hat.put_component(2, 0.0, false);

  // Set the components of j_hat all at once.

  j_hat.put_components(0.0, 1.0, 0.0);

  // Create and initialize some volatile vectors

  e3_lite i_hat_v(i_hat);
  e3_lite j_hat_v;
  j_hat_v = j_hat;

  cout << "i_hat_v:" << i_hat_v << endl;
  cout << "j_hat_v:" << j_hat_v << endl;

  // "Auto-allocated" add creates result on heap.

  e3_lite* v1_v = add(i_hat_v, j_hat_v);  

  cout << "v1_v:\t" << *v1_v << endl;  

  // Pre-allocated add requires result as argument

  e3_lite v2_v;
  add(i_hat_v, j_hat_v, v2_v);

  cout << "v2_v:\t" << v2_v << endl;
  
  // "Self-allocated" add uses first arg as result.

  e3_lite v3_v(i_hat_v);
  add_equal(v3_v, j_hat_v);

  cout << "v3_v:\t" << v3_v << endl;
  
  // Operations are also available as overloaded operators,
  // whenever it makes sens.

  e3_lite* v4_v = i_hat_v + j_hat_v;

  cout << "v4_v:\t" << *v4_v << endl;
  
  e3_lite v5_v(i_hat_v);
  v5_v += j_hat_v;

  cout << "v5_v:\t" << v5_v << endl;

  // All the usual operations of Euclidean vector algebra are 
  // available as functions, and also as operators, when it makes sense.
  // For instance:

  // Multiplication by scalar

  e3_lite v6_v;
  multiply(i_hat_v, 2.0, v6_v);

  cout << "v6_v:\t" << v6_v << endl;
  
  e3_lite v7_v(i_hat_v);
  v7_v *= 2.0;

  cout << "v7_v:\t" << v7_v << endl;
  
  // Dot product.

  e3::value_type ls0 = dot(i_hat_v, v5_v);
  e3::value_type ls1 = i_hat_v*v5_v;

  size_type lprec = cout.precision(18);
  cout << "ls0:\t" << scientific << setw(27) << ls0 << endl;  
  cout << "ls1:\t" << scientific << setw(27) << ls1 << endl;
  cout.precision(lprec);
  
  // Cross product

  e3_lite k_hat_v;
  cross(i_hat_v, j_hat_v, k_hat_v);

  cout << "k_hat_v:" << k_hat_v << endl;  

  k_hat_v = v6_v;
  k_hat_v ^= v5_v;
  
  cout << "k_hat_v:" << k_hat_v << endl;  

  // Normalization.

  normalize(k_hat_v);

  cout << "k_hat_v:" << k_hat_v << endl;  

  // Convert volatile to persistent; 
  // uses implicit coversion to row_dofs_type.

  e3 k_hat(le3_space, k_hat_v, true);

  // Exit:

  return 0;
}

  
