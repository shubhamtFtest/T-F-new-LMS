/**************************************************
* Created by:Amit Kumar, 2018.07.17
* Test Class For Trig_TF_Opp_ValidINReqForClosedWon
* Service now ticket: CHG0043878
**************************************************/

@istest
public class zTestTrig_TF_Opp_ValidINReqForClosedWon
{
   @isTest static void  Trig_TF_Opp_ValidINReqForClosedWon()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
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
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    }
    
   @isTest static void  test_eBook()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
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
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    }
    
   @isTest static void  test_invoice_number_is_null()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        oli.Invoice_Date__c = Date.today();
        oli.Invoice_Number__c = null;
        oli.Net_Price__c = 13;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    } 

   @isTest static void  test_invoice_system_SAP()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        oli.Invoice_Date__c = Date.today();
        oli.Invoice_System__c = 'SAP';
        oli.Invoice_Number__c = '12';
        oli.Net_Price__c = 13;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    } 

   @isTest static void  test_invoice_system_PT()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        oli.Invoice_Date__c = Date.today();
        oli.Invoice_System__c = 'PT';
        oli.Invoice_Number__c = '12';
        oli.Net_Price__c = 13;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    } 

   @isTest static void  test_invoice_system_Quickfill()
    {
        User u = zTEST_Shared.insertUser();
        Account a = zTEST_Shared.insertAccount(u.Id);
        Contact c = zTEST_Shared.insertContact(u.Id, a.Id);
        Id recordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - eBooks Opportunity'); 
        TriggerInterfaceHelper.runTrigger('Trig_TF_Opp_ValidINReqForClosedWon', 'Opportunity', 1, 'bi,bu',  recordtypeId, null);   
        
        Opportunity opp = zTEST_Shared.insertOpportunity(recordtypeId, u.Id, a.Id);
        PricebookEntry pbe = zTEST_Shared.insertPricebookEntry();
        OpportunityLineItem oli = zTEST_Shared.noinsertOpportunityLineItem(pbe.Id, opp.Id);
        oli.TotalPrice = null;
        oli.unitPrice = 100;
        oli.Invoice_Date__c = Date.today();
        oli.Invoice_System__c = 'Quickfill';
        oli.Invoice_Number__c = '12';
        oli.Net_Price__c = 13;
        insert oli;
        
        try {
            opp.StageName = 'Closed Won';
            update opp;
        } catch (Exception e){
        }
         
       Trig_TF_Opp_ValidINReqForClosedWon TF = new Trig_TF_Opp_ValidINReqForClosedWon();
    }      
 }