global class OPP_UpdateChildStages {

	webservice static String UpdateMembers(string Id){
	String message;
	list<Opportunity> opplist = new list<Opportunity>();
	
	Opportunity thisOpp  = [Select Id, StageName From Opportunity Where Id =:Id];
	
	list<Opportunity> opp = [Select Id from Opportunity Where Parent_Opportunty__c =:thisOpp.Id];
	
	if(opp.size() >0){
	
	for(Opportunity o: opp){
		o.StageName	= thisOpp.StageName;
		opplist.add(o);
	}
	try{
		update opplist;
		message = 'Update Succesful';		
	}
	catch(exception e){
		system.debug(e);
		message = 'there was an error';
		}
	}
	return message;
    }
}