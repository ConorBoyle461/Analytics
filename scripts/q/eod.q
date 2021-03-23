parms:1#.q;
parms:(.Q.def[`schema`hdb`action`log`archive!((getenv`BASEDIR),"/config/schema.q";(getenv `HDB),"/hdb";"START";(getenv `LOGDIR),"processlogs/EOD.log";(getenv`HOME),"/tp_archive/");.Q.opt .z.x]),.Q.opt[.z.x];

if[all parms[`action] like "START"; system raze ("l "),((getenv`BASEDIR),"scripts/q/logger.q")];

upd:{[t;x] t insert x} ;
.z.zd: 17 2 6 ; 

main:{[parms]
  .log.getHandle[parms[`log]];
  .log.write "Starting main EOD function. Loading in plant schema and reading tp log for  write down"; 
  system raze ("l "),parms[`schema] ; 
  .log.write "Schema load complete" ;
  {-11!x} hsym `$ first parms[`tplog];
  tbls: tables[] ;
  hdb:first hsym `$parms[`hdb] ;   
  writeDown[hdb;] each tbls ;
  .log.write "Write down complete for all tables";
  .log.write "Moving processed tp log to archive dir"  ; 
  moveLog[parms]  ;
  .log.write "EOD write-down complete" ; 
  exit 0
  }

writeDown:{[hdb;t]
  .log.write raze "Writing to disk for table: ",string t ;
  part:.Q.par[hdb;.z.d;t] ;
  part:hsym `$raze string part ,"/" ;                          /I want splay, surely there is a better way?
  fieldsToCompress: except[;`sym`time] cols t ;
  compressionDict:(fieldsToCompress)!((count fieldsToCompress)#(enlist (17 2 6))) ;
  (part;compressionDict) set .Q.en[hdb] get t ; 
  .log.write raze "Write to disk completed for table: ",string t ; 
  }

moveLog:{[parms]
 system raze "mv ", parms[`tplog ] , " ", parms[`archive];   /Note that the archive dir must exists before trying to archive the tplogs, what is best method to do this?
  }

if[all parms[`action] like "START";main[parms]];
