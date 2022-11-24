/*
* Amit Kumar
*/
@isTest
public class zTEST_TF_SBQQ_Quote_IsActiveQuote_Trig {

    @isTest static void testMethod1() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_IsActiveQuote_Trig', 'SBQQ__Quote__c', 1 + i, 'ai,au', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, 
                                                            Payer_Account__c = accObject.Id,
                                                            SBQQ__ExpirationDate__c = date.today()+20, 
                                                            Use_Prepay_Budget__c = true,DOI__c='123', RecordTypeId = recordTypes[0]);
            insert quoteObject;
            
            List<SBQQ__Quote__c> insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                                            FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            //system.assertEquals(null, insertedQuotes.get(0).CSD_Approval_Status__c);
            quoteObject.DOI__c = '1234';            
            update quoteObject;
            
            insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                       FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            Test.stopTest();
        }
    }    
    private static void createSampleData() {
        System.runAs(new User(ID = UserInfo.getUserId())) {
            String priceBookName = 'T&F CPQ Price Book 2017';
            Quote_Service_Settings__c customSetting = new Quote_Service_Settings__c(Name = 'Informa Plc', Product_Family__c = 'Journals-Author Side Charges', CPQ_PriceBook__c = priceBookName);
            insert customSetting;
            
            Country__c country = new Country__c(Country_2__c = 'US',Name = 'USA',Preferred_currency__c = 'USD');    
            insert country;            
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer'); 
            insert accObject;
            
            Contact conObject = new Contact(AccountId = accObject.Id,FirstName = 'test',LastName = 'test');      
            insert conObject;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                               RecordTypeId = TFProductsRecordTypeId,
                                               CPQ_Category__c = 'Technology',
                                               Article_Type__c = 'Letter',
                                               Sales_Organization__c = 'NA',
                                               Open_Access_Category__c = 'Open',
                                               ProductCode = 'XYZ',
                                               Readership_Level__c = 'Test',
                                               IsActive = true,
                                               Family = 'Journals-Author Side Charges');  
            insert prodObject;                 
            
            String standardPricebookId = Test.getStandardPricebookId();            
            List<PricebookEntry> priceBEList = new List<PricebookEntry>();            
            PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,UnitPrice = 100.00);                                  
            priceBEList.add(priceBE1);                              
            insert priceBEList;
            
            Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
            insert priceBook2;
            
            List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
            PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,UnitPrice = 100.00);    
            
            priceBEList2.add(priceBE2);                              
            insert priceBEList2;
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(
                SBQQ__Account__c = accObject.Id, 
                Payer_Account__c = accObject.Id, 
                SBQQ__ExpirationDate__c = date.today()+20, 
                Use_Prepay_Budget__c = true,
                DOI__c = '123');
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject.Id, 
                Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject;     
        }
    }    
}