/*
Created by      :   Renil Rejith
Created Date    :   2021.11.08
Apex Class		:	AutomateContactsToCampaignForArticlePass
Custom Metadata :   Automate Contact to Campaign
Scheduler Class :   AutomateContactsToCampaignScheduler
Test Class		:   Test_AutomateContactsToCampaign
*/
public with sharing class AutomateContactsToCampaignScheduler implements Schedulable {
    public void execute(SchedulableContext sc)
    {
        Database.executeBatch(new AutomateContactsToCampaignForArticlePass(), 2000);
    }
}