library(rgl)
rm(list=ls(all=TRUE))

##### Setting up the system #####
# Uncomment and edit accordingly

# setwd("") 

##### FUNCTIONS #################

dist_between_CAs <- function(A,CA_1,CA_2){
  coords_1 <- matrix(A[,CA_1,],byrow=T,ncol=3)
  coords_2 <- matrix(A[,CA_2,],byrow=T,ncol=3)
  return(coords_2-coords_1)
}

Modulo <- function(M,CA_atom){
  A <- matrix(M[,CA_atom,],byrow=T,ncol=3)
  return(sqrt(A[,1]^2+A[,2]^2+A[,3]^2))
}


CrossProduct <- function(Vec_1,Vec_2){
  M<-cbind(Vec_1[,2]*Vec_2[,3] - Vec_1[,3]*Vec_2[,2],
           Vec_1[,3]*Vec_2[,1] - Vec_1[,1]*Vec_2[,3],
           Vec_1[,1]*Vec_2[,2] - Vec_1[,2]*Vec_2[,1])
  return(M/sqrt(M[,1]^2+M[,2]^2+M[,3]^2))
}



##### List of files with XYZ coordinates  ############
# These input files contain the have 3 columns: xyz coordinates
# of every CA atom, of every recorded frame.
# Input files are produce with a bash script from the .gro obtained 
# from the simulations analysis

# The items in the input list are:
  #   input filename (.dat)
  #   Number of CA atoms in the system
  #   Number of frames recorded
  #   A color code

input_list = list(
  "CD28_CD80N_pH5" = c("CD28-CD80N_pH5.dat",224,2446,1),
  "CD28_CD80N_pH7" = c("CD28-CD80N_pH7.dat",224,2274,2)
)



### ANALYSIS ##############

# First, we create an empty array/matrix that will contain 
# the XYZ coords of the tip of the orientation vector

Tips <- c()
colors <- c()

# Choose a range of frames to analyse
range_frame <- c(1:1000)



# Data loading and processing
for (input in input_list){
  # First, we parse info from the input_list
  filename = input[1]
  N_CA     = as.numeric(input[2])
  N_frames = as.numeric(input[3])
  color    = as.numeric(input[4])
  colors <- c(colors,color)

  
  # Input data is loaded as a 3-columns matrix
  M <- matrix(scan(filename),ncol=1,byrow = T)
  
  # This matris is converted to an array with the following dimensions:
  # Dim #1: x,y,z coordinaes 
  # Dim #2: number of CA
  # Dim #3: Frame
  A <- array(t(M),dim = c(3, N_CA, N_frames))
  
  # sanity check (use if necessary)
  Triangle <- matrix(A[,c(102,18,89),],byrow=T,ncol=3) #
  
  Vec_1 <- dist_between_CAs(A,102,89)
  Vec_2 <- dist_between_CAs(A,102,18)
  
  Tips <- rbind(Tips,
              cbind(CrossProduct(Vec_1,Vec_2)[range_frame,],
                    Modulo(A,102)[range_frame],
                    rep(color,diff(range(range_frame)))
                    )
              )
  }

pallete <- c("#E69F00","#009400","#cc79a7","#0000ff")
Labs <- c("CD28, low pH", "CD28, nuetral pH")

# Now, we plot in 3D the tips of the normal to the plane
# that reflects the orientation of CD28 against CD80

open3d()

par3d("antialias",
      mouseMode="trackball",
      windowRect = c(0, 0, 512,512))

plot3d(
  x=Tips[,1], y=Tips[,2], z=Tips[,3],
  xlim = c(-1,1),
  ylim = c(-1,1),
  zlim = c(-1,1),
  xlab = ("X"), ylab = ("Y"), zlab = ("Z"),
  type = 'p',
  radius = .08,
  col = pallete[as.numeric(Tips[,5])],
  add=F,
  size=5)

aspect3d(1,1,1)

legend3d("topright", legend = Labs[colors],
         pch = 16, col = pallete[colors] , cex=1)
rglwidget()  

