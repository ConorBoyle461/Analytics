from matplotlib import pyplot as plt
from probabilityFunctions import *

def simpleRandomWalk(k,plot="True"):             #This function is a simple random walk with equally probable outcomes 
  n_values = []
  while k !=0:
    n_values.append(int(input("Please enter step a value (n): ")))
    k -= 1 
  n_values = tuple(n_values)
  for i in n_values:
    num = n_values.index(i)
    probPlot(probability(i,0.5),num,i)
  if plot == "True":
    plt.show()
  else: 
    pass 

def biasedRandomWalk(n,first,second, plot="True"):                                                # Biased random walk with variable likelihood of Success or Failure   
  data0 = probability(n,0.5) # Equally probable outcomes
  data1 = probability(n,first)   # Variable likelihood of success 1 
  data2 = probability(n,second)   # Variable liklihood of success 2
  plotThreeProbs(data0 ,data1,data2,first,second,n)
  plt.show()
    
#simpleRandomWalk(4,plot="False")
biasedRandomWalk(100,0.6,0.4)
