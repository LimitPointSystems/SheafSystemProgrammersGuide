
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

#include "fiber_bundles_namespace.h"
#include "sec_at1_space.h"
#include "sec_e2.h"
#include "std_iostream.h"
#include "storage_agent.h"

using namespace sheaf;
using namespace fiber_bundle;

int main( int argc, char* argv[])
{  
  cout << "SheafSystemProgrammersGuide Example28:" << endl;

  // Create a namespace.

  fiber_bundles_namespace lns("Example28");

  // Populate the namespace from the file we wrote in example27.
  // Retrieves the base space, fiber space and section space schema.

  storage_agent lsa_read("example27.hdf", sheaf_file::READ_ONLY);
  lsa_read.read_entire(lns);

  // Create a section space for sec_e2 sections on the line segment mesh
  // using default values for fiber space, rep, and schema.

  poset_path lbase_path("mesh/block");
  poset_path lssp_path("e2_on_block");

  sec_e2::host_type& lhost = lns.new_section_space<sec_e2>(lssp_path, lbase_path);
  
  // Print the finished poset.

  cout << lhost << endl;

  // Write it to a file for later use.

  storage_agent lsa_write("example28.hdf", sheaf_file::READ_WRITE);
  lsa_write.write_entire(lns);

  // Exit:

  return 0;
}

  
