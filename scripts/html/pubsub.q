
.z.ws:{value x};
.z.wc: {delete from `subscriptions where handle=x};

/Load in tables from dir
load `:trade ;
load `:quote ;


/* subs table to keep track of current subscriptions */
subscriptions:flip `handle`func!"i*"$\:();

/* functions to be called through WebSocket */
loadPage:{ getSyms[.z.w]; subscribe[`getQuotes]; subscribe[`getTrades];};
filterSyms:{ subscribe[`getQuotes;x];subscribe[`getTrades;x]};

getSyms:{ (neg[x]) .j.j `func`result!(`getSyms;distinct (quote`sym),trade`sym)};

getQuotes:{
  filter:$[all raze null x;distinct quote`sym;raze x];
  res: 0!select last bid,last ask by sym,last time from quote where sym in filter;
  `func`result!(`getQuotes;res)};

getTrades:{
  filter:$[all raze null x;distinct trade`sym;raze x];
  res: 0!select last price,last size by sym,last time from trade where sym in filter;
  `func`result!(`getTrades;res)};

/*subscribe to something */
subscribe:{`subscriptions upsert(.z.w;x)};

/*publish data according to subs table */
pub:{
  row:(0!subscriptions)[x];
  (neg row[`handle]) .j.j (value row[`message])[row[`params]]
  };

/* trigger refresh every 100ms */
.z.ts:{pub each til count subscriptions};
\t 1000
