-- State abbreviation list    
  select 
    displayidentifier
   ,organizationname
   from organization where organizationtypeid=2 and activeflag is true;
   order by organizationname;

-- State abbreviation list    
  select 
     abbreviatedname
    ,name  
     from contentarea
      where activeflag is true
      order by name ;
  
-- Course abbreviation list
   select 
        gc.abbreviatedname as abbreviatedname
        ,gc.name            as coursename
        ,c.abbreviatedname  as subjectname
         from gradecourse gc
        inner join contentarea c on gc.contentareaid=c.id
        where gc.course is true and gc.activeflag is true and c.activeflag is true
      order by c.abbreviatedname,gc.name,gc.abbreviatedname ;

--groups
   select  groupcode,groupname,typename
         from groups g
         inner join organizationtype ot on g.organizationtypeid=ot.id
           where g.activeflag is true and ot.activeflag is true
           order by ot.id;


   