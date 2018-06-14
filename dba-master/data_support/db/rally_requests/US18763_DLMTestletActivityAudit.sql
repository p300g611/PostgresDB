--CD Database cbdb1.#########
BEGIN;
select 
 tl.testletid,
 tl.name,
 tl.createdate,
 tl.createusername,
 tl.modifieddate,
 tl.modifiedusername,
 tv.taskvariantid,
 tv.taskid
 into temp tmp_dlm_testlet_info
   from cb.testlet tl
      left outer join cb.testlettaskvariant tlv on tl.testletid=tlv.testletid
      left outer join cb.taskvariant tv on tv.taskvariantid=tlv.taskvariantid
      where tl.testletid in (8646, 8653, 8662,4916);


\copy (SELECT * FROM tmp_dlm_testlet_info) TO 'tmp_dlm_testlet_info_05102016.csv' DELIMITER ',' CSV HEADER; 


select 
 tl.testletid,
 tl.name testletname,
 tl.createdate testletcreatedate,
 tl.createusername testletcreateusername,
 tl.modifieddate testletmodifieddate,
 tl.modifiedusername testletmodifiedusername,
 tv.taskvariantid,
 tv.name taskvariantname,
 tvr.taskvariantrevisionid,
 tvr.createdate taskvariantrevisioncreatedate,
 tvr.createusername taskvariantrevisioncreateusername,
 tvr.modifieddate taskvariantrevisionmodifieddate,
 tvr.modifiedusername taskvariantrevisionmodifiedusername,
 tv.taskid
 into temp tmp_dlm_taskvariant_info
   from cb.testlet tl
      left outer join cb.testlettaskvariant tlv on tl.testletid=tlv.testletid
      left outer join cb.taskvariant tv on tv.taskvariantid=tlv.taskvariantid
      left outer join cb.taskvariantrevision tvr on tvr.taskvariantid=tv.taskvariantid
      where tl.testletid in (8646, 8653, 8662,4916);


\copy (SELECT * FROM tmp_dlm_taskvariant_info) TO 'tmp_dlm_taskvariant_info_05102016.csv' DELIMITER ',' CSV HEADER;
ROLLback;