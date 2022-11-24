/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-01-22
** Testing Clases:  CAS_VitalSource
** Testing TrigClasses: CAS_VitalSourceBookshelfCode_Trig, CAS_VitalSourceInstructorEmail_Trig
***************************************************************************/
@isTest
public class Tests_CASVitalSource {
    
    
    static testMethod void UnitTest_VitalSource() 
    {
        CAS_VitalSource.TestCreateSettingsEmailTemplates();
        //zTEST_Shared.runTriggers.add('CAS_VitalSourceInstructorEmail');
        //zTEST_Shared.runTriggers.add('CAS_VitalSourceBookshelfCode');
               
        String locale = 'AMERICAS';
        String prefixTest ='';
        CreateSetupVitalsourceData();
        Account account = setupTestAccount('TEST_1_VitalSource' + locale +  prefixTest);
        Opportunity opp = setupTestOpportunity('TEST_1_VitalSource' + locale + prefixTest, account.Id);
        String contactId = createAccountAndContact('TestVitalSource@test.com' + prefixTest, locale);
        Product2 p1= CreateProduct(prefixTest);
        String pbe1Id = CreatePricebookEntry(prefixTest,p1 );
        OpportunityLineItem oppProduct = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1Id);
        OpportunityLineItem oppProduct2 = setupOppLineItemsRecepinet(opp.Id,contactId, pbe1Id);
        
        TriggerInterfaceHelper.runTrigger('CAS_VitalSourceBookshelfCode_Trig', 'OpportunityLineItem', 99, 'ai,au', opp.recordtypeid, null); //CAS - Course Opportunities
        TriggerInterfaceHelper.runTrigger('CAS_VitalSourceInstructorEmail_Trig', 'OpportunityLineItem', 99, 'ai,au', opp.recordtypeid, null); //CAS - Course Opportunities
        
        //Covers CRC Vitalsource/Emails processes
        oppProduct2.Adoption_Stage__c = 'Created';
        oppProduct2.VitalSource_Instructor_Email_Date__c = null;
        oppProduct2.VitalSource_Access_Period__c = 'Perpetual Access';
        oppProduct2.Order_Type__c = 'HSS Vitalsource e-Exam copy';
        update oppProduct;
        
        //Covers CRC Vitalsource/Emails processes
        oppProduct.Adoption_Stage__c = 'Created';
        oppProduct.VitalSource_Instructor_Email_Date__c = null;
        oppProduct.VitalSource_Access_Period__c = '60 Days';
        oppProduct.Order_Type__c = 'CRC Vitalsource e-Exam copy';
        update oppProduct;
        
        //Covers CRC Vitalsource/Emails processes
        oppProduct.Adoption_Stage__c = 'Created';
        oppProduct.VitalSource_Instructor_Email_Date__c = null;
        oppProduct.VitalSource_Access_Period__c = '60';
        oppProduct.Order_Type__c = 'CRC Vitalsource e-Exam copy';
        update oppProduct;
        
        //Covers HSS Vitalsource/Emails processes
        oppProduct.Feedback_Notification__c = 'Send';
        oppProduct.Adoption_Stage__c = 'In-Process';
        oppProduct.Order_Type__c = 'HSS Vitalsource e-Exam copy';
        update oppProduct;
        
        
        
        //Covers HSS backorder emails
        p1.VitalSource_Status__c=null;
        update p1;
        oppProduct.Adoption_Stage__c = 'Created';
        oppProduct.VitalSource_Instructor_Email_Date__c = null;
        oppProduct.VitalSource_Backorder_Email_Date__c= null;
        oppProduct.Order_Type__c = 'HSS Vitalsource e-Exam copy';
        update oppProduct;
        
        
    }
    
    public static void CreateSetupVitalsourceData() 
    {
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        
        TriggerInterfaceHelper.runTrigger('CAS_VitalSourceInstructorEmail_Trig', 'OpportunityLineItem', 99, 'au', oppRtId, null);
        TriggerInterfaceHelper.runTrigger('CAS_VitalSourceBookshelfCode_Trig', 'OpportunityLineItem', 99, 'ai,au', oppRtId, null);
        
        //Pricebook2 s = [select id from Pricebook2 where IsStandard = true];
        List<Setting__c> s = [SELECT Id FROM Setting__c WHERE name = 'VitalSource'];
        
        if (s.size()==0)
        {
            Setting__c ss= new Setting__c(
                name='VitalSource',
                Text_2_Label__c='Reporter URL',
                Text_3_Label__c='API Key',
                Text_4_Label__c='Reporter key',
                Text_5_Label__c='Company'
            );      
            insert ss;
            Setting_Item__c si = new Setting_Item__c
                (
                    Setting__c = ss.Id,
                    Text_1__c='https://api.vitalsource.com/v3',
                    Text_2__c='https://reporter.vitalbook.com',
                    Text_3__c='XXXXX',
                    Text_4__c='xxxx',
                    Text_5__c='Routledge',
                    Checkbox_1__c = true
                );
            insert si;
            
        }
        
        
        
        
        
        
    }
    
    public static Product2 CreateProduct(String prefixTest)
    {
        //Product2 p1[] = new Product2[]{};
        List<Product2> p1 = [SELECT Id, Name,ProductCode, VitalSource_Status__c, VitalSource_SKU__c  FROM Product2 WHERE NAME ='Test Vitalsource' LIMIT 1];
        
        if (p1 == null || p1.size()==0)
        {
            Id productRtId = MiscFunctions.getRecordtypeId('Product2', 'T&F - Products'); //CHG0038379
            
            p1.add(new Product2(
                name='Test Vitalsource', //+ prefixTest,
                ISBN__c='1234VitalSource', 
                IsActive=true,
                Description='My Product',
                RecordTypeId= productRtId,
                ProductCode='12345',
                UK_Inventory_Status__c = 'Available',
                UK_Publication_Date__c = system.now().date().addDays(-1),
                US_Inventory_Status__c = 'Available',
                US_Publication_Date__c = system.now().date().addDays(-1),
                VitalSource_Status__c = 'Live',
                VitalSource_SKU__c = 'TEST-1234VitalSource-TEST'
            ));
            insert p1[0];
        }
        
        
        
        
        return p1[0];
        
    }
    
    public static String CreatePricebookEntry(String prefixTest,Product2 p1 )
    {
        //PricebookEntry[] pbe1 = new PricebookEntry[]{};
        List<PricebookEntry> pbe1 = [SELECT Id,Pricebook2Id,Product2Id FROM PricebookEntry WHERE Product2Id=:p1.Id];
        if(pbe1==null || pbe1.size()==0)
        {
            //Pricebook2 pp = [SELECT Id,IsStandard,Name,SystemModstamp FROM Pricebook2 WHERE IsStandard = true];
            // create the pricebookentry
            pbe1.add( new PricebookEntry(
                CurrencyIsoCode = 'EUR',
                Pricebook2Id= Test.getStandardPricebookId(),
                Product2Id=p1.id, 
                UnitPrice=1.00, 
                IsActive=true, 
                UseStandardPrice=false
            ));
            
            insert pbe1[0];
        }
        
        return pbe1[0].Id;
        
    }
    
    public static String CreateAccountAndContact(String email, String Locale) {
        
        Account a = new Account(name = 'New Account' + Locale, Locale__c = Locale);
        insert a;
        
        Contact c = new Contact(
            FirstName = 'Test Contact' + Locale ,
            LastName = 'Test Last Name'+ Locale ,
            Email = Locale + email,
            AccountId = a.Id        
        );
        insert c;
        return c.Id;    
        
    }
    
    public static Opportunity setupTestOpportunity(String oppName, ID accountId) {
        Id oppRtId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - CAS Opportunity'); //CHG0038379
        Opportunity opp = new Opportunity(
            name=oppName,
            Type = 'New Business',
            stagename='Verbal',
            Probability=80,
            closedate=Date.today().addYears(4),//Date.newInstance(2020, 01, 01),
            CurrencyIsoCode = 'EUR', recordtypeid = oppRtId, 
            
            accountId=accountId
        );
        
        insert opp;
        return opp;
    }       
    
    public static OpportunityLineItem setupOppLineItems(ID opportunityId) { 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.Est_Training_Pop__c = 1;
        oli.Unit_Material_Cost__c = 1;
        oli.Gross_Cost__c = 1;
        oli.Preparation_Cost__c = 1;
        oli.Instructor_Fee__c = 1; 
        oli.TotalPrice = 2;
        oli.PricebookEntryId = [Select p.Id From PricebookEntry p Where CurrencyIsoCode = 'EUR' And IsActive = true limit 1].Id;
        // insert the opportunity line item
        insert oli;
        return oli;   
    }
    
    public static OpportunityLineItem setupOppLineItemsRecepinet(ID opportunityId, ID recipientId, ID pricebookId) { 
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opportunityId;
        oli.Quantity = 1;
        oli.Est_Training_Pop__c = 1;
        oli.Unit_Material_Cost__c = 1;
        oli.Gross_Cost__c = 1;
        oli.Preparation_Cost__c = 1;
        oli.Instructor_Fee__c = 1; 
        oli.TotalPrice = 2;
        oli.PricebookEntryId = pricebookId;
        oli.Recipient__c = recipientId;
        //oli.CurrencyIsoCode = '';
        // insert the opportunity line item
        insert oli;
        return oli;   
    }
    
    
    public static Account setupTestAccount(String accountName) 
    {
        Account a = new Account(name=accountName,
                                //OwnerId=userId,
                                BillingStreet='1234 Main Street');  
        insert a;
        return a;
    } 
    
    public static CAS_Inspection_Copy__c setupTestInspectionCopy(String oppProductId,String oppId )
    {
        CAS_Inspection_Copy__c c = new CAS_Inspection_Copy__c(
            Contact_Email__c = 'HSS.Shay.Spoonmore@informaUSA.com' 
            ,Contact_Name__c = 'Shay Spoonmore ' + system.now()
            ,Order_Type__c = 'HSS Vitalsource e-Exam copy' 
            ,Opportunity__c = oppId
            ,Opportunity_Product__c = oppProductId
            ,Sent_Feedback_Notification__c = null
            ,Sent_Created_Notification__c = null 
            ,Shipping_Date__c = null
            ,Sent_Type__c = 'Singapore'
            ,Book_Order__c = '2'
            ,Book_Title__c = 'Test Book'
            ,ISBN__c = '978-0-415-39330-0' 
            ,IsTesting__c =true);
        insert c ; 
        
        return c;  
    }
    
    public static void CheckInspectionCopy(String prefixDebug,String icId)
    {
        for(CAS_Inspection_Copy__c  ic : [SELECT Contact_Email__c,Contact_Name__c,Order_Type__c,Opportunity__c,Opportunity_Product__c, CreatedDate,Id, Name, Sent_VS_Back_Order__c,Sent_VS_Bookshelf_Code__c,Sent_VS_Instructor__c,Sent_VS_Redeemed_Feedback_Final_Push__c,Sent_VS_Redeemed_Feedback__c,Sent_VS_Redeemed__c,Sent_VS_Unredeemed_Final_Push__c,Sent_VS_Unredeemed__c,SystemModstamp  FROM CAS_Inspection_Copy__c where Id=:icId] )// build opportunities not to be included in query
        {
            System.debug('####'+ prefixDebug +'CASVitalSource:' + ic.Contact_Email__c + ' :: ' + ic.Order_Type__c + ' :: Sent_VS_Instructor=' + ic.Sent_VS_Instructor__c + ' :: Sent_VS_Bookshelf_Code='+ ic.Sent_VS_Bookshelf_Code__c + ' :: Sent_VS_Unredeemed='+ ic.Sent_VS_Unredeemed__c + ' :: Sent_VS_Unredeemed_Final_Push='+ ic.Sent_VS_Unredeemed_Final_Push__c );
            System.debug('####'+ prefixDebug +'CASVitalSource: Sent_VS_Redeemed=' + ic.Sent_VS_Redeemed__c + ' :: Sent_VS_Redeemed_Feedback=' + ic.Sent_VS_Redeemed_Feedback__c + ' :: Sent_VS_Redeemed_Feedback_Final_Push=' + ic.Sent_VS_Redeemed_Feedback_Final_Push__c + ' :: Sent_VS_Back_Order='+ ic.Sent_VS_Back_Order__c + ':: SystemModstamp='+ ic.SystemModstamp );
        }
    }
    
    
}