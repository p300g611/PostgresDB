---==========================================================================================
--steps need follow for User story US17131 (Please move the school organizations listed in the attached file from their current district (NONPUBLIC SCHOOL - 000000000008) to new district (BOCES - 000000000009))
--step1: validate the list records need to update--count should be 38 records matches to excel
--step2: update the schooldistric id 69354 to 69355 on organizationrelation table 
--step3: validate the receods after update----count 38 records
--===========================================================================================

---==========================================================================================
--step1: validate the list records need to update--count should be 38 records matches to excel
--===========================================================================================
 select id
      ,org.organizationname
      ,org.displayidentifier
	  ,org.organizationtypeid
	  ,(select organizationname from organization_parent(org.id) where organizationtypeid=5 limit 1) district_name
      ,(select displayidentifier from organization_parent(org.id) where organizationtypeid=5 limit 1) district_display_identifier 
	  ,(select id from organization_parent(org.id) where organizationtypeid=5 limit 1) district_display_id
	   from organization org
           where(org.organizationname='BROOME-DELAWARE-TIOGA BOCES' and org.displayidentifier ='039000000000') or
				(org.organizationname='CAPITAL REGION BOCES' and org.displayidentifier ='019000000000') or
				(org.organizationname='CATTAR-ALLEGANY-ERIE-WYOMING BOCES' and org.displayidentifier ='049000000000') or
				(org.organizationname='CAYUGA-ONONDAGA BOCES' and org.displayidentifier ='059000000000') or
				(org.organizationname='CLINTON-ESSEX-WARREN-WASHING BOCES' and org.displayidentifier ='099000000000') or
				(org.organizationname='DELAW-CHENANGO-MADISON-OTSEGO BOCES' and org.displayidentifier ='129000000000') or
				(org.organizationname='DUTCHESS BOCES' and org.displayidentifier ='139000000000') or
				(org.organizationname='EASTERN SUFFOLK BOCES' and org.displayidentifier ='589100000000') or
				(org.organizationname='ERIE 1 BOCES' and org.displayidentifier ='149100000000') or
				(org.organizationname='ERIE 2-CHAUTAUQUA-CATTARAUGUS BOCES' and org.displayidentifier ='149200000000') or
				(org.organizationname='FRANKLIN-ESSEX-HAMILTON BOCES' and org.displayidentifier ='169000000000') or
				(org.organizationname='GENESEE VALLEY BOCES' and org.displayidentifier ='249000000000') or
				(org.organizationname='GREATER SOUTHERN TIER BOCES' and org.displayidentifier ='559000000000') or
				(org.organizationname='HAMILTON-FULTON-MONTGOMERY BOCES' and org.displayidentifier ='209000000000') or
				(org.organizationname='HERK-FULTON-HAMILTON-OTSEGO BOCES' and org.displayidentifier ='219000000000') or
				(org.organizationname='JEFFER-LEWIS-HAMIL-HERK-ONEIDA BOCES' and org.displayidentifier ='229000000000') or
				(org.organizationname='MADISON-ONEIDA BOCES' and org.displayidentifier ='259000000000') or
				(org.organizationname='MONROE 1 BOCES' and org.displayidentifier ='269100000000') or
				(org.organizationname='MONROE 2-ORLEANS BOCES' and org.displayidentifier ='269200000000') or
				(org.organizationname='NASSAU BOCES' and org.displayidentifier ='289000000000') or
				(org.organizationname='ONEIDA-HERKIMER-MADISON BOCES' and org.displayidentifier ='419000000000') or
				(org.organizationname='ONONDAGA-CORTLAND-MADISON BOCES' and org.displayidentifier ='429000000000') or
				(org.organizationname='ORANGE-ULSTER BOCES' and org.displayidentifier ='449000000000') or
				(org.organizationname='ORLEANS-NIAGARA BOCES' and org.displayidentifier ='459000000000') or
				(org.organizationname='OSWEGO BOCES' and org.displayidentifier ='469000000000') or
				(org.organizationname='OTSEGO-DELAW-SCHOHARIE-GREENE BOCES' and org.displayidentifier ='199000000000') or
				(org.organizationname='PUTNAM-NORTHERN WESTCHESTER BOCES' and org.displayidentifier ='489000000000') or
				(org.organizationname='QUESTAR III (R-C-G) BOCES' and org.displayidentifier ='499000000000') or
				(org.organizationname='ROCKLAND BOCES' and org.displayidentifier ='509000000000') or
				(org.organizationname='ST LAWRENCE-LEWIS BOCES' and org.displayidentifier ='519000000000') or
				(org.organizationname='SULLIVAN BOCES' and org.displayidentifier ='599000000000') or
				(org.organizationname='TOMPKINS-SENECA-TIOGA BOCES' and org.displayidentifier ='619000000000') or
				(org.organizationname='ULSTER BOCES' and org.displayidentifier ='629000000000') or
				(org.organizationname='WASHING-SARA-WAR-HAMLTN-ESSEX BOCES' and org.displayidentifier ='649000000000') or
				(org.organizationname='WAYNE-FINGER LAKES BOCES' and org.displayidentifier ='439000000000') or
				(org.organizationname='WESTCHESTER BOCES' and org.displayidentifier ='669000000000') or
				(org.organizationname='WESTERN SUFFOLK BOCES' and org.displayidentifier ='589300000000') or
				(org.organizationname='TECH VALLEY HIGH SCHOOL' and org.displayidentifier ='499000000801') ;


---==========================================================================================
--step2: update the schooldistric id 69354 to 69355 on organizationrelation table 
--===========================================================================================
begin;
update  organizationrelation
set parentorganizationid=69355,
    modifieddate=now(),
	modifieduser=12
   where organizationid   in ( select org.id  from organization org
								  where(org.organizationname='BROOME-DELAWARE-TIOGA BOCES' and org.displayidentifier ='039000000000') or
									(org.organizationname='CAPITAL REGION BOCES' and org.displayidentifier ='019000000000') or
									(org.organizationname='CATTAR-ALLEGANY-ERIE-WYOMING BOCES' and org.displayidentifier ='049000000000') or
									(org.organizationname='CAYUGA-ONONDAGA BOCES' and org.displayidentifier ='059000000000') or
									(org.organizationname='CLINTON-ESSEX-WARREN-WASHING BOCES' and org.displayidentifier ='099000000000') or
									(org.organizationname='DELAW-CHENANGO-MADISON-OTSEGO BOCES' and org.displayidentifier ='129000000000') or
									(org.organizationname='DUTCHESS BOCES' and org.displayidentifier ='139000000000') or
									(org.organizationname='EASTERN SUFFOLK BOCES' and org.displayidentifier ='589100000000') or
									(org.organizationname='ERIE 1 BOCES' and org.displayidentifier ='149100000000') or
									(org.organizationname='ERIE 2-CHAUTAUQUA-CATTARAUGUS BOCES' and org.displayidentifier ='149200000000') or
									(org.organizationname='FRANKLIN-ESSEX-HAMILTON BOCES' and org.displayidentifier ='169000000000') or
									(org.organizationname='GENESEE VALLEY BOCES' and org.displayidentifier ='249000000000') or
									(org.organizationname='GREATER SOUTHERN TIER BOCES' and org.displayidentifier ='559000000000') or
									(org.organizationname='HAMILTON-FULTON-MONTGOMERY BOCES' and org.displayidentifier ='209000000000') or
									(org.organizationname='HERK-FULTON-HAMILTON-OTSEGO BOCES' and org.displayidentifier ='219000000000') or
									(org.organizationname='JEFFER-LEWIS-HAMIL-HERK-ONEIDA BOCES' and org.displayidentifier ='229000000000') or
									(org.organizationname='MADISON-ONEIDA BOCES' and org.displayidentifier ='259000000000') or
									(org.organizationname='MONROE 1 BOCES' and org.displayidentifier ='269100000000') or
									(org.organizationname='MONROE 2-ORLEANS BOCES' and org.displayidentifier ='269200000000') or
									(org.organizationname='NASSAU BOCES' and org.displayidentifier ='289000000000') or
									(org.organizationname='ONEIDA-HERKIMER-MADISON BOCES' and org.displayidentifier ='419000000000') or
									(org.organizationname='ONONDAGA-CORTLAND-MADISON BOCES' and org.displayidentifier ='429000000000') or
									(org.organizationname='ORANGE-ULSTER BOCES' and org.displayidentifier ='449000000000') or
									(org.organizationname='ORLEANS-NIAGARA BOCES' and org.displayidentifier ='459000000000') or
									(org.organizationname='OSWEGO BOCES' and org.displayidentifier ='469000000000') or
									(org.organizationname='OTSEGO-DELAW-SCHOHARIE-GREENE BOCES' and org.displayidentifier ='199000000000') or
									(org.organizationname='PUTNAM-NORTHERN WESTCHESTER BOCES' and org.displayidentifier ='489000000000') or
									(org.organizationname='QUESTAR III (R-C-G) BOCES' and org.displayidentifier ='499000000000') or
									(org.organizationname='ROCKLAND BOCES' and org.displayidentifier ='509000000000') or
									(org.organizationname='ST LAWRENCE-LEWIS BOCES' and org.displayidentifier ='519000000000') or
									(org.organizationname='SULLIVAN BOCES' and org.displayidentifier ='599000000000') or
									(org.organizationname='TOMPKINS-SENECA-TIOGA BOCES' and org.displayidentifier ='619000000000') or
									(org.organizationname='ULSTER BOCES' and org.displayidentifier ='629000000000') or
									(org.organizationname='WASHING-SARA-WAR-HAMLTN-ESSEX BOCES' and org.displayidentifier ='649000000000') or
									(org.organizationname='WAYNE-FINGER LAKES BOCES' and org.displayidentifier ='439000000000') or
									(org.organizationname='WESTCHESTER BOCES' and org.displayidentifier ='669000000000') or
									(org.organizationname='WESTERN SUFFOLK BOCES' and org.displayidentifier ='589300000000') or
									(org.organizationname='TECH VALLEY HIGH SCHOOL' and org.displayidentifier ='499000000801') ) and parentorganizationid=69354;

---==========================================================================================
--step3: validate the receods after update----count 38 records should see the ****new district_display_id =69354*****
--===========================================================================================

 select id
      ,org.organizationname
      ,org.displayidentifier
	  ,org.organizationtypeid
	  ,(select organizationname from organization_parent(org.id) where organizationtypeid=5 limit 1) district_name
      ,(select displayidentifier from organization_parent(org.id) where organizationtypeid=5 limit 1) district_display_identifier 
	  ,(select id from organization_parent(org.id) where organizationtypeid=5 limit 1) district_display_id
	   from organization org
           where(org.organizationname='BROOME-DELAWARE-TIOGA BOCES' and org.displayidentifier ='039000000000') or
				(org.organizationname='CAPITAL REGION BOCES' and org.displayidentifier ='019000000000') or
				(org.organizationname='CATTAR-ALLEGANY-ERIE-WYOMING BOCES' and org.displayidentifier ='049000000000') or
				(org.organizationname='CAYUGA-ONONDAGA BOCES' and org.displayidentifier ='059000000000') or
				(org.organizationname='CLINTON-ESSEX-WARREN-WASHING BOCES' and org.displayidentifier ='099000000000') or
				(org.organizationname='DELAW-CHENANGO-MADISON-OTSEGO BOCES' and org.displayidentifier ='129000000000') or
				(org.organizationname='DUTCHESS BOCES' and org.displayidentifier ='139000000000') or
				(org.organizationname='EASTERN SUFFOLK BOCES' and org.displayidentifier ='589100000000') or
				(org.organizationname='ERIE 1 BOCES' and org.displayidentifier ='149100000000') or
				(org.organizationname='ERIE 2-CHAUTAUQUA-CATTARAUGUS BOCES' and org.displayidentifier ='149200000000') or
				(org.organizationname='FRANKLIN-ESSEX-HAMILTON BOCES' and org.displayidentifier ='169000000000') or
				(org.organizationname='GENESEE VALLEY BOCES' and org.displayidentifier ='249000000000') or
				(org.organizationname='GREATER SOUTHERN TIER BOCES' and org.displayidentifier ='559000000000') or
				(org.organizationname='HAMILTON-FULTON-MONTGOMERY BOCES' and org.displayidentifier ='209000000000') or
				(org.organizationname='HERK-FULTON-HAMILTON-OTSEGO BOCES' and org.displayidentifier ='219000000000') or
				(org.organizationname='JEFFER-LEWIS-HAMIL-HERK-ONEIDA BOCES' and org.displayidentifier ='229000000000') or
				(org.organizationname='MADISON-ONEIDA BOCES' and org.displayidentifier ='259000000000') or
				(org.organizationname='MONROE 1 BOCES' and org.displayidentifier ='269100000000') or
				(org.organizationname='MONROE 2-ORLEANS BOCES' and org.displayidentifier ='269200000000') or
				(org.organizationname='NASSAU BOCES' and org.displayidentifier ='289000000000') or
				(org.organizationname='ONEIDA-HERKIMER-MADISON BOCES' and org.displayidentifier ='419000000000') or
				(org.organizationname='ONONDAGA-CORTLAND-MADISON BOCES' and org.displayidentifier ='429000000000') or
				(org.organizationname='ORANGE-ULSTER BOCES' and org.displayidentifier ='449000000000') or
				(org.organizationname='ORLEANS-NIAGARA BOCES' and org.displayidentifier ='459000000000') or
				(org.organizationname='OSWEGO BOCES' and org.displayidentifier ='469000000000') or
				(org.organizationname='OTSEGO-DELAW-SCHOHARIE-GREENE BOCES' and org.displayidentifier ='199000000000') or
				(org.organizationname='PUTNAM-NORTHERN WESTCHESTER BOCES' and org.displayidentifier ='489000000000') or
				(org.organizationname='QUESTAR III (R-C-G) BOCES' and org.displayidentifier ='499000000000') or
				(org.organizationname='ROCKLAND BOCES' and org.displayidentifier ='509000000000') or
				(org.organizationname='ST LAWRENCE-LEWIS BOCES' and org.displayidentifier ='519000000000') or
				(org.organizationname='SULLIVAN BOCES' and org.displayidentifier ='599000000000') or
				(org.organizationname='TOMPKINS-SENECA-TIOGA BOCES' and org.displayidentifier ='619000000000') or
				(org.organizationname='ULSTER BOCES' and org.displayidentifier ='629000000000') or
				(org.organizationname='WASHING-SARA-WAR-HAMLTN-ESSEX BOCES' and org.displayidentifier ='649000000000') or
				(org.organizationname='WAYNE-FINGER LAKES BOCES' and org.displayidentifier ='439000000000') or
				(org.organizationname='WESTCHESTER BOCES' and org.displayidentifier ='669000000000') or
				(org.organizationname='WESTERN SUFFOLK BOCES' and org.displayidentifier ='589300000000') or
				(org.organizationname='TECH VALLEY HIGH SCHOOL' and org.displayidentifier ='499000000801') ;

---or user the child relation previously do not have any school for this distict varified
--  select * from organization_children(69355);
commit;
----=====================================================================================================================
