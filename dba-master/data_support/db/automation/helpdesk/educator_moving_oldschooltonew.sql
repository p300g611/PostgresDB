do
$BODY$
   DECLARE
         educatorid_or_oldemail character varying;
         new_email              character varying;
         district_id            character varying;
         school_id              character varying;
         state_id              character varying;
         now_date               timestamp with time zone; 
	 district_dbid          bigint;
	 school_dbid            bigint;
	 err_msg                TEXT;
	 ceteSysAdminUserId     bigint;
	 aartuser_id            bigint; 
	 tmp_table              Record;
	 educator_role          text;
 BEGIN	 
         err_msg               :='';
	 now_date              :=now();
	 educatorid_or_oldemail:='';      --input box one
         new_email             :='';      --input box two
         district_id           :='';      --input box three
         school_id             :='';	  --input box four
         state_id             :='';	  --input box five
         educator_role         :='';      -- default to teacher 
	 SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin' and activeflag is true limit 1);
	 SELECT INTO district_dbid (select o.districtid from organizationtreedetail o
	                             where o.districtdisplayidentifier= district_id
	                             and statedisplayidentifier =state_id limit 1);
	 SELECT INTO school_dbid   (select o.schoolid from organizationtreedetail o
	                             where schooldisplayidentifier=school_id and o.districtdisplayidentifier=district_id 
	                             and statedisplayidentifier =state_id limit 1);
         SELECT INTO aartuser_id (select id FROM aartuser WHERE uniquecommonidentifier=educatorid_or_oldemail order by id desc limit 1);
         if(aartuser_id is null ) then 
           SELECT INTO aartuser_id (SELECT id FROM aartuser WHERE email=educatorid_or_oldemail limit 1);
           END IF;  
	  IF (district_dbid is null or school_dbid is null or aartuser_id is null) 
            THEN
             err_msg = '<error> mismatch information on district_id:'||cast(coalesce(district_id,'NULL') as text) || ' or district_id(DB):'||COALESCE(district_dbid,0)
                                 ||' OR school_id:'||cast(coalesce(school_id,'NULL') as text) || ' or school_id(DB):'||COALESCE(school_dbid,0)
                                 ||' OR educatorid_or_oldemail:'||COALESCE(educatorid_or_oldemail,'NULL')||' or aartuser_id(DB):'||COALESCE(aartuser_id,0);
             RAISE NOTICE 'Error message is %',err_msg;	        
	    ELSE
	  --INACTIVE OLD SCHOOL INFORMATION 
	   for tmp_table in (select ug.id from usersorganizations uo inner join userorganizationsgroups ug on uo.id=ug.userorganizationid and ug.activeflag is true where uo.aartuserid=aartuser_id)
	   LOOP
 	      RAISE NOTICE 'Inactivating userorganizationsgroups_id:%',tmp_table.id;
 	      update userorganizationsgroups
 	      set activeflag =false,
 	          modifieddate=now_date,
 	          modifieduser=ceteSysAdminUserId
 	      where id=tmp_table.id;  
 	   END LOOP;      
           for tmp_table in (select uo.id from usersorganizations uo where uo.activeflag is true and uo.aartuserid=aartuser_id)
	   LOOP
 	      RAISE NOTICE 'Inactivating usersorganizations_id:%',tmp_table.id;
 	      update usersorganizations
 	      set activeflag =false,
 	          modifieddate=now_date,
 	          modifieduser=ceteSysAdminUserId
 	      where id=tmp_table.id;   
 	    END LOOP; 
 	   for tmp_table in (select id from userassessmentprogram where aartuserid=aartuser_id and activeflag is true)
	   LOOP
 	      RAISE NOTICE 'Inactivating new from userassessmentprogram_id:%',tmp_table.id;
 	      update userassessmentprogram
 	      set activeflag =false,
 	          modifieddate=now_date,
 	          modifieduser=ceteSysAdminUserId
 	      where id=tmp_table.id   ;
 	    END LOOP;             
	  --ADD TO NEW SCHOOL
	   for tmp_table in (select id from aartuser where id=aartuser_id and activeflag is false )
	   LOOP
 	      RAISE NOTICE 'activating aartuser_id:%',tmp_table.id;
 	      update aartuser
 	      set activeflag =true,
 	          modifieddate=now_date,
 	          modifieduser=ceteSysAdminUserId
 	      where id=tmp_table.id   ;
 	   END LOOP;      
           for tmp_table in (select id from aartuser where id=aartuser_id and email<> case when coalesce(new_email,'')='' then email else new_email end)
	   LOOP
 	      RAISE NOTICE 'updating new email to aartuser:%',tmp_table.id;
 	      update aartuser
 	      set email =new_email,
 	          username=new_email,
 	          modifieddate=now_date,
 	          modifieduser=ceteSysAdminUserId
 	      where id=tmp_table.id   ;
 	    END LOOP;
 	   
            insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select aartuser_id        aartuserid,
                   school_dbid        organizationid,
                   true               isdefault,
                   now_date           createddate,
                   ceteSysAdminUserId createduser,
                   now_date           modifieddate,
                   ceteSysAdminUserId modifieduser, 
                   true activeflag
                   from aartuser a
                   left outer join usersorganizations uo on uo.aartuserid=a.id and uo.activeflag is true and uo.organizationid=school_dbid
                   where a.id=aartuser_id and uo.id is null ;
              RAISE NOTICE 'user added to new school:%',school_dbid;     
 	      INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                           uo.id                                         userorganizationid,
			   true                                          isdefault,
			   now_date                                      createddate,
			   ceteSysAdminUserId                            createduser,
			   now_date                                      modifieddate,
			   ceteSysAdminUserId                            modifieduser, 
			   true activeflag
			   from  usersorganizations uo 
			   inner join organization o on o.id=uo.organizationid
			   left outer join userorganizationsgroups ug on uo.id=ug.userorganizationid and uo.activeflag is true 
			   where uo.aartuserid=aartuser_id and ug.id is null and o.id=school_dbid;
	      RAISE NOTICE 'user added to new school teacher role:%',school_dbid; 
              INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       aartuser_id                                   aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                           true                                          activeflag,
			   true                                          isdefault,
			   now_date                                      createddate,
			   ceteSysAdminUserId                            createduser,
			   now_date                                      modifieddate,
			   ceteSysAdminUserId                            modifieduser, 
			   ug.id                                         userorganizationsgroupsid
			   from  usersorganizations uo 
			   inner join organization o on o.id=uo.organizationid and uo.activeflag is true
			   inner join userorganizationsgroups ug on uo.id=ug.userorganizationid and ug.activeflag is true
			   left outer join userassessmentprogram ua on ug.id=ua.userorganizationsgroupsid
			   where uo.aartuserid=aartuser_id and ua.id is null and o.id=school_dbid ;	
            RAISE NOTICE 'user added to new school teacher role for DLM:%',school_dbid;		   
 	    end if;
 	    END;
$BODY$