import math
import numpy as np
from matplotlib import pyplot as plt

def bi_co(n,k): # BinomialCoeffecient .
    m = math.factorial(n)
    b = math.factorial(n-k)
    r = math.factorial(k)
    
    return m/(r*b)    

def probability(n,p): # This is my probability density function for n,k,p and q. 
    displacement = []
    probabilities = []
    q = 1-p 
    for k in range(-n,n,2):
      n_plus = (n+k)/2
      n_minus = (n-k)/2
      prob = ( bi_co(n,(n+k)/2) ) * (p**n_plus)*(q**n_minus)
      displacement = np.append(displacement,k)
      probabilities = np.append(probabilities,100*prob)   # I want as a percentage not fraction
    return displacement,probabilities

def probPlot(data,i,n,color='black'):                                                 #I will eventually make the graphing functions more mutable/dynamic
  plt.figure(i)
  plt.plot(data[0],data[1],color=color,label ='Number of trials ' + str(n))
  plt.title('Probability Distribution n =' + str(n))
  plt.xlabel('Final x value')
  plt.ylabel('Probability (%)')

def plotThreeProbs(data,data1,data2,s,f,n):
  plt.plot(data[0],data[1],color ='black',label ='P(+) = 50%')
  plt.plot(data1[0],data1[1],color ='red',label ='P(+) = '+str(int(100*s))+'%')
  plt.plot(data2[0],data2[1],color ='blue',label ='P(+) = '+str(int(100*f))+'%')
  plt.title('Probability Distribution n = ' +str(n))
  plt.xlabel('Final displacement')
  plt.ylabel('Probability (%)')
  plt.legend()
