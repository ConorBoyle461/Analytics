/ q tick.q sym . -p 5001 </dev/null >foo 2>&1 &
/q tick.q SRC [DST] [-p 5010] [-o h]
parms:1#.q;
parms:(.Q.def[`schema`logFile`tpLog`port`action!("sym";"tpProcessLog.txt";"tpLog/tp_";"5000";"start");.Q.opt .z.x]),.Q.opt[.z.x];
if[all parms[`action] like "start";system"l ",src:$[0h~type parms[`schema];raze parms[`schema];"tick/sym"],".q"];

if[all parms[`action] like "start";system raze ("p "),parms[`port]] ;

.Q.l `:CryptoAnalytics/kdb/scripts/u.q ;   /This is hacky but I dont have time to spend on making this nice
\l `:./CryptoAnalytics/kdb/scripts/logger.q;				/Likewise as above

\d .u
ld:{if[not type key L::`$((parms[`tpLog]),string x);.[L;();:;()]];i::j::-11!(-2;L);if[0<=type i;-2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";exit 1];.log.getHandle get `.`parms`logFile;hopen L };

tick:{
	init[];
	@[;`sym;`g#] each t ;
	d::.z.D ;
	if[l::count y;L::`$":",y,"/",x,10#".";l::ld d] ; 
	.log.write "This is a test";
	}

endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};

ts:{ if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};

/if[system"t";
/ .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
/ upd:{[t;x]
/ if[not -16=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
/ t insert x;if[l;l enlist (`upd;t;x);j+:1];}];

if[not system"t";system"t 60000";
 .z.ts:{ts .z.D; .log.write "Heartbeat.." };
 upd:{[t;x]ts"d"$a:.z.P;
 if[not -16=type first first x;a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 f:key flip value t;tbl:flip f!x;.u.pub[t;tbl];if[l;l enlist (`upd;t;tbl);i+:1];}];

\d .
.u.tick[src;.z.x 1];

\
 globals used
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date
/test
>q tick.q
>q tick/ssl.q
/run
>q tick.q sym  .  -p 5010	/tick
>q tick/r.q :5010 -p 5011	/rdb
>q sym            -p 5012	/hdb
>q tick/ssl.q sym :5010		/feed
