from pyq import q
from datetime import datetime
import argparse
import csv 

#Defining kdb/q helper functions
q.connect = q('{hopen hsym x}')
q.typeMap = q('`time`sym`price`size`bid`ask`asize`bsize`max_price`min_price`volume!("NSFIFFIIFFI")')
q.tradeTbl = q('([]time:"n"$(); sym:`symbol$();price:`float$();size:`int$())')
q.quoteTbl = q('([]time:"n"$(); sym:`symbol$();bid:`float$();ask:`float$(); bsize:`int$();asize:`int$())')
q.aggTbl = q('([]time:"n"$(); sym:`symbol$() ; max_price:`float$() ; min_price: `float$(); volume:`int$())')
q.header = q('{`$"," vs raze system raze "head -1 ",string x  }')
q.createTbl = q('{[datatypes;header]flip datatypes$header!()}')
q.row_data = q('{[datatypes;row] (raze string datatypes)$(string row) }')
q.send_update = q('{[handle;tbl;data] handle(`.u.upd;tbl;data)}')



def parseArgs():
    print ("Parsing command line arguments")
    parser = argparse.ArgumentParser() 
    parser.add_argument("-csv", help="The filepath to the csv you want to publish to the kdb TP instance ",type=str)
    parser.add_argument("-tbl",help="The name of the table that you intend to publish the data to on the tickerplant",type=str)
    parser.add_argument("-tp",help="The hostname and port in the form hostname:XXXX for which the TP instance is located ",type=str)
    args = parser.parse_args()
    return args

class loadCSV:
  def __init__(self,args):
     self.csv = args.csv
     self.tp = args.tp

  def connect(self):
    q.connectTp =  q('{hopen hsym x}')   #Takes string as input, eg q.connectTp("localhost:5000") < the q interpreter will see this as a symbol
    self.handle = q.connectTp(self.tp)
    
  def sendCsv(self):
    print ("Reading in csv")
    with open(self.csv, "r") as csvfile:
      read_lines = csv.reader(csvfile)
      header = q.header(self.csv)
      datatypes = q.typeMap(header)
      next(read_lines,None)           #Skipping header line of csv
      print ("Publishing each row to TP")
      for row in read_lines:
        q_tbl =(q.createTbl(datatypes,header))
        typed = q.row_data(datatypes,row)
        filledTbl = q_tbl.upsert(typed) 
        q.send_update(self.handle,args.tbl,filledTbl)
        print ("Row sent: {}".format(row))

if __name__ == "__main__":
  args = parseArgs()
  data = loadCSV(args) 
  data.connect()
  data.sendCsv()

