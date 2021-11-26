# CD28_Orientations

With these two scripts we have computed the orientation of CD28 or CTLA4 with respect to CD80 along an all-atom simulation, as shown in Figure 6E.

**First**, we simulated the complex of CD80 with CD28 or CTLA4 as described in Methods, and then the simulations were converted with ''*gmx trjconv*'' tool from GROMACS package to *.gro* format containing only coords of CA-atoms (help can be found in https://manual.gromacs.org/documentation/2016.4/onlinehelp/gmx-trjconv.html). Most importantly, to properly monitor the orientations, in this procedure trajectories are centered and fixed on the CA coordinates of CD80 (option *-fit rot+trans* of trjconv)  and only the CD28 or CTLA4 CA_coords are recorded. All CD28 or CTL4 CA-atoms are recoded. The following scripts filter the CA-atoms of interest.

This repo includes two examples of CA-simulations in *.gro* format produced as described. You can use this files as input to the following steps.

**Second**, a bash script (*preprocess.sh*) is used to get information from the *.gro* file and produce the input files that will be analysed with the following R script.

**Third**, the Rscript (*analysis.R*) do the analysis with the coordinates of the CA-atoms. The Rscripts is autoexplanatory. Briefly, after proper rearrangement of the input information, the script compute the coords of two vectors: 

- Vector 1: between CAs of residues 102 and 89 of CD28 or CTLA4
- Vector 2: between CAs of residues 102 and 18 of CD28 or CTLA4

As, shown in the following image, we selected these residues (yellow spheres) because they are conserved positions in CD28 or CTLA4 (in blue ribbon; CD80 in red ribbon) and form a triangle (yellow plane) representative of the orientation of the protein with repect to CD80. The orientation of CD28 or CTLA4 with respect to CD80 (whose rotation and translation was fixed with ''gmx trjconv'') is monitored by the normal vector (yellow arrow, the cross product in the *analysis.R*) of the plane formed by Vector 1 and Vector 2. The tip of this vector is plotted in a 3D plot.

The Rscript has to be run in an IDE like RStudio since the plot is produced with the library ''rgl''

![Complex](./Normal_plane.png)
