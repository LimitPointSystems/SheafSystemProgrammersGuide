
//
//
// Copyright (c) 2012 Limit Point Systems, Inc.
//
//
// SWIG interface to examples component (python version)
//

//=============================================================================

%module examples_python_binding

%include "sheaves_common_binding_includes.i"
%include "fiber_bundles_common_binding_includes.i"
%include "geometry_common_binding_includes.i"
%include "fields_common_binding_includes.i"

%import  "sheaves_python_binding.i"
%import  "fiber_bundles_python_binding.i"
%import  "geometry_python_binding.i"
%import  "fields_python_binding.i"

%include "examples_common_binding.i"

//=============================================================================


%include carrays.i
%array_class(double, doubleArray);
%array_class(int, intArray);

%include cpointer.i
%pointer_class(double, doublePtr);
%pointer_class(int, intPtr);

//=============================================================================

%{
#include "std_iostream.h"
%}
 
%inline %{
ostream* get_cout()
{
   return &cout;
}
%}

//=============================================================================