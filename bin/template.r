#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file=args[1]

matrix <- read.table(file)
grid <- read.table("grid.REGION",header=TRUE)
attach(grid)
matrix <- data.matrix(matrix)
for (i in c(1:sqrt(length(matrix)))){matrix[i,i] <- 0}
ind.matrix <- Index[Loc >= START & Loc <= END]
ind.grid <- c(ind.matrix[1] -1, ind.matrix)
beg <- Loc[ind.grid[1]]
end <- Loc[ind.grid[length(ind.grid)]]
gap <- Loc[ind.matrix]-Loc[ind.matrix][1]
tmp <- Loc[ind.matrix[2:107]]-Loc[ind.matrix[1:106]]
y_Loc <- (Loc[1])
for(x in rev(tmp)){y_Loc <- c(y_Loc,y_Loc[length(y_Loc)]+x)}
x <- c(Loc[1],Loc[length(Loc)])
y <- c(y_Loc[length(y_Loc)],y_Loc[1])

rotate <- function(x) t(apply(x, 2, rev))
n <- 20
col <- rgb(1,(n-2):0/(n-1),(n-2):0/(n-1))
draw_heatmap <- function(matrix,name,color_scale){
	matrix <- rotate(matrix)
	if (color_scale!= 0){
        	breaks <- c(seq(1.001,color_scale,(color_scale-1.001)/18),max(matrix))
        }else{
		if(max(matrix)<2){
			breaks <- seq(1.001,max(matrix),(max(matrix)-1.001)/19)
		}else{
			step <- (quantile(matrix, prob=0.98)-1)/18
			up <- quantile(matrix, prob=0.98)+0.011
			if(up<2){
				up <- 2	
				step <- 0.999/18
			}
			breaks <- c(seq(1.001,up,step),max(matrix))
		}
	}
	pdf_name <- paste(name,"pdf",sep=".")
	pdf(pdf_name)
	par(mar=c(0,0,0,0))
	image(Loc[ind.grid], y_Loc, matrix, zlim=c(1, 50), col=col, breaks=breaks,xaxt="n",yaxt="n",xlab="",ylab="")
	lines(x,y)
	dev.off()
	png_name <- paste(name,"png",sep=".")
	png(png_name)
	par(mar=c(0,0,0,0))
	image(Loc[ind.grid], y_Loc, matrix, zlim=c(1, 50), col=col, breaks=breaks,xaxt="n",yaxt="n",xlab="",ylab="")
	lines(x,y)
	dev.off()
}

draw_heatmap(matrix[ind.matrix, ind.matrix],"REGION",0)
