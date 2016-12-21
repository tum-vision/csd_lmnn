# csd_lmnn
**csd_lmnn** is a package used to learn optimal shape descriptors for 3D non-rigid shapes using well known 
point descriptors like the Heat Kernel Signature and the Wave Kernel Signature and metric learning, 
in particular the Large Margin Nearest Neighbor algorithm. 
It can be used for shape classification, shape similarity ranking and shape retrieval. 
This repository is an official release of [this paper](#paper).

* [Using the code](#usage)
* [Data preparation](#data)
* [Publication](#paper)
* [License and Contact](#other)

## <a name="usage">Usage</a>
### Installation
The code was developed in Matlab 2014b under Ubuntu 14.04. You can clone the repo with:
```
git clone https://github.com/tum-vision/csd_lmnn.git
```

## <a name="data">Data preparation</a>
#### Dataset

First download your favourite 3D shapes dataset. I have mainly experimented with the SHREC'14 dataset found at: 

```
http://www.cs.cf.ac.uk/shaperetrieval/download.php
```

Depending on the resolution of your shapes you might want to downsample them. Meshlab ([https://github.com/cnr-isti-vclab/meshlab](https://github.com/cnr-isti-vclab/meshlab)) can be used for this purpose.
A bash script ``` downsample_meshes.sh ``` that uses ```meshlabserver``` is provided in the scripts directory to automate this process. A default parameter script ```QECD_20k.mlx``` to downsample at 20.000 faces is also included.

#### Usage of downsampling script

```
./scripts/downsample_meshes.sh -i path/to/input/shapes/dir -o path/to/output/shapes/dir [-s path/to/meshlab_script]

```

#### Setting your paths

You have to customize the file ```./code/toplevel_func/init_dataset.m``` to set the paths to your data directories correctly. 


#### Building mex files
The code for computing the Laplace Beltrami operator is from MeshLP and is relatively old. 
You might need to adjust your mex compiler settings to get it working for your platform. 
A script ```./code/thirdparty/calc_LB/buildmex.m``` is included that worked for me along with the resulted executable.


## <a name="paper">Publication</a>
If you use this code in your work, please cite the following paper.

Ioannis Chiotellis, Rudolph Triebel, Thomas Windheuser and Daniel Cremers, _"Non-Rigid 3D Shape Retrieval via Large Margin Nearest Neighbor Embedding"_, in proceedings of the 14th European Conference on Computer Vision, 2016. ([pdf](https://vision.in.tum.de/_media/spezial/bib/chiotellis2016csdlmnn.pdf))
    
    @InProceedings{chiotellis2016csdlmnn,
      author = "I. Chiotellis and R. Triebel and T. Windheuser and D. Cremers",
      title = "Non-Rigid 3D Shape Retrieval via Large Margin Nearest Neighbor Embedding",
      booktitle = eccv,
      year = "2016",
      month = "October",
      keywords={shape retrieval, shape representation, supervised learning},
      note = {{<a href="https://github.com/tum-vision/csd_lmnn" target="_blank">[code]</a>} },
    }

## <a name="others"> License and Contact</a>

This work is released under the[GNU General Public License Version 3 (GPLv3)](http://www.gnu.org/licenses/gpl.html).
Nevertheless it relies on other projects (see directory ```./code/thirdparty```) which are released under their own licences.

Contact **John Chiotellis** [:envelope:](mailto:chiotell@in.tum.de) for questions, comments and reporting bugs.