create temp table tmp_table ("State" text ,
"District" text ,
"School" text ,
"Student Last Name" text ,
"Student First Name" text ,
"Student Middle Initial" text ,
"Grade Level" text ,
"Student State ID" text ,
"Student Local ID" text ,
"DLM Student" text ,
"Last Modified Time" text ,
"Last Modified By" text ,
"Display - Magnification" text ,
"Display - Magnification Activate by Default" text ,
"Display - Magnification Setting" text ,
"Display - Overlay Color" text ,
"Display - Overlay Color Activate by Default" text ,
"Display - Overlay Color Code" text ,
"Display - Overlay Color Desc" text ,
"Display - Invert Color Choice" text ,
"Display - Invert Color Choice Activate By Default" text ,
"Display - Masking" text ,
"Display - Masking Activate by Default" text ,
"Display - Masking Setting" text ,
"Display - Contrast Color" text ,
"Display - Contrast Color Activate by Default" text ,
"Display - Contrast Color Background" text ,
"Display - Contrast Color Background Desc" text ,
"Display - Contrast Color Foreground" text ,
"Display - Contrast Color Foreground Desc" text ,
"Language - Item Translation Display" text ,
"Language - Item Translation Display Activate by Default" text ,
"Language - Item Translation Display Setting" text ,
"Language - Signing Type" text ,
"Language - Signing Type Activate by Default" text ,
"Language - Signing Type Setting" text ,
"Language - Braille" text ,
"Language - Braille Activate by Default" text ,
"Language - Braille Usage" text ,
"Language - Keyword Translation Display" text ,
"Language - Keyword Translation Display Activate by Default" text ,
"Language - Keyword Translation Display Setting" text ,
"Language - Tactile" text ,
"Language - Tactile Activate by Default" text ,
"Language - Tactile Setting" text ,
"Auditory - Auditory Background" text ,
"Auditory - Auditory Background Activate by Default" text ,
"Auditory - Auditory Background Breaks" text ,
"Auditory - Auditory Background Additional Testing Time" text ,
"Auditory - Auditory Background Additional Testing Time Activate by Default" text ,
"Auditory - Auditory Background Additional Testing Time Multiplier setting" text ,
"Auditory - Spoken Audio" text ,
"Auditory - Spoken Audio Activate by Default" text ,
"Auditory - Spoken Audio Voice Source Setting" text ,
"Auditory - Spoken Audio Voice Read at Start" text ,
"Auditory - Spoken Audio Spoken Preference Setting" text ,
"Auditory - Audio Directions Only" text ,
"Auditory - Spoken Audio Subject Setting" text ,
"Auditory - Switches" text ,
"Auditory - Switches Activate by Default" text ,
"Auditory - Switches Scan Speed Seconds" text ,
"Auditory - Switches Scan Initial Delay Setting Seconds" text ,
"Auditory - Switches Automatic Scan Repeat Frequency" text ,
"Other Supports - Separate, quiet, or individual setting" text ,
"Other Supports - Presentation Student reads assessment aloud to self" text ,
"Other Supports - Presentation Student Used Translation dictionary" text ,
"Other Supports - Presentation Other Accommodation Used" text ,
"Other Supports - Response - Student dictated answers to scribe" text ,
"Other Supports - Response - Student used a communication device" text ,
"Other Supports - Response - Student signed responses" text ,
"Other Supports - Provided by Alternate Form - Visual Impairment" text ,
"Other Supports - Provided by Alternate Form - Large Print" text ,
"Other Supports - Provided by Alternate Form - Paper and Pencil" text ,
"Other Supports - Requiring Additional Tools Two Switch System" text ,
"Other Supports - Requiring Additional Tools Administration via iPad" text ,
"Other Supports - Requiring Additional Tools Adaptive equipment" text ,
"Other Supports - Requiring Additional Tools Individualized manipulatives" text ,
"Other Supports - Requiring Additional Tools Calculator" text ,
"Other Supports - Provided outside system - Human read aloud" text ,
"Other Supports - Provided outside system - Sign Intrepretation" text ,
"Other Supports - Provided outside system - Translation" text ,
"Other Supports - Provided outside system - Test admin enters responses for student" text ,
"Other Supports - Provided outside system - Partner assisted scanning" text ,
"Other Supports - Provided outside system - Student provided non-embedded accommodations as noted in IEP" text);



\COPY tmp_table FROM 'pnp.csv' DELIMITER ',' CSV HEADER ;


alter table tmp_table add ela text;
alter table tmp_table add math text;
alter table tmp_table add sci text;
alter table tmp_table add test_grade text;

--2017 10172,10174
 update  tmp_table tmp
 set ela='ELA'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10172,10174)and categorycode ~* 'complete' and tc.contentareaid=3
  and tmp."Student State ID"=s.statestudentidentifier;


 update  tmp_table tmp
 set math='math'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
   inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10172,10174) and categorycode ~* 'complete' and tc.contentareaid=440
  and tmp."Student State ID"=s.statestudentidentifier;

 update  tmp_table tmp
 set sci='sci'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10172,10174) and categorycode ~* 'complete' and tc.contentareaid=441
  and tmp."Student State ID"=s.statestudentidentifier;

   update  tmp_table tmp
 set test_grade=gc.abbreviatedname
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status
  inner join gradecourse gc on gc.id=tc.gradecourseid 
  where ts.operationaltestwindowid in (10172,10174) and categorycode ~* 'complete' 
  and tmp."Student State ID"=s.statestudentidentifier;

\COPY (select * from tmp_table) to 'pnp_2017.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--2016 10131,10132,10133

\COPY tmp_table FROM 'pnp.csv' DELIMITER ',' CSV HEADER ;


alter table tmp_table add ela text;
alter table tmp_table add math text;
alter table tmp_table add sci text;
alter table tmp_table add test_grade text;

 update  tmp_table tmp
 set ela='ELA'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10131,10132,10133)and categorycode ~* 'complete' and tc.contentareaid=3
  and tmp."Student State ID"=s.statestudentidentifier;


 update  tmp_table tmp
 set math='math'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
   inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10131,10132,10133) and categorycode ~* 'complete' and tc.contentareaid=440
  and tmp."Student State ID"=s.statestudentidentifier;

   update  tmp_table tmp
 set sci='sci'
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status 
  where ts.operationaltestwindowid in (10131,10132,10133) and categorycode ~* 'complete' and tc.contentareaid=441
  and tmp."Student State ID"=s.statestudentidentifier;

   update  tmp_table tmp
 set test_grade=gc.abbreviatedname
  from studentstests st 
  inner join testsession ts on ts.id =st.testsessionid
  inner join student s on s.id=st.studentid
  inner join testcollection tc on tc.id=st.testcollectionid
  inner join category c on c.id=st.status
  inner join gradecourse gc on gc.id=tc.gradecourseid 
  where ts.operationaltestwindowid in (10131,10132,10133) and categorycode ~* 'complete' 
  and tmp."Student State ID"=s.statestudentidentifier;

\COPY (select * from tmp_table) to 'pnp_2016.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


