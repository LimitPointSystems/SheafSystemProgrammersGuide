//
//
// Copyright (c) 2013 Limit Point Systems, Inc.
//
//
// Common SWIG interface to examples cluster
//

//=============================================================================

//$$SCRIBBLE: This file contains only the part of the Swig interface which
//            is to be lists the classes, etc. to be wrapped.
//            We have to break the interface into two parts because
//            of the way Swig handles "%import" versus "%include".
//            If you change this file make sure you also change
//            "examples_common_binding_includes.i" as well.

//=============================================================================

// Include the list of files to be inserted into the generated code.

%include "examples_common_binding_includes.i"

//=============================================================================

//$$ISSUE: Ingoring the shift operators because it causes errors when
//         building the python bindings.  These errors appeared when
//         the namespaces were introduced.

%ignore *::operator<<;
%ignore *::operator>>;

//=============================================================================

// The list of classes, etc. for which wrappers will be generated.

//$$SCRIBBLE: Note that order is important in the following list.  It must
//            follow the class hierarchies.

//=============================================================================

%include "examples.h"


//=============================================================================
