SELECT       ca.name 				taskcontentareaname
	    ,case when gc.name is not null then gc.name else gb.name end  taskgrade	    
            ,t.taskid                           externaltaskid
            ,tv.taskvariantid                   externaltaskvariantid
            ,t.taskname                         taskname
            ,tv.name                            variantname
            ,stt.abbreviation                   tasktypecode 
            ,stst.abbreviation                  tasksubtypecode
	    ,t.maxscore			        itemmaxscore
            ,tv.scoringmethod			Scoringmethod
            ,case when tv.approvedstatus=0 then 'Approved' else 'Unapproved' end approvedstatus
            ,case when tv.status=2 then 'Draft' else 'Complete' end status
            ,t.scoringneeded                    scoringneeded
	    ,o.organizationid                   organizationid
	    ,o.name                             organizationname
	   , array_to_string(array_agg(distinct case when tfd.isprimary is true then  cfd.contentcode else null end ), ',') primary_content_code
	   , array_to_string(array_agg(distinct case when tfd.isprimary is false then  cfd.contentcode else null end ), ',') secondary_content_code
           ,array_to_string(array_agg(distinct ft.name  ), ',') frameworktypename
     into temp tmp_final_report       
from cb.taskvariant tv 
   inner join organization_ o on o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   left outer join cb.taskcontentframeworkdetails tfd on tfd.taskid=t.taskid and o.organizationid=tfd.organizationid
   left outer join cb.contentframeworkdetail cfd on tfd.contentframeworkdetailid=cfd.contentframeworkdetailid and cfd.inuse is true
   left outer join cb.contentframework cf on cf.contentframeworkid=cfd.contentframeworkid
   left outer join cb.frameworktype ft on ft.frameworktypeid=cf.frameworktypeid 
   left outer join cb.gradecourse gc on t.gradecourseid=gc.gradecourseid and o.organizationid=gc.organizationid and gc.inuse is true 
   left outer join cb.contentarea ca on t.contentareaid=ca.contentareaid and o.organizationid=ca.organizationid and ca.inuse is true 
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.systemrecord stt on stt.id=tt.systemrecordid  and stt.inuse is true 
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid  and tt.tasktypeid=tst.tasktypeid  and tst.inuse is true
   left outer join cb.systemrecord stst on stst.id=tst.systemrecordid  and stst.inuse is true 
   left outer join cb.systemrecord gb on t.gradebandid=gb.id      
   where  tv.inuse is true and t.inuse is true
         and o.organizationid  =15009   --only kap
         AND ca.name ='Mathematics'
         --  and o.organizationid not in (16800,18404) --Playground states
group by  ca.name 				
	    ,case when gc.name is not null then gc.name else gb.name end  	    
            ,t.taskid                           
            ,tv.taskvariantid                   
            ,t.taskname                         
            ,tv.name                            
            ,stt.abbreviation                    
            ,stst.abbreviation                  
	    ,t.maxscore			        
            ,tv.scoringmethod			
            ,case when tv.approvedstatus=0 then 'Approved' else 'Unapproved' end 
            ,case when tv.status=2 then 'Draft' else 'Complete' end 
            ,t.scoringneeded                    
	    ,o.organizationid                   
	    ,o.name                                      
   order by o.name,tv.taskvariantid,taskgrade,ca.name; 



\copy (select * from tmp_final_report ) to 'tmp_final_report_content.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

