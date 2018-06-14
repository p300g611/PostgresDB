drop table if exists tmp_item;
drop table if exists tmp_item_duration_amp;
SELECT     s.id                       Studentid
	  ,st.id                      studentstestid
	  ,gc.name                    Grade
	  ,tsc.id                     testsectionid
	  ,tstv.taskvariantid         taskvariantid     
	  ,tstv.taskvariantposition   Itemposition     
	  ,tt.name                    Itemtypename 
	   into temp tmp_item
       FROM studentstests st
		    inner JOIN test t ON st.testid = t.id
		    inner JOIN testcollectionstests tct ON st.testid = tct.testid
		    inner JOIN testcollection tc ON tc.id = tct.testcollectionid
		    inner join gradecourse gc on gc.id=tc.gradecourseid
		    inner join contentarea ca on ca.id=tc.contentareaid
		    inner JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid 
		    inner JOIN assessment a ON atc.assessmentid = a.id 
		    inner JOIN testingprogram tp ON a.testingprogramid = tp.id
		    inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id 
		    inner JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id and ts.activeflag is true
		    inner JOIN testsection as tsc ON t.id = tsc.testid
		    inner JOIN testsectionstaskvariants AS tstv ON tsc.id = tstv.testsectionid 
		    inner JOIN taskvariant tv ON tv.id = tstv.taskvariantid 
		    left outer JOIN tasktype tt on tv.tasktypeid=tt.id              
		    inner JOIN enrollment e ON st.enrollmentid = e.id 
		    inner join student s on s.id=e.studentid  
		    WHERE  ap.id=37 AND e.currentschoolyear=2016 AND st.activeflag is true and ca.id=441 --sci,kap  
		    group by s.id                       
			  ,st.id                      
			  ,gc.name                    
			  ,tsc.id                     
			  ,tstv.taskvariantid              
			  ,tstv.taskvariantposition        
			  ,tt.name;



SELECT     tmp.Studentid              Studentid
	  ,tmp.studentstestid         Studentstestid
	  ,sts.id                     Studentstestsectionid
	  ,tmp.Grade                  Grade
	  ,tmp.taskvariantid          ItemID     
	  ,tmp.Itemposition           Itemposition     
	  ,sts.createddate            Sectionscreateddate
	  ,sts.modifieddate           Sectionsmodifieddate  
	  ,sr.createddate             Itemcreateddate
	  ,sr.modifieddate            Itemmodifieddate
	  ,sr.score                   Responsescore
	  ,tmp.Itemtypename           Itemtypename 
	    into temp tmp_item_duration_amp
 from tmp_item tmp
 inner JOIN studentstestsections sts  ON tmp.studentstestid = sts.studentstestid AND sts.testsectionid = tmp.testsectionid and sts.activeflag IS true
 LEFT OUTER JOIN studentsresponses sr on sr.studentstestsectionsid=sts.id AND sr.taskvariantid=tmp.taskvariantid AND sr.activeflag IS true;


		    
\copy (select * from tmp_item_duration_amp) to 'tmp_item_duration_amp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
drop table if exists tmp_item;
drop table if exists tmp_item_duration_amp;	--63990467