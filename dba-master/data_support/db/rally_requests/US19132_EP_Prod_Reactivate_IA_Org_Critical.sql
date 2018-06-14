-- US19132: EP Prod: Reactivate IA Org - Critical
-- State: IA
-- District: Colfax-Mingo Comm School District
-- School: Colfax-Mingo Middle School - 501332 418

update organization set activeflag = true, modifieduser = 12, modifieddate = now() where displayidentifier = '501332 418' 
           and organizationname = 'Colfax-Mingo Middle School';
