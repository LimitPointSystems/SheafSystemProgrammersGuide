#
# $RCSfile: Find7Zip.cmake,v $ $Revision: 1.3 $ $Date: 2012/07/05 19:18:14 $
#
#
# Copyright (c) 2012 Limit Point Systems, Inc.
#
#

find_program(7ZA NAMES 7za 7za.exe
	PATHS ENV${PATH}
	)
if(7ZA)
  set(7ZIP_FOUND "YES" )
endif(7ZA)
