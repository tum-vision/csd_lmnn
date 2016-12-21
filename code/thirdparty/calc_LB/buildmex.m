% You might need to tinker your mex settings
mex -I../  -v -largeArrayDims CXXFLAGS="$CXXFLAGS -ansi -D_GNU_SOURCE" CXXOPTIMFLAGS="-O1 -DNDEBUG" LDOPTIMFLAGS="-O1" -output meshlp comp_meshlpmatrix.cpp matrix.cpp meshlpmatrix.cpp mshlpmatrix.cpp offobj.cpp point.cpp tmesh.cpp

