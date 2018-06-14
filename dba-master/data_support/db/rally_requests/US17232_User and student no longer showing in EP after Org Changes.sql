
--validation script 
   select 
    a.firstname,
    a.surname ,
    a.email,
    o.id,
    o.displayidentifier,
    o.organizationname,
    o.organizationtypeid,
    o.displayidentifier,
    o.activeflag
    from aartuser a 
    inner join usersorganizations uo on uo.aartuserid=a.id 
    inner join organization o on o.id=uo.organizationid
   where a.id=70432; 

---check update school( confrom here  both schools are in same dist)
  select * from organization where id=69251;
  select * from organization_parent(69251) ;

   
--Update script 

begin transaction 
   update usersorganizations 
    set organizationid=69251,
        modifieddate=now(),
        modifieduser=12
   where aartuserid=70432
Commit ;

--please run the validation script agian after update 
   
