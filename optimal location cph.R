#Define all locations as vectors (latitude, longitude, importance/frequency)
SP<-c(55.681686,12.530015,4.4)
DH<-c(55.683633,12.515466,1)
PH<-c(55.678141,12.522397,1)
Bellahoj<-c(55.706139,12.515037,1)
NorreAlle<-c(55.698486,12.560999,1)
Norrebro<-c(55.697627,12.546601,3)
Jolene<-c(55.667414,12.561064,2)
Stroget<-c(55.678673,12.574861,1)
Norreport<-c(55.683125,12.57072,3)
Christiania<-c(55.671359,12.59546,1)
Tietgen<-c(55.660909,12.589645,2)
Osterbro<-c(55.696793,12.579603,1)
AmagerStrand<-c(55.662192,12.634192,0.16)
CentralStation<-c(55.673156,12.563531,0.5)
Airport<-c(55.628577,12.644749,0.5)

#Locations vector (all locations' latitude, longitude, importance/frequency in order)
loc.vector<-c(SP,DH,PH,Bellahoj,NorreAlle,Norrebro,Jolene,Stroget,Norreport,Christiania,Tietgen,Osterbro,AmagerStrand,CentralStation,Airport)

#----Below: no manual adjustments----

#Locations matrix (3 columns: latitude, longitude, importance/frequency)
loc.matrix<-matrix(loc.vector,byrow=T, ncol=3)
   
colnames(loc.matrix)<-c("lat","long","freq")
rownames(loc.matrix)<-c("SP","DH","PH","Bellahoj","NorreAlle","Norrebro","Jolene","Stroget","Norreport","Christiania","Tietgen","Osterbro","AmagerStrand","CentralStation","Airport")

#Phythagoras function to calculate distance between two locations
distance<-function(loc1, loc2) {
d<-((loc1 [1]-loc2 [1])^2+(loc1 [2]-loc2 [2])^2)^(1/2)
return(d)
}

#Objective function: cumulated distance between a location "OptLoc" and all given locations, weighted with their respective importance/frequency
#Alternative1:
#(cd<-cd+distance(OptLoc,c(loc.matrix[i,1],loc.matrix[i,2]))*loc.matrix[i,3])
#Alternative2: square the distances to take into account the relatively higher disutility of very long distances
#(cd<-cd+distance(OptLoc,c(loc.matrix[i,1],loc.matrix[i,2]))^2*loc.matrix[i,3])
cumulatedDistance<-function (optLoc){
	cd<-0
	for (i in 1:nrow(loc.matrix)) {
		cd<-cd+distance(optLoc,c(loc.matrix[i,1],loc.matrix[i,2]))^2*loc.matrix[i,3]
		}
	return(cd)
}

#Minimize the objective function, first argument is a vector with the starting points, only give back the latitude and longitude
optim(c(55,12),cumulatedDistance)$par

cumulatedDistance(optim(c(55,12),cumulatedDistance)$par)
jagtvej15<-c(55.689355,12.542868)
cumulatedDistance(jagtvej15)
