--studentid:1473219 Please create entries in studenttracker 



INSERT INTO public.studenttracker(id, studentid, contentareaid, status, activeflag, createddate, createduser, modifieddate, modifieduser, schoolyear, courseid)
 VALUES (
nextval('studenttracker_id_seq'::regclass),
1473219,
3,
'UNTRACKED',
true,
now(),
13,
now(),
13,
2018,
null);
			 
			 
INSERT INTO public.studenttracker(id, studentid, contentareaid, status, activeflag, createddate, createduser, modifieddate, modifieduser, schoolyear, courseid)
 VALUES (
nextval(
'studenttracker_id_seq'::regclass),
1473219,
440,
'UNTRACKED',
true,
now(),
13,
now(),
13,
2018,
null);
			 			 
			 
 
