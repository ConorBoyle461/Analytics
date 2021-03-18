\d .log

info:{memstats:string .Q.w[] ;raze (string `datetime$.z.p;" ";string .z.u;"@";string .z.h;" [";memstats[`used];"/";memstats[`heap];"/";memstats[`peak];"/";memstats[`wmax];"/";memstats[`mmap];"/";memstats[`mphy];"/";memstats[`syms];"/";memstats[`syms];"] ")}

stdout:{-1 .log.write x}

stderr:{-2 .log.write x}

write:{(neg .log.logHandle) .log.info[], x }

getHandle:{.log.logHandle:hopen .log.logFile:`$raze ":",x}

.z.po:{.log.write "Connection opened on handle: ", string x}  

.z.pc:{.log.write "Connection closed on handle:" ,string x}
\d .
