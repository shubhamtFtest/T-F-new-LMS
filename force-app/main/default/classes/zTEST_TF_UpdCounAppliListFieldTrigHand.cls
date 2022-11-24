/************************************************************************************
    This test class is used for TF_UpdateCountryApplicableListFieldTrigger trigger.
*************************************************************************************/
@isTest
public class zTEST_TF_UpdCounAppliListFieldTrigHand {
    /************************************************************************************
     This method is used to test TF_UpdateCountryApplicableListFieldTrigger trigger.
    *************************************************************************************/
  //  @isTest static void updateCounAppliListFieldTrigTest() {
  ////      Account accountObj1 = [select Id from Account where Name = 'Test Account1'];
  ////      Contact contactObj1 = [select Id from Contact where LastName = 'LN'];
  ////      Account accountObj2 = [select Id from Account where Name = 'Test Account2'];
  ////      Account accountObj3 = [select Id from Account where Name = 'Test Account3'];
  ////      Account accountObj4 = [select Id from Account where Name = 'Test Account4'];
                
  ////      Test.startTest();
  ////      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
		////SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
  ////      //Create Quote.
  ////      SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id,Payer_Contact__c = contactObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60);
  ////      insert quoteObject1;
		////SBQQ__Quote__c quoteObject2 = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id,Payer_Account__c = accountObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60);
  ////      insert quoteObject2;
        
  ////      quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
  ////      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');
		
		////quoteObj2 = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject2.Id];
  ////      quoteObj2.SBQQ__BillingCountry__c = 'United States';
		////quoteObj2.Same_as_Billing__c = true;
  ////      update quoteObj2;
		
		////quoteObj2.Same_as_Billing__c = false;
  ////      update quoteObj2;
        
		////quoteObj.SBQQ__Account__c = accountObj2.Id;
  ////      update quoteObj;
        
  ////      quoteObj = [SELECT Id, Country_Applicable_List__c FROM SBQQ__Quote__c WHERE ID = :quoteObject1.Id];
  ////      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'EIFL');
  ////      System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A');
        
  ////      quoteObj.SBQQ__Account__c = accountObj3.Id;
  ////      update quoteObj;
        
  ////      quoteObj = [SELECT Id, Country_Applicable_List__c FROM SBQQ__Quote__c WHERE ID = :quoteObject1.Id];
  ////      //System.assertEquals(quoteObj.Country_Applicable_List__c, Null);
        
  ////      quoteObj.SBQQ__Account__c = accountObj4.Id;
		////quoteObj.SBQQ__BillingCountry__c = 'United States';
		////quoteObj.Same_as_Billing__c = true;
  ////      update quoteObj;
		
		////quoteObj.Same_as_Billing__c = false;
  ////      update quoteObj;
        
  ////      //quoteObj.Payer_Contact__c = contactObj2.Id;
  ////      //update quoteObj;
        
  ////      //quoteObj.Payer_Contact__c = contactObj3.Id;
  ////      //update quoteObj;
       
  ////      //quoteObj = [SELECT Id, Country_Applicable_List__c FROM SBQQ__Quote__c];
  ////      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A');
        
  ////      Test.stopTest();       
  //  }

  //  @isTest static void updateCounAppliListFieldTrigTest2() {
  //      Integer i = 0;
  //      List<Id> recordTypes = new List<Id>();
  //      for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
  //        TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
  //        recordTypes.add(recordTypeId);
  //      }

  //      TF_CheckRecursive.runOnce1();
  //      TF_CheckRecursive.runOnce1();
  //      TF_CheckRecursive.runOnce3();
  //      TF_CheckRecursive.runOnce3();

  //      Account accountObj1 = [select Id from Account where Name = 'Test Account1'];
  //      Contact contactObj1 = [select Id from Contact where LastName = 'LN'];

  //      System.assertNotEquals(accountObj1.Id, NULL);

  //      Test.startTest();
  //      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
  //      SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
  //      //Create Quote.
  //      SBQQ__Quote__c quoteObject2 = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id,Payer_Account__c = accountObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, Same_as_Billing__c = true, RecordTypeId = recordTypes[0]);
  //      insert quoteObject2;
        
  //      //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
  //      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');
        
  //      //quoteObj2 = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject2.Id];
  //      //quoteObj2.SBQQ__BillingCountry__c = 'United Kingdom';
  //      //quoteObj2.Same_as_Billing__c = true;
  //      //update quoteObj2;
        
        
  //      Test.stopTest();       
  //  }

  //  @isTest static void updateCounAppliListFieldTrigTest3() {
  //      Integer i = 0;
  //      List<Id> recordTypes = new List<Id>();
  //      for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
  //        TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
  //        recordTypes.add(recordTypeId);
  //      }

  //      Account accountObj1 = [select Id from Account where Name = 'Test Account1'];
  //      Contact contactObj1 = [select Id from Contact where LastName = 'LN'];

  //      System.assertNotEquals(accountObj1.Id, NULL);

  //      Test.startTest();
  //      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
  //      SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
  //      //Create Quote.
  //      SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id,Payer_Contact__c = contactObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, RecordTypeId = recordTypes[0]);
  //      insert quoteObject1;
        
  //      //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
  //      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');       
        
  //      Test.stopTest();       
  //  }                 

  //  @isTest static void updateCounAppliListFieldTrigTest4() {
  //      Integer i = 0;
  //      List<Id> recordTypes = new List<Id>();
  //      for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
  //        TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
  //        recordTypes.add(recordTypeId);
  //      }

  //      Account accountObj1 = [select Id, Name, Billing_Street__c, Billing_City__c, Billing_State_List__c, Billing_ZIP__c, Billing_Country_List__c from Account where Name = 'Test Account1'];
  //      Contact contactObj1 = [select Id from Contact where LastName = 'LN'];

  //      System.assertNotEquals(accountObj1.Id, NULL);

  //      Test.startTest();
  //      SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
  //      SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
  //      //Create Quote.
  //      SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(SBQQ__Account__c = accountObj1.Id,Payer_Contact__c = contactObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, Same_as_Billing__c = true, RecordTypeId = recordTypes[0]);
  //      insert quoteObject1;
        
  //      //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
  //      //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');       
        
  //      Test.stopTest();       
  //  }

  //  @testSetup static void setupData() {
  //      //Create Accounts
  //      Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
  //      Account accountObj1 = new Account(Name = 'Test Account1',
  //                                          RecordTypeId = TFAccountsRecordTypeId,
  //                                          Billing_Country_List__c = 'United Kingdom');
  //      insert accountObj1;
        
  //      Account accountObj2 = new Account(Name = 'Test Account2',
  //                                          RecordTypeId = TFAccountsRecordTypeId,
  //                                          Billing_Country_List__c = 'Afghanistan');
  //      insert accountObj2;
        
  //      Account accountObj3 = new Account(Name = 'Test Account3',
  //                                          RecordTypeId = TFAccountsRecordTypeId,
  //                                          Billing_Country_List__c = 'Australia');
  //      insert accountObj3;
        
  //      Account accountObj4 = new Account(Name = 'Test Account4',
  //                                          RecordTypeId = TFAccountsRecordTypeId);
  //      insert accountObj4;
        
  //      //Create Contacts
  //      Id TFContactsRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('T&F - Contacts').getRecordTypeId();
  //      Contact contactObj1 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN',
  //                                          Mailing_Country_List__c = 'United States');
  //      insert contactObj1;
        
  //      Contact contactObj2 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN2',
  //                                          Mailing_Country_List__c = 'Afghanistan');
  //      insert contactObj2;
        
  //      Contact contactObj3 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN3',
  //                                          Mailing_Country_List__c = 'Australia');
  //      insert contactObj3;
        
  //      //Create Country records
  //      List<Country__c> countryList = new List<Country__c>();
  //      Country__c countryObj1 = new Country__c(Name = 'United Kingdom', Applicable_List__c = 'Band A',     EIFL__c = True);
  //      countryList.add(countryObj1);
  //      Country__c countryObj2 = new Country__c(Name = 'United States', Applicable_List__c = 'Band A',  EIFL__c = False);
  //      countryList.add(countryObj2);
  //      Country__c countryObj3 = new Country__c(Name = 'Afghanistan', Applicable_List__c = Null,    EIFL__c = True);
  //      countryList.add(countryObj3);
  //      Country__c countryObj4 = new Country__c(Name = 'Australia', Applicable_List__c = Null,  EIFL__c = False);
  //      countryList.add(countryObj4);
  //      insert countryList;
  //  }

}