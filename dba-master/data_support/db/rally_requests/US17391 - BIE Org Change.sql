-- step1: create new state for "BIE-Miccosukee"
INSERT INTO organization(
             organizationname,
             displayidentifier,
             organizationtypeid, 
             welcomemessage, 
             createddate, 
             activeflag,
             createduser, 
             modifieduser, 
             modifieddate, 
             buildinguniqueness,
             schoolstartdate,
             schoolenddate, 
             contractingorganization,
             expirepasswords,
             expirationdatetype, 
             pooltype,
             multitestassignment,
             reportprocess,
             reportyear)
   select    'BIE-Miccosukee' organizationname,                      
             'BIE-Miccosukee' displayidentifier,
             organizationtypeid, 
             welcomemessage, 
             now() createddate,              
             activeflag,
             12 createduser, 
             12 modifieduser, 
             now() modifieddate, 
             buildinguniqueness,
             schoolstartdate,
             schoolenddate, 
             contractingorganization,
             expirepasswords,
             expirationdatetype, 
             pooltype,
             multitestassignment,
             reportprocess,
             reportyear from organization where id=68376;

  -- step2: moving the student to new state  
	    -- finding the organization to move the student states
			       select s.id,e.attendanceschoolid, 
			            (select displayidentifier from  organization_parent(e.attendanceschoolid) where  organizationtypeid=5),
			            (select organizationname from  organization_parent(e.attendanceschoolid) where  organizationtypeid=5)
			         from student s 
			         inner join enrollment e on s.id =e.studentid 
			         where e.attendanceschoolid in ( select id from  organization_children(68376) where organizationtypeid=7)
			         order by 3;
			
			--       
	 -- from the requirement student in the "BIE" state move the "BIE-Miccosukee" --6 only students 
	     update student 
	     set stateid=( select id from organization where 'BIE-Miccosukee' =organizationname and 'BIE-Miccosukee' = displayidentifier)
	      ,modifieduser=12
		,modifieddate=now()
	      where id in ( select s.id
			         from student s 
			         inner join enrollment e on s.id =e.studentid 
			         where e.attendanceschoolid  = 68378) ;

      
  -- step3: move the dist "Miccosukee"  from BIE state to "BIE-Miccosukee"  state

	     update organizationrelation 
	     set parentorganizationid=( select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
		,modifieduser=12
		,modifieddate=now()
	      where organizationid =68377;  
	      
-- Make this a child of global CETE organization	      
insert into organizationrelation(organizationid,parentorganizationid,createddate,activeflag,createduser,modifieduser,modifieddate) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier),
			(select id from organization where displayidentifier='CETE'),now(),true,12,12,now());	      

			insert into 
			
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='CONS'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='ST'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='DT'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='SCH'));
			
-- step4: Update current BIE state to "BIE-Choctaw"


	     update organization
	     set organizationname='BIE-Choctaw'
	        ,displayidentifier='BIE-Choctaw'
		,modifieduser=12
		,modifieddate=now()
	      where id =68376;    
	 