/*
--extract information the users belong to BTC or DTC in kap not in K-ELPA;
select distinct aart.id aartid, aart.email, --usg.id usorggroupid,
case when g.groupcode ='BTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_BTC"
,case when g.groupcode ='DTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_DTC"
,case when g.groupcode ='BTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_BTC"
,case when g.groupcode ='DTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_DTC",
ort.schoolname,
CASE WHEN ort.schoolid is not null then ort.districtname else dt.organizationname end as DistrictName, 
case when ort.schoolid is not null then ort.stateid 
     when dt.id is not null then (select id from organization_parent(dt.id) where organizationtypeid=2) 
	 else st.id  end as stateid
into temp tmp_replic 
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
left outer join organizationtreedetail ort on ort.schoolid= us.organizationid 
left outer join organization dt on (dt.id=us.organizationid and dt.organizationtypeid =5)
left outer join organization st on (st.id=us.organizationid and st.organizationtypeid=2 )
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
left outer join userassessmentprogram uspkelpa on uspkelpa.aartuserid=aart.id and uspkelpa.userorganizationsgroupsid =usg.id and uspkelpa.activeflag is true and uspkelpa.assessmentprogramid =47
inner join groups g on g.id =usg.groupid and g.activeflag is true
where aart.activeflag is true and (g.groupcode ='BTC' or g.groupcode ='DTC')
and usp.assessmentprogramid =12; 


\copy (select * from tmp_replic) to 'kap_duplic.csv'DELIMITER ',' CSV HEADER;

--extract information for update K-ELPA
select distinct aart.id aartid,usg.id usorggroupid,
case when g.groupcode ='BTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_BTC"
,case when g.groupcode ='DTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_DTC"
,case when g.groupcode ='BTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_BTC"
,case when g.groupcode ='DTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_DTC",

case when ort.schoolid is not null then ort.stateid 
     when dt.id is not null then (select id from organization_parent(dt.id) where organizationtypeid=2) 
	 else st.id  end as stateid
into temp tmp_replic 
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
left outer join organizationtreedetail ort on ort.schoolid= us.organizationid 
left outer join organization dt on (dt.id=us.organizationid and dt.organizationtypeid =5)
left outer join organization st on (st.id=us.organizationid and st.organizationtypeid=2 )
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
left outer join userassessmentprogram uspkelpa on uspkelpa.aartuserid=aart.id and uspkelpa.userorganizationsgroupsid =usg.id and uspkelpa.activeflag is true and uspkelpa.assessmentprogramid =47
inner join groups g on g.id =usg.groupid and g.activeflag is true
where aart.activeflag is true and (g.groupcode ='BTC' or g.groupcode ='DTC')
and usp.assessmentprogramid =12;

\copy  tmp_replic to 'kap_duplic.csv' WIHT HEADER;

\copy tmp_replic to 'kap_duplic.csv' DELIMITER ',' CSV HEADER;


*/


begin;
select distinct aart.id aartid,usg.id usorggroupid,
case when g.groupcode ='BTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_btc"
,case when g.groupcode ='DTC' AND usp.assessmentprogramid =12 then 'yes' else 'no' end  "kap_dtc"
,case when g.groupcode ='BTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_btc"
,case when g.groupcode ='DTC' AND uspkelpa.assessmentprogramid =47 then 'yes' else 'no' end  "kelpa_dtc",
case when ort.schoolid is not null then ort.stateid 
     when dt.id is not null then (select id from organization_parent(dt.id) where organizationtypeid=2) 
                else st.id  end as stateid
into temp tmp_replic
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
left outer join organizationtreedetail ort on ort.schoolid= us.organizationid 
left outer join organization dt on (dt.id=us.organizationid and dt.organizationtypeid =5)
left outer join organization st on (st.id=us.organizationid and st.organizationtypeid=2 )
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
left outer join userassessmentprogram uspkelpa on uspkelpa.aartuserid=aart.id and uspkelpa.userorganizationsgroupsid =usg.id and uspkelpa.activeflag is true and uspkelpa.assessmentprogramid =47
inner join groups g on g.id =usg.groupid and g.activeflag is true
where aart.activeflag is true and (g.groupcode ='BTC' or g.groupcode ='DTC')
and usp.assessmentprogramid =12;

select * from tmp_replic;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
select distinct aartid   aartuserid,47 assessmentprogramid,true  activeflag,false  isdefault,
now() createddate,12  createduser,now() modifieddate,12   modifieduser, usorggroupid   userorganizationsgroupsid
from tmp_replic where kap_btc='yes' and kelpa_btc='no';
                                                              

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
select distinct aartid   aartuserid,47 assessmentprogramid,true  activeflag,false  isdefault,
now() createddate,12  createduser,now() modifieddate,12   modifieduser, usorggroupid   userorganizationsgroupsid
from tmp_replic where kap_dtc='yes' and kelpa_dtc='no'; 

 

commit;



