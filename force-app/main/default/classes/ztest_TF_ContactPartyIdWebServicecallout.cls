@isTest
public class ztest_TF_ContactPartyIdWebServicecallout implements HttpCalloutMock{
    private integer statusCode;
    private String responseJson;
    
    public ztest_TF_ContactPartyIdWebServicecallout(integer statusCode, String responseJson){
        this.statusCode = statusCode;
        this.responseJson = responseJson;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().endsWith('user/auth/token')){
            String resptJson = '';
            resptJson = '{"access_token":"10edc9086eefa8e672eca3ad1b0040a2","token_type":"Bearer","expires_in":3600,"id_token":"eyJhbGciOiJSUzI1NiIsI"}';
            
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(resptJson);      
            resp.setStatusCode(200);
            return resp;
        }else{
            HttpResponse resp = new HttpResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(responseJson);      
            resp.setStatusCode(statusCode);
            return resp;
        }
    }
    
    public static void UpdateContactRequestsetup()
    {
        String Id;
        id='1234567';
    }
    
    static TestMethod void getContactPartyID_possitive()
    {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Get_PartyId_URL__c = 'https://api.taylorandfrancis.com/v1/customers/party/';
        insert setting;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
        insert accObject;        
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        system.debug(contactRecordtypeId);       
        Contact newContact = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert newContact; 
        
        test.startTest();
        string jsonStr = '{"metadata": {"contactsCount": 356782,"message": "party with venkataramana.mohan@informa.com found","status": "success"},"data": {"contact": {"partyId": 392768,"lastName": "Mohan","orcid": null,"partySfdcId": null}}}';
        Test.setMock(HttpCalloutMock.class, new ztest_TF_ContactPartyIdWebServicecallout(200, jsonStr));
        TF_ContactPartyIdWebServiceCallout.getContactPartyID(newContact.id,'venkataramana.mohan@informa.com'); 
        test.stopTest();
        
        jsonStr = '{"metadata": {"message": "party with venkataramana.mohan1@informa.com not  found","status": "success"},"data": {"contact": null,"organisations": null,"source": null}}';
        // Test.setMock(HttpCalloutMock.class, new ztest_TF_ContactPartyIdWebServicecallout(200, jsonStr));        
        // TF_ContactPartyIdWebServiceCallout.getContactPartyID(newContact.id,'venkataramana.mohan1@informa.com'); 
        
    }
    
    static TestMethod void getContactPartyID_negative()
    {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Get_PartyId_URL__c = 'https://api.taylorandfrancis.com/v1/customers/party/';
        insert setting;
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accObject = new Account(Name = 'Test Acc',
                                        RecordTypeId = TFAccountsRecordTypeId,
                                        Type = 'Customer');
        insert accObject;        
        Id contactRecordtypeId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts');
        system.debug(contactRecordtypeId);       
        Contact newContact = new Contact(AccountId = accObject.Id, Lastname = 'Test contact');
        insert newContact; 
        
        test.startTest();       
        
        string jsonStr = '{"metadata": {"message": "party with venkataramana.mohan1@informa.com not  found","status": "success"},"data": {"contact": null,"organisations": null,"source": null}}';
        Test.setMock(HttpCalloutMock.class, new ztest_TF_ContactPartyIdWebServicecallout(200, jsonStr));        
        TF_ContactPartyIdWebServiceCallout.getContactPartyID(newContact.id,'venkataramana.mohan1@informa.com'); 
        test.stopTest();
    }
    
}