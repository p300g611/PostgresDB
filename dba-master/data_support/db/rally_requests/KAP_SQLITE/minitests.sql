select it.testtestid interimtestid,it.name interimtestname,gc.abbreviatedname interimtestgrade,ca.abbreviatedname interimtestsubject
,mini.id testid,mini.testname,mini.externalid externalid,gc.abbreviatedname testgrade,ca.abbreviatedname testsubject,ct.categorycode testspecification
into temp tmp_interimtest
from test t
inner join interimtest it on it.testtestid=t.id and it.activeflag is true 
inner join interimtesttest itt on itt.interimtestid=it.id and itt.activeflag is true 
inner JOIN test mini on mini.id=itt.testid
left outer join gradecourse gc on gc.id=it.gradecourseid
left outer join contentarea ca on ca.id=it.contentareaid
left outer join gradecourse mgc on mgc.id=t.gradecourseid
left outer join contentarea mca on mca.id=t.contentareaid
left JOIN testspecstatementofpurpose tstop on t.testspecificationid=tstop.testspecificationid
left JOIN category ct on ct.id=tstop.statementofpurposeid
order by t.id;


\copy (select * from tmp_interimtest) to 'interimtest.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



