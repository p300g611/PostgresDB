#!/bin/bash
psql -h cbdb1.prodku.cete.us -U lportal_reader -f "/srv/extracts/CETE/1_datalayout_cb.sql" -d lportal #> /srv/extracts/CETE/1_datalayout_cb.out
psql -h aartdwdb.prodku.cete.us -U aartdw_reader -f "/srv/extracts/CETE/2_datalayout_dw.sql" -d aartdw #> /srv/extracts/CETE/2_datalayout_dw.out
psql -h cbdb1.prodku.cete.us -U lportal_reader -f "/srv/extracts/CETE/3_datalayout_cb.sql" -d lportal #> /srv/extracts/CETE/3_datalayout_cb.out
#for others
#psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/all/4_datalayout_ep_kelpa.sql" -d aart-prod
#psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/all/4_datalayout_ep_cpass.sql" -d aart-prod
#psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/all/4_datalayout_ep_interim.sql" -d aart-prod
#psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/all/datalayout_ep_pnp.sql" -d aart-prod

#for KAP
#GRADES=( "K" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" )
GRADES=( "3" "4" "5" "6" "7" "8" "9" "10" )

for i in "${GRADES[@]}"
do
   echo $i
   psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/4_datalayout_ep.sql" -d aart-prod -v v_year=2017 -v v_ap=12 -v v_sub=3 -v v_grade=$i
   mv /srv/extracts/CETE/kap_extract_ela_grade.txt /srv/extracts/CETE/kap_extract_ela_grade$i.txt
   psql -h pool.prodku.cete.us -U aart_reader -f "/srv/extracts/CETE/4_datalayout_ep.sql" -d aart-prod -v v_year=2017 -v v_ap=12 -v v_sub=440 -v v_grade=$i   
   mv /srv/extracts/CETE/kap_extract_ela_grade.txt /srv/extracts/CETE/kap_extract_math_grade$i.txt
done