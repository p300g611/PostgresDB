DO
$BODY$
DECLARE
       now_date timestamp with time zone; 
       aart_userid integer;
       row_count integer;
       userstory text;
BEGIN
     now_date :=now();
     aart_userid :=(SELECT id FROM aartuser WHERE username = 'cetesysadmin');
     row_count:=0;
     userstory:='DE13632'; --please add user story number 

 --grade3 
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=86
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 3'
				     where  currentgradelevel is null 
					    and id in ( 2327487,
							2327228,
							2328312,
							2326969,
							2327727
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;

  --grade4 
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=37
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 4'
				     where  currentgradelevel is null 
					    and id in ( 2213427,
							2324868,
							2325990,
							2325795,
							2324481,
							2325391,
							2325518,
							2326416,
							2325854

							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;
 --grade5
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=7
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 5'
				     where  currentgradelevel is null 
					    and id in ( 2322565,
							2327057,
							2324398,
							2214952,
							2323491,
							2322360
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;
 --grade6
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=92
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 6'
				     where  currentgradelevel is null 
					    and id in ( 2328609,
							2320595,
							2322266,
							2321147,
							2321934
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;

 --grade7
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=64
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 7'
				     where  currentgradelevel is null 
					    and id in ( 2319232,
							2318964,
							2320483,
							2320162,
							2325383,
							2320940,
							2319327,
							2319448,
							2320653
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;

 --grade8 
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=91
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 8'
				     where  currentgradelevel is null 
					    and id in ( 2318946,
							2319491,
							2319035,
							2321416,
							2318472,
							2318110,
							2317910,
							2318497,
							2317656,
							2318804,
							2318704
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;	
 --grade9 
     WITH updated_rows AS ( update enrollment 
				    set currentgradelevel=31
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 old grade null and new grade 9'
				     where  currentgradelevel is null 
					    and id in ( 2316863,
							2331656,
							2329708,
							2329942,
							2331980,
							2331077,
							2315404,
							2330974,
							2332006,
							2330387

							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;
 --VA students 
     WITH updated_rows AS ( update enrollment 
				    set activeflag=false
					    ,modifieddate=now_date
					    ,modifieduser=aart_userid
					    ,notes ='As per DE13632 Inactivated'
				     where  currentgradelevel is null 
					    and id in ( 497537,494397,493974
							 )
		            RETURNING 1    ) 
	                     SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;					  

END;
$BODY$; 






    

