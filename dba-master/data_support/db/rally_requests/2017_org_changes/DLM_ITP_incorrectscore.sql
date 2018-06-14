select 
sr.studentid,s.statestudentidentifier,
sr.taskvariantid,tv.externalid,
sr.response student_response,sr.score student_score,scoringdata
into temp tmp_studentsresponses
from studentsresponses sr
inner join student s on s.id =sr.studentid
inner join taskvariant tv on tv.id=sr.taskvariantid 
where tv.externalid in (44976,
46433,
46472,
54577,
55006,
55009,
55014
);


select 
sr.studentid,s.statestudentidentifier,
sr.taskvariantid,tv.externalid,
sr.response student_response,sr.score student_score,scoringdata
into temp tmp_studentsresponses
from studentsresponses sr
inner join student s on s.id =sr.studentid
inner join taskvariant tv on tv.id=sr.taskvariantid 
where tv.externalid in (33766,
38280,
38281,
43933,
49415
);
\copy (select distinct * from tmp_studentsresponses) to 'studentsresponses_EP0621.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  

select tv.id taskvariant,tv.externalid,foilid,externaltaskid,
responseorder,correctresponse,responsescore
into temp tmp_taskvariantsfoils
 from taskvariantsfoils tfv 
inner join taskvariant tv on tv.id=tfv.taskvariantid 
inner join tasktype ty on ty.id=tv.tasktypeid
where tv.externalid in (33766,
38280,
38281,
43933,
49415
);

\copy (select distinct * from tmp_taskvariantsfoils) to 'taskvariantsfoils_EP0621.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  


--cb
select taskvariantid taskvariantid_cb,responseorder,correctresponse,responsescore,responsetext
into temp tmp_taskvariantsfoils
 from cb.taskvariantresponse where taskvariantid in (33766,
38280,
38281,
43933,
49415
);

\copy (select distinct * from tmp_taskvariantsfoils order by 1,2) to 'taskvariantsfoils_CB0621.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select taskvariantid,innovativeitemdata
into temp tmp_taskvariantscb
 from cb.taskvariant  where taskvariantid in (44976,46433,46472,54577,55006,55009,55014,33766,38280,38281,43933,49415);

 \copy (select distinct * from tmp_taskvariantscb order by 1,2) to 'taskvariantscb_itp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);