--duplicate by schoolname and displayidentifier
drop table if exists tmp_org;
with dups as (
 select schoolname,schooldisplayidentifier,statedisplayidentifier,count(statedisplayidentifier)
 from organizationtreedetail 
 group by schoolname,schooldisplayidentifier,statedisplayidentifier
 having count(statedisplayidentifier)>1)
 select tmp.*
 into temp tmp_org
 from organizationtreedetail tmp 
 inner join dups on dups.schooldisplayidentifier=tmp.schooldisplayidentifier
 and dups.schoolname=tmp.schoolname
 order by tmp.schoolname,tmp.schooldisplayidentifier;
 \copy (select * from tmp_org) to 'school_display_and_name_duplicated.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 
-- duplicate by school displayidentifier
drop table if exists tmp_org;
with dups as (
 select schooldisplayidentifier,statedisplayidentifier,count(statedisplayidentifier)
 from organizationtreedetail 
 group by schooldisplayidentifier,statedisplayidentifier
 having count(statedisplayidentifier)>1)
 select tmp.* into temp tmp_org
 from organizationtreedetail tmp 
 inner join dups on dups.schooldisplayidentifier=tmp.schooldisplayidentifier
 order by tmp.schooldisplayidentifier;
\copy (select * from tmp_org) to 'school_display_duplicated.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- duplicate by school displayidentifier and district
drop table if exists tmp_org;
with dups as (
 select schooldisplayidentifier,districtdisplayidentifier,statedisplayidentifier,count(statedisplayidentifier)
 from organizationtreedetail 
 group by schooldisplayidentifier,statedisplayidentifier,districtdisplayidentifier
 having count(statedisplayidentifier)>1)
 select tmp.* into temp tmp_org
 from organizationtreedetail tmp 
 inner join dups on dups.schooldisplayidentifier=tmp.schooldisplayidentifier
 -- and tmp.districtdisplayidentifier=dups.districtdisplayidentifier
 order by tmp.schooldisplayidentifier;
\copy (select * from tmp_org) to 'school_display_and_district_duplicated.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


 --duplicate by districtname and district displayidentifier
drop table if exists tmp_org;
with dups as (
select organizationname,displayidentifier,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) state,count(*)
 from organization
 where organizationtypeid=5 and activeflag is true 
group by organizationname ,displayidentifier ,state
having count(*)>1)
 select tmp.id,tmp.organizationname district,tmp.displayidentifier districtdisplay,(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1) state
 into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier
 and dups.organizationname=tmp.organizationname
 order by tmp.organizationname,tmp.displayidentifier;
\copy (select * from tmp_org) to 'district_display_and_name_duplicated.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--duplicate by  district displayidentifier
drop table if exists tmp_org;
with dups as (
select displayidentifier,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) state,count(*)
 from organization
 where organizationtypeid=5 and activeflag is true 
group by displayidentifier,state
having count(*)>1)
 select tmp.id,tmp.organizationname district,tmp.displayidentifier districtdisplay,(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1) state
 into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier and dups.state=(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1)
 order by tmp.displayidentifier;
 \copy (select * from tmp_org) to 'district_display_duplicated.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--------------------------------------------------------------------------------------------
--for Both active and inactive status
--duplicate by schoolname and displayidentifier
drop table if exists tmp_org;
with dups as (
select organizationname,displayidentifier,(select displayidentifier from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay,count(*)
 from organization
 where organizationtypeid=7 --and activeflag is true 
group by organizationname ,displayidentifier ,statedisplay
having count(*)>1
 )
 select tmp.id,tmp.displayidentifier schooldisplay,tmp.organizationname schoolname,tmp.activeflag schoolactive
 ,(select organizationname from organization_parent(id) where organizationtypeid=5 limit 1) districtname
 ,(select displayidentifier from organization_parent(id) where organizationtypeid=5 limit 1) districtdisplay
 ,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay
 into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier
 and dups.organizationname=tmp.organizationname
 order by tmp.organizationname,tmp.displayidentifier;
 \copy (select * from tmp_org) to 'school_display_and_name_duplicated_inactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 
-- duplicate by school displayidentifier
drop table if exists tmp_org;
with dups as (
select displayidentifier,(select displayidentifier from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay,count(*)
 from organization
 where organizationtypeid=7 --and activeflag is true 
group by displayidentifier ,statedisplay
having count(*)>1
 )
 select tmp.id,tmp.displayidentifier schooldisplay,tmp.organizationname schoolname,tmp.activeflag schoolactive
 ,(select organizationname from organization_parent(id) where organizationtypeid=5 limit 1) districtname
 ,(select displayidentifier from organization_parent(id) where organizationtypeid=5 limit 1) districtdisplay
 ,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay
  into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier
 order by tmp.displayidentifier;
\copy (select * from tmp_org) to 'school_display_duplicated_inactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- duplicate by school displayidentifier and district
drop table if exists tmp_org;
with dups as (
select displayidentifier
,(select displayidentifier from organization_parent(id) where organizationtypeid=5 limit 1) districtdisplay
,(select displayidentifier from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay,count(*)
 from organization
 where organizationtypeid=7 --and activeflag is true 
group by displayidentifier ,statedisplay,districtdisplay
having count(*)>1
 )
 select tmp.id,tmp.displayidentifier schooldisplay,tmp.organizationname schoolname,tmp.activeflag schoolactive
 ,(select organizationname from organization_parent(id) where organizationtypeid=5 limit 1) districtname
 ,(select displayidentifier from organization_parent(id) where organizationtypeid=5 limit 1) districtdisplay
 ,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) statedisplay
  into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier
 and districtdisplay=dups.districtdisplay
 order by tmp.displayidentifier;
\copy (select * from tmp_org) to 'school_display_and_district_duplicated_inactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


 --duplicate by districtname and district displayidentifier
drop table if exists tmp_org;
with dups as (
select organizationname,displayidentifier,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) state,count(*)
 from organization
 where organizationtypeid=5 --and activeflag is true 
group by organizationname ,displayidentifier ,state
having count(*)>1)
 select tmp.id,tmp.organizationname district,tmp.displayidentifier districtdisplay,(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1) state
 into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier
 and dups.organizationname=tmp.organizationname
 order by tmp.organizationname,tmp.displayidentifier;
\copy (select * from tmp_org) to 'district_display_and_name_duplicated_inactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--duplicate by  district displayidentifier
drop table if exists tmp_org;
with dups as (
select displayidentifier,(select organizationname from organization_parent(id) where organizationtypeid=2 limit 1) state,count(*)
 from organization
 where organizationtypeid=5 --and activeflag is true 
group by displayidentifier,state
having count(*)>1)
 select tmp.id,tmp.organizationname district,tmp.displayidentifier districtdisplay,(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1) state
 into temp tmp_org
 from organization tmp 
 inner join dups on dups.displayidentifier=tmp.displayidentifier and dups.state=(select organizationname from organization_parent(tmp.id) where organizationtypeid=2 limit 1)
 order by tmp.displayidentifier;
 \copy (select * from tmp_org) to 'district_display_duplicated_inactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

 