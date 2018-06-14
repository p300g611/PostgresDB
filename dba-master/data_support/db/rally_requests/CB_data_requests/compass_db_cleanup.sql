-- Editor 

begin;

truncate table editor.teitemversion;
delete from  editor.teitem;
truncate   editor.teitem CASCADE;
truncate   editor.teitem;

select count(*) from editor.teitemversion;
select count(*) from editor.teitem;


select 'truncate table cb.'||table_name ||' CASCADE;' from information_schema.tables  where table_type='BASE TABLE'  and table_schema='cb';

drop table if exists tmp_table;
select table_schema, 
       table_name, 
       (xpath('/row/cnt/text()', xml_count))[1]::text::int as row_count
into temp tmp_table       
from (
  select table_name, table_schema, 
         query_to_xml(format('select count(*) as cnt from %I.%I', table_schema, table_name), false, true, '') as xml_count
  from information_schema.tables
  where table_schema = 'cb' --<< change here for the schema you want
) t
order by table_name;

select * from tmp_table where row_count>0 order by 2

ALTER SEQUENCE cb.readabilityguidelineid_seq RESTART WITH 1;

sequence_name
readabilityguidelineid_seq

select 'ALTER SEQUENCE cb.'||sequence_name ||  ' RESTART WITH ' || start_value||';' 
 from information_schema.sequences where sequence_schema='cb'

\copy ( select id,categoryname,categorycode,categorydescription,categorytypeid,externalid,originationcode,now() createddate,1 createduser,activeflag,now() modifieddate,1 modifieduser from category ) to 'category.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select id,typename,typecode,typedescription,externalid,originationcode,now() createddate,1 createduser,activeflag,now() modifieddate,1 modifieduser from categorytype  ) to 'categorytype.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select * from category

\COPY categorytype FROM 'categorytype.csv' DELIMITER ',' CSV HEADER ; 
\COPY category FROM 'category.csv' DELIMITER ',' CSV HEADER ; 


-----cb.programfieldcontrol 
\copy (select * from cb.programfieldcontrol ) to 'programfieldcontrol.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select * from information_schema.columns where  column_name  ilike '%operatio%'

select * from operationaltestwindow;
begin;

INSERT INTO public.operationaltestwindow( windowname, effectivedate, expirydate, modifieddate, createduser, 
            modifieduser, suspendwindow, activeflag, createddate, testenrollmentflag, 
            assessmentprogramid, testenrollmentmethodid, autoenrollmentflag, 
            scoringwindowflag, scoringwindowid, scoringwindowstartdate, scoringwindowenddate)
select 'compass-2018' windowname,now() effectivedate,'2030-12-31' expirydate,now()  modifieddate,a.id createduser, 
            a.id modifieduser,false suspendwindow,true activeflag,now() createddate,null testenrollmentflag, 
            1 assessmentprogramid,null testenrollmentmethodid,null autoenrollmentflag, 
            false scoringwindowflag,null scoringwindowid,null scoringwindowstartdate,null scoringwindowenddate 
            from aartuser a where username='cetesysadmin' 
            and not exists (select 1 from operationaltestwindow where 'compass-2018'=windowname) limit 1;


update  operationaltestwindow 
set    assessmentprogramid =1
where windowname='compass-2018'; 

select * from operationaltestwindowstestcollections   

-- insert into operationaltestwindowstestcollections (operationaltestwindowid,testcollectionid,createduser,createddate,modifieduser,modifieddate)
-- select  operationaltestwindowid,testcollectionid,createduser,createddate,modifieduser,modifieddate from operationaltestwindowstestcollections;

select * from operationaltestwindowstestcollections ;

insert into operationaltestwindowstestcollections
select 1,6,1,now(),1,now(),true;
insert into operationaltestwindowstestcollections
select 1,7,1,now(),1,now(),true;

select * from operationaltestwindowstestcollections tgt 
inner join testcollection tc on tgt.testcollectionid=tc.id
inner join testcollectiontests tct on tct.testcollectionid=tc.id
inner join test t on t.id=tct.testid
where tc.activeflag is true 
select * from testcollection ;

select * from operationaltestwindow  

insert into operationaltestwindowstestcollections
select 1,tc.id,1,now(),1,now(),true from testcollection tc  where externalid in (
2
,3
,8
,9
,10
,11
,12
,13
,14
,15
,16
,17
,18
,19
,20
,21
,22
,23
,24
,25
,26
,27
,28
,29
,30
,31
,32
,33
,34
,35
,36
,37
,38
,39
,40
,41
,42
,43
,44
,45
)
and not exists (select 1 from operationaltestwindowstestcollections tgt where tgt.testcollectionid=tc.id);

commit;

CREATE temp TABLE tmp_programfieldcontrol
(
  fieldcontrolid bigserial NOT NULL,
  organizationid bigint,
  organizationname character varying(100),
  fieldnameid character varying(100),
  fieldname character varying(40),
  defaultvalueid character varying(50),
  defaultvalue character varying(100),
  screenname character varying(20),
  objecttype character varying(100),
  objectsubtype character varying(100),
  mandatory boolean,
  hidden boolean,
  contenttype character varying(20),
  inputtype character varying(50),
  createdate timestamp with time zone,
  modifieddate timestamp with time zone,
  createuserid bigint,
  modifieduserid bigint,
  createusername character varying(100),
  modifiedusername character varying(100),
  configurable character varying(100),
  elementid character varying(100));

\COPY tmp_programfieldcontrol FROM 'programfieldcontrol.csv' DELIMITER ',' CSV HEADER ;

INSERT INTO cb.programfieldcontrol(
             organizationid, organizationname, fieldnameid, 
            fieldname, defaultvalueid, defaultvalue, screenname, objecttype, 
            objectsubtype, mandatory, hidden, contenttype, inputtype, createdate, 
            modifieddate, createuserid, modifieduserid, createusername, modifiedusername, 
            configurable, elementid)
 select  182635 organizationid,'The Institute' organizationname, fieldnameid, 
            fieldname, defaultvalueid, defaultvalue, screenname, objecttype, 
            objectsubtype, mandatory, hidden, contenttype, inputtype,now() createdate, 
            modifieddate, createuserid, modifieduserid, createusername, modifiedusername, 
            configurable, elementid from tmp_programfieldcontrol where organizationname='KAP';


/*
truncate table cb.lmfailedtaskreconciliation CASCADE;
truncate table cb.testlettaskvariant CASCADE;
truncate table cb.testlettaskvariantrevision CASCADE;
truncate table cb.testlettestdevelopment CASCADE;
truncate table cb.testletshare CASCADE;
truncate table cb.testlettag CASCADE;
truncate table cb.lmattributetypedifference CASCADE;
truncate table cb.lmattributetyperule CASCADE;
truncate table cb.lmmicromapattributetype CASCADE;
truncate table cb.lmmicromapdifference CASCADE;
truncate table cb.lmmicromaplinkagelevel CASCADE;
truncate table cb.lmnodeattribute CASCADE;
truncate table cb.lmnodecomment CASCADE;
truncate table cb.organizationlmframeworktype CASCADE;
truncate table cb.lmnodedifference CASCADE;
truncate table cb.lmnode CASCADE;
truncate table cb.lmpublishedattributetype CASCADE;
truncate table cb.lmpublishedcontentarea CASCADE;
truncate table cb.lmpublishedmicromap CASCADE;
truncate table cb.accessibilityfile CASCADE;
truncate table cb.accessibilityfiletype CASCADE;
truncate table cb.accesspopulation CASCADE;
truncate table cb.lmuserfilter CASCADE;
truncate table cb.accommodationtype CASCADE;
truncate table cb.alternatepathway CASCADE;
truncate table cb.archiveunarchivereason CASCADE;
truncate table cb.testpanel CASCADE;
truncate table cb.lmoption CASCADE;
truncate table cb.lmpublishedattribute CASCADE;
truncate table cb.lmpublishedmicromapattributetype CASCADE;
truncate table cb.lmdatatype CASCADE;
truncate table cb.attachmentinformation CASCADE;
truncate table cb.attachmentmetadata CASCADE;
truncate table cb.autoreuploaditpitems CASCADE;
truncate table cb.brailletype CASCADE;
truncate table cb.browseroptions CASCADE;
truncate table cb.cognitivetaxonomy CASCADE;
truncate table cb.cognitivetaxonomydimension CASCADE;
truncate table cb.compositionpercentage CASCADE;
truncate table cb.contentarea CASCADE;
truncate table cb.contentdeployment CASCADE;
truncate table cb.contentdeploymentstage CASCADE;
truncate table cb.compositemedia CASCADE;
truncate table cb.brailleaccommodation CASCADE;
truncate table cb.contentframework CASCADE;
truncate table cb.contentframeworkcorrespondence CASCADE;
truncate table cb.contentframeworkdetail CASCADE;
truncate table cb.contentframeworkmapping CASCADE;
truncate table cb.downloadstatus CASCADE;
truncate table cb.errormessage CASCADE;
truncate table cb.findandreplace CASCADE;
truncate table cb.findandreplace_copy CASCADE;
truncate table cb.findandreplacegroup CASCADE;
truncate table cb.frameworklevel CASCADE;
truncate table cb.frameworktype CASCADE;
truncate table cb.gradecourse CASCADE;
truncate table cb.itemspecsdefinitiontypes CASCADE;
truncate table cb.lmassessmentmodelrule CASCADE;
truncate table cb.lmattribute CASCADE;
truncate table cb.lmattributetype CASCADE;
truncate table cb.lmchangeinfo CASCADE;
truncate table cb.lmcontentareadifference CASCADE;
truncate table cb.lmmicromap CASCADE;
truncate table cb.lmpublishedmicromaplinkagelevel CASCADE;
truncate table cb.lmpublishednode CASCADE;
truncate table cb.lmpublishednodeattribute CASCADE;
truncate table cb.lmpublishedview CASCADE;
truncate table cb.lmpublishedviewlayer CASCADE;
truncate table cb.lmpublishedviewnode CASCADE;
truncate table cb.lmpublishedviewpath CASCADE;
truncate table cb.lmrule CASCADE;
truncate table cb.lmusercolor CASCADE;
truncate table cb.lmversion CASCADE;
truncate table cb.lmview CASCADE;
truncate table cb.lmviewlayer CASCADE;
truncate table cb.lmviewnode CASCADE;
truncate table cb.lmviewpath CASCADE;
truncate table cb.lmviewprofile CASCADE;
truncate table cb.mathematicalpractice CASCADE;
truncate table cb.media CASCADE;
truncate table cb.mediacontentarea CASCADE;
truncate table cb.mediacontentareavers CASCADE;
truncate table cb.mediaformat CASCADE;
truncate table cb.mediagradecourse CASCADE;
truncate table cb.mediagradecoursevers CASCADE;
truncate table cb.mediashare CASCADE;
truncate table cb.mediatag CASCADE;
truncate table cb.mediatagvers CASCADE;
truncate table cb.mediatestingprogram CASCADE;
truncate table cb.mediatestprogvers CASCADE;
truncate table cb.mediatype CASCADE;
truncate table cb.mediavarianttagvers CASCADE;
truncate table cb.mediaversion CASCADE;
truncate table cb.multiparttask CASCADE;
truncate table cb.nodeweight CASCADE;
truncate table cb.organizationtype CASCADE;
truncate table cb.panel CASCADE;
truncate table cb.paneluser CASCADE;
truncate table cb.programfieldcontrol CASCADE;
truncate table cb.qtiexportfile CASCADE;
truncate table cb.qtiimportfile CASCADE;
truncate table cb.qtitestformplanner CASCADE;
truncate table cb.readabilityguideline CASCADE;
truncate table cb.readaloudtype CASCADE;
truncate table cb.reviewcollection CASCADE;
truncate table cb.reviewcollectionpanel CASCADE;
truncate table cb.reviewcollectionpaneluser CASCADE;
truncate table cb.reviewmanagementassignment CASCADE;
truncate table cb.reviewtype CASCADE;
truncate table cb.reviewtypecategory CASCADE;
truncate table cb.reviewtypedetail CASCADE;
truncate table cb.scaffoldstatistic CASCADE;
truncate table cb.signedtype CASCADE;
truncate table cb.statementofpurpose CASCADE;
truncate table cb.status CASCADE;
truncate table cb.stimulustag CASCADE;
truncate table cb.systemrecord CASCADE;
truncate table cb.systemrecordattribute CASCADE;
truncate table cb.systemrecorddependent CASCADE;
truncate table cb.systemrecordsyncorder CASCADE;
truncate table cb.systemselectoption CASCADE;
truncate table cb.task CASCADE;
truncate table cb.taskcontentframeworkdetails CASCADE;
truncate table cb.taskcontentframeworkdetailsversion CASCADE;
truncate table cb.taskdifficulty CASCADE;
truncate table cb.tasklayout CASCADE;
truncate table cb.tasklayoutformat CASCADE;
truncate table cb.taskmathematicalpractice CASCADE;
truncate table cb.taskrevision CASCADE;
truncate table cb.taskscontentframeworkcorrespondence CASCADE;
truncate table cb.taskscontentframeworkcorrespondenceversion CASCADE;
truncate table cb.taskshare CASCADE;
truncate table cb.taskstimulustag CASCADE;
truncate table cb.taskstools CASCADE;
truncate table cb.tasksubtype CASCADE;
truncate table cb.tasktype CASCADE;
truncate table cb.taskvariantcommentrevision CASCADE;
truncate table cb.taskvariantitemusagerevision CASCADE;
truncate table cb.taskvariantlearningmapnoderevision CASCADE;
truncate table cb.taskvariantresponserevision CASCADE;
truncate table cb.taskvariantrevision CASCADE;
truncate table cb.taskvariantstimulustagrevision CASCADE;
truncate table cb.testblueprint CASCADE;
truncate table cb.testblueprintcontentbalance CASCADE;
truncate table cb.testblueprintlevelinfo CASCADE;
truncate table cb.testblueprintminlevelinfo CASCADE;
truncate table cb.testblueprinttaskproperties CASCADE;
truncate table cb.testcollection CASCADE;
truncate table cb.testformat CASCADE;
truncate table cb.testingprogram CASCADE;
truncate table cb.testlet CASCADE;
truncate table cb.testletcomment CASCADE;
truncate table cb.testletmanageusage CASCADE;
truncate table cb.testletrevision CASCADE;
truncate table cb.testletsensitivitytag CASCADE;
truncate table cb.testpanelstage CASCADE;
truncate table cb.testpanelstagetestcollection CASCADE;
truncate table cb.testpopulation CASCADE;
truncate table cb.testpublishfailurereason CASCADE;
truncate table cb.testsection CASCADE;
truncate table cb.testsectionstools CASCADE;
truncate table cb.testspecconstruct CASCADE;
truncate table cb.testspecification CASCADE;
truncate table cb.testspecitemdifficulty CASCADE;
truncate table cb.testspeclevelinfo CASCADE;
truncate table cb.testspecpart CASCADE;
truncate table cb.testspecscognitivedimensions CASCADE;
truncate table cb.testspecsection CASCADE;
truncate table cb.testspecsectionconstruct CASCADE;
truncate table cb.testspecselectionstatistic CASCADE;
truncate table cb.testspecsreadguidelines CASCADE;
truncate table cb.testspecstatementofpurpose CASCADE;
truncate table cb.testspecstools CASCADE;
truncate table cb.testspecthetanode CASCADE;
truncate table cb.testspectypeofreporting CASCADE;
truncate table cb.tool CASCADE;
truncate table cb.tooltype CASCADE;
truncate table cb.typeofreporting CASCADE;
truncate table cb.udruploadstatus CASCADE;
truncate table cb.varianttype CASCADE;
truncate table cb.textaccommodation CASCADE;
truncate table cb.mediavariant CASCADE;
truncate table cb.taskvariant CASCADE;
truncate table cb.testdevelopment CASCADE;
truncate table cb.contentgroup CASCADE;
truncate table cb.itemstatistic CASCADE;
truncate table cb.mediaaccessproperties CASCADE;
truncate table cb.mediadescriptionview CASCADE;
truncate table cb.mediavariantattachment CASCADE;
truncate table cb.mediavariantcomment CASCADE;
truncate table cb.mediavariantshare CASCADE;
truncate table cb.mediavarianttag CASCADE;
truncate table cb.mediavariantversion CASCADE;
truncate table cb.multiparttaskvariant CASCADE;
truncate table cb.qtiimportitemdetail CASCADE;
truncate table cb.reviewcollectionitem CASCADE;
truncate table cb.reviewcollectionpaneluseritem CASCADE;
truncate table cb.rubriccategory CASCADE;
truncate table cb.taskvariantcomment CASCADE;
truncate table cb.taskvariantitemusage CASCADE;
truncate table cb.taskvariantlearningmapnode CASCADE;
truncate table cb.taskvariantmediavariant CASCADE;
truncate table cb.taskvariantmediavariantrevision CASCADE;
truncate table cb.taskvariantresponse CASCADE;
truncate table cb.taskvariantresponsemediavariant CASCADE;
truncate table cb.taskvariantresponsemediavariantrevision CASCADE;
truncate table cb.taskvariantsenemies CASCADE;
truncate table cb.taskvariantstimulustag CASCADE;
truncate table cb.taskvariantworkhistory CASCADE;
truncate table cb.testdevelopmentaccessibilityflag CASCADE;
truncate table cb.testdevelopmentfeedbackrules CASCADE;
truncate table cb.testdevelopmentsectiontask CASCADE;
truncate table cb.testdevelopmenttestsection CASCADE;
truncate table cb.testdevelopmenttestsectionresource CASCADE;
truncate table cb.testletmediavariant CASCADE;
truncate table cb.testletmediavariantrevision CASCADE;
truncate table cb.testpanelscoring CASCADE;
truncate table cb.testpanelstagemapping CASCADE;
truncate table cb.testpriorparameter CASCADE;
truncate table cb.contentgroupaccommodation CASCADE;
truncate table cb.multiparttaskvariantrevision CASCADE;
truncate table cb.readaloudaccommodation CASCADE;
truncate table cb.reviewcollectionpaneluseritemattribute CASCADE;
truncate table cb.rubricinfo CASCADE;
truncate table cb.signedaccommodation CASCADE;
truncate table cb.testdevelopmentsectionnavigationrule CASCADE;
truncate table cb.testdevelopmentsectionreentryrule CASCADE;

select distinct table_name from  information_schema.tables  where table_type='BASE TABLE'  and table_schema='cb'
and table_name in (
'lmmicromapattributetype'
,'lmnodeattribute'
,'lmnodecomment'
,'lmpublishedmicromapattributetype'
,'lmpublishedviewnode'
,'lmviewnode'
,'brailleaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'contentgroupaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'testpanelscoring'
,'testpanelstage'
,'testpanelstagemapping'
,'testpanelstagetestcollection'
,'lmattributetype'
,'lmpublishedattributetype'
,'lmattributetypedifference'
,'lmattributetyperule'
,'lmmicromapattributetype'
,'lmmicromaplinkagelevel'
,'lmoption'
,'lmpublishedattribute'
,'lmpublishedmicromapattributetype'
,'lmpublishedmicromaplinkagelevel'
,'attachmentmetadata'
,'mediavariantattachment'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'contentframework'
,'gradecourse'
,'mediacontentarea'
,'mediacontentareavers'
,'task'
,'taskrevision'
,'testcollection'
,'testlet'
,'testpanel'
,'frameworklevel'
,'mediagradecourse'
,'mediagradecoursevers'
,'multiparttask'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'testdevelopment'
,'testdevelopmentsectiontask'
,'testletcomment'
,'testletmanageusage'
,'testletmediavariant'
,'testletmediavariantrevision'
,'testletsensitivitytag'
,'testletshare'
,'testlettag'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testlettestdevelopment'
,'testpanelscoring'
,'testpanelstage'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'reviewcollectionpaneluseritemattribute'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmenttestsectionresource'
,'textaccommodation'
,'contentdeployment'
,'task'
,'taskrevision'
,'taskscontentframeworkcorrespondence'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'contentframeworkmapping'
,'lmassessmentmodelrule'
,'taskcontentframeworkdetails'
,'testblueprintminlevelinfo'
,'testspeclevelinfo'
,'testblueprintcontentbalance'
,'testblueprinttaskproperties'
,'findandreplace'
,'contentframework'
,'frameworklevel'
,'organizationlmframeworktype'
,'task'
,'taskrevision'
,'taskshare'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'contentframework'
,'frameworklevel'
,'mediagradecourse'
,'mediagradecoursevers'
,'task'
,'taskrevision'
,'testcollection'
,'testlet'
,'testpanel'
,'multiparttask'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'testdevelopment'
,'testdevelopmentsectiontask'
,'testletcomment'
,'testletmanageusage'
,'testletmediavariant'
,'testletmediavariantrevision'
,'testletsensitivitytag'
,'testletshare'
,'testlettag'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testlettestdevelopment'
,'testpanelscoring'
,'testpanelstage'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'reviewcollectionpaneluseritemattribute'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmenttestsectionresource'
,'textaccommodation'
,'lmattributetypedifference'
,'lmattributetyperule'
,'lmmicromapattributetype'
,'lmmicromaplinkagelevel'
,'lmoption'
,'lmpublishedattribute'
,'lmpublishedattributetype'
,'lmpublishedmicromapattributetype'
,'lmpublishedmicromaplinkagelevel'
,'lmmicromapattributetype'
,'lmmicromapdifference'
,'lmmicromaplinkagelevel'
,'lmpublishedmicromapattributetype'
,'lmpublishedmicromaplinkagelevel'
,'lmpublishednodeattribute'
,'lmattributetyperule'
,'lmattributetypedifference'
,'lmcontentareadifference'
,'lmmicromapdifference'
,'lmnodedifference'
,'lmpublishedattribute'
,'lmpublishedattributetype'
,'lmpublishedcontentarea'
,'lmpublishednode'
,'lmpublishednodeattribute'
,'lmviewlayer'
,'lmviewnode'
,'lmviewpath'
,'taskmathematicalpractice'
,'mediacontentarea'
,'mediacontentareavers'
,'mediagradecourse'
,'mediagradecoursevers'
,'mediashare'
,'mediatag'
,'mediatagvers'
,'mediatestingprogram'
,'mediatestprogvers'
,'mediavariant'
,'mediaversion'
,'compositemedia'
,'contentgroup'
,'mediaaccessproperties'
,'mediadescriptionview'
,'mediavariantattachment'
,'mediavariantcomment'
,'mediavariantshare'
,'mediavarianttag'
,'mediavariantversion'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'testdevelopmenttestsectionresource'
,'testletmediavariant'
,'testletmediavariantrevision'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'textaccommodation'
,'media'
,'mediatype'
,'mediacontentarea'
,'mediacontentareavers'
,'mediagradecourse'
,'mediagradecoursevers'
,'mediashare'
,'mediatag'
,'mediatagvers'
,'mediatestingprogram'
,'mediatestprogvers'
,'mediavariant'
,'mediaversion'
,'compositemedia'
,'contentgroup'
,'mediaaccessproperties'
,'mediadescriptionview'
,'mediavariantattachment'
,'mediavariantcomment'
,'mediavariantshare'
,'mediavarianttag'
,'mediavariantversion'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'testdevelopmenttestsectionresource'
,'testletmediavariant'
,'testletmediavariantrevision'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'textaccommodation'
,'media'
,'mediacontentarea'
,'mediacontentareavers'
,'mediagradecourse'
,'mediagradecoursevers'
,'mediashare'
,'mediatag'
,'mediatagvers'
,'mediatestingprogram'
,'mediatestprogvers'
,'mediavariant'
,'mediaversion'
,'compositemedia'
,'contentgroup'
,'mediaaccessproperties'
,'mediadescriptionview'
,'mediavariantattachment'
,'mediavariantcomment'
,'mediavariantshare'
,'mediavarianttag'
,'mediavariantversion'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'testdevelopmenttestsectionresource'
,'testletmediavariant'
,'testletmediavariantrevision'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'textaccommodation'
,'contentgroup'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'taskvariantlearningmapnode'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'taskvariantlearningmapnode'
,'taskvariantlearningmapnoderevision'
,'paneluser'
,'reviewcollectionpanel'
,'reviewcollectionpaneluser'
,'reviewcollectionpaneluseritem'
,'reviewcollectionpaneluseritemattribute'
,'qtiimportitemdetail'
,'qtitestformplanner'
,'reviewcollectionitem'
,'reviewcollectionpanel'
,'reviewcollectionpaneluser'
,'reviewcollectionpaneluseritem'
,'reviewcollectionpaneluseritemattribute'
,'reviewcollectionpaneluser'
,'reviewcollectionpaneluseritem'
,'reviewcollectionpaneluseritemattribute'
,'reviewcollectionpaneluseritem'
,'reviewcollectionpaneluseritemattribute'
,'reviewcollectionpanel'
,'reviewcollectionpaneluser'
,'reviewcollectionpaneluseritem'
,'reviewcollectionpaneluseritemattribute'
,'reviewtypedetail'
,'reviewcollectionpaneluseritemattribute'
,'reviewtypedetail'
,'testspecstatementofpurpose'
,'mediatag'
,'mediatagvers'
,'mediavarianttag'
,'mediavarianttagvers'
,'taskstimulustag'
,'taskvariantstimulustag'
,'taskvariantstimulustagrevision'
,'testlettag'
,'contentdeployment'
,'frameworklevel'
,'organizationtype'
,'readabilityguideline'
,'reviewtype'
,'scaffoldstatistic'
,'systemrecordattribute'
,'systemrecorddependent'
,'taskvariant'
,'testcollection'
,'testletsensitivitytag'
,'testpanel'
,'testpanelstage'
,'testpopulation'
,'testspecification'
,'tooltype'
,'compositionpercentage'
,'contentgroup'
,'itemstatistic'
,'lmassessmentmodelrule'
,'multiparttaskvariant'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'reviewtypedetail'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantresponse'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopment'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'testpanelstagemapping'
,'testpanelstagetestcollection'
,'testspecconstruct'
,'testspecitemdifficulty'
,'testspeclevelinfo'
,'testspecsection'
,'testspecsreadguidelines'
,'testspecstatementofpurpose'
,'testspecstools'
,'testspectypeofreporting'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'multiparttaskvariantrevision'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantresponsemediavariant'
,'testblueprintcontentbalance'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpriorparameter'
,'testsection'
,'testspecpart'
,'testspecsectionconstruct'
,'testspecthetanode'
,'textaccommodation'
,'testblueprinttaskproperties'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'testsectionstools'
,'testspecselectionstatistic'
,'testcollection'
,'testdevelopment'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'textaccommodation'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskrevision'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'task'
,'taskrevision'
,'tasksubtype'
,'multiparttask'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'textaccommodation'
,'taskvariantlearningmapnoderevision'
,'taskvariantresponsemediavariantrevision'
,'multiparttaskvariantrevision'
,'taskvariantcommentrevision'
,'taskvariantitemusagerevision'
,'taskvariantlearningmapnoderevision'
,'taskvariantmediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantstimulustagrevision'
,'taskvariantresponsemediavariantrevision'
,'testblueprintlevelinfo'
,'testblueprintminlevelinfo'
,'testdevelopment'
,'contentgroup'
,'itemstatistic'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'textaccommodation'
,'testblueprinttaskproperties'
,'testdevelopment'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'textaccommodation'
,'mediatestingprogram'
,'mediatestprogvers'
,'task'
,'taskrevision'
,'testcollection'
,'testlet'
,'testpanel'
,'multiparttask'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'taskcontentframeworkdetails'
,'taskmathematicalpractice'
,'taskscontentframeworkcorrespondence'
,'taskshare'
,'taskstimulustag'
,'taskstools'
,'taskvariant'
,'testdevelopment'
,'testdevelopmentsectiontask'
,'testletcomment'
,'testletmanageusage'
,'testletmediavariant'
,'testletmediavariantrevision'
,'testletsensitivitytag'
,'testletshare'
,'testlettag'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testlettestdevelopment'
,'testpanelscoring'
,'testpanelstage'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'multiparttaskvariantrevision'
,'reviewcollectionpaneluseritemattribute'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantresponserevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantlearningmapnoderevision'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmenttestsectionresource'
,'textaccommodation'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'testdevelopmentsectiontask'
,'testletcomment'
,'testletmanageusage'
,'testletmediavariant'
,'testletmediavariantrevision'
,'testletsensitivitytag'
,'testletshare'
,'testlettag'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testlettestdevelopment'
,'reviewcollectionpaneluseritemattribute'
,'testpanelstagemapping'
,'testpanelstagetestcollection'
,'testcollection'
,'testpanel'
,'testdevelopment'
,'testpanelscoring'
,'testpanelstage'
,'testpanelstagetestcollection'
,'contentgroup'
,'itemstatistic'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'textaccommodation'
,'testdevelopmenttestsection'
,'testsectionstools'
,'testspecselectionstatistic'
,'contentgroup'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'textaccommodation'
,'testpriorparameter'
,'testspecsectionconstruct'
,'compositionpercentage'
,'lmassessmentmodelrule'
,'testdevelopment'
,'testspecconstruct'
,'testspecitemdifficulty'
,'testspeclevelinfo'
,'testspecsection'
,'testspecsreadguidelines'
,'testspecstatementofpurpose'
,'testspecstools'
,'testspectypeofreporting'
,'contentgroup'
,'itemstatistic'
,'testblueprintcontentbalance'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'testsection'
,'testspecpart'
,'testspecsectionconstruct'
,'testspecthetanode'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testblueprinttaskproperties'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'testsectionstools'
,'testspecselectionstatistic'
,'textaccommodation'
,'testblueprintcontentbalance'
,'testblueprinttaskproperties'
,'testsection'
,'testspecpart'
,'testspecsectionconstruct'
,'testspecthetanode'
,'testdevelopmenttestsection'
,'testsectionstools'
,'testspecselectionstatistic'
,'contentgroup'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'textaccommodation'
,'testspecselectionstatistic'
,'taskstools'
,'testsectionstools'
,'testspecstools'
,'testspectypeofreporting'
,'mediavariant'
,'taskvariant'
,'testdevelopment'
,'textaccommodation'
,'compositemedia'
,'contentgroup'
,'itemstatistic'
,'mediaaccessproperties'
,'mediadescriptionview'
,'mediavariantattachment'
,'mediavariantcomment'
,'mediavariantshare'
,'mediavarianttag'
,'mediavariantversion'
,'multiparttaskvariant'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponse'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsection'
,'testdevelopmenttestsectionresource'
,'testletmediavariant'
,'testletmediavariantrevision'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'multiparttaskvariantrevision'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testlettestdevelopment'
,'compositemedia'
,'contentgroup'
,'mediaaccessproperties'
,'mediadescriptionview'
,'mediavariantattachment'
,'mediavariantcomment'
,'mediavariantshare'
,'mediavarianttag'
,'mediavariantversion'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantmediavariant'
,'taskvariantmediavariantrevision'
,'taskvariantresponsemediavariant'
,'taskvariantresponsemediavariantrevision'
,'testdevelopmenttestsectionresource'
,'testletmediavariant'
,'testletmediavariantrevision'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'textaccommodation'
,'contentgroup'
,'itemstatistic'
,'multiparttaskvariant'
,'qtiimportitemdetail'
,'reviewcollectionitem'
,'reviewcollectionpaneluseritem'
,'rubriccategory'
,'taskvariantcomment'
,'taskvariantitemusage'
,'taskvariantlearningmapnode'
,'taskvariantmediavariant'
,'taskvariantresponse'
,'taskvariantsenemies'
,'taskvariantstimulustag'
,'taskvariantworkhistory'
,'testdevelopmentsectiontask'
,'testlettaskvariant'
,'testlettaskvariantrevision'
,'testpanelscoring'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'multiparttaskvariantrevision'
,'readaloudaccommodation'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'signedaccommodation'
,'taskvariantresponsemediavariant'
,'textaccommodation'
,'contentgroup'
,'itemstatistic'
,'testdevelopmentaccessibilityflag'
,'testdevelopmentfeedbackrules'
,'testdevelopmenttestsection'
,'testpanelstagemapping'
,'testpriorparameter'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'textaccommodation'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'textaccommodation'
,'multiparttaskvariantrevision'
,'reviewcollectionpaneluseritemattribute'
,'rubricinfo'
,'contentgroup'
,'taskvariantlearningmapnode'
,'taskvariantresponsemediavariant'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'textaccommodation'
,'contentgroup'
,'testdevelopmentsectionnavigationrule'
,'testdevelopmentsectionreentryrule'
,'testdevelopmentsectiontask'
,'testdevelopmenttestsectionresource'
,'testlettestdevelopment'
,'brailleaccommodation'
,'contentgroupaccommodation'
,'readaloudaccommodation'
,'signedaccommodation'
,'textaccommodation') order by 1;



