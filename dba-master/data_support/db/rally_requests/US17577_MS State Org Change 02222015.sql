--///////////////validation//////////////////

-- organization info 
select id
      ,organizationname
      ,displayidentifier
      ,organizationtypeid
      ,activeflag
      ,modifieddate::date
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae
      ,(select  id from organization_parent(o.id) where organizationtypeid=5) dtid
      ,(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname
      ,(select  id from organization_parent(o.id) where organizationtypeid=2) stid 
from  organization o
where displayidentifier in ('1320','1321','6_1320','8_1320') 
     and (select  organizationname from organization_parent(o.id) where organizationtypeid=2) ='Mississippi'
     order by displayidentifier
        ,createddate desc;

--///////////////update code--"Mississippi"//////////////////

select * from organization_children(3931);
select * from organization_children(79311);

begin;

 update organization 
 set modifieduser=12,
    modifieddate=now(),
    displayidentifier='8_1321'
     where id=4146 ;


     update organization 
 set modifieduser=12,
    modifieddate=now(),
    displayidentifier='6_1321'
     where id=4116 ;



 update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=79311
     where organizationid=4146 and parentorganizationid=3931;


     update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=79311
     where organizationid=4116 and parentorganizationid=3931;
 


 update organization 
 set modifieduser=12,
    modifieddate=now(),
    activeflag =false
     where id=3931 and activeflag is true ;


     
commit;

----------------------------------------------------------

select id
      ,organizationname
      ,displayidentifier
      ,organizationtypeid
      ,activeflag
      ,modifieddate::date
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae
      ,(select  id from organization_parent(o.id) where organizationtypeid=5) dtid
      ,(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname
      ,(select  id from organization_parent(o.id) where organizationtypeid=2) stid 
from  organization o
where displayidentifier in ('1320','1321','6_1320','8_1320') 
     and (select  organizationname from organization_parent(o.id) where organizationtypeid=2) ='Mississippi-cPass'
     order by displayidentifier
        ,createddate desc;

--///////////////update code--"Mississippi-cpass"//////////////////

select * from organization_children(66654);
select * from organization_children(79341);

begin;

 update organization 
 set modifieduser=12,
    modifieddate=now(),
    displayidentifier='8_1321'
     where id=66684 ;


     update organization 
 set modifieduser=12,
    modifieddate=now(),
    displayidentifier='6_1321'
     where id=67607 ;



 update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=79341
     where organizationid=66684 and parentorganizationid=66654;


     update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=79341
     where organizationid=67607 and parentorganizationid=66654;

      update organization 
 set modifieduser=12,
    modifieddate=now(),
    activeflag =false
     where id=66654 and activeflag is true ;
 

commit;

----------------------------------------------------------

	


