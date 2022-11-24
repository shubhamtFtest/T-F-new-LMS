@isTest
global class zTest_TF_UBXAccountWebServiceCallout {
    static testMethod void ubxAccountTest () {
        TF_OrgSpecificProps__c setting = new TF_OrgSpecificProps__c();
        setting.Get_UBX_IpAuth_URL__c = 'https://api.taylorandfrancis.com/v1/ipauth/party/';
        setting.Get_UBX_OrgId_URL__c = 'https://api.taylorandfrancis.com/v2/auth/org?org_id=';
        insert setting;
        
        //Creating account record
        List<Account> accList = new List<Account>();
        accList.add( new Account( Name = 'Test Account1', Type = 'Customer' ) );
        insert accList;
        
        Test.startTest();
        Test.setMock ( HttpCalloutMock.class, new MockGenerator_Test() );
        TF_UBXAccountWebServiceCallout.getUBXAccountValidation( accList[0].id );
        Test.stopTest();
    }
    
    //class to create a mock response
    global class MockGenerator_Test implements HttpCalloutMock {
        global HttpResponse respond ( HTTPRequest  req ) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"metadata": {"status": "success","message": {}},"data": [{"ip_access_control_id": "897388","ip_start": "111.93.244.226","ip_end": "111.93.244.226","access_type": "allow","party_id": "100","db_add_date": "2019-07-31T12:29:48.704Z","db_update_date": "2019-07-31T12:29:48.704Z","created_by": "internaladmin@yopmail.com","updated_by": "internaladmin@yopmail.com","deleted_on": null,"description": "Tricon_ip2","ip_type_id": 1,"source": null,"threat_type": null}]}');
            return res;
        }
    }
}