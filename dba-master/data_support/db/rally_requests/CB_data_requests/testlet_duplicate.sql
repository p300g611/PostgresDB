--5049,8760,8284,6038,8560,5307,5042,5889,4253,13650,10938,11384,10564,10464,10320,13626,10894,13596)
--13615,10795,13639,11379
--10521,13644,10499,13631,13627

-- \copy (select * from cb.testletmediavariant) to 'testletmediavariant_prod_before.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--validation
select * from (
  SELECT testletid, mediavariantid, sortorder, groupnumber, testletmediavariantid, 
       version, testletmediaversion, testletmediavariantversion,
  ROW_NUMBER() OVER(PARTITION BY testletid, mediavariantid, sortorder, groupnumber ORDER BY testletid, mediavariantid, sortorder, groupnumber asc) AS Row
  FROM cb.testletmediavariant 
) dups
where 
dups.Row > 1 and testletid in(5049,8760,8284,6038,8560,5307,5042,5889,4253,13650,10938,11384,10564,10464,10320,13626,10894,13596,13615,10795,13639,11379,10521,13644,10499,13631,13627); 


--Delete the duplicate records
delete from cb.testletmediavariant  where testletmediavariantid in(select testletmediavariantid from (
  SELECT testletid, mediavariantid, sortorder, groupnumber, testletmediavariantid, 
       version, testletmediaversion, testletmediavariantversion,
  ROW_NUMBER() OVER(PARTITION BY testletid, mediavariantid, sortorder, groupnumber ORDER BY testletid, mediavariantid, sortorder, groupnumber asc) AS Row
  FROM cb.testletmediavariant
) dups
where 
dups.Row > 1 and testletid in(5049,8760,8284,6038,8560,5307,5042,5889,4253,13650,10938,11384,10564,10464,10320,13626,10894,13596,13615,10795,13639,11379,10521,13644,10499,13631,13627));