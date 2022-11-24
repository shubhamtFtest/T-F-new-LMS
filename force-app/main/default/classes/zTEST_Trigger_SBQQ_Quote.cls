/*
* CAB Ticket #: CHG0037688
* Changes: lines 62 - 101, related to CHG0037688
*/
@isTest
private class zTEST_Trigger_SBQQ_Quote {  

    /******Updated by:Amit Kumar, 2021.05.13 **********/
    private static void createSingleUseSalesDealSampleData() {
        Id recordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
        Sales_Deal__c configObject = new Sales_Deal__c();             
        configObject.RecordTypeId = recordTypeId;
        configObject.Promocode__c = 'MAK-2018-USJFISD';
        configObject.Discount_Display_Name__c = 'Coupon code';
        configObject.Active__c = true;
        configObject.Single_Use__c = true;
        configObject.Used_Quote__c='';
        configObject.Number_of_Quotes_used_this_PromoCode__c=null;
        configObject.Start_Date__c = date.today();
        configObject.End_Date__c = date.today()+20;
        configObject.Deal_Name__c = 'Promocode- single use';
        configObject.Type_of_Deal__c = 'APC Deal';        
        insert configObject;
    }

    /******Updated by:Amit Kumar, 2021.05.13 **********/
    @isTest static void testSalesDealDiscSingleUse() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_DealsPromoCodeDisc_Trig', 'SBQQ__Quote__c', ++i, 'ai,au', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            createSingleUseSalesDealSampleData();
            String priceBookName = 'T&F CPQ Price Book 2017';
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                               RecordTypeId = TFProductsRecordTypeId,
                                               CPQ_Category__c = 'Technology',
                                               Article_Type__c = 'Letter',
                                               Sales_Organization__c = 'NA',
                                               Open_Access_Category__c = 'Open',
                                               ProductCode = 'GACR',
                                               Readership_Level__c = 'Test',
                                               IsActive = true,
                                               Family = 'Journals-Author Side Charges');  
            insert prodObject;
            
            String standardPricebookId = Test.getStandardPricebookId();
            List<PricebookEntry> priceBEList = new List<PricebookEntry>();            
            PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                         UnitPrice = 100.00);                                  
            priceBEList.add(priceBE1);                              
            insert priceBEList;
            
            Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
            insert priceBook2;
            
            List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
            PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, 
                                                         Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                         UnitPrice = 100.00);    
            
            priceBEList2.add(priceBE2);                              
            insert priceBEList2;            
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',
                                                            SBQQ__ExpirationDate__c = date.today()+20, RecordTypeId = recordTypes[0]);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject.Id,
                Discount_Rules_Applied__c = 'PROMOCODE');
            insert quoteLineObject;            
            
            List<SBQQ__Quote__c> insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, PromoCode__c, SBQQ__Status__c
                                                                            FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            Test.startTest();
            system.assertEquals(false, insertedQuotes.isEmpty());
            system.assertEquals('Draft', insertedQuotes.get(0).SBQQ__Status__c);

            quoteObject.SBQQ__Status__c = 'Customer Accepted';
            update quoteObject;
            
            insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                       FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            Test.stopTest();
        }
    }
    
    /******Updated by:Amit Kumar, 2018.10.29 **********/
    private static void createSingleUseCpqDiscConfigSampleData() {
            Id TFCPQDiscountConfigurationRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
            CPQ_Discount_Configuration__c cpqDiscConfigObject = new CPQ_Discount_Configuration__c();             
            cpqDiscConfigObject.RecordTypeId = TFCPQDiscountConfigurationRecordTypeId;
            cpqDiscConfigObject.Discount_Type__c = '% Discount';
            cpqDiscConfigObject.Discount_Value_Percentage__c = 50.0;
            cpqDiscConfigObject.Promocode__c = 'MAK-2018-USJFISD';
            cpqDiscConfigObject.Product_Code__c = 'GACR';
            cpqDiscConfigObject.Discount_Display_Name__c = 'Coupon code';
            cpqDiscConfigObject.Active__c = true;
            cpqDiscConfigObject.Single_Use__c = true;
            cpqDiscConfigObject.Used_Quote__c='';
            cpqDiscConfigObject.Number_of_Quotes_used_this_PromoCode__c=null;
            cpqDiscConfigObject.Start_Date__c = date.today();
            cpqDiscConfigObject.End_Date__c = date.today()+20;
            insert cpqDiscConfigObject; 
    }
    
    /******Updated by:Amit Kumar, 2018.10.29 **********/
    private static void createMultipleUseCpqDiscConfigSampleData() {
            //Insert CPQ Discount Configuration
            Id TFCPQDiscountConfigurationRecordTypeId = Schema.SObjectType.CPQ_Discount_Configuration__c.getRecordTypeInfosByName().get('T&F - PromoCode').getRecordTypeId();
            CPQ_Discount_Configuration__c cpqDiscConfigObject = new CPQ_Discount_Configuration__c();             
            cpqDiscConfigObject.RecordTypeId = TFCPQDiscountConfigurationRecordTypeId;
            cpqDiscConfigObject.Discount_Type__c = '% Discount';
            cpqDiscConfigObject.Discount_Value_Percentage__c = 50.0;
            cpqDiscConfigObject.Promocode__c = 'MAK-2018-USJFISD';
            cpqDiscConfigObject.Product_Code__c = 'GACR';
            cpqDiscConfigObject.Discount_Display_Name__c = 'Coupon code';
            cpqDiscConfigObject.Active__c = true;
            cpqDiscConfigObject.Single_Use__c = false;
            cpqDiscConfigObject.Used_Quote__c='';
            cpqDiscConfigObject.Number_of_Quotes_used_this_PromoCode__c=null;
            cpqDiscConfigObject.Start_Date__c = date.today();
            cpqDiscConfigObject.End_Date__c = date.today()+20;
            insert cpqDiscConfigObject; 
    }
    
    /******Updated by:Amit Kumar, 2018.10.29 **********/
    
    @isTest static void testPromoCodeDiscSingleUse() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_PromoCodeDiscount_Trig', 'SBQQ__Quote__c', ++i, 'ai,au', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
        createSingleUseCpqDiscConfigSampleData();
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'GACR',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();            
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, 
                                                     Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);    
        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;            
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            Test.startTest();
            
            Id TFpromocodeRecordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
            Sales_Deal__c sdobj = new Sales_Deal__c(Type_of_Deal__c  = 'APC Deal', Deal_Name__c = 'salesdeal', Start_Date__c = System.today(), End_Date__c = System.today()+1, PromoCode__c = 'MAK-2018-USJFISD', RecordTypeId = TFpromocodeRecordTypeId);
            insert sdobj;       
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',
                                                            SBQQ__ExpirationDate__c = date.today()+20, RecordTypeId = recordTypes[0]);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject.Id,
                Discount_Rules_Applied__c = 'PROMOCODE');
            insert quoteLineObject;            
            
            List<SBQQ__Quote__c> insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, PromoCode__c, SBQQ__Status__c
                                                                            FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            system.assertEquals('Draft', insertedQuotes.get(0).SBQQ__Status__c);
            //system.assertEquals('MAK-2018-USJFISD', insertedQuotes.get(0).PromoCode__c);
            
            quoteObject.SBQQ__Status__c = 'Customer Accepted';
            //quoteObject.Use_Prepay_Budget__c = false;
            
            update quoteObject;
            
            insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                       FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            Test.stopTest();
        }
    }    
    
    /******Updated by:Amit Kumar, 2018.10.29 **********/
    
    @isTest static void testPromoCodeDiscMultipleUse() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_PromoCodeDiscount_Trig', 'SBQQ__Quote__c', ++i, 'ai,au', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
        createMultipleUseCpqDiscConfigSampleData();
        String priceBookName = 'T&F CPQ Price Book 2017';
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           ProductCode = 'GACR',
                                           Readership_Level__c = 'Test',
                                           IsActive = true,
                                           Family = 'Journals-Author Side Charges');  
        insert prodObject;
        
        String standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBEList = new List<PricebookEntry>();            
        PricebookEntry priceBE1 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = standardPricebookId, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);                                  
        priceBEList.add(priceBE1);                              
        insert priceBEList;
        
        Pricebook2 priceBook2 = new Pricebook2(Name = priceBookName, IsActive = True);
        insert priceBook2;
        
        List<PricebookEntry> priceBEList2 = new List<PricebookEntry>();
        PricebookEntry priceBE2 = new PricebookEntry(CurrencyIsoCode = 'USD',IsActive = True, 
                                                     Pricebook2Id = priceBook2.Id, Product2Id = prodObject.Id,
                                                     UnitPrice = 100.00);    
        
        priceBEList2.add(priceBE2);                              
        insert priceBEList2;            
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',RecordTypeId = TFAccountsRecordTypeId,Type = 'Customer');
            insert accObject;
            
            Test.startTest();
            
            Id TFpromocodeRecordTypeId = Schema.SObjectType.Sales_Deal__c.getRecordTypeInfosByName().get('Promocode Deal').getRecordTypeId();
            Sales_Deal__c sdobj = new Sales_Deal__c(Type_of_Deal__c  = 'APC Deal', Deal_Name__c = 'salesdeal', Start_Date__c = System.today(), End_Date__c = System.today()+1, PromoCode__c = 'MAK-2018-USJFISD', RecordTypeId = TFpromocodeRecordTypeId);
            insert sdobj;
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',
                                                            SBQQ__ExpirationDate__c = date.today()+20, RecordTypeId = recordTypes[0]);
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quoteObject.Id, 
                SBQQ__Product__c = prodObject.Id,
                Discount_Rules_Applied__c = 'PROMOCODE');
            insert quoteLineObject;            
            
            List<SBQQ__Quote__c> insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, PromoCode__c, SBQQ__Status__c
                                                                            FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            system.assertEquals('Draft', insertedQuotes.get(0).SBQQ__Status__c);
            //system.assertEquals('MAK-2018-USJFISD', insertedQuotes.get(0).PromoCode__c);
            
            quoteObject.SBQQ__Status__c = 'Customer Accepted';
            //quoteObject.Use_Prepay_Budget__c = false;
            
            update quoteObject;
            
            insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                       FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            Test.stopTest();
        }
    } 
 
    @isTest static void testQuoteTriggerHandler() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUpdate_Trig', 'SBQQ__Quote__c', ++i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_SendEmailApproved_Trig', 'SBQQ__Quote__c', ++i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_CloneRejectedQuotes_Trig', 'SBQQ__Quote__c', ++i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUndelete_Trig', 'SBQQ__Quote__c', ++i, 'aud', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_DeletePrepayTrans_Trig', 'SBQQ__Quote__c', ++i, 'bd', recordTypeId, null);
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Customer'); 
            insert accObject;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                               RecordTypeId = TFProductsRecordTypeId,
                                               CPQ_Category__c = 'Technology',
                                               Article_Type__c = 'Letter',
                                               Sales_Organization__c = 'NA',
                                               Open_Access_Category__c = 'Open',
                                               Readership_Level__c = 'Test');   
            insert prodObject;                                         
            
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account', AccountName__c = accObject.Id, Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;  
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Author_Status__c='Accepted', CSD_Approval_Status__c = 'Approved', Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true, RecordTypeId = recordTypes[0]);   
            insert quoteObject;
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Renewal__c = true, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay', SBQQ__PriorQuantity__c = 3, SBQQ__NetPrice__c = 10, SBQQ__UpgradedQuantity__c = 2);
            insert quoteLineObject;
            
            Test.startTest();
            
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c  FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
            
            delete quoteObj;
            
            undelete quoteObj;
            
            System.assert(quoteObj != null);
            
            Test.stopTest();
        }
    }
    
    @isTest static void autoUpdateStatusOnQuote() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdateStatus_Trig', 'SBQQ__Quote__c', 1 + i, 'bu', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Customer');
            insert accObject;
            
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id,
                                                            SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true, RecordTypeId = recordTypes[0]);
            insert quoteObject;
            
            List<SBQQ__Quote__c> insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                                            FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            system.assertEquals(null, insertedQuotes.get(0).CSD_Approval_Status__c);
            system.assertEquals(null, insertedQuotes.get(0).Approved_Rejected_Date__c);
            
            quoteObject.Author_Status__c = 'Accepted';
            quoteObject.Use_Prepay_Budget__c = false;
            
            update quoteObject;
            
            insertedQuotes = new List<SBQQ__Quote__c>([SELECT Id, CSD_Approval_Status__c, Approved_Rejected_Date__c
                                                       FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id]);
            system.assertEquals(false, insertedQuotes.isEmpty());
            //  system.assertEquals('Automatic Approval', insertedQuotes.get(0).CSD_Approval_Status__c);
            //  system.assertEquals(Date.today(), insertedQuotes.get(0).Approved_Rejected_Date__c);
            
            Test.stopTest();
        }
    }
    
    @isTest static void changeAccountforQuote() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUpdate_Trig', 'SBQQ__Quote__c', 1 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_SendEmailApproved_Trig', 'SBQQ__Quote__c', 2 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_CloneRejectedQuotes_Trig', 'SBQQ__Quote__c', 3 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUndelete_Trig', 'SBQQ__Quote__c', 4 + i, 'aud', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_DeletePrepayTrans_Trig', 'SBQQ__Quote__c', 5 + i, 'bd', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Customer'); 
            insert accObject;
            
            Account accObject2 = new Account(Name = 'Test Account2',
                                             RecordTypeId = TFAccountsRecordTypeId,
                                             Type = 'Customer');
            insert accObject2;
            
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account1', AccountName__c = accObject.Id,Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                               RecordTypeId = TFProductsRecordTypeId,
                                               CPQ_Category__c = 'Technology',
                                               Article_Type__c = 'Letter',
                                               Sales_Organization__c = 'NA',
                                               Open_Access_Category__c = 'Open',
                                               Readership_Level__c = 'Test');   
            insert prodObject;                                  
            
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id,  Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true, RecordTypeId = recordTypes[0]);   
            insert quoteObject;       
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject;
            
            SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
            quoteObj = [SELECT id,Name,Use_Prepay_Budget__c,SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = :quoteObject.Id];
            quoteObj.SBQQ__Account__c = accObject2.Id;
            quoteObj.CSD_Approval_Status__c = 'Approved';
            quoteObj.Author_Status__c = 'Accepted';
            update quoteObj;
            
            System.assertEquals(quoteObj.SBQQ__Account__c , accObject2.Id);
            
            Test.stopTest(); 
        }
    }
    
    @isTest static void testDeleteOldPrepayAccTrans() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUpdate_Trig', 'SBQQ__Quote__c', 1 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_SendEmailApproved_Trig', 'SBQQ__Quote__c', 2 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_CloneRejectedQuotes_Trig', 'SBQQ__Quote__c', 3 + i, 'au', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_OnAfterUndelete_Trig', 'SBQQ__Quote__c', 4 + i, 'aud', recordTypeId, null);
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_DeletePrepayTrans_Trig', 'SBQQ__Quote__c', 5 + i, 'bd', recordTypeId, null);
            ++i;
            recordTypes.add(recordTypeId);
        }
        
        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
            Account accObject = new Account(Name = 'Test Account',
                                            RecordTypeId = TFAccountsRecordTypeId,
                                            Type = 'Customer'); 
            insert accObject;
            
            Prepay_Accounts__c prepayAccountObj = new Prepay_Accounts__c(Name = 'Test Prepay Account1', AccountName__c = accObject.Id,Total_Budgeted_Amount__c=2000.00);
            insert prepayAccountObj;
            
            Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
            Product2 prodObject = new Product2(Name = 'Test Product', 
                                               RecordTypeId = TFProductsRecordTypeId,
                                               CPQ_Category__c = 'Technology',
                                               Article_Type__c = 'Letter',
                                               Sales_Organization__c = 'NA',
                                               Open_Access_Category__c = 'Open',
                                               Readership_Level__c = 'Test');   
            insert prodObject;      
            
            
            Test.startTest();
            
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__Account__c = accObject.Id, Payer_Account__c = accObject.Id, SBQQ__ExpirationDate__c = date.today()+20, Use_Prepay_Budget__c = true, RecordTypeId = recordTypes[0]);   
            insert quoteObject;       
            
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = prodObject.Id, Discount_Rules_Applied__c = 'Prepay', Best_Discount_Rule__c = 'Prepay');
            insert quoteLineObject;
            
            Prepay_Account_Transactions__c prepayAccTransObj = new Prepay_Account_Transactions__c(PrepayAccounts__c = prepayAccountObj.Id, Quote_ID__c = quoteObject.Id);
            insert prepayAccTransObj;
            
            Map<Id,Id> accountquoteMap = new Map<Id,Id>();
            accountquoteMap.put(quoteObject.Id, accObject.Id);
            
            TF_SBQQ_Quote_Utils.deleteoldAccountPrepayTransaction(accountquoteMap);
            
            List<Prepay_Account_Transactions__c> prepayAccTransList = new List<Prepay_Account_Transactions__c>();
            prepayAccTransList = [select id,Name from Prepay_Account_Transactions__c where Quote_ID__c = :quoteObject.Id];
            
            System.assertEquals(prepayAccTransList.size(), 0);
            
            Test.stopTest();
        }
    }
    
    @isTest static void updateCounAppliListFieldTrigTest2() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
            recordTypes.add(recordTypeId);
        }
        
        TF_CheckRecursive.runOnce1();
        TF_CheckRecursive.runOnce1();
        TF_CheckRecursive.runOnce3();
        TF_CheckRecursive.runOnce3();
        
        Account accountObj1 = [select Id from Account where Name = 'Test Account1'];
        Contact contactObj1 = [select Id from Contact where LastName = 'LN'];
        Country__c countryObj1 = [select Id from Country__c where Name = 'United Kingdom'];
        
        System.assertNotEquals(accountObj1.Id, NULL);
        
        Test.startTest();
        SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
        SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
        //Create Quote.
        SBQQ__Quote__c quoteObject2 = new SBQQ__Quote__c(SBQQ__BillingCountry__c = 'United Kingdom',SBQQ__Account__c = accountObj1.Id,Payer_Account__c = accountObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, Same_as_Billing__c = true, RecordTypeId = recordTypes[0]);
        insert quoteObject2;
        
        //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
        //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');
        
        //quoteObj2 = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject2.Id];
        //quoteObj2.SBQQ__BillingCountry__c = 'United Kingdom';
        //quoteObj2.Same_as_Billing__c = true;
        //update quoteObj2;
        
        
        Test.stopTest();       
    }
    
    @isTest static void updateCounAppliListFieldTrigTest3() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
            recordTypes.add(recordTypeId);
        }
        
        Account accountObj1 = [select Id from Account where Name = 'Test Account1'];
        Contact contactObj1 = [select Id from Contact where LastName = 'LN'];
        Country__c countryObj1 = [select Id from Country__c where Name = 'United Kingdom'];
        
        System.assertNotEquals(accountObj1.Id, NULL);
        
        Test.startTest();
        SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
        SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
        //Create Quote.
        SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(SBQQ__BillingCountry__c = 'United Kingdom',SBQQ__Account__c = accountObj1.Id,Payer_Contact__c = contactObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, RecordTypeId = recordTypes[0]);
        insert quoteObject1;
        
        //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
        //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');       
        
        Test.stopTest();       
    }                 
    
    @isTest static void updateCounAppliListFieldTrigTest4() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosById().keySet()) {
            TriggerInterfaceHelper.runTrigger('TF_SBQQ_Quote_UpdtCtryApplListField_Trig', 'SBQQ__Quote__c', ++i, 'bi,bu', recordTypeId, null);
            recordTypes.add(recordTypeId);
        }
        
        Account accountObj1 = [select Id, Name, Billing_Street__c, Billing_City__c, Billing_State_List__c, Billing_ZIP__c, Billing_Country_List__c from Account where Name = 'Test Account1'];
        Contact contactObj1 = [select Id from Contact where LastName = 'LN'];
        Country__c countryObj1 = [select Id from Country__c where Name = 'United Kingdom'];
        
        System.assertNotEquals(accountObj1.Id, NULL);
        
        Test.startTest();
        SBQQ__Quote__c quoteObj = new SBQQ__Quote__c();
        SBQQ__Quote__c quoteObj2 = new SBQQ__Quote__c();
        
        //Create Quote.
        SBQQ__Quote__c quoteObject1 = new SBQQ__Quote__c(SBQQ__BillingCountry__c = 'United Kingdom',SBQQ__Account__c = accountObj1.Id,Payer_Account__c = accountObj1.Id, SBQQ__PrimaryContact__c = contactObj1.Id, SBQQ__ExpirationDate__c = System.today() + 60, Same_as_Billing__c = true, RecordTypeId = recordTypes[0]);
        insert quoteObject1;
        
        //quoteObj = [SELECT Id,Same_as_Billing__c,Country_Applicable_List__c,SBQQ__Account__c,SBQQ__PrimaryContact__c FROM SBQQ__Quote__c where Id = :quoteObject1.Id];
        //System.assertEquals(quoteObj.Country_Applicable_List__c, 'Band A, EIFL');       
        
        Test.stopTest();       
    }
    
    @testSetup static void setupData() {
        //Create Accounts
        Id TFAccountsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('T&F - Accounts').getRecordTypeId();
        Account accountObj1 = new Account(Name = 'Test Account1',
                                          RecordTypeId = TFAccountsRecordTypeId,
                                          Billing_Country_List__c = 'United Kingdom');
        insert accountObj1;
        
        Account accountObj2 = new Account(Name = 'Test Account2',
                                          RecordTypeId = TFAccountsRecordTypeId,
                                          Billing_Country_List__c = 'Afghanistan');
        insert accountObj2;
        
        Account accountObj3 = new Account(Name = 'Test Account3',
                                          RecordTypeId = TFAccountsRecordTypeId,
                                          Billing_Country_List__c = 'Australia');
        insert accountObj3;
        
        Account accountObj4 = new Account(Name = 'Test Account4',
                                          RecordTypeId = TFAccountsRecordTypeId);
        insert accountObj4;
        
        //Create Contacts
        Id TFContactsRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('T&F - Contacts').getRecordTypeId();
        Contact contactObj1 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN',
                                          Mailing_Country_List__c = 'United States');
        insert contactObj1;
        
        Contact contactObj2 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN2',
                                          Mailing_Country_List__c = 'Afghanistan');
        insert contactObj2;
        
        Contact contactObj3 = new Contact(RecordTypeId = TFContactsRecordTypeId, LastName = 'LN3',
                                          Mailing_Country_List__c = 'Australia');
        insert contactObj3;
        
        //Create Country records
        List<Country__c> countryList = new List<Country__c>();
        Country__c countryObj1 = new Country__c(Name = 'United Kingdom', Applicable_List__c = 'Band A',     EIFL__c = True, Preferred_currency__c= 'USD');
        countryList.add(countryObj1);
        Country__c countryObj2 = new Country__c(Name = 'United States', Applicable_List__c = 'Band A',  EIFL__c = False);
        countryList.add(countryObj2);
        Country__c countryObj3 = new Country__c(Name = 'Afghanistan', Applicable_List__c = Null,    EIFL__c = True);
        countryList.add(countryObj3);
        Country__c countryObj4 = new Country__c(Name = 'Australia', Applicable_List__c = Null,  EIFL__c = False);
        countryList.add(countryObj4);
        insert countryList;
    }
    
    static testMethod void testGetCountryApplicableListValue() {
        String s1 = TF_SBQQ_Quote_Utils.getCountryApplicableListValue(null, false);
        System.assertequals('', s1);
        
        String s2 = TF_SBQQ_Quote_Utils.getCountryApplicableListValue(null, true);
        System.assertequals('EIFL', s2);
        
        String s3 = TF_SBQQ_Quote_Utils.getCountryApplicableListValue('test', true);
        System.assertequals('test, EIFL', s3);
    }
}