select distinct aart.firstname||' '||aart.surname as username,aart.email, aa.firstname||' '||aa.surname as acountmodiuser,
aa.email, aa.modifieddate::date,
 (case when uog.status =1 then 'pending' when uog.status =2 then 'active' else 'inactive' end)as status, 
 aar.firstname||' '||aar.surname as groupmodifyname, aar.email as modifyemail, aar.modifieddate::date,
 (select organizationname from organization_parent(og.id) where  organizationtypeid =5) as districtname,
 (select organizationname from organization_parent(og.id) where  organizationtypeid =2) as statename
 from aartuser aart
		 join aartuser aa on aa.id = aart.modifieduser
		 join usersorganizations ug on aart.id =ug.aartuserid
		 join userorganizationsgroups uog on ug.id =uog.userorganizationid
		 left outer  join aartuser aar on uog.modifieduser = aar.id
		 left outer  join usersorganizations ur on aar.id = ur.aartuserid
		 left outer join organization og on og.id= ur.organizationid
 where aart.id in (72798,130593);