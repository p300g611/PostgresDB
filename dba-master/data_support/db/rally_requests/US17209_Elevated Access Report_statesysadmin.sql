
SELECT  a.id                                                                                             id
       ,a.firstname 											 firstname
       ,a.surname 											 surname
       ,a.email                                                                                          email
       ,a.modifieduser                                                                                   modifieduser
       ,a.activeflag                                                                                     activestatus
       ,o.id                                                                                             organizationid
       ,o.displayidentifier                                                                              displayname
       ,ot.typename                                                                                      organizationtype
       ,(select displayidentifier from organization_parent(o.id) where organizationtypeid=5 limit 1)     DistrictNumber
       ,(select organizationname from organization_parent(o.id) where organizationtypeid=5 limit 1)      DistrictName
       ,(select displayidentifier from organization_parent(o.id) where organizationtypeid=2 limit 1)     StateNumber
       ,(select organizationname from organization_parent(o.id) where organizationtypeid=2 limit 1)      StateName
       ,g.groupname                                                                                      groupname
       FROM aartuser a 
	      INNER JOIN usersorganizations uo on a.id=uo.aartuserid
	      INNER JOIN userorganizationsgroups uog on uo.id=uog.userorganizationid 
	      INNER JOIN  groups g on g.id=uog.groupid and g.groupcode ='SSAD'
	      INNER JOIN organization o on o.id=uo.organizationid
	      inner join organizationtype ot on ot.id=o.organizationtypeid
	     --where  o.organizationtypeid in (5,7)
      ORDER BY o.id ;



