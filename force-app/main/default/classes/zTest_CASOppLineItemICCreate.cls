/************************************************************************** 
*
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2016-01-06 
***************************************************************************/
@isTest
public class zTest_CASOppLineItemICCreate 
{
	static testMethod void testCAS_1() 
    {
    		Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
    	
        TriggerInterfaceHelper.runTrigger('CAS_OppLineItemICCreate_Trig', 'OpportunityLineItem', 50, 'bu', oppRtId, null);
        
        User u = zTEST_Shared.insertUser();
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry('0120Y000000WnAaQAK');//T&F - Products
        Product2 p = [Select Subject_Code__c, Id From product2 where Id =:pbe.Product2Id];
        String addSubjectCodes = '; subj0101 - this is only a test1; subj0202 - this is only a test2';
        P.Subject_Code__c = P.Subject_Code__c + ' - test' + addSubjectCodes;
        update p;
        
        Opportunity opp = zTEST_Shared.insertOpportunity(oppRtId,u.Id); 
        OpportunityLineItem oli = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        OpportunityLineItem oli2 = zTEST_Shared.insertOpportunityLineItem(pbe.Id, opp.Id, 'Created');
        
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Contact c2 = zTEST_Shared.insertContact(u.Id, a.Id);
        
        oli.Adoption_Stage__c = 'In-Process';
        oli.Order_Type__c = 'HSS Vitalsource e-Exam copy';
		oli.Recipient__c = c.Id;
        oli.Feedback_Notification__c = 'Send';
        oli2.Adoption_Stage__c = 'In-Process';
        oli2.Order_Type__c = 'CRC Vitalsource e-Exam copy';
        oli2.Recipient__c = c2.Id;
        oli2.Feedback_Notification__c = 'Do Not Send';
            
        update new OpportunityLineItem[]{oli,oli2};
            
        CAS_Inspection_Copy__c ic = Tests_CASVitalSource.setupTestInspectionCopy(oli.Id,opp.Id);
        
        oli.Order_Type__c = 'HSS Vitalsource e-Exam copy';
        oli.Feedback_Notification__c = 'Do Not Send';
        oli.VitalSource_Redeemed_Date__c = date.today().addDays(1);
        oli.Adoption_Stage__c = 'In-Process';
        oli.Fulfillment_House__c = 'test';
        oli.Shipping_Date__c = date.today();
        oli.IsTesting__c = True;
        update oli;
        oli.Shipping_Date__c = date.today().addDays(1);
        update oli;   
        
    }
}