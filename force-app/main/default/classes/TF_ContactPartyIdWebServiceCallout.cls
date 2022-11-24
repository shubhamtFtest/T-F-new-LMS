public class TF_ContactPartyIdWebServiceCallout {
  
 
    //private static String contactPartyIdURI = 'https://api.taylorandfrancis.com/v1/customers/party/';   
    Public static void  getContactPartyID(String Id, String EmailId)
    {  
       TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
       String contactPartyIdURI = (String) orgSpecificProps.get('Get_PartyId_URL__c');
        System.debug('contactPartyIdURI'+ contactPartyIdURI);
        String contactCustomerID = null;
        Map<String, String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');        
        try {
            HttpResponse res = null;
            contactPartyIdURI=contactPartyIdURI + EmailId + '/';
            res = TF_PlatformExecuter.execute(contactPartyIdURI,'GET','idtoken', null, headers, false);
            
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                String responseBody = res.getBody(); 
                // replacing contact with vContact
                responseBody=responseBody.replace('contact', 'vcontact');
                System.debug('********!' + responseBody);
                System.debug('****ResponseCode****!' + res.getStatusCode());
                ContactResponse contactRes = (ContactResponse)JSON.deserialize(responseBody, ContactResponse.class);                
                System.debug('contactRes///'+contactRes);
                //fetching partyid from response
                if(String.valueof(contactRes.Data.vcontact)!=null){
                contactCustomerID = String.valueof(contactRes.Data.vcontact.PartyId); 
                    }
                System.debug('contactCustomerID///'+contactCustomerID);
                if(String.isNotBlank(contactCustomerID)){
                    updatePartyId(contactCustomerID,Id);
                }
                
            }  
            else{
                system.debug('#####!DEBUG'+ '' + res);
                system.debug('#####!DEBUG'+ '' + Id);               
            }
        } 
        catch (Exception ex) { 
            System.debug('******** Exception : ' + ex.getMessage());     
        }
    }
    private static String updatePartyId(String partyID,String SFContactId){           
        If (String.isNotBlank(partyID)){
            try{     
                system.debug('SFContactId' + ' ' + SFContactId);                   
                //Contact con = [SELECT Id, Name FROM Contact Where id = :SFContactId];
                Contact con=new Contact();
                con.id=SFContactId;
                con.Party_Id__c  = partyID;              
                update con;   
                system.debug('Contact updated');
                Return 'Success';
            } 
            catch(exception e){
                system.debug(e.getmessage() + ' '  + 'update failed');
                Return 'Failed';
            }            
        }
        else if(partyID =='' || String.isBlank(partyID)){            
            Return 'Failed';                     
        }
        
        Return 'Success';
    }
    //classes for traversing the json  
    class vcontact{
        public Integer partyId;
        public String lastName;
        public Object orcid;
        public String partySfdcId;		
    }
    class MetaData {
        private String message;
        private String status; 
    }
    
    class Data {
        private vcontact vcontact;
    }
    
    class ContactResponse {
        private MetaData metadata;
        private Data data;
    }
    
    
    
}