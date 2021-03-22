parms:1#.q;
parms:(.Q.def[`tpPort`action`csv!("5000";"LOAD";"");.Q.opt .z.x]),.Q.opt[.z.x];


typeMap:`time`sym`price`size`bid`ask`asize`bsize`max_price`min_price`volume!("NSFIFFIIFFI")
h:hopen `$raze (":localhost:"),(parms[`tpPort]) ; 

loadFunction:{[parms;h]
  fileHeader: system raze "head -1 ",parms[`csv] ;
  parseRule: typeMap `$"," vs raze fileHeader ;
  parsedTbl: (parseRule;enlist csv) 0: first hsym `$parms[`csv] ;
  if[not `time in cols parsedTbl;parsedTbl: `time xcols update time:.z.n from parsedTbl ];
  $[`price in cols parsedTbl;
    h(`.u.upd;`trade;parsedTbl);
    `ask in cols parsedTbl;
    h(`.u.upd;`quote;parsedTbl)];
	
  }


if[first parms[`action] like "LOAD"; loadFunction[parms;h];exit 0];

