begin;
update organization
 set activeflag ='false',
     modifieduser=12,
 modifieddate=now() 
 where activeflag='true' and id in (60025,60027,60031,60030,60028,60023,60026,60029,60024) and organizationtypeid=3;
commit;



