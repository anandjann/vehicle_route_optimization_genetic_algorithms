#install.packages('gtools')
rm(list=ls(all=TRUE))
setwd("C:/Users/gaman/Desktop/Kusuma/Route Optimization")

library(gtools)
travel_time = read.csv("TravelTime.csv",header = TRUE)
job_execution_time = read.csv("JobExecutionTime.csv",header = TRUE)

allStopID = job_execution_time$StopId 
allStopID[length(allStopID) + 1] = 'Depot'
stop_id = data.frame(permutations(n = length(allStopID),r=2,v=allStopID,repeats.allowed = FALSE))
stop_id_set = as.data.frame( paste(stop_id$X1,stop_id$X2,sep = ":"))
stop_id_set_travel_time = data.frame(paste(travel_time$stopId1 , travel_time$stopId2, sep = ":"),travel_time$time)
names(stop_id_set) = c("X1");
names(stop_id_set_travel_time) = c("X1");
m = merge(x = stop_id_set, y = stop_id_set_travel_time, by = "X1", all.x = TRUE)
names(m) = c('jobid','time')

#impute  missing values to max value of travel time
m$time[is.na(m$time)] = max(travel_time$time)
max_route_length = 7
max_execution_time = 720

rm(stop_id,stop_id_set,stop_id_set_travel_time)

#Gets Travel time from one stopID to other stopID
get_travel_time = function(stop_pair){
  t_time = 0
  # m - vector containing stopid1:stopid2 , travel_time
  i = match(stop_pair,m$jobid)
  t_time = m$time[i]
  
  return(t_time)
}

# Gets job execution time
get_job_execution_time = function(stopid){
  e_time = 0
  i = match(stopid,job_execution_time$StopId)
  e_time = job_execution_time$EstimatedDurationMinutes[i]
  
  return(e_time)
}

# Pass complete population to fitness function 
# fitness function returns total execution time for whole population
# with penalty added to it if required
fitness = function(x){
  total_execution_time = 0

  for(i in 1:length(x)){
    vec_len = length(x[[i]])
    execution_time = 0
    penalty_length = 0
    penalty_time = 0

    for (j in 1:(vec_len-1)){
      execution_time = execution_time + get_travel_time(paste(x[[i]][j],x[[i]][j+1],sep=':'))
      if(x[[i]][j] != 'Depot'){
        execution_time = execution_time + get_job_execution_time(x[[i]][j])
      }
    }
    # total job execution time not exceeding 720 minutes
    if(execution_time > max_execution_time ){
      penalty_time = penalty_time + 2000 * (execution_time - max_execution_time )
    }
  
    execution_time = execution_time + penalty_time + penalty_length 
    total_execution_time = total_execution_time + execution_time
  }
  
  #cat("Fitness Value :",total_execution_time,"\n")
  return(total_execution_time)
}

# function checks for time constraint
time_constraint = function(x){
  vec_len = length(x)
  execution_time = 0
  
  for (i in 1:(vec_len - 1)){
    execution_time = execution_time + get_travel_time(paste(x[i],x[i+1],sep=':'))
    if(x[i] != 'Depot'){
      execution_time = execution_time + get_job_execution_time(x[i])
    }
  }

  return(execution_time)
}

# Mutate function
mutate = function(r){
  #cat("Peforming Mutate :")
  
  for (i in 1:(length(r))){
    #cat("Before:",r[[i]],"\n")
    if(length(r[[i]]) > 3){
      g = sample(x = 2:(length(r[[i]]) - 1), size = 2)
      tmp = r[[i]][g[1]]
      r[[i]][g[1]] = r[[i]][g[2]]
      r[[i]][g[2]] = tmp
    }
    #cat("after:",r[[i]],"\n\n")
  }
  return(r)
}

# Crossover function
crossover = function(r){
  #cat("Peforming Crossover :")
  new_routes = c()
  len = length(r)
  while(length(r) > 0){
    if(length(r) == 1){
      new_routes[length(new_routes) + 1] = list(r[[1]])
      r = r[-1]
    }else{
      g = sample(x=1:length(r),size=2)
      r1 = r[[g[1]]]
      r2 = r[[g[2]]]
      #cat("Before:\n",r1,"\n",r2,"\n")
      min_len = min(c(length(r1),length(r2)))
      x_point = sample(x=c(2:(min_len) - 1),size=1)
      r1_1 = r1[1:x_point]
      r1_2 = na.omit(r1[x_point+1: (length(r1))])
      r2_1 = r2[1:x_point]
      r2_2 = na.omit(r2[x_point+1:(length(r2))])
      
      new_routes[length(new_routes) + 1] = list(c(r1_1,r2_2))
      new_routes[length(new_routes) + 1] = list(c(r2_1,r1_2))
      r=r[-c(g[1],g[2])]
      #cat("After:\n",c(r1_1,r2_2),"\n",c(r2_1,r1_2),"\n")
    }
  }
  
 return(new_routes)
}


display_routes = function(r){
  total_stop_ids = 0
  for(i in 1:length(r)){
    cat("Route",i,":")
    for(j in 1:length(r[[i]])){
      if(r[[i]][j] != 'Depot'){
        total_stop_ids = total_stop_ids + 1
      }
      cat(r[[i]][j]," ")
    }
    cat("\n")
  }
  cat("Total No.of Stopids:",total_stop_ids,"\n")
}

GeneticAlgo = function (it,alpha){
stopIDs = allStopID[1:68] #Remove Depot from it
initPop=list()
r = c()
  while(length(stopIDs) > 0){
    selected_id = sample(stopIDs,1)
      if(length(r) == 0){
      r = c(selected_id)
    }else{
      r = c(r,selected_id)
    }

    if((time_constraint(c('Depot',r,'Depot')) > max_execution_time) | ( length(r) > max_route_length) ){
      initPop[length(initPop)+1] = list(c('Depot',r[-length(r)],'Depot'))
      #cat(c('Depot',r[-length(r)],'Depot'),"\n")
      r = c()
    }else{
      #stopIDs = stopIDs[-which (stopIDs %in% r)]
      stopIDs = stopIDs[-which (stopIDs == selected_id)]
    }
  }
  #create a route with left over values
  if(length(r) > 0){
    initPop[length(initPop)+1] = list(c('Depot',r,'Depot'))
    #cat(c('Depot',r,'Depot'))
  }
  cat("Initial Routes :\n")
  display_routes(initPop)

  fitment = fitness(initPop)
  cat("Initial Fitment:",fitment,"\n")
  for(i in 1:it){
    v = runif(1,0,1)
    if(v > alpha){
      new_pop = crossover(initPop)
      new_fitment = fitness(new_pop)
    }else{
      new_pop = mutate(initPop)
      new_fitment = fitness(new_pop) 
    }
  
    if(new_fitment < fitment){
      initPop = new_pop
      fitment = new_fitment
      cat("New Improved Fitment:",fitment,"\n")
    }
    
  }
  cat("\n\n ##################################\n")  
  cat("Final Routes :\n")
  display_routes(initPop)
  cat("##################################\n")
}

#GeneticAlgo(iteration, aplha=crossover rate)
# 1-alpha will be taken as mutation rate
GeneticAlgo(1000,0.5)


