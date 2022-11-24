/****************************************************************************************
    //This batch class is used to expire the license based on license type and end date
    //Created by Shefali for POF-265 on dated 12-10-2018
    //Test class "zTEST_TF_LicenseExpirationBatch"
    //Modified by Vikas Varshney for POF-264 on dated 17-10-2018, added a callout in finish method
    //and stopped callout from trigger 'TF_CreateLicenseJSON_Tgr'
    //Modified by Vikas Varshney for POF-604 on dated 13-11-2018
    //Modified by Shefali Arora for POF-646 on dated 23-11-2018
    //Modified by Shefali Arora for POF-785 on date 08-02-2019
    //Modified by Vikas Varshney for LMS-181 on dated 25th July, 2019
    //Modified by Vikas Varshney for LMS-251 on dated 06th September, 2019
    //Modified by Vikas Varshney for UBX-10932 on dated 14th August, 2020
****************************************************************************************/


global class TF_LicenseExpirationBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public static Boolean stopLicenseTriggerFlag = false;
    public List<License__c> licenseFinishList = new List<License__c>();
    
    //Fetching the values from the License__c
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date todaysDate = System.today()-1;
        String querrry = 'SELECT id, name, Customer__c, Customer__r.Type, Customer__r.Ringgold_Account_ID__c, Customer__r.Customer_Id__c, Update_Type__c, Product__c, Product__r.Hub_Id__c, Order_Number__c, License_Type__c, Grant_Type__c, Start_Date__c, End_Date__c, Status__c, Contact__c, Contact__r.Party_Id__c, RecordType.Name, Access_Scope__c FROM License__c WHERE End_Date__c =: todaysDate';
    
        return Database.getQueryLocator(querrry);
    }
  
    //Getting all the values in the licenseList    
    global void execute(Database.BatchableContext BC, List<License__c> licenseList) {
        licenseFinishList.clear();
        stopLicenseTriggerFlag = true;
        if (!licenseList.isEmpty()) {
            for (License__c l : licenseList ) {
                if( (l.License_Type__c != NULL) && ((l.License_Type__c == 'Subscription') || (l.License_Type__c == 'Trial') || (l.License_Type__c == 'EBS')) ) {
                    licenseFinishList.add(l);
                }
            }  
        }
                
        if ( !licenseFinishList.isEmpty() ) {
            TF_CreateLicenseJSON_Tgr obj = new TF_CreateLicenseJSON_Tgr();
            obj.extraLicenseExecution( licenseFinishList );
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
}