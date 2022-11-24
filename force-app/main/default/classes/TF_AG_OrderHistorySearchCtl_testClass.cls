@isTest
public class TF_AG_OrderHistorySearchCtl_testClass 
{
    @isTest
    public static void func1()
    {
        //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Account ta = new Account();
        ta.Name='{testaccount1}';
        insert ta;
        
        Contract c = new Contract(Name='testcontract1',StartDate=Date.Today(),Status = 'Draft', AccountId = ta.Id,  ContractTerm = 4);
        insert c;
        
        Order to = new Order();
        to.Name = '{ordertest1}';
        to.AccountId = ta.Id;
        to.ContractId = c.Id;
        to.EffectiveDate = Date.Today();
        to.Status = 'Draft';
        insert to;
        
        Contact con = new Contact(LastName ='testCon',AccountId = ta.Id);
        insert con; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
        User u = new User(Alias = 'standt1',BMIS_Account_Number__c  ='00001111',CommunityNickname='testNick',CurrencyIsoCode='AED',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com', ContactId = con.Id, IsActive = True);
        system.debug('debug in test'+u.BMIS_Account_Number__c);
        insert u;
        
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator_Order());
        System.runAs(u) {
            // The following code runs as user 'u'
            //System.debug('Current User: ' + UserInfo.getUserName());
            //System.debug('Current Profile: ' + UserInfo.getProfileId());
            //system.debug('current user id: '+Userinfo.getuserid());
            Test.startTest();
            TF_AG_OrderHistorySearchCtl.getOrderDataFromAPI('1');
            Test.stopTest();
        }
        
        //system.debug('in test class'+uv);
    }
    
    @isTest
    public static void func2()
    {
        
        Account ta = new Account();
        ta.Name='{testaccount1}';
        insert ta;
        
        Contract c = new Contract(Name='testcontract1',StartDate=Date.Today(),Status = 'Draft', AccountId = ta.Id,  ContractTerm = 4);
        insert c;
        
        Order to = new Order();
        to.Name = '{ordertest1}';
        to.AccountId = ta.Id;
        to.ContractId = c.Id;
        to.EffectiveDate = Date.Today();
        to.Status = 'Draft';
        insert to;
        
        Contact con = new Contact(LastName ='testCon',AccountId = ta.Id);
        insert con; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Agent Extranet Community User'];
        User u = new User(Alias = 'standt1',BMIS_Account_Number__c  ='00001111',CommunityNickname='testNick',CurrencyIsoCode='AED',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='testAgentExtra@agent.com', ContactId = con.Id, IsActive = True);
        insert u;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new TF_AG_MockHttpResponseGenerator_Order());
        TF_AG_OrderHistorySearchCtl.getOrderDetailData(ta.id,to.id,'1');
        
        Test.stopTest();
    }
    
}