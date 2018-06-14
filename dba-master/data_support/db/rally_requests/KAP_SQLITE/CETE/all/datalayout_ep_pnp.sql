--PNP extract
drop table if exists tmp_pnp;
SELECT
s.id                     studentid,
spiav.id                 valueid,
piac.attributecontainer  attributecontainer,
pia.attributename        attributename,
spiav.selectedvalue      "value"
 into temp tmp_pnp
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join gradecourse egc  on e.currentgradelevel=egc.id
JOIN studentassessmentprogram sap ON sap.studentid = s.id
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc
ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid in (select organizationid from orgassessmentprogram where assessmentprogramid=12) AND e.currentschoolyear=2017;

\copy (select  * from tmp_pnp) to 'kap_pnp.txt' (FORMAT CSV,DELIMITER('|'), HEADER TRUE, FORCE_QUOTE *);