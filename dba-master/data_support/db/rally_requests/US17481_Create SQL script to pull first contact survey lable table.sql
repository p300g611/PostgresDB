SELECT distinct
	    surveylabelnumber,
	    surveylabel,
	    responselabel,
	    responsevalue
 FROM firstcontact 
order by surveylabelnumber,
              responselabel;