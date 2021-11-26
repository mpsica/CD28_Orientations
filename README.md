# CD28_Orientations

Two scripts are necesary to produce the plot in Figure 6E.

First a trajectory file in .gro format containing only coords of CA atoms is produce with ''trjconv'' tool from GROMACS package (help can be found in https://manual.gromacs.org/documentation/2016.4/onlinehelp/gmx-trjconv.html). In this procedure, trajectories are centered and fixed on the CA coordinates of CD80 and only the CD28 or CTLA4 CA coords are recorded. All CD28 or CTL4 CA atoms are recoded. The following scripts filter the CAs of interest.

Second, a bash script (preprocess.sh) is used to format the information in the .gro files and produce the input files that will be analysed with the following R script.

Third, the Rscript do the analysis with the coordinates of the CA atoms. 

The R scripts (analisys.R) is autoexplanatory. Briefly, after proper rearrangement of the input information, the script compute the coords of two vectors: 

- Vector 1: between CAs of residues 102 and 89 of CD28 or CTLA4
- Vector 2: between CAs of residues 102 and 18 of CD28 or CTLA4

We selected these residues because they are conserved positions in CD28 or CTLA4 and form a triangle that representative of the orientation of the protein with repect to CD80. The orientation of CD28 or CTLA4 with respect to CD80 (whose rotation and translation was fixed with ''gmx trjconv'') is monitored by the normal vector (cross product in the Rscript) of the plane formed by Vector 1 and Vector 2. The tip of the vector is plotted in a 3D plot.

The Rscript has to be run in an IDE like RStudio since the plot is produced with the library ''rgl''

