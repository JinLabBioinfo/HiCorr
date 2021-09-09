#!/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

full=args[1]

data=read.table(full,sep='\t',stringsAsFactors=F)
df=read.table('dist.len.stat',sep='\t',stringsAsFactors=F)

rownames(df)=paste(df[,1],df[,2],df[,3],sep=':')
df$read=df[,4]*df[,5]
rownames(data)=paste(data[,1],data[,2],data[,3],sep=':')

data$read=0
data[rownames(df),'read']=df$read
data[,5]=data$read/data[,4]
write.table(data[,1:5],'integrated.dist.len.stat',sep='\t',quote=F,row.names=F,col.names=F)


