--validation 

-- find the correct response has 0 score 
--ep
select distinct tv.id,tv.externalid from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
where tt.code in ('MC-K','T-F')  and coalesce(tvf.responsescore,0)=0 and tvf.correctresponse=true;

--CB
select tv.status ,count(distinct tv.taskvariantid)
from cb.taskvariant tv 
inner join organization_ o on o.organizationid=tv.organizationid
inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
inner join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
inner join cb.systemrecord stt on stt.id=tt.systemrecordid  and stt.inuse is true
inner join cb.taskvariantresponse tvs  on tvs.taskvariantid=tv.taskvariantid 
where tvs.correctresponse is true and coalesce(responsescore,0)=0 and stt.abbreviation in ('MC-K','T-F')
group by tv.status;

-- Find the level 4 for dlm
  select distinct cf.contentframeworkid,testspecificationid,o.name,cfd.contentcode,fl.level 
  from cb.contentframework cf 
  inner join cb.contentframeworkdetail cfd on cfd.contentframeworkid=cf.contentframeworkid 
  inner join cb.frameworklevel fl on fl.frameworklevelid=cfd.frameworklevelid
  inner join cb.testspecification tc on tc.contentframeworkid=cfd.contentframeworkid and cf.organizationid=tc.organizationid
  inner join organization_ o on cf.organizationid=o.organizationid
   where fl.level in (4,5) and cf.organizationid = 12508 -- and testspecificationid=2117
  and cf.frameworktypeid in (select frameworktypeid from cb.organizationlmframeworktype);




  select distinct cf.contentframeworkid,testspecificationid,o.name,cfd.contentcode,fl.level 
  from cb.contentframework cf 
  inner join cb.contentframeworkdetail cfd on cfd.contentframeworkid=cf.contentframeworkid 
  inner join cb.frameworklevel fl on fl.frameworklevelid=cfd.frameworklevelid
  inner join cb.testspecification tc on tc.contentframeworkid=cfd.contentframeworkid and cf.organizationid=tc.organizationid
  inner join organization_ o on cf.organizationid=o.organizationid
   where fl.level in (4,5) and cf.organizationid = 12508 -- and testspecificationid=2117
  and cf.frameworktypeid in (select frameworktypeid from cb.organizationlmframeworktype);




select distinct tv.taskvariantid
from cb.taskvariant tv 
   inner join organization_ o on o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
    join cb.taskcontentframeworkdetails tfd on tfd.taskid=t.taskid and o.organizationid=tfd.organizationid
    join cb.contentframeworkdetail cfd on tfd.contentframeworkdetailid=cfd.contentframeworkdetailid 
    join cb.contentframework cf on cf.contentframeworkid=cfd.contentframeworkid 
    join cb.organizationlmframeworktype cfo on cfo.frameworktypeid=cf.frameworktypeid
   join cb.contentarea ca on t.contentareaid=ca.contentareaid and o.organizationid=ca.organizationid and ca.inuse is true
   where ca.contentareaid=42; 

select * from studentsresponses where studentid  in ( 348526,
567505,
649842,
1052832,
1053060,
1341965) and taskvariantid in (select id from taskvariant where externalid =300);

   



select count(distinct externalid) from taskvariant 
where externalid in (68339
,68385
,68343
,68353
,68366
,68361
,68377
,68382
,68348
,68387
,68380
,68384
,68378
,68340
,68372
,68359
,68365
,68346
,68367
,68345
,68374
,68373
,68354
,68344
,68383
,68379
,68375
,68370
,68363
,68360
,68349
,68347
,68368
,68381
,68362
,68352
,68369
,68386
,68364
,68371
,68358
,68122
,68376);
