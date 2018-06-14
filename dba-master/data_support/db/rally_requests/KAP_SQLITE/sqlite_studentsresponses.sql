--updated script 
select a.studentstestsid,a.score,responsetext,
                b.foilsorder,b.correctresponse,
                c.externalid as externaltaskid, c.contentareaname,c.taskname,c.tasktypecode,
                d.studentid,d.totalrawscore,
                g.gradecourse,g.testname,g.externalid as externaltestid,g.testinternalname,                
                h.legalfirstname, h.legallastname, h.statestudentidentifier,h.grade,h.state,h.district,h.school,
                h.activeenrollmentflag,h.exitwithdrawaltype
                from (select distinct taskvariantid,studentstestsid,score,foildid,responsetext from studentsresponses ) a 
                left join taskvariantsfoils b on a.taskvariantid=b.taskvariantid and a.foildid=b.foilid
                left join (select distinct id,externalid, taskname,tasktypecode,contentareaname from taskvariant) c on a.taskvariantid=c.id
                left join (select distinct id,studentid,totalrawscore,programname,interimtheta,testid from studentstests) d on a.studentstestsid=d.id
                left join (select distinct id,gradecourse,testname,externalid,testinternalname from test) g on d.testid=g.id
                left join (select distinct id,legalfirstname,legallastname,statestudentidentifier,
                grade,state,district,school, activeenrollmentflag,exitwithdrawaltype from student) h on d.studentid=h.id
                where c.contentareaname='ELA' 
                and state='Kansas'
--original script                
select a.studentstestsid,a.score,responsetext,
               b.foilsorder,b.correctresponse,
               c.externalid as externaltaskid, c.contentareaname,c.taskname,c.tasktypecode,
               d.studentid,d.teststatus,
               g.gradecourse,g.testname,g.externalid as externaltestid,g.testinternalname,                
               h.state
               from (select distinct taskvariantid,studentstestsid,score,foildid,responsetext from studentsresponses ) a 
               left join taskvariantsfoils b on a.taskvariantid=b.taskvariantid and a.foildid=b.foilid
               left join (select distinct id,externalid, taskname,tasktypecode,contentareaname from taskvariant) c on a.taskvariantid=c.id
               left join (select distinct id,studentid,teststatus,programname,interimtheta,testid from studentstests) d on a.studentstestsid=d.id
               left join (select distinct id,gradecourse,testname,externalid,testinternalname from test) g on d.testid=g.id
               left join (select distinct id,state from student) h on d.studentid=h.id
               where c.contentareaname='M' 
               and teststatus='complete'
               and state='Kansas'

