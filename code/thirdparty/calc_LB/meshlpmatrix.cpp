#include <mex.h>
#include "comp_meshlpmatrix.h"
#include "meshlpmatrix.h"

bool generate_sym_meshlp_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& AAV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);

	double h;
   double maxs, mins, avers;                                                                         
	tmesh.MeshSize(maxs, mins, avers);
	mexPrintf("avers: %f\n", avers);
	if(htype == 0){
		h = avers * hs;
	}
	else{
		h = hs;
	}

	mexPrintf("h: %f\n", h);
	generate_sym_meshlp_matrix(tmesh, h, rho, IIV,  JJV,  SSV, AAV);
	return true;
}

bool generate_sym_meshlp_matrix_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
											unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& AAV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);

	double h;
   double maxs, mins, avers;                                                                         
	tmesh.MeshSize(maxs, mins, avers);
	mexPrintf("avers: %f\n", avers);
	if(htype == 0){
		h = avers * hs;
	}
	else{
		h = hs;
	}

	mexPrintf("h: %f\n", h);
	generate_sym_meshlp_matrix_geod(tmesh, h, rho, IIV,  JJV,  SSV, AAV);
	return true;
}


bool generate_meshlp_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
								   unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);

	double h;
   double maxs, mins, avers;                                                                         
	tmesh.MeshSize(maxs, mins, avers);
	mexPrintf("avers: %f\n", avers);
	if(htype == 0){
		h = avers * hs;
	}
	else{
		h = hs;
	}

	mexPrintf("h: %f\n", h);
	generate_meshlp_matrix(tmesh, h, rho, IIV,  JJV,  SSV);
	return true;
}

bool generate_meshlp_matrix_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
										unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);

	double h;
   double maxs, mins, avers;                                                                         
	tmesh.MeshSize(maxs, mins, avers);
	mexPrintf("avers: %f\n", avers);
	if(htype == 0){
		h = avers * hs;
	}
	else{
		h = hs;
	}

	mexPrintf("h: %f\n", h);
	generate_meshlp_matrix_geod(tmesh, h, rho, IIV,  JJV,  SSV);
	return true;
}

bool generate_meshlp_matrix_adp_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
									   double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);
	generate_meshlp_matrix_adp(tmesh, hs, rho, IIV,  JJV,  SSV);
	return true;
}

bool generate_meshlp_matrix_adp_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
											double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);
	generate_meshlp_matrix_adp_geod(tmesh, hs, rho, IIV,  JJV,  SSV);
	return true;
}

void generate_Xu_Meyer_laplace_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, 
											 vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& DDV)
{
	TMesh tmesh;
	//if( !(tmesh.ReadOffFile(filename)) ){
   	//mexPrintf("Failed to open file %s\n", filename);
  	//}
	tmesh.ReadMatlabStruct(TRI, NT, XX,YY,ZZ, NV);
	generate_Xu_Meyer_laplace_matrix(tmesh,  IIV,  JJV,  SSV, DDV);
}


