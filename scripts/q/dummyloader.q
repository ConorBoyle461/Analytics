parms:1#.q;
parms:(.Q.def[`logFile`tpPort`action`user!("feedhandlerProcessLog.txt";"5000";"START";string .z.u);.Q.opt .z.x]),.Q.opt[.z.x];
h:neg hopen `$raze (":localhost:"),(parms[`tpPort]) ; /connect to tickerplant 
syms:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L`TSLA.A  /stocks
prices:syms!45.15 191.10 178.50 128.04 341.30 600.20 /starting prices 
n:2 /number of rows per update
flag:1 /generate 10% of updates for trade and 90% for quote
getmovement:{[s] rand[0.0001]*prices[s]} /get a random price movement 
/generate trade price
getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]} 
getbid:{[s] prices[s]-getmovement[s]} /generate bid price
getask:{[s] prices[s]+getmovement[s]} /generate ask price
/timer function
if[first parms[`action] like "START";
  .z.ts:{sendDummyRecord[h]}
  ]

/trigger timer every 100ms


sendDummyRecord:{[h]
  s:n?syms;
  $[0<flag mod 10;
    h(".u.upd";`quote;flip `time`sym`bid`ask`bsize`asize!"nsffii"$(n#.z.N;s;getbid'[s];getask'[s];n?1000;n?1000));
    h(".u.upd";`trade;flip `time`sym`price`size!"nsfi"$(n#.z.N;s;getprice'[s];n?1000))];
  flag+:1;}

\t 100
