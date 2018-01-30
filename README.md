# VEHICLE ROUTE OPTIMIZATION

## ABSTRACT

The agenda of this project is to design an efficient Genetic Algorithm to solve the Vehicle Routing 
Problem. Many versions of the Vehicle Routing Problem have been described. The Vehicle Routing 
Problem with Time Windows is discussed here and can in a simplified way be described as follows: A 
fleet of vehicles is to serve a number of customers from a central depot. Each vehicle has limited 
capacity and each customer has a certain demand (which converts to time of service). A time cost is
assigned to each route between every two customers and the objective is to minimize the total cost of
travelling to all the customers.

Spring-Cleaning (hypothetical company) offers a wide variety of cleaning services. They provide carpet cleaning, 
tile and grout cleaning, upholstery cleaning, hardwood floor cleaning and air duct cleaning, etc. Broadly, they are 
categorized as residential and commercial cleaning. They have presence in 48 cities nationwide with 
various depots servicing specific regions.

Spring-Cleaning currently has an in house software that collects and maintains the services and schedules and 
decides vehicle routes. You need to work with Spring-Cleaning to develop an optimal routing solution for their 
vehicles. This will be accomplished by designing a solution using advanced optimization techniques.

## DATA

The data is in two csv files. The 'JobExecutionTime.csv' has information of estimated duration in minutes at a particular stop ID. 
The 'TravelTime.csv' consists of travel time between two stop ID's. The two files are merged to carry out the 
preprocessing steps.
For missing values in travel time, the maximum value was assigned.

## CONSTRAINTS

Spring-Cleaning strives to service requests by dynamically scheduling their resources under various
constraints. You will be given data with routes scheduled on one day for each of their depots. Every
vehicle in a depot would have a set of stops for the day, where stops means customers. In addition, they
have to consider constraints like length of the time to complete the job, travel time between stops,
maximum travel time in a route and maximum number of stops in a route.

The constraints include a set of vehicles with limits on total route duration, number of customers to be 
serviced and with no repetition of service. The objective is to minimize travel time for set of customers 
without being tardy or exceeding number of customers or service time at customer in a particular route.

## GENETIC ALGORITHM 

The Vehicle Routing Problem (VRP) dates back to the end of the fifties of the last century when Dantzig
and Ramser set the mathematical programming formulation and algorithmic approach to solve the problem of 
delivering gasoline to service stations. Since then the interest in VRP evolved from a small group of 
mathematicians to the broad range of researchers and practitioners, from different disciplines, involved 
in this field today.

The VRP definition states that m vehicles initially located at a depot are to deliver discrete quantities of
goods to n customers. Determining the optimal route used by a group of vehicles when serving a group
of users represents a VRP problem. The objective is to minimize the overall transportation cost by
optimizing time. The solution of the classical VRP problem is a set of routes which all begin and end in
the depot, and which satisfies the constraint that all the customers are served only once. The transportation
cost can be improved by reducing the total travelled distance and by reducing the number of the required vehicles.

The principles of GAs are well known. A population of solutions is maintained and a reproductive process
allows parent solutions to be selected from the population. Offspring solutions are produced which exhibit
some of the characteristics of each parent. The fitness of each solution can be related to the objective
function value, in this case the total distance travelled, and the level of any constraint violation. 
Analogous to biological processes, offspring with relatively good fitness levels are more likely to survive
and reproduce, with the expectation that fitness levels throughout the population will improve as it evolves.
More details are given by Reeves, for example. The starting point for any GA is in the representation of each
solution or population member. Typically, this will be in the form of a string or chromosome. Individual 
positions within each chromosome are referred to as genes.

## STEPS FOLLOWED

### Selection
First we select a proportion of the existing population to breed a new generation. The selection is
done on a fitness-based approach where fitter individuals are more likely to breed then others.

### Reproduction
During the reproduction phase the next generation is created using the two basic methods, crossover
and mutation. For every new child a pair of parents is selected from which the child inherits its properties. 
In the crossover process genotype is taken from both parents and combined to create a new child. 

With a certain probability the child is further exposed to some mutation, which consists of modifying certain genes.
This helps to further explore the solution space and ensure, or preserve, genetic diversity. The occurrence 
of mutation is generally associated with low probability. A proper balance between genetic quality and diversity
is therefore required within the population in order to support efficient search.

### Implementation
R statistical programming language was used to implement the system. 

## ADVANTAGES OF GENETIC ALGORITHMS

 It can solve every optimization problem which can be described with the chromosome encoding.

 It solves problems with multiple solutions.

 Since the genetic algorithm execution technique is not dependent on the error surface, we can solve 
multi-dimensional, non-differential, non-continuous, and even non-parametrical problems.

 Structural genetic algorithm gives us the possibility to solve the solution structure and solution
parameter problems at the same time by means of genetic algorithm.

 Genetic algorithm is a method which is very easy to understand and it practically does not demand the knowledge
of mathematics.

 Genetic algorithms are easily transferred to existing simulations and models.

## LIMITATIONS OF GENETIC ALGORITHMS

 Certain optimization problems (they are called variant problems) cannot be solved by means of genetic algorithms.
This occurs due to poorly known fitness functions which generate bad chromosome blocks in spite of the fact that
only good chromosome blocks cross-over.

 There is no absolute assurance that a genetic algorithm will find a global optimum. It happens very often
when the populations have a lot of subjects.

 Like other artificial intelligence techniques, the genetic algorithm cannot assure constant optimization response
times. Even more, the difference between the shortest and the longest optimization response time is much larger
than with conventional gradient methods. This unfortunate genetic algorithm property limits the genetic algorithms'
use in real time applications.

 Genetic algorithm applications in controls which are performed in real time are limited because of random solutions
and convergence, in other words this means that the entire population is improving, but this could not be said
for an individual within this population. Therefore, it is unreasonable to use genetic algorithms for on-line controls
in real systems without testing them first on a simulation model.

