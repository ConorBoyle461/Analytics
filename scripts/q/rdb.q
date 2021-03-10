/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];
parms:1#.q ; 
parms:(.Q.def[`tpPort`action!("localhost:5000";"start");.Q.opt .z.x]),.Q.opt[.z.x];
upd:{[t;x]  t upsert x };

if[all parms[`action] like "START";
  system raze ("p "),parms[`port]];

handle::(hopen `$raze (":localhost:"),(parms[`tpPort]))   /Assuming rdb is running on local host

/ get the ticker plant and history ports, defaults are 5010,5012
/.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!z};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .({handle(`.u.sub;x;`)} each `$parms[`tables];handle(`.u.i);handle(`.u.L ));
