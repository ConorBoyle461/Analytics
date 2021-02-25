parms:1#.q ;
parms:(.Q.def[(`oldlog`id`newlog)!(`;enlist "IBM.N";`:newlog);.Q.opt .z.x]),.Q.opt[.z.x] ;


oldLog:get first hsym `$parms[`oldlog];
func:{if[x[1]=`trade; 
	new_record:(x[0];x[1];select from x[2] where sym = first `$parms[`id]);
	if[0<count new_record[2];newLog,:enlist new_record]];
	}

func each oldLog ;

(first hsym `$parms[`newlog]) set newLog ;
exit 0 ;
