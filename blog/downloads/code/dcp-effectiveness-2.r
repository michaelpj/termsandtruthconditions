x <- c(37,15,20,10,404,642,1377,631,3113,4417,183,284,150,48,838,1440,587,2566,1699,1937,
2617,930,2712,141,159,4185,1062,47,15,120,6,89,3027,733,23520,296,922,84,82,673,192,37,
57,52449,156,121,47,39,688,36793,2028,9,398,129,4530,15,22,160,11,7,19,17,147,86,87,88,
4,12632,14,671,15869,409,789,345,924,37,734,1132,31114,136,9834,11920,3,149,1977,81,
1458,2128,1411,396,353,22,6269,39,2449,21,68,318,301,13158,207,102,197,7,225,42,117,73)
x <- log(x)



eval <- function(x,k){
	sum(log(dnorm(x,k[1],k[2])))
}

update1 <- function(x,k){
temp <- k[[2]]
for(i in 1:length(x)){ 
	temp2 <- (1/k[[1]][2]^2+1/k[[1]][3]^2)^-1
	temp1 <- (k[[1]][1]/k[[1]][2]^2+x[i]/k[[1]][3]^2)*temp2
	temp[i] <- rnorm(1,temp1,sqrt(temp2)) 
	}
return(temp)
}

update2 <- function(k){
	temp2 <- (length(k[[2]])/k[[1]][2]^2)^-1
	temp1 <- (sum(k[[2]])/k[[1]][2]^2)*temp2
	temp <- rnorm(1,temp1,sqrt(temp2)) 
	return(temp)
}

update3 <- function(x,k){
	temp <- sqrt(rinvgamma(1,length(x)/2,sum((x-k[[1]][1])^2)/2)) 
	return(temp)
}


library(MCMCpack)
rob <- rep(0,50)
rob2 <- rep(0,50)
for(nic in 1:50){

	stores <- 100000
	per <- 10
	errory <- (nic-0.5)/50

	k <- list(NULL,NULL)
	k[[1]] <- c(mean(x),sd(x)*sqrt((1-errory)),sd(x)*sqrt(errory))
	k[[2]] <- x

	hold1 <- matrix(0,stores,length(k[[1]]))
	hold2 <- matrix(0,stores,length(k[[2]]))
	for(i in 1:stores*per){
		k[[2]] <- update1(x,k)
		k[[1]][1] <- update2(k)
		temp <- update3(x,k)/sqrt(sum(k[[1]][2:3]^2))
		k[[1]][2:3] <- k[[1]][2:3]*temp
		if(i%%per==0){ 
			hold1[i/per,] <- k[[1]]
			hold2[i/per,] <- k[[2]]
		}
	}

	gains <- rep(0,50*stores)
	curtot <- 0
	for(j in 1:50){
		for(i in 1:stores){
			temp <- rnorm(1,hold1[i,1],hold1[i,2])
			temp2 <- rnorm(1,temp,hold1[i,3])
			current <- exp(-hold2[i,order(x)[1]])
			potential <- exp(-temp)
			if(temp2<min(x)) gains[(j-1)*stores+i] <- potential - current	#increase in dalys per dollar for changing to new intervention
			curtot <- curtot + current/stores/50
		}
	}
	

	a <- mean(gains)	#expected increase in dalys per dollar for asessing a new intervention
	b <- 5e9	#money moved by givewell suggestions over, say, a ten year period
	d <- 1e5	#cost of givewell assessing an additional intervention

	rob[nic] <- a*b/d#estimate of dalys per dollar for dcp
	rob2[nic] <- curtot
	print(nic)
}


library(magicaxis)
pdf("temp.pdf")
plot((1:50-0.5)/50,log10(rob),xlab="Precentage of variance in reported efficencies that is due to error",ylab="DALYs per $ donated",type="l",col=2,axes=F,ylim=c(-2.5,3))
magaxis(unlog="y")
lines((1:50-0.5)/50,log10(rob2),col=3)
legend(0.6,2.8,c("DCP donations","Direct donations"),lty=c(1,1),col=c(2,3))
dev.off()

pdf("temp2.pdf")
plot((1:999)/1000,dbeta((1:999)/1000,2,4),type="l",xlab="Precentage of variance in reported efficencies that is due to error",ylab="density")
dev.off()

cat <- dbeta((1:50-0.5)/50,2,4)

mean(rob*cat)
mean(rob2*cat)

