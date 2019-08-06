# NEED TO UPDATE THIS SLOPE VALUE EVERY TIME
slope <- as.numeric(read.table("slope_value.tab"))

data <- read.table("FILE", col.names=c("gid1", "gid2", "val", "rand"))
attach(data)
prob <- 1 - 1/slope
r <- rand / (slope - 1)
r[r==0] <- 1e5
data$pval <- pnbinom(val - 1, size=r, mu=rand, lower.tail=FALSE)
detach()
write.table(data, file="FILE.p_val", row.names=FALSE, col.names=FALSE, sep="\t", quote=FALSE)

