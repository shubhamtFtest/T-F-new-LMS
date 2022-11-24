@isTest
global class zTest_TF_AccountPartyIdWebServiceCallout {
    static testMethod void accountPartyIdTest () {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Get_PartyId_URL__c = 'https://api.taylorandfrancis.com/v2/auth/user/auth/token';
        insert setting;
        
        //Creating account record
        List<Account> accList = new List<Account>();
        accList.add( new Account( Name = 'Test Account1', Type = 'Customer' ) );
        insert accList;
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        TF_AccountPartyIdWebServiceCallout.getAccountPartyID( accList[0].id );
        Test.stopTest();
    }
    
    static testMethod void accountPartyIdNegativeTest () {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Get_PartyId_URL__c = 'https://api.taylorandfrancis.com/v2/auth/user/auth/token';
        insert setting;
        
        //Creating account record
        List<Account> accList = new List<Account>();
        accList.add( new Account( Name = 'Test Account1', Type = 'Customer' ) );
        insert accList;
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Negative() );
        TF_AccountPartyIdWebServiceCallout.getAccountPartyID( accList[0].id );
        Test.stopTest();
    }
    
    //class to create a mock response
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"metadata": {"message":"party with 0010Y00000v3R8qQAE not  found","status": "success"},"data": {"contact": null,"organisations":[{"partyId":52725,"partySfdcId":"0011l00000BP2vxAAD"}],"source":null}}');
            return res;
        }
    }
    
    //class to create a mock response
    global class MockGenerator_Negative implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(500);
            res.setStatus('null');
            res.setBody('{"metadata":{"message":"party with 0011l00000BP2vxAAD found","status":"success"},"data":{"contact":"null","organisations":[{"accountSettings":{},"comments":"Org for Order hub test","description":"Org for Order hub test","isTestOrg":true,"isni":"null","isniName":"null","name":"IgnoreTestOrg2","organisationType":"institute","parentRingGoldId":"null","partyId":52725,"partySfdcId":"0011l00000BP2vxAAD","relationships":"null","ringGoldId":"null","sourceOrgId":0,"taxDetail":"null","url":""}],"source":"order-hub"}}');
            return res;
        }
    }
}