#!/bin/bash

root_dir=/projects/csd_lmnn;

mlx_script=${root_dir}/scripts/QECD_20k.mlx
shapes_in_dir=${root_dir}/data/SHREC14_HUMAN/REAL/resol_original
shapes_out_dir=${root_dir}/data/SHREC14_HUMAN/REAL/resol_20kf

mkdir -p $shapes_out_dir
cd $shapes_in_dir

for i in $( ls ); 
do
	echo Downsampling shape $i
	meshlabserver -i $shapes_in_dir"/"$i -o $shapes_out_dir"/"$i -s $mlx_script
done
