public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCaseRecord(String recordId) {
        return [
            SELECT  Id, SuppliedEmail,SuppliedName, SuppliedPhone, ContactEmail, ContactPhone, ContactId, Contact.Name,Contact.Business__c , AccountId, Contact.Mailing_Country_List__c 
            FROM Case
            WHERE Id =: recordId
            WITH SECURITY_ENFORCED
        ];
    }
    @AuraEnabled
    public static Id getContactList(String conName, String conEmail, String conPhone, String conAccountId, String conBusiness, String conMalingCountry ){
    //     String[] str2 = conName.split(' ');
    //     String fName = str2[0];
    //    String lName = str2[1];
        try{
            Contact con = new Contact();
            // con.LastName=lName;
            // con.FirstName=fName;
            con.LastName = conName;
            con.Email=conEmail;
            con.AccountId=conAccountId;
            con.Phone=conPhone;
            con.Business__c = conBusiness;
            con.Mailing_Country_List__c= conMalingCountry;
           list<Contact> conlist =[SELECT Id,Email FROM Contact WHERE Email=: conEmail];
           List<Case> caseList = [SELECT Id,SuppliedEmail FROM Case WHERE SuppliedEmail=: conEmail];
            if (conlist.size() == 0) {
            insert con;
            if (caseList.size() !=0) {
                for(Case caseRec : caseList)
                {
                    caseRec.ContactId = con.Id;
                }
                update caseList;
            }
            return con.Id; 
            }
             else {
                return null; 
            }
       }
        catch(Exception ex){
            return null;
        }
    }
     
    @AuraEnabled(cacheable=true)
   public static List<Account> getAccount(){
    list<Account> acc =[SELECT id FROM Account WHERE Name = 'CSD Personal'];
    System.debug('acc'+acc);
    return acc;
   }
}