//Class: OppRenewalTFeBooks.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Bharat- 2017.11.08 - Ticket #CHG0038753  
//Modified by Matt Smith - 2019.05.30 - 01236121
//Modified by Matt Smith - 2021.09.14 - 01945770

public with sharing class OppRenewalTFeBooks {
    public static void renewOpps(Set<Id> oppIds, List<Opportunity> opps) {
        //Called in Trigger
        //renew(opps, false); //coming from a Before Update trigger, so calling the Update command is not necessary
        renew(oppIds, opps, false); //coming from a Before Update trigger, so calling the Update command is not necessary
    }
    public static Id renewOpp(Id oppId) {
        //Called from page, so return cloned Id so it can be navigated to
        return renew(new Set<Id>{oppId}, null, true);
    }
    private static Id renew(Set<Id> oppIds, List<Opportunity> opps, Boolean performUpdate) {
        Id returnVal;
        
        Id salesRepId = TF_ERN_Settings__c.getOrgDefaults().Sales_Rep_Id__c; //The new opp owner
      
        //Get Opportunites to renew (inlude all fields to clone)
        if (opps == null)
          opps = [SELECT Id, Name, StageName, AccountId, Next_Renewal__c, CloseDate, Volume_Year__c, Start_Date__c, End_Date__c,
                    OwnerId, Participating_institutions__c, Pricebook2Id, CurrencyIsoCode, RecordtypeId, Deal_Type__c,
                    Parent_Opportunty__c, Account.Region__c, Account.Locale__c, Primary_Contact__c, Primary_Contact__r.Id, Product_Family__c, Order_Type__c, Renewal_Method__c
                  FROM Opportunity
                WHERE Id IN :oppIds];

        //See if Parent Opp was already renewed
        Set<Id> parentOppIds = new Set<Id>();
        for (Opportunity opp : opps) {
          if (opp.Parent_Opportunty__c != null)
              parentOppIds.add(opp.Parent_Opportunty__c);
        }
        List<Opportunity> parentRenewalOpps = [SELECT Id, Previous_Renewal__c FROM Opportunity WHERE Previous_Renewal__c IN :parentOppIds];
        Map<Id,Id> mapParentOppToParentRenewal = new Map<Id,Id>();
        for (Opportunity parentRenewalOpp : parentRenewalOpps) {
            mapParentOppToParentRenewal.put(parentRenewalOpp.Previous_Renewal__c, parentRenewalOpp.Id);
        }
        
        //Get currency code for salesRepId
        String salesRep_CurrencyIsoCode = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id = :salesRepId].DefaultCurrencyIsoCode;
        
        map<Id,String> mapOldOppIdToRenewalCurrency = new map<Id,String>();
        
        //Clone Opps
        List<Opportunity> clonedOpps = new List<Opportunity>();
        for (Opportunity opp : opps) {
            Opportunity clonedOpp = opp.clone(false, true, false, false);
            clonedOpp.StageName = 'Prospect';
            clonedOpp.Probability = 10;
            clonedOpp.Type = 'Renewal';
            clonedOpp.LeadSource = 'Renewal';
            clonedOpp.Lead_Source_Detail__c = 'N/A';
            clonedOpp.Primary_Contact__c = opp.Primary_Contact__r.Id; //copies over the primary contact field value so it doesn't create a duplicate OCR due to this trigger - Trig_CreateContactRole_opp
            clonedOpp.Description = ''; //Description should be empty
            clonedOpp.Opportunity_for_Renewal__c = 'Yes';
            if (opp.End_Date__c == null)
              clonedOpp.Start_Date__c = (opp.Start_Date__c == null ? null : opp.Start_Date__c.addYears(1)); //Add one year
      else
              clonedOpp.Start_Date__c = opp.End_Date__c.addDays(1); //The day after the previous opp's end date
            clonedOpp.End_Date__c = (opp.End_Date__c == null ? null : opp.End_Date__c.addYears(1)); //Add one year
            clonedOpp.CloseDate = clonedOpp.Start_Date__c;
            clonedOpp.Name = opp.Name + ' - Renewal';
            clonedOpp.Last_Year_s_Owner__c = opp.OwnerId;
            clonedOpp.Subs_Amount_GBP__c = 0;
            clonedOpp.Subs_Amount_USD__c = 0;
            clonedOpp.Amount = 0;
            clonedOpp.Previous_Renewal__c = opp.Id;
            clonedOpp.Don_t_Send__c = false;
            clonedOpp.Date_Sent__c = null;
            clonedOpp.Customer_Response__c = null;
            clonedOpp.Customer_Feedback__c = null;
            clonedOpp.Date_Reminder_Sent__c = null;
            clonedOpp.Date_Second_Reminder_Sent__c = null;
            if (opp.Order_Type__c == 'One-Time Purchase')
              clonedOpp.Order_Type__c = 'Maintenance';
            if (opp.Parent_Opportunty__c != null && mapParentOppToParentRenewal.containsKey(opp.Parent_Opportunty__c))
                clonedOpp.Parent_Opportunty__c = mapParentOppToParentRenewal.get(opp.Parent_Opportunty__c);
            //Get Owner & Currency
            /*Set<String> familyExclusions = new Set<String>{'eBooks','T&F Reference','Routledge Reference','Medical'};  // add Medical Product family
            if (opp.Account.Region__c == 'Americas' || familyExclusions.contains(opp.Product_Family__c) == false) {
                clonedOpp.OwnerId = salesRepId;
                clonedOpp.CurrencyIsoCode = salesRep_CurrencyIsoCode;
            }*/
      if (opp.Account.Locale__c == 'AMERICAS') {
                    clonedOpp.OwnerId = salesRepId;
                    clonedOpp.CurrencyIsoCode = salesRep_CurrencyIsoCode;
                }
            else {
                clonedOpp.OwnerId = opp.OwnerId;  
            }      
            
      mapOldOppIdToRenewalCurrency.put(opp.Id, clonedOpp.CurrencyIsoCode);
      //Add to List            
            clonedOpps.add(clonedOpp);
        }
        system.debug('LUP: Inserting clonedOpps = ' + clonedOpps);
        Database.SaveResult[] srList = Database.insert(clonedOpps);
        
        //Update old Opportunity
        map<Id,Id> mapMainToRenewal = new map<Id,Id>();
        for (Integer i = 0; i < opps.size(); i++) {
            opps[i].Next_Renewal__c = srList[i].getId();
          system.debug('LUP: opps[i].Next_Renewal__c = ' + opps[i].Next_Renewal__c);
            opps[i].Renewal_Date__c = date.today();
            opps[i].Reason_No_Renewal__c = null;
            mapMainToRenewal.put(opps[i].Id, srList[i].getId());
        }
        if (performUpdate)
          update opps;
        
        //***** Get OpportunityLineItem to clone *****
        List<OpportunityLineItem> olis = 
         [SELECT Id, OpportunityId, Opportunity.CurrencyIsoCode, PricebookEntry.Product2Id, PricebookEntry.Pricebook2Id, 
           PricebookEntryId, Quantity, eBook_Order_Type__c,
            Start_Date__c, End_Date__c, Access__c, Trial_Start_Date__c, Trial_End_Date__c,
            Product_Type__c, Scheduled__c, Core_Subscription__c, Description,
            PricebookEntry.Product2.Family, UnitPrice, Invoice_Number__c, AccountName__c,
          Seats_Users__c
          FROM OpportunityLineItem
          WHERE OpportunityId IN :oppIds];
        
        //check for change in currency
        Set<Id> productIds = new Set<Id>();
        for (OpportunityLineItem oli : olis) {  
          if (mapOldOppIdToRenewalCurrency.get(oli.OpportunityId) != oli.Opportunity.CurrencyIsoCode)
            productIds.add(oli.PricebookEntry.Product2Id);
        }
        //Get replacement PricebookEntry records
        Map<String, Id> mapNewPbeId = new Map<String, Id>();
        if (productIds.size() > 0) {
          List<PricebookEntry> pbes = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id IN :productIds AND CurrencyIsoCode = :salesRep_CurrencyIsoCode];
          for (PricebookEntry pbe : pbes) {
            mapNewPbeId.put(pbe.Product2Id + ':' + pbe.Pricebook2Id, pbe.Id);
          }
        }
        //Clone OLIs
        List<OpportunityLineItem> clonedOlis = new List<OpportunityLineItem>();
        for (OpportunityLineItem oli : olis) {
            OpportunityLineItem clonedOli = oli.clone(false, true);
            //Get new Opp
            clonedOli.OpportunityId = mapMainToRenewal.get(oli.OpportunityId);
            //change Pricebook (if necessary)
            Boolean invalidProduct = false;
            if (oli.Opportunity.CurrencyIsoCode != mapOldOppIdToRenewalCurrency.get(oli.OpportunityId)) {
              String key = oli.PricebookEntry.Product2Id + ':' + oli.PricebookEntry.Pricebook2Id;
            if (mapNewPbeId.containsKey(key))
                clonedOli.PricebookEntryId = mapNewPbeId.get(key);
            else
                invalidProduct = true;
            } else {
              clonedOli.PricebookEntryId = oli.PricebookEntryId;
            }
            clonedOli.Description = oli.Description;
            clonedOli.UnitPrice = oli.UnitPrice; //Updated this line to copy over unit price, so total amount would copy over to new opp.
            clonedOli.Invoice_Number__c = ''; //Invoice Number should be blank 
            // clonedOli.TotalPrice = null; //can't specify both UnitPrice and TotalPrice
            // clonedOli.Previous_Sales_Price__c = oli.TotalPrice; // previous sales price is an old field from the Informa org. 
            // clonedOli.Previous_Invoice__c = oli.Invoice_Number__c; // previous invoice is an old field from the Informa org.
            // clonedOli.Invoice_Number__c = null; // invoice number is an old field from the Informa org.
            if (!invalidProduct)
              clonedOlis.add(clonedOli);
        }
        if (clonedOlis.size() > 0)
            insert clonedOlis;
        
        //***** Clone OpportunityContactRole *****
        List<OpportunityContactRole> ocrs = 
         [SELECT Id, ContactId, OpportunityId, Role, IsPrimary
          FROM OpportunityContactRole
          WHERE OpportunityId IN :oppIds];

        List<OpportunityContactRole> clonedOcrs = new List<OpportunityContactRole>();
        for (OpportunityContactRole ocr : ocrs) {
            OpportunityContactRole clonedOcr = ocr.clone(false, true);
            clonedOcr.OpportunityId = mapMainToRenewal.get(ocr.OpportunityId);
            clonedOcrs.add(clonedOcr);
        }
        if (clonedOcrs.size() > 0)
            insert clonedOcrs;

        //***** Participants *****
        List<Account_To_Opportunity__c> oldA2Os = [SELECT Id, Account__c, Opportunity__c FROM Account_To_Opportunity__c WHERE Opportunity__c IN :oppIds];
        if (oldA2Os.size() > 0) {
            List<Account_To_Opportunity__c> newA2Os = new List<Account_To_Opportunity__c>();
            for (Account_To_Opportunity__c oldA2O : oldA2Os) {
                Account_To_Opportunity__c newA2O = new Account_To_Opportunity__c();
                newA2O.Account__c = oldA2O.Account__c;
                newA2O.Opportunity__c = mapMainToRenewal.get(oldA2O.Opportunity__c);
                newA2Os.add(newA2O);
            }
            insert newA2Os;
        }

        //return Cloned Opp Id for redirect
        return srList[0].getId();
    }
}