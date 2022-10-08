#!/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

full=args[1]

data=read.table(full,sep='\t',stringsAsFactors=F,row.names=1)
df=read.table('dist.stat',sep='\t',stringsAsFactors=F,row.names=1)

#rownames(df)=paste(df[,1],df[,2],df[,3],sep=':')
#df$read=df[,4]*df[,5]
#rownames(data)=paste(data[,1],data[,2],data[,3],sep=':')
#colnames(df)='read'
df$read=df[,1]*df[,2]

data$read=0
data[rownames(df),'read']=df$read
data$avg=data$read/data[,1]
data[,2:3]=NULL
data$read=NULL
write.table(data,'integrated.dist.len.stat',sep='\t',quote=F,col.names=F)



