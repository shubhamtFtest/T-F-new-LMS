/*
 * Created by - Sourabh Goyal
 * Created on - 26 Nov 2020
 * Description - Test methods for MergeAccountController_Test 
 * Coverage - 97%
                
 * Modified On - 20 May 2021
 * Modified By - Sourabh
 */
@isTest
private class MergeAccountController_Test {
    
    @TestSetup static void setup(){
        Account masterAcc1 = new Account();
        masterAcc1.Name = 'Test1';
        masterAcc1.Ringgold_Account_ID__c = '11111';
        masterAcc1.Customer_Id__c = '100';
        Insert masterAcc1;
        
        Account dupAcc1 = new Account();
        dupAcc1.Name = 'Test2';
        dupAcc1.AnnualRevenue = 1000;
        dupAcc1.Ringgold_Account_ID__c = '11888';
        dupAcc1.Customer_Id__c = '200';
        Insert dupAcc1;
        
        
        Setting__c setting = new Setting__c();
        setting.Name = 'Account_Merge_Error_Logs';
        insert setting;
        
        
        
    }
    
    @isTest static void mergeAcc_Test1(){
    	Account winningAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test1' LIMIT 1];
        Account losingAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test2' LIMIT 1];
     
        Test.startTest();
        MergeAccountController.fetchAccountsByIds(winningAcc.id);
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_SFDCId());
        String winningResp = MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'1');
        
        String losingResp = MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'2');
        MergeAccountController.MergeAccountResponse winningData = (MergeAccountController.MergeAccountResponse)JSON.deserialize(winningResp, MergeAccountController.MergeAccountResponse.class);
        MergeAccountController.MergeAccountResponse losingData = (MergeAccountController.MergeAccountResponse)JSON.deserialize(losingResp, MergeAccountController.MergeAccountResponse.class);
        
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_SFDCId_WithoutData());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'1');
        
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_SFDCId_2());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');
        
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_SFDCId_3());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');
        
        
        
        MergeAccountController.mergeAcc(winningAcc.Id,losingAcc.Id);
        
        
        Test.stopTest();
        System.assertEquals('SUCCESS', winningData.status);
		System.assertEquals('SUCCESS', losingData.status);
    } 
    
    @isTest static void mergeAcc_Test2(){
    	Account winningAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test1' LIMIT 1];
        Account losingAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test2' LIMIT 1];
     	
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_PartyId_WithoutData());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'1');
		MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'2');
        
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_RinggoldId());
        MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'1');
		MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');
        
        Test.stopTest();
    
    } 
    
    
    @isTest static void mergeAcc_Test3(){
    	Account winningAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test1' LIMIT 1];
        Account losingAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test2' LIMIT 1];
     	
        winningAcc.Ringgold_Account_ID__c = null;
        System.debug('@@@Calling from Merge test 3');
        Test.startTest(); 
          
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_PartyId_WithData());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');

        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_Empty());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'1');
        MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'2');
        
        //winningAcc.Customer_Id__c = '';
        winningAcc.Ringgold_Account_ID__c = '';
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_NotMatched());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');
        
        
        MergeAccountController.mergeAcc(winningAcc.Id, losingAcc.Id);
        MergeAccountController.MergeAccountResponse mergeResp = new MergeAccountController.MergeAccountResponse();
        AccountMergeData accMergeData = new AccountMergeData();
        accMergeData.metadata = new AccountMergeData.MetaData();
        accMergeData.metadata.message = '';
        Test.stopTest();
    }
    
    
    @isTest static void mergeAcc_Test4(){
    	Account winningAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test1' LIMIT 1];
        Account losingAcc = [SELECT Id,Name,Ringgold_Account_ID__c,Customer_Id__c from Account Where Name = 'Test2' LIMIT 1];
     
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_SFDCId());
        MergeAccountController.getDataToAnalyze(winningAcc.id,winningAcc.Ringgold_Account_ID__c,winningAcc.Customer_Id__c,'2');
        
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_RinggoldId());
        MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'2');
       
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_PartyId_WithData());
        MergeAccountController.getDataToAnalyze(losingAcc.id,losingAcc.Ringgold_Account_ID__c,losingAcc.Customer_Id__c,'2');
    
        Test.stopTest();
    } 
    
    
    /*@isTest static void mergeAcc_Test3(){
    	Account account1= new Account();
        account1.Name='test1';
        account1.Ringgold_Account_ID__c='11338';
        account1.Customer_Id__c='100'; 
        insert account1;
            
        
        Account duplicateAcc= new Account();
        duplicateAcc.Name='dupTest1';
        duplicateAcc.Ringgold_Account_ID__c ='11388';
        duplicateAcc.Customer_Id__c='200';
        insert duplicateAcc;
      
        Test.startTest();
        MergeAccountController.fetchAccountsByIds(account1.id);
        Test.setMock(HttpCalloutMock.class, new MergeResponseGenerator_RinggoldId());
        //MergeAccountController.getDataToAnalyze(account1.id,account1.Ringgold_Account_ID__c,account1.Customer_Id__c,'1');
        MergeAccountController.getDataToAnalyze(account1.id,account1.Ringgold_Account_ID__c,account1.Customer_Id__c,'2');
        Test.stopTest();
    
    }*/
    
     public class MergeResponseGenerator_Empty implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            res.setBody('{ "metadata":{"message":"Ok","status":200}, "data" : null}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MergeResponseGenerator_NotMatched implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : null}');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 111,"sfdc_id": "0011n00001za7MFAAY","name": " Not Matched Acc","ringgold_id": "10000","pt_id": null,"setup": {"partyId": 111,"orgName": "ILSI Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":1,"bp_count": null,"usage": false,"licenses": null } }');
                res.setStatusCode(200);
                return res;
            }
            
                
        }
    }
    
    public class MergeResponseGenerator_SFDCId implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : [ {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "SFDC ID Account","ringgold_id": "11888","pt_id": null,"setup": {"partyId": 200,"orgName": " SFDC Id and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":0,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0} } ] }');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
    
    public class MergeResponseGenerator_SFDCId_WithoutData implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : [ {"party_id": null,"sfdc_id": "0011n00001za7MFAAY","name": "null","ringgold_id": "null","pt_id": null,"setup": {"partyId": null,"orgName": " SFDC Id and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":0,"bp_count": null,"usage": false,"licenses": null } ] }');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
    
    public class MergeResponseGenerator_SFDCId_2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : [ {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "SFDC Id 2 Acc","ringgold_id": "11000","pt_id": null,"setup": {"partyId": 200,"orgName": "SFDC Id 2","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":1,"bp_count": null,"usage": false,"licenses": null } ] }');
                res.setStatusCode(200);
                return res;
            }if (req.getEndpoint().endsWith('ringgoldId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "SFDC 2 Ringgold","ringgold_id": "11888","pt_id": null,"setup": {"partyId": 200,"orgName": "SFDC 2 Ringgold ","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":1,"bp_count": null,"usage": false,"licenses": null } }');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
    
    public class MergeResponseGenerator_SFDCId_3 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : [ {"party_id": 100,"sfdc_id": "0011n00001za7MFAAY","name": "SFDC Id 2 Acc","ringgold_id": "11111","pt_id": null,"setup": {"partyId": 200,"orgName": "SFDC Id 2","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":1,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0 }} ] }');
                res.setStatusCode(200);
                return res;
            }if (req.getEndpoint().endsWith('ringgoldId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "SFDC 2 Ringgold","ringgold_id": "11888","pt_id": null,"setup": {"partyId": 200,"orgName": "SFDC 2 Ringgold ","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":1,"bp_count": null,"usage": false,"licenses": null } }');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
        }
    }
        
    public class MergeResponseGenerator_PartyId_WithData implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Bad Request","status":400},"data" :null}');
                res.setStatusCode(400);
                return res;
            } else if (req.getEndpoint().endsWith('partyId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "Party Id with Data ","ringgold_id": "11111","pt_id": null,"setup": {"partyId": 200,"orgName": "Party Id with Data","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 1,"bp_count": null,"usage": false,"licenses": null}}');
                res.setStatusCode(200);
                return res;
            } else if(req.getEndpoint().endsWith('ringgoldId')){
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "Party Id with Data Ringgold",ringgold_id": "11388","pt_id": null,"setup": {"partyId": 4294495,"orgName": "Party Id with Data Rinngold Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 1,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
            /*res.setHeader('Content-Type', 'application/json');
            //TokenDetails token = new TokenDetails();
            res.setStatusCode(200);
            res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 4294495,"sfdc_id": "0011n00001za7MFAAY","name": "ILSI Health and Environmental Sciences Institute","ringgold_id": "460456","pt_id": null,"setup": {"partyId": 4294495,"orgName": "ILSI Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 1,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
            return res;*/
        }
    }
    
    public class MergeResponseGenerator_PartyId_WithoutData implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Bad Request","status":400},"data" :null}');
                res.setStatusCode(400);
                return res;
            } else if (req.getEndpoint().endsWith('partyId')) {
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": null,"sfdc_id": "0011n00001za7MFAAY","name": null,"ringgold_id": null,"pt_id": null,"setup": {"partyId": null,"orgName": null,"ipEnabled": null,"idpEnabled": null,"mfaEnabledUsers": null,"validAddress": false},"parent_accounts": null,"child_accounts": null,"contactList":null,"bp_count": null,"usage": null,"licenses": null}}');
                res.setStatusCode(200);
                return res;
            } else if(req.getEndpoint().endsWith('ringgoldId')){
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "Party Id without Data RinngoldHealth and Environmental Sciences Institute","ringgold_id": "11888","pt_id": null,"setup": {"partyId": 4294495,"orgName": "Party Id with Data rinngold Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList":0,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
            /*res.setHeader('Content-Type', 'application/json');
            //TokenDetails token = new TokenDetails();
            res.setStatusCode(200);
            res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 4294495,"sfdc_id": "0011n00001za7MFAAY","name": "ILSI Health and Environmental Sciences Institute","ringgold_id": "460456","pt_id": null,"setup": {"partyId": 4294495,"orgName": "ILSI Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 1,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
            return res;*/
        }
    }
       
    
    public class MergeResponseGenerator_RinggoldId implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.debug('End point******************'+req.getEndpoint());
            System.debug('End with******************'+req.getEndpoint().endsWith('sfdcId'));
            if (req.getEndpoint().endsWith('sfdcId')) {
                res.setBody('{ "metadata":{"message":"Bad Request","status":400},"data" :null}');
                res.setStatusCode(400);
                return res;
            } else if (req.getEndpoint().endsWith('partyId')) {
                res.setBody('{ "metadata":{"message":"Bad Request","status":500}}');
                res.setStatusCode(400);
                return res;
            } else if(req.getEndpoint().endsWith('ringgoldId')){
                res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 200,"sfdc_id": "0011n00001za7MFAAY","name": "Rinngold Acc Id","ringgold_id": "11388","pt_id": null,"setup": {"partyId": 4294495,"orgName": "Rinngold Acc","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 0,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
                res.setStatusCode(200);
                return res;
            }else{
                res.setBody('{ "metadata":{"message":"Ok","status":200}}');
                res.setStatusCode(200);
                return res;
            }
            /*res.setHeader('Content-Type', 'application/json');
            //TokenDetails token = new TokenDetails();
            res.setStatusCode(200);
            res.setBody('{ "metadata":{"message":"Ok","status":200},"data" : {"party_id": 4294495,"sfdc_id": "0011n00001za7MFAAY","name": "ILSI Health and Environmental Sciences Institute","ringgold_id": "460456","pt_id": null,"setup": {"partyId": 4294495,"orgName": "ILSI Health and Environmental Sciences Institute","ipEnabled": false,"idpEnabled": false,"mfaEnabledUsers": false,"validAddress": false},"parent_accounts": 0,"child_accounts": 0,"contactList": 1,"bp_count": null,"usage": false,"licenses": {"activeLicenseCount": 0,"expiredLicenseCount": 0,"deactiveLicenseCount": 0}}}');
            return res;*/
        }
    }
    
    
    
}