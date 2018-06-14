--- *** good with this script *** ---
-- Rajendra ::: validate and the updates requested in this file are good. 
-- Rajendra ::: We will discuss about the point of execution of this updates in this entire update process. 
-- Rajendra ::: Probably after updating the include science flag & allquestionsflag update.
-- Find inactive responseid and need to mergeid with active one's
select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=12
and (sr.activeflag is false or responseorder =2)
order by 1,3;
--  labelnumber |              responsevalue               | responseorder | id  | activeflag
-- -------------+------------------------------------------+---------------+-----+------------
--  Q511        | 0% (student does not exhibit this skill) |             1 |  67 | f
--  Q511        | Almost never (0% - 20% of the time)      |             2 |  68 | t
--  Q512        | 0% (student does not exhibit this skill) |             1 |  72 | f
--  Q512        | None to 20% of the time                  |             2 |  73 | t
--  Q513        | 0% (student does not exhibit this skill) |             1 |  77 | f
--  Q513        | None to 20% of the time                  |             2 |  78 | t
--  Q514        | 0% (student does not exhibit this skill) |             1 |  82 | f
--  Q514        | None to 20% of the time                  |             2 |  83 | t
--  Q515        | 0% (student does not exhibit this skill) |             1 |  87 | f
--  Q515        | None to 20% of the time                  |             2 |  88 | t
--  Q516        | 0% (student does not exhibit this skill) |             1 |  92 | f
--  Q516        | None to 20% of the time                  |             2 |  93 | t
--  Q517        | 0% (student does not exhibit this skill) |             1 |  97 | f
--  Q517        | None to 20% of the time                  |             2 |  98 | t
--  Q518        | 0% (student does not exhibit this skill) |             1 | 102 | f
--  Q518        | None to 20% of the time                  |             2 | 103 | t
-- (16 rows)

-- page12: find the student responses with inactive surveyresponse
-- validation
select surveyresponseid,count(*) from studentsurveyresponse ssr 
where ssr.activeflag is true 
and surveyresponseid in (select sr.id
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=12
and sr.activeflag is false)
group by surveyresponseid;
--  surveyresponseid | count
-- ------------------+-------
--                77 |     5
--                92 |    10
--                82 |     6
--                97 |    13
--                67 |     4
--                87 |     6
--               102 |    14
--                72 |     7
-- (8 rows)

select surveyresponseid,count(*) from studentsurveyresponse ssr 
where ssr.activeflag is true 
and surveyresponseid in (select sr.id
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=12
and sr.activeflag is false) and responsetext is not null 
group by surveyresponseid;

-- Rajendra ::: We are good with this update for page 12. (Can we have the same update for pages 10 & 14 also?)
-- Rajendra ::: Also need to check if the page has all questions answered then need to update iscompleted flag to true for these pages.
-- need to set active response id for inactive response and ignore if active one already true 
begin;
update studentsurveyresponse set surveyresponseid=68,modifieddate=now(),modifieduser=12 where surveyresponseid=67 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=68 and activeflag is true);

update studentsurveyresponse set surveyresponseid=73,modifieddate=now(),modifieduser=12 where surveyresponseid=72 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=73 and activeflag is true);

update studentsurveyresponse set surveyresponseid=78,modifieddate=now(),modifieduser=12 where surveyresponseid=77 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=78 and activeflag is true);

update studentsurveyresponse set surveyresponseid=83,modifieddate=now(),modifieduser=12 where surveyresponseid=82 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=83 and activeflag is true);

update studentsurveyresponse set surveyresponseid=88,modifieddate=now(),modifieduser=12 where surveyresponseid=87 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=88 and activeflag is true);

update studentsurveyresponse set surveyresponseid=93,modifieddate=now(),modifieduser=12 where surveyresponseid=92 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=93 and activeflag is true);

update studentsurveyresponse set surveyresponseid=98,modifieddate=now(),modifieduser=12 where surveyresponseid=97 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=98 and activeflag is true);

update studentsurveyresponse set surveyresponseid=103,modifieddate=now(),modifieduser=12 where surveyresponseid=102 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=103 and activeflag is true);

commit;

-- datateam ::: above script executed on stage

-- UPDATE 3
-- UPDATE 5
-- UPDATE 4
-- UPDATE 5
-- UPDATE 5
-- UPDATE 5
-- UPDATE 6
-- UPDATE 9


-- need to inactivate for inactive if active one already true 
-- Rajenndra ::: Does the above script nullify the results for the below update queries?
begin;
update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=67 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=68 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=72 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=73 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=77 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=78 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=82 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=83 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=87 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=88 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=92 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=93 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=97 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=98 and activeflag is true);

update studentsurveyresponse set activeflag=false,modifieddate=now(),modifieduser=12 where surveyresponseid=102 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=103 and activeflag is true);

commit;
-- datateam ::: above script executed on stage
-- UPDATE 1
-- UPDATE 2
-- UPDATE 1
-- UPDATE 1
-- UPDATE 1
-- UPDATE 5
-- UPDATE 7
-- UPDATE 5


-- validation after update
select surveyresponseid,count(*) from studentsurveyresponse ssr 
where ssr.activeflag is true 
and surveyresponseid in (select sr.id
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=12
and sr.activeflag is false)
group by surveyresponseid;
------------------------------------------------------------------------------------------------------------------------

-- trying to find out same this on different page
select globalpagenum,count(*) from studentsurveyresponse ssr
inner join (select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag,globalpagenum
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where sr.activeflag is false) tmp on ssr.surveyresponseid=tmp.id
and ssr.activeflag is true
group by globalpagenum;
-- globalpagenum | count
-- ---------------+-------
--             14 |   122
--             12 |    65
--              1 |    31
--             10 |    16
--              2 |    29
-- (5 rows)
-- Rajendra ::: We need updates for 14, 10 and 12
--page 2:
select globalpagenum,tmp.id,count(*) from studentsurveyresponse ssr
inner join (select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag,globalpagenum
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where sr.activeflag is false) tmp on ssr.surveyresponseid=tmp.id
and ssr.activeflag is true and globalpagenum=2
group by globalpagenum,tmp.id
order by 1;
--  globalpagenum | id  | count
-- ---------------+-----+-------
--              2 | 386 |    29
-- (1 row)


select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=2 and labelnumber='Q19'
--and (sr.activeflag is false)
order by 1,3;

--  labelnumber |                 responsevalue                 | responseorder | id  | activeflag
-- -------------+-----------------------------------------------+---------------+-----+------------
--  Q19         | No known hearing loss                         |             1 | 386 | f
--  Q19         | Deaf or hard of hearing                       |             2 | 387 | t
--  Q19         | No hearing loss suspected/documented          |             3 | 426 | t
--  Q19         | Questionable hearing but testing inconclusive |             4 | 427 | t
-- (4 rows)
-- need verify with scriptbee: please notify if we need to update 386 to 426
-- Rajendra ::: Yes we need to update if there is any active studentsurvey response with 386. 
-- Rajendra ::: Confirm if the surveypagestatus iscomleted update will be done after this update
---------------------------------------------------------------------------------------------------------
-- please uncomment if you want to run this.
/*
begin;
update studentsurveyresponse set surveyresponseid=426,modifieddate=now(),modifieduser=12 where surveyresponseid=386 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=426 and activeflag is true);
commit;

-- need to inactivate for inactive if active one already true 
begin;
update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=386 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=426 and activeflag is true);
commit;
*/
--page 1:
select globalpagenum,tmp.id,count(*) from studentsurveyresponse ssr
inner join (select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag,globalpagenum
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where sr.activeflag is false) tmp on ssr.surveyresponseid=tmp.id
and ssr.activeflag is true and globalpagenum=1
group by globalpagenum,tmp.id
order by 1;
-- globalpagenum | id  | count
-- ---------------+-----+-------
--              1 | 336 |     1
--              1 | 337 |     9
--              1 | 338 |    21
-- (3 rows)



select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=1 and labelnumber='Q17'
--and (sr.activeflag is false)
order by 1,3;

--  labelnumber |                                                                                                              responsevalue
--                                                           | responseorder | id  | activeflag
-- -------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------+---------------+-----+------------
--  Q17         | Regular Class: includes students who receive the majority of their education program in a regular classroom and receive special education and related services outside the reg
-- ular classroom for less than 21 percent of the school day |             1 | 336 | f
--  Q17         | Resource Room: includes students who receive special education and related services outside of the regular classroom for at least 21 percent but no more than 60 percent of th
-- e school day                                              |             2 | 337 | f
--  Q17         | Separate Class: includes students who receive special education and related services outside the regular class for more than 60 percent of the school day
--                                                           |             3 | 338 | f
--  Q17         | Separate School: Includes public or private separate day school for students with disabilities, at public school expense
--                                                           |             4 | 339 | t
--  Q17         | Residential Facility: Includes public or private separate residential school for students with disabilities, at public school expense
--                                                           |             5 | 340 | t
--  Q17         | Homebound/Hospital Environment: Includes students placed in and receiving special education in a hospital or homebound program
--                                                           |             6 | 341 | t
--  Q17         | 80% or more of the day in Regular Class
--                                                           |             7 | 423 | t
--  Q17         | 40% - 79% of the day in Regular Class
--                                                           |             8 | 424 | t
--  Q17         | Less than 40% of the day in Regular Class
--                                                           |             9 | 425 | t
-- need verify with scriptbee: please notify if we need to update 336 to 425 --special note ( trying to match 1/3=1/4)
-- need verify with scriptbee: please notify if we need to update 337 to 424 
-- need verify with scriptbee: please notify if we need to update 338 to 423
-- Rajendra ::: Yes we need to update the existing active studentsurveyresponses for 336,337 and 338. 
-- Rajendra ::: Please make sure that surveypagestatus iscompleted is updated after this update
-- uncomment if you want to run this.
/*
begin;
update studentsurveyresponse set surveyresponseid=425,modifieddate=now(),modifieduser=12 where surveyresponseid=336 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=425 and activeflag is true);

update studentsurveyresponse set surveyresponseid=424,modifieddate=now(),modifieduser=12 where surveyresponseid=337 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=424 and activeflag is true);

update studentsurveyresponse set surveyresponseid=423,modifieddate=now(),modifieduser=12 where surveyresponseid=338 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=423 and activeflag is true);

commit;


-- need to inactivate for inactive if active one already true 
begin;
update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=336 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=425 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=337 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=424 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=338 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=423 and activeflag is true);

commit;


*/
--page 10:
select globalpagenum,tmp.id,count(*) from studentsurveyresponse ssr
inner join (select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag,globalpagenum
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where sr.activeflag is false) tmp on ssr.surveyresponseid=tmp.id
and ssr.activeflag is true and globalpagenum=10
group by globalpagenum,tmp.id
order by 1;
--  globalpagenum | id | count
-- ---------------+----+-------
--             10 | 37 |     1
--             10 | 42 |     1
--             10 | 47 |     3
--             10 | 52 |     2
--             10 | 57 |     3
--             10 | 62 |     6
-- (6 rows)


select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=10 and responseorder in (1,2)
--and (sr.activeflag is false)
order by 1,3;


--  labelnumber |              responsevalue               | responseorder | id | activeflag
-- -------------+------------------------------------------+---------------+----+------------
--  Q491        | 0% (student does not exhibit this skill) |             1 | 37 | f
--  Q491        | Almost never (0% - 20% of the time)      |             2 | 38 | t
--  Q492        | 0% (student does not exhibit this skill) |             1 | 42 | f
--  Q492        | 1% to 20% of the time                    |             2 | 43 | t
--  Q493        | 0% (student does not exhibit this skill) |             1 | 47 | f
--  Q493        | 1% to 20% of the time                    |             2 | 48 | t
--  Q494        | 0% (student does not exhibit this skill) |             1 | 52 | f
--  Q494        | 1% to 20% of the time                    |             2 | 53 | t
--  Q495        | 0% (student does not exhibit this skill) |             1 | 57 | f
--  Q495        | 1% to 20% of the time                    |             2 | 58 | t
--  Q496        | 0% (student does not exhibit this skill) |             1 | 62 | f
--  Q496        | 1% to 20% of the time                    |             2 | 63 | t
-- (12 rows)
-- need verify with scriptbee: please notify if we need to update 37 to 38 and (all 6 inactivated to activated)
-- Rajendra ::: Yes we need to update this. Also iscompleted flag of surveypagestatus.
-- need to set active response id for inactive response and ignore if active one already true 
begin;
update studentsurveyresponse set surveyresponseid=38,modifieddate=now(),modifieduser=12 where surveyresponseid=37 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=38 and activeflag is true);

update studentsurveyresponse set surveyresponseid=43,modifieddate=now(),modifieduser=12 where surveyresponseid=42 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=43 and activeflag is true);

update studentsurveyresponse set surveyresponseid=48,modifieddate=now(),modifieduser=12 where surveyresponseid=47 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=48 and activeflag is true);

update studentsurveyresponse set surveyresponseid=53,modifieddate=now(),modifieduser=12 where surveyresponseid=52 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=53 and activeflag is true);

update studentsurveyresponse set surveyresponseid=58,modifieddate=now(),modifieduser=12 where surveyresponseid=57 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=58 and activeflag is true);

update studentsurveyresponse set surveyresponseid=63,modifieddate=now(),modifieduser=12 where surveyresponseid=62 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=63 and activeflag is true);
commit;
-- datateam ::: above script executed on stage
-- UPDATE 1
-- UPDATE 1
-- UPDATE 2
-- UPDATE 2
-- UPDATE 2
-- UPDATE 5
-- need to inactivate for inactive if active one already true 
begin;
update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=37 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=38 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=42 and activeflag is true 
and surveyid in ( select surveyid from studentsurveyresponse where surveyresponseid=43 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=47 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=48 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=52 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=53 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=57 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=58 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=62 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=63 and activeflag is true);
commit;
-- datateam ::: above script executed on stage
-- UPDATE 0
-- UPDATE 0
-- UPDATE 1
-- UPDATE 0
-- UPDATE 1
-- UPDATE 1

-- validation after update
select surveyresponseid,count(*) from studentsurveyresponse ssr 
where ssr.activeflag is true 
and surveyresponseid in (select sr.id
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=10
and sr.activeflag is false)
group by surveyresponseid;
---------------------------------------------------------------------------------------------------------
--page 14:
select globalpagenum,tmp.id,count(*) from studentsurveyresponse ssr
inner join (select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag,globalpagenum
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where sr.activeflag is false) tmp on ssr.surveyresponseid=tmp.id
and ssr.activeflag is true and globalpagenum=14
group by globalpagenum,tmp.id
order by 1;
--  globalpagenum | id  | count
-- ---------------+-----+-------
--             14 | 173 |     8
--             14 | 143 |    18
--             14 | 133 |     6
--             14 | 168 |     9
--             14 | 158 |    11
--             14 | 113 |     3
--             14 | 118 |     2
--             14 | 128 |     6
--             14 | 163 |     7
--             14 | 138 |     6
--             14 | 148 |    17
--             14 | 153 |    25
--             14 | 123 |     4
-- (13 rows)




select labelnumber,responsevalue,responseorder,sr.id,sr.activeflag
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.labelnumber in ( select distinct labelnumber
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=14 --and responseorder in (1,2)
and (sr.activeflag is false)) and responseorder in (1,2)
order by 1,3;


 -- labelnumber |              responsevalue               | responseorder | id  | activeflag
-- -------------+------------------------------------------+---------------+-----+------------
--  Q541        | 0% (student does not exhibit this skill) |             1 | 113 | f
--  Q541        | Almost never (0% - 20% of the time)      |             2 | 114 | t
--  Q5410       | 0% (student does not exhibit this skill) |             1 | 158 | f
--  Q5410       | None to 20% of the time                  |             2 | 159 | t
--  Q5411       | 0% (student does not exhibit this skill) |             1 | 163 | f
--  Q5411       | None to 20% of the time                  |             2 | 164 | t
--  Q5412       | 0% (student does not exhibit this skill) |             1 | 168 | f
--  Q5412       | None to 20% of the time                  |             2 | 169 | t
--  Q5413       | 0% (student does not exhibit this skill) |             1 | 173 | f
--  Q5413       | None to 20% of the time                  |             2 | 174 | t
--  Q542        | 0% (student does not exhibit this skill) |             1 | 118 | f
--  Q542        | None to 20% of the time                  |             2 | 119 | t
--  Q543        | 0% (student does not exhibit this skill) |             1 | 123 | f
--  Q543        | None to 20% of the time                  |             2 | 124 | t
--  Q544        | 0% (student does not exhibit this skill) |             1 | 128 | f
--  Q544        | None to 20% of the time                  |             2 | 129 | t
--  Q545        | 0% (student does not exhibit this skill) |             1 | 133 | f
--  Q545        | None to 20% of the time                  |             2 | 134 | t
--  Q546        | 0% (student does not exhibit this skill) |             1 | 138 | f
--  Q546        | None to 20% of the time                  |             2 | 139 | t
--  Q547        | 0% (student does not exhibit this skill) |             1 | 143 | f
--  Q547        | None to 20% of the time                  |             2 | 144 | t
--  Q548        | 0% (student does not exhibit this skill) |             1 | 148 | f
--  Q548        | None to 20% of the time                  |             2 | 149 | t
--  Q549        | 0% (student does not exhibit this skill) |             1 | 153 | f
--  Q549        | None to 20% of the time                  |             2 | 154 | t



-- need verify with scriptbee: please notify if we need to update 113 to 114 and (all 13 inactivated to activated)
-- need to set active response id for inactive response and ignore if active one already true 
begin;
update studentsurveyresponse set surveyresponseid=114,modifieddate=now(),modifieduser=12 where surveyresponseid=113 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=114 and activeflag is true);

update studentsurveyresponse set surveyresponseid=159,modifieddate=now(),modifieduser=12 where surveyresponseid=158 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=159 and activeflag is true);

update studentsurveyresponse set surveyresponseid=164,modifieddate=now(),modifieduser=12 where surveyresponseid=163 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=164 and activeflag is true);

update studentsurveyresponse set surveyresponseid=169,modifieddate=now(),modifieduser=12 where surveyresponseid=168 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=169 and activeflag is true);

update studentsurveyresponse set surveyresponseid=174,modifieddate=now(),modifieduser=12 where surveyresponseid=173 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=174 and activeflag is true);

update studentsurveyresponse set surveyresponseid=119,modifieddate=now(),modifieduser=12 where surveyresponseid=118 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=119 and activeflag is true);

update studentsurveyresponse set surveyresponseid=124,modifieddate=now(),modifieduser=12 where surveyresponseid=123 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=124 and activeflag is true);

update studentsurveyresponse set surveyresponseid=129,modifieddate=now(),modifieduser=12 where surveyresponseid=128 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=129 and activeflag is true);

update studentsurveyresponse set surveyresponseid=134,modifieddate=now(),modifieduser=12 where surveyresponseid=133 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=134 and activeflag is true);

update studentsurveyresponse set surveyresponseid=139,modifieddate=now(),modifieduser=12 where surveyresponseid=138 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=139 and activeflag is true);

update studentsurveyresponse set surveyresponseid=144,modifieddate=now(),modifieduser=12 where surveyresponseid=143 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=144 and activeflag is true);

update studentsurveyresponse set surveyresponseid=149,modifieddate=now(),modifieduser=12 where surveyresponseid=148 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=149 and activeflag is true);

update studentsurveyresponse set surveyresponseid=154,modifieddate=now(),modifieduser=12 where surveyresponseid=153 and activeflag is true 
and surveyid not in ( select surveyid from studentsurveyresponse where surveyresponseid=154 and activeflag is true);

commit;
-- datateam ::: above script executed on stage
-- UPDATE 3
-- UPDATE 8
-- UPDATE 5
-- UPDATE 6
-- UPDATE 8
-- UPDATE 1
-- UPDATE 3
-- UPDATE 5
-- UPDATE 5
-- UPDATE 5
-- UPDATE 11
-- UPDATE 11
-- UPDATE 16

-- need to inactivate for inactive if active one already true 
begin;
update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=113 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=114 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=158 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=159 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=163 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=164 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=168 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=169 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=173 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=174 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=118 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=119 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=123 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=124 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=128 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=129 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=133 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=134 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=138 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=139 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=143 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=144 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=148 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=149 and activeflag is true);

update studentsurveyresponse set activeflag = false,modifieddate=now(),modifieduser=12 where surveyresponseid=153 and activeflag is true 
and surveyid  in ( select surveyid from studentsurveyresponse where surveyresponseid=154 and activeflag is true);

commit;
-- datateam ::: above script executed on stage
-- UPDATE 0
-- UPDATE 3
-- UPDATE 2
-- UPDATE 4
-- UPDATE 1
-- UPDATE 1
-- UPDATE 1
-- UPDATE 1
-- UPDATE 1
-- UPDATE 1
-- UPDATE 8
-- UPDATE 8
-- UPDATE 10

-- validation after update
select surveyresponseid,count(*) from studentsurveyresponse ssr 
where ssr.activeflag is true 
and surveyresponseid in (select sr.id
from surveylabel  sl 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=14
and sr.activeflag is false)
group by surveyresponseid;

---------------------------------------------------------------------------------------------------------


-- Special note : if validation 6 done. Then we are 100% ready to inactivate student responses for inactive responses and questions.
-- need verify with scriptbee: please notify if we need to update 113 to 114 and (all 13 inactivated to activated)
-- should be zero after the above update
select globalpagenum,count(*) from studentsurveyresponse ssr 
inner join surveyresponse sr on ssr.surveyresponseid = sr.id 
inner join surveylabel sl on sr.labelid = sl.id 
where ssr.activeflag is true and sr.activeflag is false
group by globalpagenum;


-- Rajendra : This is good to execute. This need to be executed only on stage. 
--need verify with scriptbee about this do we need set studentsurveyresponse to false
 select sp.globalpagenum,count(*)
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 
 and ssr.activeflag is true and sl.activeflag is false    
 group by sp.globalpagenum;

-- │ globalpagenum │ count │
-- ├───────────────┼───────┤
-- │            14 │ 36072 │
-- │             4 │   251 │
-- │             6 │   635 │
-- │             3 │   207 │
-- │            13 │   106 │
-- │             5 │     3 │
-- └───────────────┴───────┘


