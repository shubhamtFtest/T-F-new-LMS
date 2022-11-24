@RestResource(urlMapping='/PartyIdIncrementer/*')
global without sharing class PartyIdIncrementer {
    
	//ENDPOINT: https://taylorandfrancis.my.salesforce.com/services/apexrest/PartyIdIncrementer 

    global class Response {
    	public Integer partyId;
    }

    @HttpPost
    global static integer getNextPartyId() {
        return getNextPartyId(1)[0];
    }
    
    @HttpGet
    global static void doGet() {
        Response res = new Response();
        res.partyId = getNextPartyId(1)[0];
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }    
    
    public static List<integer> getNextPartyId(integer count) {
        //Increment
		integer partyId;
        List<Party__c> parties = new List<Party__c>();
        for (integer i = 0; i < count; i++) {
            Party__c p = new Party__c();
            parties.add(p);
        }        
        insert parties;

        //Get Ids just created
        Set<Id> ids = new Set<Id>();
        for (integer i = 0; i < count; i++) {
            ids.add(parties[i].Id);
        }
        
        //Get Names (aka Party Ids) just created
        List<Integer> partyIds = new List<Integer>();
        parties = [SELECT Id, Name FROM Party__c WHERE Id = :ids ORDER BY Name ASC];
        for (Party__c p : parties) {
            partyIds.add(integer.valueOf(p.Name));
            system.debug('Party ID = ' + p.Name);
        }
        
        //Remove unneeded party records
        delete parties;
        
        //Return range
		return partyIds;        
    }
}