#include <mex.h>
#include <math.h>
#include <vector>
#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <assert.h>

#include "meshlpmatrix.h"


using namespace std;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	
	/*  check for proper number of arguments */
	/* NOTE: You do not need an else statement when using mexErrMsgTxt
	 *       within an if statement, because it will never get to the else
	 *       statement if mexErrMsgTxt is executed. (mexErrMsgTxt breaks you out of
	 *       the MEX-file) 
	*/
	if(nrhs < 4){ 
		mexErrMsgTxt("At least 4 inputs required.");
	}
	if(nrhs > 5){
		mexErrMsgTxt("At most 5 inputs required.");
	}
	if(nlhs != 4){
		mexErrMsgTxt("Four output required.");
	}

	double *TRI = mxGetPr(prhs[0]);
	double *XX  = mxGetPr(prhs[1]);
	double *YY  = mxGetPr(prhs[2]);
	double *ZZ  = mxGetPr(prhs[3]);
	int NT		= mxGetM(prhs[0]);
	int NV		= mxGetNumberOfElements(prhs[1]);

	unsigned int htype = 0, dtype = 0;
	double hs = 2, rho = 3;
	
	if(nrhs == 5){
		const mxArray *opt = prhs[4];
		mxClassID category = mxGetClassID(opt);
		if(category != mxSTRUCT_CLASS){
			mexErrMsgTxt("Third input must be a structure");
		}
	 	mwSize total_num_of_elements;
  		mwIndex index;
  		int number_of_fields, field_index;
  		const char  *field_name;
  		const mxArray *field_array_ptr;
  		total_num_of_elements = mxGetNumberOfElements(opt); 
  		number_of_fields = mxGetNumberOfFields(opt);
  
  		/* Walk through each structure element. */
  		for (index=0; index<total_num_of_elements; index++)  {
    
    		/* For the given index, walk through each field. */ 
    		for (field_index=0; field_index<number_of_fields; field_index++)  {
         	field_name = mxGetFieldNameByNumber(opt, field_index);
				field_array_ptr = mxGetFieldByNumber(opt, index, field_index);
		      if (field_array_ptr == NULL) {
					continue;
				}

				if(strcmp(field_name, "hs") == 0){
					mxClassID   cat = mxGetClassID(field_array_ptr);
					if(cat == mxDOUBLE_CLASS){
						//mexPrintf("hs: %f", hs);
						hs = (*mxGetPr(field_array_ptr));
					}
				}
				else if(strcmp(field_name, "rho") == 0){
					mxClassID   cat = mxGetClassID(field_array_ptr);
					if(cat == mxDOUBLE_CLASS){
						//mexPrintf("rho: %f", rho);
						rho = (*mxGetPr(field_array_ptr));
					}
				}
				else if(strcmp(field_name, "htype") == 0){
					mxClassID   cat = mxGetClassID(field_array_ptr);
					if(cat == mxCHAR_CLASS){
						char buf[256];
    					mwSize buflen;

		    			/* Allocate enough memory to hold the converted string. */
				    	buflen = mxGetNumberOfElements(field_array_ptr) + 1;
						if(buflen > 256){
							buflen = 256;
						}

					  	/* Copy the string data from string_array_ptr and place it into buf. */
				  	  	if (mxGetString(field_array_ptr, buf, buflen) == 0){
					  		if( strcmp(buf, "ddr") == 0 ){
								htype = 0;	
							}
							else if( strcmp(buf, "psp") == 0 ){
								htype = 1;
							}
					  	}
					}
				}
				else if(strcmp(field_name, "dtype") == 0){
					mxClassID   cat = mxGetClassID(field_array_ptr);
					if(cat == mxCHAR_CLASS){
						char buf[256];
    					mwSize buflen;

		    			/* Allocate enough memory to hold the converted string. */
				    	buflen = mxGetNumberOfElements(field_array_ptr) + 1;
						if(buflen > 256){
							buflen = 256;
						}

					  	/* Copy the string data from string_array_ptr and place it into buf. */
				  	  	if (mxGetString(field_array_ptr, buf, buflen) == 0){

							//mexPrintf("%s>>\n", buf);

					  		if( strcmp(buf, "euclidean") == 0 ){
								dtype = 0;	
							}
							else if( strcmp(buf, "geodesic") == 0 ){
								dtype = 1;
							}
							else if( strcmp(buf, "cotangent") == 0 ){
								dtype = 2;
							}

					  	}
					}
				}
			}// for field_index
      }//for index
   }//if(nrhs == 3)
	//mexPrintf("dtype: %d, htype: %d, hs: %.2f, rho: %.2f\n", dtype, htype, hs, rho);

	//cout<<"nn: "<<nn<<" hs: "<<hs<<" rho: "<<rho<<endl;
	
	double *II, *JJ, *SS, *AA;
	vector<double> SSV, AAV;
	vector<unsigned int> IIV, JJV;
	
	switch (dtype){
		case 0:
			generate_sym_meshlp_matrix_matlab(TRI, NT, XX,YY,ZZ, NV, htype, hs, rho, IIV, JJV, SSV, AAV);
			break;
		case 1:
			generate_sym_meshlp_matrix_geod_matlab(TRI, NT, XX,YY,ZZ, NV, htype, hs, rho, IIV, JJV, SSV, AAV);
			break;
		case 2:
			generate_Xu_Meyer_laplace_matrix_matlab(TRI, NT, XX,YY,ZZ, NV, IIV, JJV, SSV, AAV);
			break;

	}

	unsigned int dim = AAV.size();
	unsigned int nelem = IIV.size();
	if( nelem != JJV.size() ||  nelem != SSV.size() ){
		mexErrMsgTxt("Dimension of II, JJ, SS has to be the same");
	}
	plhs[0] = mxCreateDoubleMatrix(nelem, 1, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(nelem, 1, mxREAL);
	plhs[2] = mxCreateDoubleMatrix(nelem, 1, mxREAL);
	plhs[3] = mxCreateDoubleMatrix(dim, 1, mxREAL);
	II = mxGetPr(plhs[0]);
	JJ = mxGetPr(plhs[1]);
	SS = mxGetPr(plhs[2]);
	AA = mxGetPr(plhs[3]);

	for(mwSize i = 0; i < nelem; i ++){
		II[i] = IIV[i];
		JJ[i] = JJV[i];
		SS[i] = SSV[i];
	}
	for(mwSize i = 0; i < dim; i ++){
		AA[i] = AAV[i];
	}

//	mxFree(filename);
}


