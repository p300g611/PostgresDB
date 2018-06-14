BEGIN;

update aartuser 
set uniquecommonidentifier ='7823887592',
modifieddate = now(),
modifieduser =12
where id  = 29456;

update userassessmentprogram
set  isdefault = false
where id = 192926; 

update userorganizationsgroups
set isdefault = true
where id = 246244;

COMMIT;