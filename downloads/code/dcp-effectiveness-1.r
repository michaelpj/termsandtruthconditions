#the DCP data in $/DALY
x <- c(37,15,20,10,404,642,1377,631,3113,4417,183,284,150,48,838,1440,587,2566,1699,1937,
2617,930,2712,141,159,4185,1062,47,15,120,6,89,3027,733,23520,296,922,84,82,673,192,37,
57,52449,156,121,47,39,688,36793,2028,9,398,129,4530,15,22,160,11,7,19,17,147,86,87,88,
4,12632,14,671,15869,409,789,345,924,37,734,1132,31114,136,9834,11920,3,149,1977,81,
1458,2128,1411,396,353,22,6269,39,2449,21,68,318,301,13158,207,102,197,7,225,42,117,73)

#switch to DALY/$
x <- 1/x

png("interventions-distribution.png")
plot(density(x), main="Distribution of intervention effectiveness", xlab="Cost-effectiveness -- DALYs/$")
dev.off()

x <- log(x)

png("interventions-distribution-log.png")
plot(density(x), main="Distribution of intervention effectiveness", xlab="Log-effectiveness -- log(DALYs/$)")
dev.off()

k <- c(mean(x),sd(x))

#eval works out the likelihood of getting the data given the distribution parameters
eval <- function(x,k){
	sum(log(dnorm(x,k[1],k[2])))
}

gains <- rep(0,1e6)

#gains contains the difference in effectivenesses
for(i in 1:1e6) gains[i] <- exp(rnorm(1,k[1],k[2])) - exp(max(x))

png("gains-distribution.png")
plot(density(log(gains[gains>0])), main="Gains in effectiveness", xlab="Log of gain in effectiveness -- log(DALYs/$)")
dev.off()

a <- sum(gains[gains>0])/length(gains)	#expected increase in dalys per dollar for asessing a new intervention
b <- 530e6	#money moved by givewell suggestions
d <- 1e5	#cost of givewell assessing an additional intervention

a*b/d		#estimate of dalys per dollar for dcp





