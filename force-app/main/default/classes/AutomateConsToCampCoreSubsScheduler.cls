/*
Created by      :   Renil Rejith
Created Date    :   2022.051.13
User Story      :   [MES-120] https://taylorfrancis.atlassian.net/browse/MES-120
Apex Class      :   AutomateContactsToCampaignForCoreSubs
Custom Metadata :   Automate Contact to Campaign
Test Class      :   Test_AutomateConsToCampCoreSubs
*/
public with sharing class AutomateConsToCampCoreSubsScheduler implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        Database.executeBatch(new AutomateContactsToCampaignForCoreSubs(), 2000);
    }
}