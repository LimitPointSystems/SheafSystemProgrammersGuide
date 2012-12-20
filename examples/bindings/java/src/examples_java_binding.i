//
//
// Copyright (c) 2012 Limit Point Systems, Inc.
//
//
// SWIG interface to examples component (java version)
//

//=============================================================================

%module examples_java_binding

%include "arrays_java.i"

%import "fields_java_binding.i"
%include "examples_common_binding.i"

//=============================================================================
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
                                                                                                    
