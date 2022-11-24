@isTest(SeeAllData=true)
public class zTest_LeadConvert_TFBatch {
    public static void setup(){
        
        //Create a Account record
        List<Account> accList = new List<Account>{new Account(Name = 'Test_Account',Type = 'Customer',Classification__c = 'Client')};
        insert accList;
        
        //Create a Contact record
        Contact con = new Contact();
        con.FirstName = 'conTest';
        con.LastName = 'lastTest';
        con.Email = 'testemail@gmail.com';
        con.AccountId = accList[0].id;
        insert con;
        
        //Create  Product record
        Product2 p = new Product2();
        p.Name = 'test_pro';
        p.ProductCode = 'Pro-X';
        p.IsActive = true;
        insert p;                
        
        //Create a list of Lead records
        List<Lead> listLead = new List<Lead>{
            new Lead(Order_Type__c = 'Gratis',Product_Name__c = p.id,Company = 'Test',Email = 'testfghdgfhghf@gmail.com',LastName = 'Test1',Course_Start_Date__c = date.today(),Course_Name__c = 'Lead',Book_Title_Requested__c = 'Lead Book Title',ISBN__c = 'ISBN12',Author__c ='Lead_Author',Publisher__c = 'CRC Press',Book_Requested_Type__c = 'Print',Delivery_Instructions__c = 'Lead_Delivery',Other_Considered_Texts__c = 'Other_Lead',Other_Decision_Maker__c = 'Decision_Lead',Lead_Adoption_Level__c = 'Supplementary reading',Adoption_Probability__c = '1',Current_Text__c = 'Current_Text',Website_Source__c = 'Website_Lead',Promo_Code_C__c = 'abcd',Current_Text_Feedback__c = '2',Last_Text_Change__c = 'More than four years ago',New_Course__c = 'Yes',Table_of_Contents_Review__c = '4',LeadSource = 'Agent'),
            new Lead(Order_Type__c = 'e-Inspection Copy',Product_Name__c = p.id,Company = 'Test1',Email = 'testemail@gmail.com',LastName = 'Test2',Course_Start_Date__c = date.today().addDays(4),Course_Name__c = 'Lead_Course',Book_Title_Requested__c = 'Lead Requested Title',ISBN__c = 'ISBN13',Author__c ='Lead_Author1',Publisher__c = 'Guilford Press',Book_Requested_Type__c = 'eBook',Delivery_Instructions__c = 'Lead_Delivery1',Other_Considered_Texts__c = 'Other_Lead1',Other_Decision_Maker__c = 'Decision_Lead1',Lead_Adoption_Level__c = 'Required reading',Adoption_Probability__c = '2',Current_Text__c = 'Current_Text1',Website_Source__c = 'Website_Lead1',Promo_Code_C__c = 'ab',Current_Text_Feedback__c = '4',Last_Text_Change__c = 'Less than two years ago',New_Course__c = 'No',Table_of_Contents_Review__c = '2',LeadSource = 'Alliance events')
            };
        insert listLead;
        
        //Create an Opportunity record
        List<Opportunity> opp_List = new List<Opportunity>();
        opp_List.add( new Opportunity (Name = 'Test_Opp1', AccountId = accList[0].id,Renewal_Method__c = 'Direct', StageName = 'Negotiating', LeadSource = 'Agent', Type = 'Adjustment', CloseDate = Date.today().addDays(6)));
        insert opp_List;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = p.Id,
             UnitPrice = 100.00,
             CurrencyIsoCode='USD',
             IsActive = true
        );
        
        System.debug('Before Insert pbEntry ======>' + pbEntry);
        insert pbEntry;
        System.debug('After Insert pbEntry ======>' + pbEntry);
        List<PricebookEntry> lstPBECurISOCode = [SELECT Id,Unitprice, Pricebook2.Name,Product2Id,product2.List_Price__c, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id = :p.id  AND CurrencyIsoCode='USD' AND PriceBook2.Name = 'Standard Price Book'];
        System.debug('lstPBECurISOCode ======>' + lstPBECurISOCode + 'Name ======>' + lstPBECurISOCode[0].Pricebook2.Name);
        /*
        //Create a Opportunity Product
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Quantity = 1;
        oli.Order_Type__c = 'Complimentary Exam Copy';
        oli.VitalSource_Bookshelf_Code__c = 'Already Sent';
        oli.opportunityid = opp_List[0].id;
        oli.Product2Id = p.id;
        oli.PricebookEntryId = Test.getStandardPricebookId();
        oli.UnitPrice = 50;
        oli.TotalPrice_GBP__c = 10;
        insert oli;
        */
        //Create a Setting record
        List<Setting__c> listOfSetting = new List<Setting__c>{new Setting__c(Name = 'Lead Ids to convert',Description__c = 'Setting_Description') };
        insert listOfSetting; 
        
        String leadIdds = listLead[0].id+','+listLead[1].id;
        
        //Create a Setting Item record
        List<Setting_Item__c> lstSettngItem = new List<Setting_Item__c>{new Setting_Item__c(Setting__c = listOfSetting[0].id, Long_Text_1__c = leadIdds) };
        insert lstSettngItem;
            
        System.debug('Test class lstSettngItem ========>' + lstSettngItem);
    }
    public static testMethod void LeadConvert_Test () {
        setup();
        
        List<Setting_Item__c> ldids = [ Select setting__c, Long_Text_1__c from Setting_Item__c where setting__r.Name = 'Lead Ids to convert' ];
        System.debug('Test class ldids ========>' + ldids);
        
        test.startTest();
        LeadConvert_TFBatch obj = new LeadConvert_TFBatch();
        Database.executeBatch( obj );
        test.stopTest();
        
    }
}