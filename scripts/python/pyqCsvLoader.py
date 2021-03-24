from pyq import q
from datetime import datetime
import argparse


q.connectTp =  q('{0N!x;hopen hsym x}')   #Takes string as input, eg q.connectTp("localhost:5000")


def parseArgs():
    parser = argparse.ArgumentParser() 
    parser.add_argument("-csv", help="The filepath to the csv you want to publish to the kdb TP instance ",type=str)
    parser.add_argument("-tp",help="The hostname and port in the form hostname:XXXX for which the TP instance is located ",type=str)
    parser.add_argument("-action",help="Action as to whether or not to execute load i.e RUN or DEBUG",type=str)
    args = parser.parse_args()
    return args


class loadCSV:
  def __init__(self,args):
     self.csv = args.csv
     self.tp = args.tp
     self.action = args.action

  def connectTp(self):
    print(self.tp)
    self.handle = q.connectTp(self.tp)

args = parseArgs()
test = loadCSV(args)
test.connectTp()
print(test.handle)
