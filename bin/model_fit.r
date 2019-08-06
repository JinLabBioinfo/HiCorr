group_list <- read.table("lambda_group.tab", col.names=c("group", "lambda", "range"))

group <- group_list$group
lambda <- group_list$lambda
file <- paste("data_list.group.", group, sep="")
graph <- paste("hist.group.", group, ".pdf", sep="")
avg <- c()
var <- c()
avg_adj <- c()
var_adj <- c()

for(i in 1:length(group)){
        data <- read.table(file[i], col.names=c("count","actual_lambda"))
	attach(data)
        data$pval <- ppois(count-1, lambda[i], lower.tail=FALSE)
        detach()
        attach(data)
        max <- max(count)
        avg <- c(avg, mean(count))
        var <- c(var, var(count))
        xlim <- max(6, 1+qpois(1e-5, lambda[i], lower.tail=FALSE))


        avg_adj <- c(avg_adj, mean(count[count < xlim]))
        var_adj <- c(var_adj, var(count[count < xlim]))
        detach()
}
model <- lm(var_adj ~ lambda + 0)
slope <- as.numeric(model$coefficients)
scale <- slope

write.table(slope, file="slope_value.tab", col.names=FALSE, row.names=FALSE)

pdf("plot.var_2_mean.pdf", width=5, height=5)
plot(lambda, var_adj, xlab="Expected value", ylab="Variance", main="Statistical property of read counts")
lines(c(0,max(lambda)+1), slope*c(0,max(lambda)+1), col="red")
legend("topleft", paste("y = ", as.integer(slope*1000 + 0.5)/1000, "x", sep=""), lty = 1, col="red")
dev.off()

for(i in 1:length(group)){
	data <- read.table(file[i], col.names=c("count","actual_lambda"))
	attach(data)

	max <- max(count)
        xlim <- max(6, 1+qpois(1e-5, lambda[i], lower.tail=FALSE))
	
	shape <- lambda[i] / scale
	prob <- 1 - 1/slope
	r <- lambda[i] / (slope - 1)

	
	pdf(graph[i], width=5, height=5)
	hist(count - 0.5, breaks=0:max - 0.5, probability=TRUE, main=paste("Distribution of read counts (Exp = ",lambda[i],")", sep=""), xlab="Read counts", ylab="Probability", xlim=c(0,xlim)-0.5)
#	lines(0:xlim, dpois(0:xlim, lambda[i]), col="blue")
#	lines(0:xlim, pgamma(0:xlim + 0.5, shape=shape, scale=scale) - pgamma(0:xlim - 0.5, shape=shape, scale=scale), col="red")
	lines(0:xlim, dnbinom(0:xlim, size=r, mu=lambda[i]), col="blue")	

	legend("topright", c("Histogram of fraction", "Neg binomial distribution"), bty="n", pch=c(0, NA), lty=c(0,1), pt.cex = 2, col=c("black","blue"))
	
	dev.off()

	detach()
}

