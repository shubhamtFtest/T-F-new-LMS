public class ConvertContactToPersonAccount {
    public static void convertAcc(id contactID, id PersonAccountID){
        Contact contactNeedConversion = [SELECT ID,FirstName,LastName, IsPersonAccount,AccountID,OwnerID FROM Contact WHERE Id = :contactID];
        Account newPersonAccount = [SELECT id, RecordTypeId from Account where id = :PersonAccountID];
        newPersonAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        //TODO if newPersonAccount is null then make CS call and update the party ID 
        Database.SaveResult[] updatedAccounts = Database.update(new List<Account>{newPersonAccount}, false) ;
        System.debug('updated Person Accounts'+ updatedAccounts);
        if(updatedAccounts.get(0).isSuccess()){Account newAccount = [SELECT id,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,FirstName,LastName,PersonEmail,Phone,Request_BP_Number__c,Customer_Id__c,Request_RRAddressId__c from Account where id = :PersonAccountID];
            if(newAccount.Request_BP_Number__c  != null && newAccount.Request_BP_Number__c != ''){Country__c countryCode = [SELECT Country_2__c, Name FROM Country__c where Name =:newAccount.BillingCountry];
                String jsonStringBody = '';jsonStringBody+='{';jsonStringBody+='"houseNumber": "",';jsonStringBody+='"addressLine1": "'+ newAccount.BillingStreet +'",';jsonStringBody+='"addressLine2": "",';jsonStringBody+='"addressLine3": "",';jsonStringBody+='"city": "' + newAccount.BillingCity + '",'; jsonStringBody+='"state":"'+ newAccount.BillingState +'",';jsonStringBody+='"country": "'+ newAccount.BillingCountry +'",';jsonStringBody+='"countryCode": "'+countryCode+'",';jsonStringBody+='"postalCode": "'+ newAccount.BillingPostalCode +'",';jsonStringBody+='"addressType": "PERSON",';jsonStringBody+='"contactType": "",';jsonStringBody+='"firstName": "'+ newAccount.FirstName +'",';jsonStringBody+='"lastName": "'+ newAccount.LastName +'",';jsonStringBody+='"title": "",';jsonStringBody+='"emailAddress": "'+newAccount.PersonEmail+'",';jsonStringBody+='"telephone" : "'+ newAccount.Phone +'",';jsonStringBody+='"bpPartnerFunction": "SP",';jsonStringBody+='"bpBusinessPartnerCategory" : "1",';jsonStringBody+='"bpNumber": "'+newAccount.Request_BP_Number__c +'",';if(newAccount.Request_RRAddressId__c  != null || newAccount.Request_RRAddressId__c != ''){jsonStringBody+='"rrAddressId": "'+newAccount.Request_RRAddressId__c +'",';}jsonStringBody+='"source": "",';jsonStringBody+='"addressUseType": "Account Billing"';jsonStringBody+='}';String resp = SAP_BP_Service.processRequest(jsonStringBody, '/'+newAccount.Customer_Id__c+'/generateBP/');
                System.debug('SAP BP creation resp' + resp);
            }
        }
    }
    

}