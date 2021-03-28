import numpy as np  
import random

def arithmeticBM(t,dt,mu,sigma,price_initial):          #A function to simulat Arithmetic Brownian Motion based on inputs shown
  results = {}
  x_values = np.array([price_initial])
  t_values =np.array([0])
  for i in np.arange(0+dt,t,dt):   
      sigma = sigma
      B = np.sqrt(i)*np.random.normal(0.0,1)
      value = price_initial + mu*i + sigma*B
      t_values = np.append(t_values,i)
      x_values = np.append(x_values,value)
  results['time'] = t_values
  results['values'] = x_values
  return results 
