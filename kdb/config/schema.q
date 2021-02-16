quote:([]time:`timespan$();sym:`g#`symbol$();bid:`float$();ask:`float$(); bsize:`int$();asize:`int$());
trade:([]time:`timespan$();sym:`symbol$();price:`float$();size:`int$());
aggregation:`time`sym`max_price`min_price`volume xcols 0!select time,max_price:max price, min_price:min price, volume: sum size  by sym from trade ;
