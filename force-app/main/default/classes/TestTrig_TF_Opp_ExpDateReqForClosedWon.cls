@istest
public class TestTrig_TF_Opp_ExpDateReqForClosedWon
{
   @isTest static void  Trig_TF_Opp_ExpDateReqForClosedWon_Test()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ExpiryDateReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        oli.Invoice_Date__c = Date.today();
        oli.Invoice_Number__c = '12';
        oli.Net_Price__c = 13;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
         
        Trig_TF_Opp_ExpiryDateReqForClosedWon TF = new Trig_TF_Opp_ExpiryDateReqForClosedWon();
    }
 }