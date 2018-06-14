begin;

--version1
select o.name organizationname,cf.contentframeworkid,ft.name contentframeworktypename,gc.name gradecoursename
      ,ca.name contentareaname,fl.title frameworklevelname ,fl.level
      ,coalesce(cdc.cc,0)   numberofitemsincontentframework
      ,count(distinct contentframeworkdetailid) numberofitemsincontentframeworklevel
      ,array_to_string(array_agg(cd.contentcode), '; ') contentcode into temp tmp_contentframework
      from cb.contentframework cf 
      inner join organization_ o      on cf.organizationid=o.organizationid and cf.inuse is true
      inner join cb.frameworktype ft  on cf.frameworktypeid=ft.frameworktypeid and cf.organizationid=ft.organizationid and ft.inuse is true 
      left outer join cb.gradecourse gc    on cf.gradecourseid=gc.gradecourseid     and cf.organizationid=gc.organizationid and gc.inuse is true 
      left outer join cb.contentarea ca    on cf.contentareaid=ca.contentareaid     and cf.organizationid=ca.organizationid and ca.inuse is true
      left outer join cb.frameworklevel fl on cf.frameworktypeid=fl.frameworktypeid and fl.inuse is true
      left outer join cb.contentframeworkdetail cd on cf.contentframeworkid=cd.contentframeworkid and fl.frameworklevelid=cd.frameworklevelid and cd.inuse is true    
      left outer join (select contentframeworkid,count(*) cc from cb.contentframeworkdetail where inuse is true 
                           --where  frameworklevelid in (select frameworklevelid from 
                        group by contentframeworkid) cdc on cf.contentframeworkid=cdc.contentframeworkid    
where cf.contentframeworkid=96 --and fl.level=1	 
group by o.name,ft.name,gc.name,cf.contentframeworkid
         ,ca.name,fl.title,fl.level,cdc.cc 
order by o.name,ft.name,gc.name
         ,ca.name,fl.level   	; 


\copy (select * from tmp_contentframework) to 'tmp_contentframework.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--version2
select o.name organizationname,cf.contentframeworkid,ft.name contentframeworktypename,gc.name gradecoursename
      ,ca.name contentareaname,fl.title frameworklevelname ,fl.level,cd.contentcode,count(tcfd.taskid) numberoftask into temp tmp_contentframework
      from cb.contentframework cf 
     inner join organization_ o      on cf.organizationid=o.organizationid and cf.inuse is true
    inner join cb.frameworktype ft  on cf.frameworktypeid=ft.frameworktypeid and cf.organizationid=ft.organizationid and ft.inuse is true 
     left outer join cb.gradecourse gc    on cf.gradecourseid=gc.gradecourseid     and cf.organizationid=gc.organizationid and gc.inuse is true 
      left outer join cb.contentarea ca    on cf.contentareaid=ca.contentareaid     and cf.organizationid=ca.organizationid and ca.inuse is true
      left outer join cb.frameworklevel fl on cf.frameworktypeid=fl.frameworktypeid and fl.inuse is true
      left outer join cb.contentframeworkdetail cd on cf.contentframeworkid=cd.contentframeworkid and cd.inuse is true and fl.frameworklevelid=cd.frameworklevelid
      left outer join cb.taskcontentframeworkdetails tcfd on tcfd.contentframeworkdetailid = cd.contentframeworkdetailid and tcfd.organizationid=cf.organizationid
where cf.contentframeworkid=96 and cd.contentframeworkid is not null
group by o.name,ft.name,gc.name,cf.contentframeworkid
         ,ca.name,fl.title,fl.level ,cd.contentcode
order by o.name,ft.name,gc.name
         ,ca.name,fl.level;

\copy (select * from tmp_contentframework) to 'tmp_contentframework.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--version3
         select o.name organizationname,cf.contentframeworkid,ft.name contentframeworktypename,gc.name gradecoursename
      ,ca.name contentareaname,fl.title frameworklevelname ,fl.level,cd.contentcode,count(tcfd.taskid) numberoftask into temp tmp_contentframework
      from cb.contentframework cf 
     inner join organization_ o      on cf.organizationid=o.organizationid and cf.inuse is true
    inner join cb.frameworktype ft  on cf.frameworktypeid=ft.frameworktypeid and cf.organizationid=ft.organizationid and ft.inuse is true 
     left outer join cb.gradecourse gc    on cf.gradecourseid=gc.gradecourseid     and cf.organizationid=gc.organizationid and gc.inuse is true 
      left outer join cb.contentarea ca    on cf.contentareaid=ca.contentareaid     and cf.organizationid=ca.organizationid and ca.inuse is true
      left outer join cb.frameworklevel fl on cf.frameworktypeid=fl.frameworktypeid and fl.inuse is true
      left outer join cb.contentframeworkdetail cd on cf.contentframeworkid=cd.contentframeworkid and cd.inuse is true and fl.frameworklevelid=cd.frameworklevelid
      left outer join cb.taskcontentframeworkdetails tcfd on tcfd.contentframeworkdetailid = cd.contentframeworkdetailid and tcfd.organizationid=cf.organizationid
where  cd.contentframeworkid is not null and fl.level>0
group by o.name,ft.name,gc.name,cf.contentframeworkid
         ,ca.name,fl.title,fl.level ,cd.contentcode
         having count(tcfd.taskid)>0
order by o.name,ft.name,gc.name
         ,ca.name,fl.level;

\copy (select * from tmp_contentframework) to 'tmp_contentframework.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
rollback;	 

/*
select o.name organizationname,ft.name contentframeworktypename,gc.name gradecoursename
      ,ca.name contentareaname,fl.title frameworklevelname ,fl.level
      ,cdc.cc   numberofitemsincontentframework
      ,count(distinct contentframeworkdetailid) numberofitemsincontentframeworklevel
      ,array_to_string(array_agg(cd.contentcode), '; ') contentcode,cf.contentframeworkid
    select distinct  cf.contentframeworkid  from cb.contentframework cf --497
      inner join organization_ o      on cf.organizationid=o.organizationid and cf.inuse is true --450
      inner join cb.frameworktype ft  on cf.frameworktypeid=ft.frameworktypeid and cf.organizationid=ft.organizationid and ft.inuse is true --443
      left join cb.gradecourse gc    on cf.gradecourseid=gc.gradecourseid     and cf.organizationid=gc.organizationid and gc.inuse is true --379
      left join cb.contentarea ca    on cf.contentareaid=ca.contentareaid     and cf.organizationid=ca.organizationid and ca.inuse is true --379
      left join cb.frameworklevel fl on cf.frameworktypeid=fl.frameworktypeid and fl.inuse is true --355
      left outer join cb.contentframeworkdetail cd on cf.contentframeworkid=cd.contentframeworkid and fl.frameworklevelid=cd.frameworklevelid and cd.inuse is true    
      left outer join (select contentframeworkid,count(*) cc from cb.contentframeworkdetail where inuse is true 
                        group by contentframeworkid) cdc on cf.contentframeworkid=cdc.contentframeworkid    
--where cf.contentframeworkid=59 and fl.level=1	 and
group by o.name,ft.name,gc.name,cf.contentframeworkid
         ,ca.name,fl.title,fl.level,cdc.cc 
order by o.name,ft.name,gc.name
         ,ca.name,fl.level

select * from cb.frameworklevel where frameworktypeid=20 and  inuse is true   title
Subheading
select * from cb.frameworktype where frameworktypeid=20
select * from cb.contentframework where contentframeworkid=96
select * from cb.contentframeworkdetail where contentframeworkid=250 and frameworktypeid=8
 cb.contentframeworkdetail

 contentframeworkid

 frameworklevelid
36
1



--need to ferift ailas names--still meed to validate by cf count
select * from cb.contentframeworkdetail  limit 10
select * from organization_       order by 1

companyid
10131
8
select  frameworktypeid,companyid,gradecourseid,sortorder,level,name,count(*) from cb.frameworklevel
where inuse is true
group by frameworktypeid,companyid,gradecourseid,sortorder,level,name
having count(*)>1 where contentframeworkid=447 limit 10

select distinct type from cb.systemrecord  limit 10

select * from information_schema.columns where column_name ilike '%name%' 
and table_schema not in ('pg_catalog','information_schema') and table_name ilike '%frame%';



select * from cb.gradecourse    where frameworktypeid=8;

select * from cb.frameworklevel  where frameworklevelid=
280

select * from 
*/