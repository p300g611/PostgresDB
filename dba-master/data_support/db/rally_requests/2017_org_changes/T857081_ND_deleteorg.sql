/*select * from organizationtreedetail where statedisplayidentifier  ='ND'
and schooldisplayidentifier in ('0800177191',
'2201474874',
'3800178581',
'3410059991',
'5116154463',
'4701948923');

select * from organizationtreedetail where statedisplayidentifier  ='ND'
and schooldisplayidentifier in ('2000731723');
*/
update usersorganizations
set  organizationid =38836
 where organizationid =38912;
 
update organization 
set activeflag =false,
 modifieduser=12,
 modifieddate=now()
 where id in ( select schoolid from organizationtreedetail where statedisplayidentifier  ='ND'
		and schooldisplayidentifier in ('0800177191',
		'2201474874',
		'3800178581',
		'3410059991',
		'5116154463',
		'4701948923'));    

delete from organizationtreedetail 
where schoolid in (select schoolid from organizationtreedetail where statedisplayidentifier  ='ND'
		and schooldisplayidentifier in ('0800177191',
		'2201474874',
		'3800178581',
		'3410059991',
		'5116154463',
		'4701948923'));
 
