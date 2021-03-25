from pyq import q
from datetime import datetime
import argparse
import csv 

def parseArgs():
    parser = argparse.ArgumentParser() 
    parser.add_argument("-csv", help="The filepath to the csv you want to publish to the kdb TP instance ",type=str)
    parser.add_argument("-tp",help="The hostname and port in the form hostname:XXXX for which the TP instance is located ",type=str)
    parser.add_argument("-action",help="Action as to whether or not to execute load i.e RUN or DEBUG",type=str)
    args = parser.parse_args()
    return args


q.connect = q('{hopen hsym x}')
q.tradeTbl = q('([]time:"n"$(); sym:`symbol$();price:`float$();size:`int$())')
q.quoteTbl = q('([]time:"n"$(); sym:`symbol$();bid:`float$();ask:`float$(); bsize:`int$();asize:`int$())')
q.aggTbl = q('([]time:"n"$(); sym:`symbol$() ; max_price:`float$() ; min_price: `float$(); volume:`int$())')
q.header = q('{system raze "head -1 ",string x  }')
q.createTbl = q('{flip (`$"," vs x)!()}')

class loadCSV:
  def __init__(self,args):
     self.csv = args.csv
     self.tp = args.tp
     self.action = args.action

  def connect(self):
    q.connectTp =  q('{hopen hsym x}')   #Takes string as input, eg q.connectTp("localhost:5000")
    self.handle = q.connectTp(self.tp)
    
  def readCsv(self):
    with open(self.csv, "r") as csvfile:
      read_lines = csv.reader(csvfile)
      header = q.header(self.csv)
      next(read_lines,None)
      for row in read_lines:
        q_tbl =(q.createTbl(header.first))
        tbl = q_tbl.upsert(row)


args = parseArgs()
test = loadCSV(args)
test.connect()
test.readCsv()
