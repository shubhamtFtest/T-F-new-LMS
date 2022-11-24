/**************************************************
* Created by Tom Reed
* Test methods for TF_Billing_Currency_Update Trigger
**************************************************/
@istest
public class zTest_TF_Billing_Currency_Update {
    
    Public static testmethod void TestBillingInsert(){
	    //Insert new Opportunity
    	Opportunity opp = New Opportunity(Name = 'Test Opportunity', Stagename = 'Open', CloseDate = Date.newInstance(2018, 01, 01), CurrencyIsoCode = 'USD');
    	Insert opp;
    
    	Id billingRtId = MiscFunctions.getRecordtypeId('Billing__c', 'T&F One-Off Billing');
        
    	TriggerInterfaceHelper.runTrigger('TF_Billing_Currency_Update_Trig', 'Billing__c', 99, 'bi', billingRtId, null);
    	Billing__c bi = New Billing__c(CurrencyIsoCode = 'GBP', Amount__c = 100, opportunity__c = opp.id, opportunity__r = opp,recordtypeid = billingRtId);
    	Insert bi;
     
		bi = [SELECT id, RecordType.name, CurrencyIsoCode, Opportunity__c, opportunity__r.id  FROM Billing__c]; 
    	System.debug('This id' + bi.opportunity__r.id);  
        
    	System.debug(opp);    
        
    }

}