/*
Created by      :   Renil Rejith
Created Date    :   2022.05.13
User Story      :   [MES-120] https://taylorfrancis.atlassian.net/browse/MES-120
Description     :   Automate adding contacts to campaign for marketing. 
                    The Marketing team would like to automate the process of adding contacts to campaing than 
                    doing it manually from the report. This scheduled class runs every 14 days and adds contacts to campaign. 
Custom Metadata :   Automate Contact to Campaign
Scheduler Class :   AutomateConsToCampCoreSubsScheduler
Test Class      :   Test_AutomateConsToCampCoreSubs

*/
public with sharing class AutomateContactsToCampaignForCoreSubs implements Database.Batchable<SObject>, Database.Stateful
{       
    Set<Id> oppIdSet = new Set<Id>();  
    Map<Id,String> contactMap = new Map<Id,String>();
    Automate_Contact_to_Campaign__mdt autoContToCamp;
    
    public AutomateContactsToCampaignForCoreSubs()
    {
        //custom metadata to fetch email, opportunity owner and campaign Id.
        autoContToCamp = [SELECT DeveloperName, Campaign_Id__c, Email_Domain_To_Ignore__c,
                                                            Opportunity_Owners__c, Product_Name__c  
                                                            FROM Automate_Contact_to_Campaign__mdt 
                                                            WHERE DeveloperName = 'Contacts_to_Campaign_for_Core_Subs' LIMIT 1];
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {          
        String  query   =  'SELECT Id, Name, StageName, CloseDate, Owner.Name, ContactId, ';  
                query   += '(SELECT Id, Name FROM OpportunityLineItems WHERE Name LIKE \'%'+autoContToCamp.Product_Name__c+'%\') ';     
                query   += 'FROM Opportunity ';
                query   += 'WHERE StageName = \'Closed Won\' AND  (NOT Name LIKE \'%AGENT%\') ';
                query   += 'AND CloseDate = THIS_YEAR AND Type = \'New Business\' ';
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> oppList)
    {
        List<CampaignMember> campaignMembersList = new List<CampaignMember>();
        List<String> oppsOwnerList = autoContToCamp.Opportunity_Owners__c.split(',');
        
        //Looping over the Opportunity List to get the OppsId
        if(!oppList.isEmpty())
        {
            for(Opportunity opp : oppList)
            {
                //check if opps entering have related oppLineItems
                if(!opp.OpportunityLineItems.isEmpty())
                {
                    //looping over the Opportunity Owner list in the custom metadata.
                    for(String oppOwnr : oppsOwnerList)
                    {
                        //check if Opp owner's name is in the above list(oppsOwnerList)
                        if(opp.Owner.Name.contains(oppOwnr))
                        {
                            oppIdSet.add(opp.Id);
                        }
                    }
                }
            }
        }
        
        if(!oppIdSet.isEmpty())
        {
            //Looping over the OpportunityContactRole to insert contacts to campaign
            for(OpportunityContactRole oppConRole : [SELECT Id, OpportunityId, ContactId, Contact.Email, Contact.Status__c,
                                                     Contact.HasOptedOutOfEmail, Contact.Name
                                                     FROM OpportunityContactRole 
                                                     WHERE OpportunityId IN: oppIdSet AND Contact.Status__c = 'Active' 
                                                     //AND Contact.HasOptedOutOfEmail = false 
                                                     AND (NOT Contact.Email LIKE: autoContToCamp.Email_Domain_To_Ignore__c)])
            {
                if(!contactMap.containsKey(oppConRole.ContactId))
                {
                    contactMap.put(oppConRole.ContactId,oppConRole.Contact.Status__c);
                    if(!oppConRole.Contact.Email.contains(autoContToCamp.Email_Domain_To_Ignore__c))
                    {
                        System.debug('Cons '+oppConRole.Contact.Name);
                        //create campaign members with status 'added to campaign' and get campaign Id from the Custom Metadata
                        CampaignMember cm = New CampaignMember(CampaignId = autoContToCamp.Campaign_Id__c, ContactId=oppConRole.ContactId, 
                                                                Status='Added to Campaign');
                    
                        campaignMembersList.add(cm);
                    }
                }
            }
        }
        try {
            Database.SaveResult[] campMemberResult = Database.insert(campaignMembersList, false);
        } catch (DMLException ex) {
            throw new DMLException('Unable to perform DML on Campaign Members '+ex.getMessage());
        }
    } 

    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                            FROM AsyncApexJob 
                            WHERE Id =: bc.getJobId()];
    }
}