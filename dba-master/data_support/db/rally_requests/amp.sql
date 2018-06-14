SELECT
      s.statestudentidentifier AS "statestudentidentifier",
      CASE
        WHEN s.comprehensiverace = '1' THEN 'White'
        WHEN s.comprehensiverace = '3' THEN 'African American'
        WHEN s.comprehensiverace = '4' THEN 'Asian'
        WHEN s.comprehensiverace = '5' THEN 'American Indian'
        WHEN s.comprehensiverace = '6' THEN 'Alaska Native'
        WHEN s.comprehensiverace = '7' THEN 'Two or More Races'
        WHEN s.comprehensiverace = '8' THEN 'Native Hawaiian or Pacific islander'
        ELSE ''
      END AS "race",
      s.hispanicethnicity AS "hispanicethnicity",
      CASE WHEN s.gender = 0 THEN 'Female'
           ELSE 'Male'
      END AS "gender",
      s.esolparticipationcode AS "esol",
      s.primarydisabilitycode AS "primarydisabilitycode",
      ca.abbreviatedname AS "contentareaname",
      gc.abbreviatedname AS "grade",
      osch.organizationname AS "attendanceschool",
      odt.organizationname AS "districtname",
      ost.organizationname AS "statename",
      sr.scalescore AS "scalescore",
      array_to_string(array_agg(distinct(CASE WHEN ta.attrvalue ilike '%Windows%' THEN 'Windows'
                                              WHEN ta.attrvalue ilike '%Macintosh%' THEN 'Mac'
                                              WHEN ta.attrvalue ilike '%TDE-ChromeAgent%' THEN 'Chromebook'
                                              WHEN ta.attrvalue ilike '%TDE-IPADAgent%' THEN 'iPad'
                                              e
                                              END)),
                                     ',') osbrowser
      --INTO temp table tmp_amp_2015
      FROM studentreport sr
      JOIN student s ON (sr.studentid = s.id)
      JOIN contentarea ca ON (sr.contentareaid = ca.id)
      JOIN gradecourse gc ON (sr.gradeid = gc.id)
      JOIN organization osch ON (sr.attendanceschoolid = osch.id)
      JOIN organization odt ON (sr.districtid = odt.id)
      JOIN organization ost ON (sr.stateid = ost.id)
      JOIN studentstests st ON (s.id = st.studentid)
      JOIN studentstestsections sts ON (sts.studentstestid = st.id)
      LEFT JOIN tde_tracker t ON (t.typecode = CAST (sts.id AS text))
      LEFT JOIN tde_tracker_attrs ta ON (ta.trackerid = t.id AND t.goaltype = 'Os-Browser')
      WHERE sr.schoolyear = 2015 AND sr.assessmentprogramid = 37 and  ca.abbreviatedname in ('ELA','M') AND s.statestudentidentifier = '183063'
      GROUP BY  s.statestudentidentifier ,
          		  s.comprehensiverace ,
          		  s.hispanicethnicity ,
          		  s.gender,
          		  s.esolparticipationcode ,
          		  s.primarydisabilitycode ,
          		  ca.abbreviatedname ,
                gc.abbreviatedname,
          		  osch.organizationname ,
                odt.organizationname ,
                ost.organizationname ,
          		  sr.scalescore
      ORDER BY 	s.statestudentidentifier,
                ca.abbreviatedname ;
