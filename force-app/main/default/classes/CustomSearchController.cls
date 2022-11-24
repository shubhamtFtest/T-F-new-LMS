/*CustomSearchController_Test
created by Sidhant Chauhan
*/
public class CustomSearchController {
    @AuraEnabled
    public static List<Print_Order__c> searchForIds(String searchText) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        Id userId=UserInfo.getUserId();
        Id contactid=[Select contactid from user where Id=:userId].contactid;
        Contact cc=[select id,AccountId from contact where id=:contactid];
        //   List<List<SObject>> results = [FIND :searchText IN ALL FIELDS  RETURNING Print_Order__c(Id,Name)];
        List<Print_Order__c> ids = new List<Print_Order__c>();
        //for (List<SObject> sobjs : results) {
        if(profileName=='India Reprint Printer'){
            for (Print_Order__c sobj : [select id,name,printer__c from Print_Order__c where printer__c=:cc.Accountid and name =:searchText]) {
                
                ids.add(sobj);
            }
        }
        else if(profileName=='India Reprint Distributor'){
            for (Print_Order__c sobj : [select id,name,customer__c from Print_Order__c where customer__c=:cc.accountid and name =:searchText]) {
                ids.add(sobj);
            }
        }
        else if(profileName=='India Reprint Credit Control'){
            for (Print_Order__c sobj : [select id,name from Print_Order__c where name =:searchText]) {
                ids.add(sobj);  
            }
        }
        // }
        return ids;
    }
}