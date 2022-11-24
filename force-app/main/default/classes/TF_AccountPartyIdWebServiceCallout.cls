/*****************************************************************************************
    //This is callout class for consortium menbers of account having Type as "Consortium"
    //Created by Vikas Varshney for LMS-38 & LMS-53 on dated 22-Apr-2019
******************************************************************************************/

public class TF_AccountPartyIdWebServiceCallout {
    public static String  getAccountPartyID ( String accId ) {
        
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String accountPartyIdURI = (String) orgSpecificProps.get('Get_PartyId_URL__c');
        String accountCustomerID = null;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        //Map<Id, TandF_Account_to_Consortium__c> idToConsortiummMap;
        
        try {
            //if ( String.isNotBlank(accId) ) {
                //idToConsortiummMap = new Map<id, TandF_Account_to_Consortium__c>( [ SELECT Consortium_Member__c FROM TandF_Account_to_Consortium__c WHERE ConsortiumParent__c =:accId ] ) ;
            //}
            
            HttpResponse res = new HttpResponse();
            if ( String.isNotBlank(accountPartyIdURI) ) {
                accountPartyIdURI = accountPartyIdURI + accId + '?type=sfid';
                res = TF_PlatformExecuter.execute( accountPartyIdURI, 'GET', 'idtoken', null, headers, false );
            }
            System.debug('response =====>' + res);
            System.debug('response Body =====>' + res.getBody());
            
            if ( res != NULL && res.getStatusCode() == 200 ) {
                String responseBody = res.getBody();
                AccountResponse accountRes = (AccountResponse)JSON.deserialize(responseBody, AccountResponse.class);

                if ( accountRes != NULL ) {
                    if ( accountRes.Data != NULL ) {
                        if ( accountRes.Data.organisations != NULL ) {
                            if ( accountRes.Data.organisations[0].partyId != NULL ) {
                                accountCustomerID = String.valueof(accountRes.Data.organisations[0].partyId);
                            }
                        }
                    }
                }
                if ( String.isNotBlank(accountCustomerID) ) {
                    Account accUpdate = new Account(); 
                    accUpdate.Id = accId;
                    accUpdate.Customer_Id__c = accountCustomerID;
                    update accUpdate;
                    
                    return accountCustomerID;
                }
            }
        } catch ( Exception ex ) {
            System.debug('*********** Exception :' + ex.getMessage());
            return accountCustomerID;
        }
        return accountCustomerID;
    }
    /*
    //Declared methods
    public static void consortiumCallout ( String accountIdd ) {
        try {
            TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String accountPartyIdURI = (String) orgSpecificProps.get('Get_PartyId_URL__c');
            Map<String, String> headers = new Map<String,String>();
            headers.put('Content-Type', 'application/json');
            Map<Id, TandF_Account_to_Consortium__c> idToConsortiumMap;
            Map<Id, HttpResponse> accIdToResponseMap = new Map<Id, HttpResponse>();
            List<Id> accIdAPIList = new List<Id>();
            List<Account> accUpdateList = new List<Account>();
            
            if ( String.isNotBlank(accountIdd) )
                idToConsortiumMap = new Map<id, TandF_Account_to_Consortium__c>( [ SELECT Consortium_Member__c, Consortium_Member__r.Customer_Id__c FROM TandF_Account_to_Consortium__c WHERE ConsortiumParent__c =:accountIdd ] ) ;
            //System.debug('idToConsortiumMap Size =====>' + idToConsortiumMap.size());
            //System.debug('idToConsortiumMap =====>' + idToConsortiumMap);
            
            if ( !idToConsortiumMap.isEmpty() ) {
                for ( Id consortiumId : idToConsortiumMap.keySet() ) {
                    if ( String.isBlank(idToConsortiumMap.get( consortiumId ).Consortium_Member__r.Customer_Id__c) ) {
                        accIdAPIList.add( idToConsortiumMap.get( consortiumId ).Consortium_Member__c );
                    }
                }
            }
            
            if ( !accIdAPIList.isEmpty() && accIdAPIList.size() < 95 ) {
                //Integer sn = 1;
                for ( Id accId : accIdAPIList ) {
                    String consortiumResponse = calloutCS( accountPartyIdURI, accId, headers );
                    //System.debug('consortiumResponse ' + sn + ' =====>' + consortiumResponse);
                    if ( String.isNotBlank(consortiumResponse) ) {
                        Account consortiumUpdate = new Account();
                        consortiumUpdate.Id = accId;
                        consortiumUpdate.Customer_Id__c = consortiumResponse;
                        accUpdateList.add( consortiumUpdate );
                    }
                    //sn++;
                }
            }
            
            //System.debug('accUpdateList =====>' + accUpdateList);
                        
            if ( !accUpdateList.isEmpty() ) {
                update accUpdateList;
            }
        } catch ( Exception ex ) {
            System.debug('*********** Consortium Members Callout Exception :' + ex.getMessage());
        }
    }
    
    static String calloutCS ( String partyIdURL, String accountId, Map<String, String> headers ) {
        HttpResponse response = new HttpResponse();
        String consortiumCustomerID = '';
        
        if ( String.isNotBlank(partyIdURL) && String.isNotBlank(accountId) ) {
            partyIdURL += accountId + '?type=sfid';
            response = TF_PlatformExecuter.execute( partyIdURL, 'GET', 'idtoken', null, headers, false );
            //System.debug('Response Body =====>' + response);
            
            if ( response != NULL && response.getStatusCode() == 200 ) {
                String responseBody = response.getBody();
                AccountResponse consortiumRes = (AccountResponse)JSON.deserialize(responseBody, AccountResponse.class);
                //System.debug('consortiumRes =====>' + consortiumRes);
                
                if ( consortiumRes != NULL ) {
                    if ( consortiumRes.Data != NULL ) {
                        if ( consortiumRes.Data.organisations != NULL ) {
                            if ( consortiumRes.Data.organisations[0].partyId != NULL ) {
                                consortiumCustomerID = String.valueof(consortiumRes.Data.organisations[0].partyId);
                                //System.debug('consortiumCustomerID =====>' + consortiumCustomerID);
                            }
                        }
                    }
                }
            }
        }
        //System.debug('******** Consortium Members Callout ********');
        
        return consortiumCustomerID;
    }*/
    
    //classes for traversing the json  
    public class Organisations {
        public Integer partyId;
		public String name;
		public String ringGoldId;
		public String organisationType;
		public String partySfdcId;
    }
    
    public class Metadata {
		public String message;
		public String status;
	}

	public class Data {
		public Object contact;
		public List<Organisations> organisations;
		public Object source;
	}
    
    public class AccountResponse {
        public Metadata metadata;
	    public Data data;
    }
}