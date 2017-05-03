
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

/// @example Example28
/// SheafSystem Programmer's Guide Example 28: Creating a section space.

#include "SheafSystem/fiber_bundles_namespace.h"
#include "SheafSystem/sec_at1_space.h"
#include "SheafSystem/sec_e2.h"
#include "SheafSystem/std_iostream.h"
#include "SheafSystem/storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;
using namespace std;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example28:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example28");

  // Populate the namespace from the file we wrote in example25.
  // Retrieves the base space.

  storage_agent lsa_read("example23.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Create a section space for sec_e2 sections on the line segment mesh
  // using standard rep and no suffixes.

  poset_path lbase_path("mesh/block");

  sec_e2::host_type& lsec_e2_host = sec_e2::standard_host(lns, lbase_path, "", "", "", true);

  cout << endl;
  cout << "sec_e2 space path: " << lsec_e2_host.path() << endl;
  cout << "sec_e2 space schema path: " << lsec_e2_host.schema().path() << endl;
  cout << "sec_e2 space scalar space path: " << lsec_e2_host.scalar_space_path() << endl;
  
  // Print the finished poset.

  cout << lsec_e2_host << endl;


  // Create a section space for sec_e2 sections on the line segment mesh
  // using rep "elelment_element_constant" and both section and fiber suffixes.

  poset_path lrep_path("sec_rep_descriptors", "element_element_constant");
  
  sec_e2::host_type& lsec_e2_other_host = 
    sec_e2::standard_host(lns, lbase_path, lrep_path, "_other", "_new", true);
  
  cout << endl;
  cout << "other sec_e2 space path: " << lsec_e2_other_host.path() << endl;
  cout << "other sec_e2 space schema path: " << lsec_e2_other_host.schema().path() << endl;
  cout << "other sec_e2 space scalar space path: " << lsec_e2_other_host.scalar_space_path() << endl;


  // Write the namespace to a file for later use.

  storage_agent lsa_write("example28.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
