quote:([]time:"n"$(); sym:`symbol$();bid:`float$();ask:`float$(); bsize:`int$();asize:`int$());
trade:([]time:"n"$(); sym:`symbol$();price:`float$();size:`int$());
aggregation:([]time:"n"$(); sym:`symbol$() ; max_price:`float$() ; min_price: `float$(); volume:`int$() )
/ commenting these out aggregation:`time`sym`max_price`min_price`volume xcols 0!select time:"n"$time, max_price:max price,min_price:min price, volume: sum size  by sym from trade ;
