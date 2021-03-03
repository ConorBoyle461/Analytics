/ q tick.q sym . -p 5001 </dev/null >foo 2>&1 &
/q tick.q SRC [DST] [-p 5010] [-o h]
parms:1#.q;
parms:(.Q.def[`schema`tpLog`port`action!("config/advancedKdb/schema.q";"tpLog";"5000";"start");.Q.opt .z.x]),.Q.opt[.z.x];
if[all parms[`action] like "START";
  system"l ",parms[`schema]];

if[all parms[`action] like "START";
  system raze ("p "),parms[`port]];

\d .u
getLogHandle:{[parms;date]
      .[L;();:;()];           /Opening the tp log up from the file name as a list?
      i::j::-11!(-2;L);      /
      if[0<=type i;-2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";exit 1];
     / .log.getHandle[parms[`logFile]];
      hopen L };

tick:{[parms]
	init[];
	@[;`sym;`g#] each t ;
	d::.z.D ;
	if[not `l in key .u;                                   /Checking if there is a log handle already open
	   L:: hsym `$ raze parms[`tpLog],"tp_",string d;    /TP log filenname
           l::getLogHandle[parms;] d] ; 					/Assign a hande for tp log file 
	}

endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};

init:{w::t!(count t::tables`.)#()}

del:{w[x]_:w[x;;0]?y};.z.pc:{del[;x]each t};

sel:{$[`~y;x;select from x where sym in y]}

pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each w t}

add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])}

sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}

end:{(neg union/[w[;;0]])@\:(`.u.end;x)}

ts:{ if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};

/if[system"t";
/ .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
/ upd:{[t;x]
/ if[not -16=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
/ t insert x;if[l;l enlist (`upd;t;x);j+:1];}];

if[not system"t";system"t 60000";
 .z.ts:{ts .z.D};
 upd:{[t;x]ts"d"$a:.z.P;
   datatypes:exec t from meta t;
   if[not (datatypes~(exec t from meta x));'datatype_mismatch];
   .u.pub[t;x];
   if[l;l enlist (`upd;t;x);i+:1];}];

\d .
.u.tick[parms];

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
