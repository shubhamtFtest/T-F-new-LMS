@istest
public class zTestTrig_Opp_InvoiceDateReqForClosedWon
{
   @isTest static void  Trig_TF_Opp_InvoiceDateReqForClosedWon()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_InvoiceDateReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
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
         
       Trig_TF_Opp_InvoiceDateReqForClosedWon TF = new Trig_TF_Opp_InvoiceDateReqForClosedWon();
    }  
    
   @isTest static void  Trig_TF_Opp_InvoiceDateReqForClosedWon2()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        //Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity');
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_InvoiceDateReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
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
         
       Trig_TF_Opp_InvoiceDateReqForClosedWon TF = new Trig_TF_Opp_InvoiceDateReqForClosedWon();
    }     
 }