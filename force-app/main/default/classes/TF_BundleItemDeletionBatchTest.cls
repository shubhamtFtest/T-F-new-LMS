/**
Author : Radhikay Banerjee
Apex class :  TF_LicenseExpiryNotificationBatch
**/
@isTest(seeAllData=false)
public class TF_BundleItemDeletionBatchTest  {
    
    @istest 
     private static void test_execute(){  
         
         Account thisAccount = new Account();
         thisAccount.Name = 'testAcc';
         thisAccount.Customer_Id__c = '022113';
         insert thisAccount;
         
         
         
         Id bespokeRecordTypeId = MiscFunctions.getRecordtypeId('Product2', 'T&F - BespokeCollection');
         
         Product2 newParentProduct = new Product2();
        newParentProduct.name='testProd';
        newParentProduct.IsActive=true;
        newParentProduct.Description='test';
        newParentProduct.RecordTypeId=bespokeRecordTypeId;
        newParentProduct.Category__c='[{"name":"test test","givenName":"test","familyName":"test","role":"Editor","position":1}]';
        newParentProduct.keywords__c='[{"name":"harish","description":"HARISH","position":1}]';
        newParentProduct.copyrightyear__c='2018';
        newParentProduct.Lead_Author_Editor__c='test';
        newParentProduct.Product_Type_Author_Facing__c='Manual Curation';
        newParentProduct.alternateName__c='alternate';
        newParentProduct.inLanguage__c='en';
        newParentProduct.version__c='1.0';
        newParentProduct.doi__c='122/33';
        newParentProduct.ean__c='333';
        newParentProduct.issn__c='12345';
        newParentProduct.Publisher__c='Pub';
        newParentProduct.businessId__c='PUB123';
        newParentProduct.Sales_Channels__c='UBX_sales';
        
        insert newParentProduct;
        
        Bundle_Line_Item__c lineItem = new Bundle_Line_Item__c();
        lineItem.Title__c='World Heritage';
        lineItem.IsUnsilo__c=true;
        lineItem.Authors__c='Rosalie Callway'; 
        lineItem.doi__c='1234';
        lineItem.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem;        
        Bundle_Line_Item__c lineItem2 = new Bundle_Line_Item__c();
        lineItem2.Title__c='World Heritage';
        lineItem2.IsUnsilo__c=true;
        lineItem2.Authors__c='Rosalie Callway'; 
        lineItem2.doi__c='5678';
        lineItem2.Product_Bundle_Parent__c=newParentProduct.id;
        insert lineItem2;        
         SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(Article_Title__c = 'Test', PromoCode__c = 'MAK-2018-USJFISD',SBQQ__Status__c = 'Draft',SBQQ__Primary__c = True,
                                                            SBQQ__ExpirationDate__c = date.today()+20);
         insert quoteObject;
         Opportunity thisOpp = new Opportunity();
         thisOpp.Name = 'Test Opp';
         thisOpp.AccountId = thisAccount.Id;
         thisOpp.StageName = 'Prospect';
         thisOpp.SBQQ__PrimaryQuote__c = quoteObject.Id;
         thisOpp.CloseDate = date.today()+20;
         insert thisOpp;
		
			SBQQ__QuoteLine__c quoteLineObject1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteObject.Id, SBQQ__Product__c = newParentProduct.Id, Discount_Rules_Applied__c = 'Prepay');
            insert quoteLineObject1;         
        thisOpp.StageName = 'Closed Won';
         thisOpp.Multi_year_deal__c ='No';
         thisOpp.Opportunity_for_Renewal__c = 'No';
         thisOpp.Reason_No_Renewal__c = 'test';
         update thisOpp;
         
         Test.startTest();
        

         TF_BundleItemDeletionBatch obj = new TF_BundleItemDeletionBatch();
         DataBase.executeBatch(obj,20); 
         Test.stopTest();
         
     }

}