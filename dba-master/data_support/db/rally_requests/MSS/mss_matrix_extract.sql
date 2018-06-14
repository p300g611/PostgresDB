select srm.studentid
,srm.studentstestsid 
,srm.studentstestsectionsid 
,srm.taskvariantid 
,(select textHtml from taskvariantmatrix tvq where tvq.taskvariantid=srm.taskvariantid and srm.foilid=tvq.id) foil
,(select Case when textHtml like '%Strongly Agree%' then 'Strongly Agree' 
       when textHtml like '%Strongly Disagree%' then 'Strongly Disagree'        
       when textHtml like '%Neither Disagree nor Agree%' then 'Neither Disagree nor Agree' 
	   when textHtml like '%Disagree%' then 'Disagree' 
       when textHtml like '%Agree%' then 'Agree' 
       when textHtml like '%Almost Always%' then 'Almost Always' 
       when textHtml like '%Almost Never%' then 'Almost Never' 
       when textHtml like '%Frequently&nbsp;%' then 'Frequently&nbsp;' 
       when textHtml like '%Very Often%' then 'Very Often' 
       when textHtml like '%Once in a While%' then 'Once in a While' 
       when textHtml like '%Sometimes%' then 'Sometimes' 
       when textHtml like '%Never%' then 'Never' 
       when textHtml like '%Always%' then 'Always' 
       when textHtml like '%Frequently%' then 'Frequently' 
  else textHtml end  from taskvariantmatrix tva where tva.taskvariantid=srm.taskvariantid and srm.options=tva.id) options
,(select textHtml end  from taskvariantmatrix tva where tva.taskvariantid=srm.taskvariantid and srm.options=tva.id) textHtml
from studentsresponsesmatrix srm;