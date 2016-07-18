Large Margin Nearest Neighbors
==============================

 ![LMNN Cake Image](https://bytebucket.org/mlcircus/lmnn/raw/bb416614a3cb0d3e2339b748f3b803069f1c81b7/figures/lmnncake.jpg "Image of LMNN Figure on a cake.") 

 (Thanks to [John Blitzer](http://john.blitzer.com), who gave me this cake for my 30th birthday.)

This is a [MATLAB](http://en.wikipedia.org/wiki/MATLAB) implementation of [Large Margin Nearest Neighbor](http://en.wikipedia.org/wiki/Large_margin_nearest_neighbor) (LMNN), a metric learning algorithm first introduced by [Kilian Q. Weinberger, John C. Blitzer and Lawrence K. Saul](http://www.cse.wustl.edu/~kilian/papers/NIPS2005_0265.pdf) in 2005. LMNN is a metric learning algorithm to improve [k-nearest neighbor](http://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) classification by learning a generalized Euclidean metric
![Equation](https://bytebucket.org/mlcircus/lmnn/raw/bb416614a3cb0d3e2339b748f3b803069f1c81b7/figures/mahalanobis.png)
especially for nearest neighbor classification. For more details on the solver see the [2009 JMLR paper](http://www.jmlr.org/papers/volume10/weinberger09a/weinberger09a.pdf). 

(The current version is 3.0.1.)

## Usage:
To see a working demo, please run (inside the MATLAB console):

Version 3:
setpaths3
cd demos
isoletdemo

Version 2:
`install`
`demo`


## Credit:
If you use this code in scientific work, please cite:

```
#!bibtex
@article{weinberger2009distance,
  title={Distance metric learning for large margin nearest neighbor classification},
  author={Weinberger, K.Q. and Saul, L.K.},
  journal={The Journal of Machine Learning Research},
  volume={10},
  pages={207--244},
  year={2009},
  publisher={JMLR.org}
}
```


## Changelog:
- update 04/08/2015
	 - added simple implementation of Neighbourhood Component Analysis (NCA)
- update 03/31/2015
	 - released version 3.0.0
	 - Version 3 uses the _squared_ LMNN loss (which is differentiable) and the optimization is usesMark Schmidt's LBFGS implementation
- update 03/27/2015
	 - released version 2.6.0
	 - this version has a much simpler, clearer and faster gradient computation
	 - other small bug fixes
- update 02/26/2015
	 - fixed a bug in SOD.m (for very large data sets)
	 - added a simple bandit algorithm to choose between SOD.m and SODmex.c during runtime
	 - Added sd2b.c, which speeds up gradient computation for smallish data sets.
	 - Added findLMNNparams.m for automatic tune LMNN parameters
- update 01/23/2015
     - Release version 2.5.1
     - moved to Bitbucket as new host
     - Fixed bug 
- update 23/04/2014
     - Release version 2.5:
	 - introduce new parameter "subsample" (subsample 10% of constraints by default)
	 - improve convergence criteria
- update 10/04/2013
     - fixed a small but critical bug in applypca.m (this function is optional as pre-processing)
- update 09/17/2013
     -Version 2.4.1:
     - Set default validation parameter to 0.2
     -  Now perform cross validation over maxstepsize automatically
- update 07/26/2013
     - Version 2.4:
     - Added GB-LMNN
     - New demo.m (now including GB-LMNN)
     - Made small changes to LMNN (mostly usability)
     - Parallelized some C-functions with open-MP 
     - Thanks to Gao Huang (Tsinghua university) for helping with the GB-LMNN implementation
- update 13/11/2012
     - Fixed a bug that prevented execution with even values for k.
- update 01/11/2012
     - Added optional 'diagonal' version to learn diagonal matrices 
- update 09/19/2012
     - Added 32-bit Windows binaries (Thanks to Ya Shi)
- update 09/18/2012
     - Added parameter 'outdim' to easily specify the output dimensionality
     - Small fixes in mtree code, which broke compilation on some windows machines. 
     - Speedup in findimps3Dm by substituting some repmats with bsxfun (somehow they have been overlooked)
- update 09/13/2012
     - Small fix to setpaths.m script
     - Rearranged files to ensure that the mexed files are in the path.
     - updated demo
- update 09/06/2012
     - Small fix to install.m script
- update 08/23/2012
    - Removed mex files which are no longer faster than the Matlab equivalent (Matlab became a lot faster over the years)
    - Updated mtrees to compile on windows computers and no longer use depreciated libraries
    - Removed all BLAS / LAPACK dependencies 
    - Renamed knnclassify.m to knncl.m (as former clashed with the implementation from the statistics toolbox)
    - (Many thanks to Jake Gardner who helped a lot with tiding up of the code.)



(LMNN is different from the work by [Domeniconi et al. 2005](http://cs.gmu.edu/~carlotta/publications/01461432.pdf) with a very similar title.)