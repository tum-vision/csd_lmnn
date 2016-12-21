#ifndef __MESHLPMATRIX_H__
#define __MESHLPMATRIX_H__

#include <vector>
using namespace std;
bool generate_sym_meshlp_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& AAV);

bool generate_sym_meshlp_matrix_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& AAV);

bool generate_meshlp_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV);

bool generate_meshlp_matrix_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, unsigned int htype, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV);

bool generate_meshlp_matrix_adp_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV);

bool generate_meshlp_matrix_adp_geod_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, double hs, double rho, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV);



void generate_Xu_Meyer_laplace_matrix_matlab(double *TRI, int NT, double *XX, double *YY, double *ZZ, int NV, vector<unsigned int>& IIV, vector<unsigned int>& JJV, vector<double>& SSV, vector<double>& DDV);

#endif //__MESHLPMATRIX_H__
