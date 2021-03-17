/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

parms:1#.q ; 
parms:(.Q.def[`tpPort`action`log!("localhost:5000";"start";(getenv `LOGDIR),"processlogs/rdb1.log");.Q.opt .z.x]),.Q.opt[.z.x] ;
upd:{[t;x]  .log.write "Update recieved for table: ",string t ; 
            t upsert x } ;

init:{[parms]
  .log.getHandle[parms[`log]] ;
  .log.write "Initializing RDB.." ;
  .log.write "Connecting to TP.." ;
  handle::(hopen `$raze (":localhost:"),(parms[`tpPort])) ;
  .u.rep .({handle(`.u.sub;x;`)} each `$parms[`tables];handle(`.u.i);handle(`.u.L )) ; } 

/ get the ticker plant and history ports, defaults are 5010,5012
/.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!z};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
/.u.rep .({handle(`.u.sub;x;`)} each `$parms[`tables];handle(`.u.i);handle(`.u.L ));

if[all parms[`action] like "START"; 
   system raze ("p "),parms[`port];
   system raze ("l "),((getenv`BASEDIR),"scripts/q/logger.q");
   init[parms];];

