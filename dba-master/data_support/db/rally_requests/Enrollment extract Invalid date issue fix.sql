

--========================================================================================================
--query to find "Year values in date fields preceded by 00” on student table and send me the unique values.
--========================================================================================================
--student  --dateofbirth --Validation
		select id, dateofbirth curr_dateofbirth
			,cast(case when EXTRACT(YEAR from dateofbirth) between 1 and 16 then dateofbirth+INTERVAL '2000 year' 
			      when EXTRACT(YEAR from dateofbirth) between 90 and 99 then dateofbirth+INTERVAL '1900 year' 
			      when EXTRACT(YEAR from dateofbirth) between 900 and  999 then dateofbirth+INTERVAL '1000 year' 
			      when EXTRACT(YEAR from dateofbirth) between 201 and  209 then dateofbirth+INTERVAL '1800 year' 
			      else dateofbirth END as date) upd_dateofbirth   
			    from student std 
		  where length(cast (EXTRACT(YEAR from dateofbirth) as varchar(4)))<4 
		  order by dateofbirth;
	 --Update 
	 update student
	     set dateofbirth=  cast(case when EXTRACT(YEAR from dateofbirth) between 1 and 16 then dateofbirth+INTERVAL '2000 year' 
					      when EXTRACT(YEAR from dateofbirth) between 90 and 99 then dateofbirth+INTERVAL '1900 year' 
					      when EXTRACT(YEAR from dateofbirth) between 900 and  999 then dateofbirth+INTERVAL '1000 year' 
					      when EXTRACT(YEAR from dateofbirth) between 201 and  209 then dateofbirth+INTERVAL '1800 year' 
					      else dateofbirth END as date)       
	     where length(cast (EXTRACT(YEAR from dateofbirth) as varchar(4)))<4;
              
 --========================================================================================================        
--enrollment  --schoolentrydate --Validation
		select  id,schoolentrydate curr_schoolentrydate
			,case when EXTRACT(YEAR from schoolentrydate) between 1 and 16 then schoolentrydate+INTERVAL '2000 year' 
			      when EXTRACT(YEAR from schoolentrydate) between 90 and 99 then schoolentrydate+INTERVAL '1900 year' 
			      when EXTRACT(YEAR from schoolentrydate) between 900 and  999 then schoolentrydate+INTERVAL '1000 year' 
			      when EXTRACT(YEAR from schoolentrydate) between 201 and  209 then schoolentrydate+INTERVAL '1800 year' 
			      else schoolentrydate END upd_schoolentrydate   
			    from enrollment  
		  where length(cast (EXTRACT(YEAR from schoolentrydate) as varchar(4)))<4 
		  order by schoolentrydate;
	 --Update 
	 update enrollment
	     set schoolentrydate=  case when EXTRACT(YEAR from schoolentrydate) between 1 and 16 then schoolentrydate+INTERVAL '2000 year' 
					      when EXTRACT(YEAR from schoolentrydate) between 90 and 99 then schoolentrydate+INTERVAL '1900 year' 
					      when EXTRACT(YEAR from schoolentrydate) between 900 and  999 then schoolentrydate+INTERVAL '1000 year' 
					      when EXTRACT(YEAR from schoolentrydate) between 201 and  209 then schoolentrydate+INTERVAL '1800 year' 
					      else schoolentrydate END        
	     where length(cast (EXTRACT(YEAR from schoolentrydate) as varchar(4)))<4;
              
 --======================================================================================================== 
--enrollment  --districtentrydate --Validation
		select id, districtentrydate curr_districtentrydate
			,case when EXTRACT(YEAR from districtentrydate) between 1 and 16 then districtentrydate+INTERVAL '2000 year' 
			      when EXTRACT(YEAR from districtentrydate) between 90 and 99 then districtentrydate+INTERVAL '1900 year' 
			      when EXTRACT(YEAR from districtentrydate) between 900 and  999 then districtentrydate+INTERVAL '1000 year' 
			      when EXTRACT(YEAR from districtentrydate) between 201 and  209 then districtentrydate+INTERVAL '1800 year' 
			      else districtentrydate END upd_districtentrydate   
			    from enrollment  
		  where length(cast (EXTRACT(YEAR from districtentrydate) as varchar(4)))<4 
		  order by districtentrydate;
	 --Update 
	 update enrollment
	     set districtentrydate=  case when EXTRACT(YEAR from districtentrydate) between 1 and 16 then districtentrydate+INTERVAL '2000 year' 
					      when EXTRACT(YEAR from districtentrydate) between 90 and 99 then districtentrydate+INTERVAL '1900 year' 
					      when EXTRACT(YEAR from districtentrydate) between 900 and  999 then districtentrydate+INTERVAL '1000 year' 
					      when EXTRACT(YEAR from districtentrydate) between 201 and  209 then districtentrydate+INTERVAL '1800 year' 
					      else districtentrydate END        
	     where length(cast (EXTRACT(YEAR from districtentrydate) as varchar(4)))<4;
              
 --========================================================================================================

--enrollment  --stateentrydate --Validation
		select id, stateentrydate curr_stateentrydate
			,case when EXTRACT(YEAR from stateentrydate) between 1 and 16 then stateentrydate+INTERVAL '2000 year' 
			      when EXTRACT(YEAR from stateentrydate) between 90 and 99 then stateentrydate+INTERVAL '1900 year' 
			      when EXTRACT(YEAR from stateentrydate) between 900 and  999 then stateentrydate+INTERVAL '1000 year' 
			      when EXTRACT(YEAR from stateentrydate) between 201 and  209 then stateentrydate+INTERVAL '1800 year' 
			      else stateentrydate END upd_stateentrydate   
			    from enrollment  
		  where length(cast (EXTRACT(YEAR from stateentrydate) as varchar(4)))<4 
		  order by stateentrydate;
	 --Update 
	 update enrollment
	     set stateentrydate=  case when EXTRACT(YEAR from stateentrydate) between 1 and 16 then stateentrydate+INTERVAL '2000 year' 
					      when EXTRACT(YEAR from stateentrydate) between 90 and 99 then stateentrydate+INTERVAL '1900 year' 
					      when EXTRACT(YEAR from stateentrydate) between 900 and  999 then stateentrydate+INTERVAL '1000 year' 
					      when EXTRACT(YEAR from stateentrydate) between 201 and  209 then stateentrydate+INTERVAL '1800 year' 
					      else stateentrydate END        
	     where length(cast (EXTRACT(YEAR from stateentrydate) as varchar(4)))<4;
              
 --========================================================================================================   
