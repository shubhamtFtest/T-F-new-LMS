/*
 Created by Jeff Lup on 2014.04.08, CHG0057797, for Journals
 Modified by Hailey Niemand - 2014.11.07 - CHG0062554 - ensure PBE selected isn't in Standard Pricebook
 Modified by Hailey Niemand - 2015.10.26 - CHG0069223
 Modified by Jeff Lup on 2017.06.02 - CHG0035197 - changed class to "without sharing"
Modified by Bharat on 2017.12.15 - CHG0039538 --- Opportunity Name should be Account Name and the following volume year.
Modified by Piyush Jain - 2018.03.12 - CHG0042296- added child oppornties update
Modified By Shefali Arora - 2020.02.10 (Jira Ticket SAL-1307)

*/

//public with sharing class OppRenewalPromptLb_TFJournalsController {
public without sharing class OppRenewalPromptLb_TFJournalsController { //CHG0035197
    private Opportunity opp;
    
    public Id oppId { get { return opp.Id;} set; }
    public Id renewalId { get; set; }
    public String reasonForNoRenewal { get; set; }  
    public String oldStage { get; set; }
    public Boolean showOldStage { get; set; }
    
    public OppRenewalPromptLb_TFJournalsController(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord();
        List<OpportunityFieldHistory> ofh = [SELECT OldValue
                                             FROM OpportunityFieldHistory
                                             WHERE OpportunityId = :opp.Id
                                                AND Field = 'StageName'
                                             ORDER BY CreatedDate DESC
                                             LIMIT 1];
        if (ofh.size() > 0) {
            oldStage = (String)ofh[0].OldValue;
            showOldStage = true;
        } else {
            showOldStage = false;
        }
    }
    
    public Pagereference yesRenewal() {
         // CHG0039538 Change Cloned Opp Name with Account Name following with volume year
        //unnecessary, as this class only runs for Journals
        /*
        TFJournalRecordRenewal__c tfRecordtypeID= TFJournalRecordRenewal__c.getValues('RecordTypeId');
        string recordTypeId='';
        if(tfRecordtypeID!=null && tfRecordtypeID.RecordTypeID__c !=''){
            recordTypeId=tfRecordtypeID.RecordTypeID__c;
        }
        */
        
        //***** Get OpportunityLineItem to clone *****
        List<OpportunityLineItem> olis = 
         [SELECT Id, OpportunityId, PricebookEntryId, Quantity, eBook_Order_Type__c,
            Start_Date__c, End_Date__c, Access__c, Trial_Start_Date__c, Trial_End_Date__c,
            Product_Type__c, Scheduled__c, Core_Subscription__c, Description,
            PricebookEntry.Product2.Family, PricebookEntry.Product2.Target_Product__c
            , Category__c //CHG0069223
           ,UnitPrice  //CHG0075099
          FROM OpportunityLineItem
          WHERE OpportunityId = :opp.Id];
        
        //***** Clone Opportunity *****
        Opportunity clonedOpp = opp.clone(false, true);
        
        //CHG0043678 - was commented out because of bug, but was never fixed
        //clonedOpp.CloseDate = (opp.Volume_Year__c == null ? null : Date.newInstance(12, 31, integer.valueOf(opp.Volume_Year__c) + 1)); //Dec 31 of next year
        clonedOpp.CloseDate = (opp.Volume_Year__c == null ? null : Date.newInstance(integer.valueOf(opp.Volume_Year__c) + 1, 12, 31)); //Dec 31 of next year

        clonedOpp.Volume_Year__c = (opp.Volume_Year__c == null ? null : String.valueOf(Integer.valueOf(opp.Volume_Year__c) + 1)); //Add one year
        if(opp.Volume_Year__c >= opp.Multi_Year_Deal_End_Year__c){
            clonedOpp.Multi_year_deal__c = '';
            clonedOpp.Multi_Year_Deal_Start_Year__c = '';
            clonedOpp.Multi_Year_Deal_End_Year__c = '';    
        }
        else {
            clonedOpp.Multi_year_deal__c = opp.Multi_year_deal__c;
            clonedOpp.Multi_Year_Deal_Start_Year__c = opp.Multi_Year_Deal_Start_Year__c;
            clonedOpp.Multi_Year_Deal_End_Year__c = opp.Multi_Year_Deal_End_Year__c;   
        }
        
       // CHG0039538 Change Cloned Opp Name with Account Name following with volume year
        //if(recordTypeId == opp.RecordTypeId){ //this class only runs for Journals
            string AccountName=[select Name from Account where Id = : opp.AccountId ].Name; 
            clonedOpp.Name= AccountName +'-Renewal '+ clonedOpp.Volume_Year__c;
            clonedOpp.Opportunity_for_Renewal__c = 'Yes';
   
        //}else{
            //clonedOpp.Name=clonedOpp.Volume_Year__c + ' Renewal';
        //}
        
      //  clonedOpp.Name = clonedOpp.Volume_Year__c + ' Renewal';
        clonedOpp.Description = ''; //Description should be empty
        //clonedOpp.Amount = 0;
        clonedOpp.Subs_Amount_GBP__c = 0;
        clonedOpp.Subs_Amount_USD__c = 0;
        if(opp.StageName =='Investigating'){ //CHG0075099 
            clonedOpp.StageName = 'Investigating';
        }
        else if(opp.StageName =='Closed Won'){
            clonedOpp.StageName = 'Evaluating';
        }
        clonedOpp.Probability = 10;
        clonedOpp.Type = 'Renewal';
        clonedOpp.LeadSource = 'Renewal';
        //clonedOpp.Start_Date__c = (opp.Start_Date__c == null ? null : opp.Start_Date__c.addYears(1)); //Add one year
        //clonedOpp.End_Date__c = (opp.End_Date__c == null ? null : opp.End_Date__c.addYears(1)); //Add one year
        if (opp.Parent_Opportunty__c != null) {
            List<Opportunity> parentsRenewalOpps = [SELECT Id FROM Opportunity WHERE Previous_Renewal__c = :opp.Parent_Opportunty__c LIMIT 1];
            if (parentsRenewalOpps.size() > 0)
                clonedOpp.Parent_Opportunty__c = parentsRenewalOpps[0].Id;
        }
        clonedOpp.Previous_Renewal__c = opp.Id;
        
        insert clonedOpp;
        
         //*******Clone OppotunityTeam
        List<OpportunityTeamMember> relatedTeamMembers = new List<OpportunityTeamMEmber>();
        for(OpportunityTeamMember tm : [SELECT OpportunityAccessLevel, OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember WHERE OpportunityId =: opp.id]){
            //if(opp.OwnerId != tm.UserId && tm.TeamMemberRole !='Opportunity Owner'){
                OpportunityTeamMember otm = tm.clone(false);
                otm.OpportunityID = clonedOpp.Id;
                relatedTeamMembers.add(otm);
           // }
        } 
               
        insert relatedTeamMembers;
        
        //***** Clone Child oppornuiteis - piyush *****
         List<Opportunity> Childopp = new List<Opportunity>();
          for(Opportunity ch : [SELECT Id,Parent_Opportunty__c,Volume_Year__c FROM Opportunity WHERE Parent_Opportunty__c = :opp.id ])
                {
                     system.debug('ch1'+ch);
                     system.debug('Volume year'+clonedOpp.Volume_Year__c);
                     system.debug('Volume yearchild'+(opp.Volume_Year__c == null ? null : String.valueOf(Integer.valueOf(opp.Volume_Year__c) + 1)));
                   If(opp.id !=opp.Parent_Opportunty__c && ch.Volume_Year__c == clonedOpp.Volume_Year__c)
                       {
                           system.debug('ch'+ch);
                           ch.Parent_Opportunty__c = clonedOpp.Id;
                           Childopp.add(ch);
                           system.debug('ch2'+ch);
                        }
                 } 
            if(Childopp.size()>0)
                 {
                   update Childopp ;
                   
                 }
        
        //***** Clone OpportunityLineItem *****
        Set<Id> targetProductIds = new Set<Id>();
        Map<Id,Id> mapOldPbeIdToTargetProductId = new Map<Id,Id>();
        for (OpportunityLineItem oli : olis) {
            targetProductIds.add(oli.PricebookEntry.Product2.Target_Product__c);
            mapOldPbeIdToTargetProductId.put(oli.PricebookEntryId, oli.PricebookEntry.Product2.Target_Product__c);
            
        }
        List<PricebookEntry> targetPBEs = [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2Id IN :targetProductIds AND CurrencyIsoCode = :opp.CurrencyIsoCode AND Pricebook2Id = :opp.Pricebook2Id]; //CHG0062554 
        Map<Id,Id> mapTargetProductIdToPBEId = new Map<Id,Id>();
        for (PricebookEntry pbe : targetPBEs) {
            mapTargetProductIdToPBEId.put(pbe.Product2Id, pbe.Id);
        }
        
        List<OpportunityLineItem> clonedOlis = new List<OpportunityLineItem>();
        for (OpportunityLineItem oli : olis) {
            OpportunityLineItem clonedOli = oli.clone(false, true);
            clonedOli.OpportunityId = clonedOpp.Id;
            Id newPricebookEntryId = mapTargetProductIdToPBEId.get(mapOldPbeIdToTargetProductId.get(oli.PricebookEntryId));
            clonedOli.PricebookEntryId = (newPricebookEntryId == null ? oli.PricebookEntryId : newPricebookEntryId);
            clonedOli.Category__c = oli.Category__c; //CHG0069223
            //clonedOli.Start_Date__c = (oli.Start_Date__c == null ? null : oli.Start_Date__c.addYears(1)); //Add one year
            //clonedOli.End_Date__c = (oli.End_Date__c == null ? null : oli.End_Date__c.addYears(1)); //Add one year
            //clonedOli.Trial_Start_Date__c = (oli.Trial_Start_Date__c == null ? null : oli.Trial_Start_Date__c.addYears(1)); //Add one year
            //clonedOli.Trial_End_Date__c = (oli.Trial_End_Date__c == null ? null : oli.Trial_End_Date__c.addYears(1)); //Add one year
            clonedOli.Description = ''; //Description should be empty
            clonedOli.UnitPrice = oli.UnitPrice;//0; //Zero price //CHG0075099 @@Avi
            clonedOlis.add(clonedOli);
        }
        if (clonedOlis.size() > 0)
            insert clonedOlis;
        
        //***** Clone Opportunity Attachment :CHG0075099 *****
         List<Attachment> attachments = 
         [SELECT Id, Body, Parentid, Name,ContentType
          FROM Attachment
          WHERE Parentid = :opp.Id];

        List<Attachment> clonedAttachments = new List<Attachment>();
        for (Attachment attachment : attachments) {
            Attachment clonedAttch = attachment.clone(false, true);
            clonedAttch.Parentid = clonedOpp.Id;
            clonedAttachments.add(clonedAttch);
        }
        if (clonedAttachments.size() > 0)
            insert clonedAttachments;
        //***** End Clone Opportunity Attachment*****
        
        //***** Clone OpportunityContactRole ***** 
        List<OpportunityContactRole> ocrs = 
         [SELECT Id, ContactId, OpportunityId, Role, IsPrimary
          FROM OpportunityContactRole
          WHERE OpportunityId = :opp.Id];

        List<OpportunityContactRole> clonedOcrs = new List<OpportunityContactRole>();
        for (OpportunityContactRole ocr : ocrs) {
            OpportunityContactRole clonedOcr = ocr.clone(false, true);
            clonedOcr.OpportunityId = clonedOpp.Id;
            clonedOcrs.add(clonedOcr);
        }
        if (clonedOcrs.size() > 0)
            insert clonedOcrs;

        //***** Participants *****
        List<Account_To_Opportunity__c> oldA2Os = [SELECT Id, Account__c, Opportunity__c FROM Account_To_Opportunity__c WHERE Opportunity__c = :opp.Id];
        if (oldA2Os.size() > 0) {
            List<Account_To_Opportunity__c> newA2Os = new List<Account_To_Opportunity__c>();
            for (Account_To_Opportunity__c oldA2O : oldA2Os) {
                Account_To_Opportunity__c newA2O = new Account_To_Opportunity__c();
                newA2O.Account__c = oldA2O.Account__c;
                newA2O.Opportunity__c = clonedOpp.Id;
                newA2Os.add(newA2O);
            }
            insert newA2Os;
        }

        //***** Update old Opportunity *****
        opp.Next_Renewal__c = clonedOpp.Id;
        //opp.Reason_No_Renewal__c = 'Test Reason';
        update opp;
        
        //set renewalId for redirect
        renewalId = clonedOpp.Id;// Getting the renewal Id
        
        Pagereference pageRef = new Pagereference('/'+renewalId);
        return pageRef;

        return null;
    }

    public Pagereference noRenewal() {
        if (reasonForNoRenewal != null && reasonForNoRenewal != '') {
            opp.Reason_No_Renewal__c = reasonForNoRenewal;
            update opp;
        }
        return null;
    }
    public Pagereference cancelClosedWon() {
        opp.StageName = oldStage;
        update opp;
        return null;
    } 
}