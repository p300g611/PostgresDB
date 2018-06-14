--psql -h pg1 -U aart_reader -f "WindowID.sql" aart-prod
select distinct opt.id WindowID,
opt.effectivedate     WindowStateDate, 
opt.expirydate        WindowEndDate,
opt.windowname        WindowName,
org.organizationname  State,
ap.abbreviatedname    Program
into temp tmp_WindowID   
from operationaltestwindow opt   
join operationaltestwindowstate ops on ops.operationaltestwindowid = opt.id
join organization org on org.id = ops.stateid 
join operationaltestwindowstestcollections opwt on opwt.operationaltestwindowid = opt.id
join assessmentstestcollections asct on asct.testcollectionid = opwt.testcollectionid
JOIN assessment a ON asct.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id   
where opt.activeflag is true
order by opt.id desc,State,ap.abbreviatedname;
\copy (select * from tmp_WindowID) to 'WindowID.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
