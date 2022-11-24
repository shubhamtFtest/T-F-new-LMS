/***************************************************************************************
This test class is for TF_PreventDuplicateAccountAffiliationType trigger. 
******************************************************************************************/
@isTest
public class zTEST_TF_AccountAffiliTriggerHandler {
    //Create Affiliation Types
    Public static Affiliation_Types__c createAffiliationType(String Name) {
        Affiliation_Types__c afftype = new Affiliation_Types__c();
        afftype.Name = Name;
        return afftype;
    }
    
    //Create Account
    Public static Account createAccount() {
        Account accObject = new Account(Name = 'Test Account');
        return accObject;
    }
    
    //Create Account Affiliation
    Public static Account_Affiliation__c createAccountAffiliation (Id accountId, Id afftypeId) {
        Account_Affiliation__c accaffObj = new Account_Affiliation__c();
        accaffObj.Account__c = accountId;
        accaffObj.Affiliation_Type__c = afftypeId;
        return accaffObj;
    }
    
    //Test TF_PreventDuplicateAccountAffiliationType trigger
    //Create Account Affiliation for NESLI and VSNU.
    @isTest static void PreventDuplicateAffiTypeTriggerTest() {
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Account accObj = createAccount();
            Affiliation_Types__c afftyp1 = createAffiliationType('NESLI');
            Affiliation_Types__c afftyp2 = createAffiliationType('VSNU');
            
            Test.startTest();
            try {
                insert accObj;
                insert afftyp1;
                insert afftyp2;
                Account_Affiliation__c accaffObj1 = createAccountAffiliation (accObj.id,afftyp1.id);
                insert accaffObj1; 
                
                Account_Affiliation__c accaffObj2 = createAccountAffiliation (accObj.id,afftyp2.id);
                insert accaffObj2;
                
                Account acc = [select Nesli_Membership__c,VSNU_Membership__c from account where id = :accObj.id];
                //System.assertEquals(1, acc.NESLI_Membership__c);
                //System.assertEquals(1, acc.VSNU_Membership__c);
                
                Account_Affiliation__c accaffObj3 = createAccountAffiliation (accObj.id,afftyp2.id);
                insert accaffObj3;
            }
            catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains('Duplicate Affiliation Type records with same Account ID & Affiliation Type cannot be inserted.') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);           
            }
            
            List<Account_Affiliation__c> accountAffList = new List<Account_Affiliation__c>();
            accountAffList = [SELECT Id, Name From Account_Affiliation__c WHERE Account__c = :accObj.id];
            //System.assertEquals(accountAffList.size(), 2);
                
            Test.stopTest();
        }  
    }
}