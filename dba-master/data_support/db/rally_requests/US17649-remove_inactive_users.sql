
UPDATE aartuser
SET activeflag = false, 
username = username || '-inactiveUS17649', email = email || '-inactiveUS17649',
uniquecommonidentifier = uniquecommonidentifier || '-inactiveUS17649',
modifieduser = (select id from aartuser where username = 'cetesysadmin'), modifieddate = now()
WHERE id in
(select aartuserid from (select au.id as aartuserid,uso.id as userorganizationid, 
count(usog.*) as numOfRoles, usog.status 
from aartuser au 
join usersorganizations uso on uso.aartuserid = au.id 
join userorganizationsgroups usog on usog.userorganizationid = uso.id
where uso.organizationid in (
       select schoolid from organizationtreedetail where statedisplayidentifier = 'NY' and districtname = 'MIDDLE COUNTRY CSD')
                     group by au.id, uso.id, usog.status) 
                     as inactiveaartusers where numOfRoles= 1 and status = 3);