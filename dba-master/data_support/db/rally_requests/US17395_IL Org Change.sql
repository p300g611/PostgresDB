DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 row_count integer;
BEGIN
now_date :=now();

      update organizationrelation set parentorganizationid=57652,  modifieduser=12,modifieddate=now_date where parentorganizationid=45476;
      RAISE NOTICE 'updated organizationrelation parent 45476 to 57652' ;
      
      update organization set activeflag=false , modifieduser=12, modifieddate=now_date where displayidentifier='020910430040000' and id=45476; 
      RAISE NOTICE 'inactive organization 45476 ' ;

              drop table if exists  tmp_insert_dist ;
              Create temporary table tmp_insert_dist (upd_org_nbr  text , curr_org_nbr text ,upd_org_name text ) ;
                              insert into tmp_insert_dist  
			              select '010092620260000','460092620260000','A-C Central CUSD 262'
				union select '300910370040000','020910370040000','Anna CCSD 37'
				union select '300910810160000','020910810160000','Anna Jonesboro CHSD 81'
				union select '260290010260000','220290010260000','Astoria CUSD 1'
				union select '510652130260000','380652130260000','Athens CUSD 213'
				union select '010090150260000','460090150260000','Beardstown CUSD 15'
				union select '130410820020000','250410820020000','Bethel SD 82'
				union select '470980000616100','550980000616100','Bi-County Special Educ Coop'
				union select '010050010260000','460050010260000','Brown County CUSD 1'
				union select '210440430030000','020440430030000','Buncombe Cons SD 43'
				union select '300020010220000','020020010220000','Cairo USD 1'
				union select '260290660250000','220290660250000','Canton Union SD 66'
				union select '300771000260000','020771000260000','Century CUSD 100'
				union select '170540610040000','380540610040000','Chester-East Lincoln CCSD 61'
				union select '300910170220000','020910170220000','Cobden SUD 17'
				union select '531021220170000','431021220170000','County of Woodford School'
				union select '260290030260000','220290030260000','CUSD 3 Fulton County'
				union select '210440640020000','020440640020000','Cypress SD 64'
				union select '300910660220000','020910660220000','Dongola USD 66'
				union select '470980200020000','550980200020000','East Coloma - Nelson CESD 20'
				union select '030110040260000','100110040260000','Edinburg CUSD 4'
				union select '300020050260000','020020050260000','Egyptian CUSD 5'
				union select '531020110260000','431020110260000','El Paso-Gridley CUSD 11'
				union select '470980010260000','550980010260000','Erie CUSD 1'
				union select '531021400260000','431021400260000','Eureka CUD 140'
				union select '050160650616100','050160650610000','Evanston Dists 65/202 Jnt Agr'
				union select '130410990040000','250410990040000','Farrington CCSD 99'
				union select '130410030040000','250410030040000','Field CCSD 3'
				union select '531020060260000','431020060260000','Fieldcrest CUSD 6'
				union select '010698010606000','460698010606000','Four Rivers Spec Educ Dist'
				union select '010690010260000','460690010260000','Franklin CUSD 1'
				union select '130418010606000','250418010606000','Franklin-Jefferson Co Sp Ed Dist'
				union select '531020690020000','431020690020000','Germantown Hills SD 69'
				union select '210440010260000','020440010260000','Goreville CUD 1'
				union select '130410060040000','250410060040000','Grand Prairie CCSD 6'
				union select '510652000260000','380652000260000','Greenview CUSD 200'
				union select '200330100260000','250330100260000','Hamilton Co CUSD 10'
				union select '170540210260000','380540210260000','Hartsburg Emden CUSD 21'
				union select '530601260260000','380601260260000','Havana CUSD 126'
				union select '350590050260000','430590050260000','Henry-Senachwine CUSD 5'
				union select '030680030260000','100680030260000','Hillsboro CUSD 3'
				union select '530601890260000','380601890260000','Illini Central CUSD 189'
				union select '010691170220000','460691170220000','Jacksonville SD 117'
				union select '300778010606000','020778010606000','Jamp Spec Educ Services'
				union select '210610380260000','020610380260000','Joppa-Maple Grove UD 38'
				union select '260290970260000','220290970260000','Lewistown CUSD 97'
				union select '300910160040000','020910160040000','Lick Creek CCSD 16'
				union select '170544040160000','380544040160000','Lincoln CHSD 404'
				union select '170540270020000','380540270020000','Lincoln ESD 27'
				union select '030680120260000','100680120260000','Litchfield CUSD 12'
				union select '531020210260000','431020210260000','Lowpoint-Washburn CUSD 21'
				union select '210610010260000','020610010260000','Massac UD 1'
				union select '130410120040000','250410120040000','McClellan CCSD 12'
				union select '330664040260000','270664040260000','Mercer County School District 404'
				union select '010690110260000','460690110260000','Meredosia-Chambersburg CUSD 11'
				union select '300771010260000','020771010260000','Meridian CUSD 101'
				union select '531020010040000','431020010040000','Metamora CCSD 1'
				union select '350590070260000','430590070260000','Midland CUSD 7'
				union select '530601910260000','380601910260000','Midwest Central CUSD 191'
				union select '330942380260000','270942380260000','Monmouth-Roseville CUSD 238'
				union select '470981450040000','550981450040000','Montmorency CCSD 145'
				union select '470980060260000','550980060260000','Morrison CUSD 6'
				union select '030110010260000','100110010260000','Morrisonville CUSD 1'
				union select '130410800020000','250410800020000','Mount Vernon SD 80'
				union select '170540230260000','380540230260000','Mt Pulaski CUSD 23'
				union select '130412010170000','250412010170000','Mt Vernon Twp HSD 201'
				union select '170540880020000','380540880020000','New Holland-Middletown ED 88'
				union select '210440320030000','020440320030000','New Simpson Hill SD 32'
				union select '030680220260000','100680220260000','Nokomis CUSD 22'
				union select '130410050040000','250410050040000','Opdyke-Belle-Rive CCSD 5'
				union select '030110080260000','100110080260000','Pana CUSD 8'
				union select '030680020260000','100680020260000','Panhandle CUSD 2'
				union select '010690171000000','460690171000000','Pathway Services Unlimited'
				union select '190220200636300','190220200630000','Philip J Rock Center and School'
				union select '510652020260000','380652020260000','Porta CUSD 202'
				union select '030110174000000','100110174000000','Presbyterian Church USA'
				union select '470980030260000','550980030260000','Prophetstown-Lyndon-Tampico CUSD3'
				union select '350785350260000','430785350260000','Putnam County CUSD 535'
				union select '470980020260000','550980020260000','River Bend CUSD 2'
				union select '531020020040000','431020020040000','Riverview CCSD 2'
				union select '531020600260000','431020600260000','Roanoke Benson CUSD 60'
				union select '470980130020000','550980130020000','Rock Falls ESD 13'
				union select '470983010170000','550983010170000','Rock Falls Twp HSD 301'
				union select '130410020040000','250410020040000','Rome CCSD 2'
				union select '260850050260000','220850050260000','Schuyler-Industry CUSD 5'
				union select '010860020260000','460860020260000','Scott-Morgan CUSD 2'
				union select '300910840260000','020910840260000','Shawnee CUSD 84'
				union select '030110140240000','100110140240000','South Fork SD 14'
				union select '260290040260000','220290040260000','Spoon River Valley CUSD 4'
				union select '470980050260000','550980050260000','Sterling CUSD 5'
				union select '130410790020000','250410790020000','Summersville SD 79'
				union select '030110030260000','100110030260000','Taylorville CUSD 3'
				union select '010690270260000','460690270260000','Triopia CUSD 27'
				union select '330943040260000','270943040260000','United CUSD 304'
				union select '130410229000000','250410229000000','United Methodist Childrens Home'
				union select '260290020260000','220290020260000','V I T CUSD 2'
				union select '210441330170000','020441330170000','Vienna HSD 133'
				union select '210440550020000','020440550020000','Vienna SD 55'
				union select '010090640260000','460090640260000','Virginia CUSD 64'
				union select '130410010260000','250410010260000','Waltonville CUSD 1'
				union select '010690060260000','460690060260000','Waverly CUSD 6'
				union select '330362350260000','270362350260000','West Central CUSD 235'
				union select '170540920040000','380540920040000','West Lincoln-Broadwell ESD 92'
				union select '010860010260000','460860010260000','Winchester CUSD 1';
			
			row_count := ( select count(*) from tmp_insert_dist);
			RAISE NOTICE 'rows need to process: %' , row_count;	
			row_count := ( select count(*) from organization org inner join tmp_insert_dist tmp on org.displayidentifier=tmp.curr_org_nbr);
			RAISE NOTICE 'rows match to update: %' , row_count;
			row_count := ( select count(*) from organization org inner join tmp_insert_dist tmp on org.displayidentifier=tmp.upd_org_nbr and org.activeflag=true);
			RAISE NOTICE 'rows org already exists-count should be zero: %' , row_count;
	
       update organization org
               set modifieddate=now_date,   
                   modifieduser=12 ,
                   displayidentifier=tmp.upd_org_nbr,
                   organizationname=tmp.upd_org_name
          from tmp_insert_dist tmp   
          where org.displayidentifier=tmp.curr_org_nbr
               and (select  id from organization_parent(org.id) where organizationtypeid=2)=9632 and org.organizationtypeid=5;
				       
			row_count := ( select count(*) from organization where modifieddate=now_date and modifieduser=12 );
			RAISE NOTICE 'rows updated including 1 inactive row : %' , row_count;	
				       
		   
END;
$BODY$;    




















