select id,organizationname from organization where id = (select organizationid from usersorganizations where aartuserid =(select id from aartuser
where email = 'xxxxxxxxxxxx@xyz.com'));
