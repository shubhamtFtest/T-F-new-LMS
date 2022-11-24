/*************************************************************************************************
    //This batch class is used to make licenses as Static based on Dynamic License End Date
    //Test class "zTEST_TF_LicenseStaticBatch"
    //Created by Vikas Varshney for UBXC-221 on dated 18 Mar, 2020
*************************************************************************************************/


global class TF_LicenseStaticBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public static Boolean licenseStaticFlag = false;
    
    //Fetching the values from the License__c
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date todaysDate = System.today();
        todaysDate = todaysDate.addDays(-1);
        String updateType = 'Dynamic';
        String querrry = 'SELECT id, Update_Type__c, Dynamic_License_End_Date__c FROM License__c WHERE Dynamic_License_End_Date__c =: todaysDate AND Update_Type__c =:updateType';
    
        return Database.getQueryLocator(querrry);
    }
  
    //Getting all the values in the licenseList    
    global void execute(Database.BatchableContext BC, List<License__c> licenseList) {
        List<License__c> licenseUpdateList = new List<License__c>();
        licenseStaticFlag = true;
        
        if ( !licenseList.isEmpty() ) {
            for ( License__c lic : licenseList ) {
                License__c licUpdate = new License__c();
                licUpdate.id = lic.id;
                licUpdate.Update_Type__c = 'Static';
                licUpdate.Dynamic_License_End_Date__c = NULL;
                licenseUpdateList.add( licUpdate );
            }
        }
        
        if ( !licenseUpdateList.isEmpty() ) {
            update licenseUpdateList;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}