/*
drop table if exists tmp_groupauthoritylockdownperiod;
select gap.id,
      gap.modifieddate,
       gap.organizationid,
       o.organizationname,
       gap.fromdate,
       gap.todate ,
       gap.fromdate  + case when o.displayidentifier in ('NH','NJ','WA','VT','NY','BIE-Miccosukee','WV') then '4 hours'   --Need to change here using existing values 
                           when o.displayidentifier in ('CO','UT') then '6 hours'
                            else   INTERVAL '5 hours' end fromdate_GMT,
       gap.todate       +case when o.displayidentifier in ('NH','NJ','WA','VT','NY','BIE-Miccosukee','WV') then '4 hours' --Need to change here using existing values 
                           when o.displayidentifier in ('CO','UT') then '6 hours'
                            else   INTERVAL '5 hours' end todate_GMT,
       gap.createddate
       -- into temp tmp_groupauthoritylockdownperiod
     from groupauthoritylockdownperiod gap
       left outer join organization o on gap.organizationid=o.id 
       where o.activeflag is true
       order by 2 ;
\COPY (select * from tmp_groupauthoritylockdownperiod) To 'tmp_groupauthoritylockdownperiod_03142016.csv' DELIMITER '|' CSV HEADER;
*/
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 row_count integer;
BEGIN
now_date :=now();
with update_count as 
	(
	update groupauthoritylockdownperiod gap
	 set    modifieduser=12,
	        modifieddate=now_date,
	        fromdate =gap.fromdate  + case when o.displayidentifier in ('NH','NJ','WA','VT','NY','BIE-Miccosukee','WV') then '4 hours'  
                           when o.displayidentifier in ('CO','UT') then '6 hours'
                            else   INTERVAL '5 hours' end,
                todate=gap.todate       +case when o.displayidentifier in ('NH','NJ','WA','VT','NY','BIE-Miccosukee','WV') then '4 hours' 
                           when o.displayidentifier in ('CO','UT') then '6 hours'
                            else   INTERVAL '5 hours' end
	  from organization o
	  where gap.organizationid=o.id and o.activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated groupauthoritylockdownperiod : %' , row_count;		   
END;
$BODY$;

  
