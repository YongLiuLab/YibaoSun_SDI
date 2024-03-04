
# Install and load required libraries 
# e.g. pip install numpy brainspace surfplot neuromaps nibabel 

from surfplot import Plot
from brainspace.datasets import load_parcellation
from brainspace.mesh.mesh_io import read_surface
from neuromaps.datasets import fetch_fslr
import numpy as np
from numpy import *
# Load the surface we want to use as the background
# Read in your own background surface {'.ply', '.vtp', '.vtk', '.fs', '.asc', '.gii'} 
surfaces = read_surface(r'F:\Code\coupling\data\templates\Q1-Q6_R440.L.midthickness.32k_fs_LR.surf.gii') 

# Or use one of the surface files included in the neuromaps package 
# Here we are using the 32k FsLR (a symmetric version 
# fsaverage space template with ~32k verticies in each hemisphere
surfaces = fetch_fslr()
lh, rh = surfaces['inflated']

# Next we want to load the parcellation/atlas we want to plot
# on the background surface. A parcellation is a array or surface file the same 
# length (number of vertices) as the background surface, with the same value  
# assigned to clusters of vertivies, representing discrete brain regions  
# We can either read in a surface file in FsLR space
#atlas = read_surface('./path/to/surface/atlas/file.gii.gz') 

# Or use one of the surface files included in the brainspace package
atlas = load_parcellation('schaefer', 100, join = True)

# You can either plot this atlas directly, or assign new values 
# to each parcel to demonstrate an statistical effect. Here we assign a 
# random value between [0,1] to each unique parcel (excluding the medial wall [0])
unique = np.unique[1:len(atlas)]
for i in range(unique.shape[0]):
	rd = np.random.uniform(low=0.0, high=1.0, size=1).round(3)
	atlas = np.where(atlas==unique[i], rd, atlas)

# Generate plot
p = Plot(lh, rh, views=['lateral','medial'], zoom=1.2)
p.add_layer(atlas, cbar=True, cmap='inferno')
p.build()