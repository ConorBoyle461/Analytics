parms:1#.q;
parms:(.Q.def[`schema`hdb`action`log!((getenv`BASEDIR),"/config/schema.q";(getenv `HDB),"/hdb/";"START";(getenv `LOGDIR),"processlogs/EOD.log");.Q.opt .z.x]),.Q.opt[.z.x];

if[all parms[`action] like "START"; system raze ("l "),((getenv`BASEDIR),"scripts/q/logger.q")];

upd:{[t;x] t insert x} ;
.z.zd: 17 2 6 ; 

main:{[parms]
  .log.getHandle[parms[`log]];
  .log.write "Starting main EOD function. Loading in plant schema and reading tp log for  write down"; 
  system raze ("l "),parms[`schema] ; 
  .log.write "Schema load complete" ;
  {-11!x} each hsym `$parms[`tplog];
  tbls: tables[] ;
  hdb:hsym `$parms[`hdb] ;   
  {.log.write raze "Writing table to hdb: ",string y;  ;.Q.dpft[x;.z.d;`sym;y]}[hdb;] each tbls ;
  .log.write "Completed write down to HDB" ;
  BREAK;

  }

