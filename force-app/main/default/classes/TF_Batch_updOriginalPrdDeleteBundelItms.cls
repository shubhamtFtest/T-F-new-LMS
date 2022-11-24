/*
* test class : zTest_TF_Batch_updOrgPrdDeleteBundelItms
*/

global class TF_Batch_updOriginalPrdDeleteBundelItms implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    
    private String orgPrdId;
    private String clonedPrdId;
    
    List<Bundle_Line_Item__c> fullBLItms = new List<Bundle_Line_Item__c>() ;
    
    public TF_Batch_updOriginalPrdDeleteBundelItms(String productId, String clonedProductId) {
        orgPrdId = productId;
        clonedPrdId = clonedProductId;
    }
    
    global Database.queryLocator start(Database.BatchableContext BC) {
        
        Product2 originalProduct = [select Id,name, Hub_Id__c FROM Product2 WHERE id = :orgPrdId limit 1];
        /*Product2 clonedProduct = [select Id,version__c, Description,Contributors__c,Keywords__c,Sales_Channels__c,Applicable_Channels__c,Applicable_Customer_Types__c,Applicable_License_Types__c,Unsilo_Class_Id__c,lastModifiedBy.Id,lastModifiedBy.name,CreatedBy.Id,CreatedBy.Name, LastModifiedDate,Product_Type_Author_Facing__c,Dynamic_Collection_Criteria__c,Collection_Valid_From__c,Collection_Valid_To__c,Collection_updatedFrom__c,Collection_updatedTo__c,Netbase_Classifications__c,Subject_Classifications__c,IsSellable__c,Product_Category__c,Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c ,Collection_Banner_Image_Size__c ,Collection_Cover_Image_Size__c,Abstract__c,DOI__c,Product_Type__c,Collection_Subject_Area__c, Collection_Auto_Rollover__c,DiscountedPercentage__c
                                  ,Backlist__c   
                                  FROM Product2 WHERE id = :clonedPrdId limit 1];*/
        Product2 clonedProduct = [select Id,version__c, Description,Contributors__c,Keywords__c,Sales_Channels__c,Applicable_Channels__c,Applicable_Customer_Types__c,Applicable_License_Types__c,Unsilo_Class_Id__c,lastModifiedBy.Id,lastModifiedBy.name,CreatedBy.Id,CreatedBy.Name, LastModifiedDate,Product_Type_Author_Facing__c,Dynamic_Collection_Criteria__c,Collection_Valid_From__c,Collection_Valid_To__c,Collection_updatedFrom__c,Collection_updatedTo__c,Netbase_Classifications__c,Subject_Classifications__c,IsSellable__c,Product_Category__c,Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c ,Collection_Banner_Image_Size__c ,Collection_Cover_Image_Size__c,Abstract__c,DOI__c,Product_Type__c,Collection_Subject_Area__c, Collection_Auto_Rollover__c,DiscountedPercentage__c,Backlist__c,Is_collection_free__c   FROM Product2 WHERE id = :clonedPrdId limit 1];
        //updating the original Product
        system.debug('cloned version' + clonedProduct.version__c);
        originalProduct.version__c=clonedProduct.version__c;
        originalProduct.Description=clonedProduct.Description;
        originalProduct.Contributors__c=clonedProduct.Contributors__c;
        originalProduct.Keywords__c=clonedProduct.Keywords__c;
        originalProduct.Sales_Channels__c = clonedProduct.Sales_Channels__c;
        originalProduct.Applicable_Channels__c = clonedProduct.Applicable_Channels__c;
        originalProduct.Applicable_Customer_Types__c = clonedProduct.Applicable_Customer_Types__c;
        originalProduct.Applicable_License_Types__c = clonedProduct.Applicable_License_Types__c;
        originalProduct.Unsilo_Class_Id__c = clonedProduct.Unsilo_Class_Id__c;
        originalProduct.Dynamic_Collection_Criteria__c=clonedProduct.Dynamic_Collection_Criteria__c;
        originalProduct.Product_Type_Author_Facing__c=clonedProduct.Product_Type_Author_Facing__c;
        originalProduct.Collection_Valid_From__c=clonedProduct.Collection_Valid_From__c;
        originalProduct.Collection_Valid_To__c=clonedProduct.Collection_Valid_To__c;
        originalProduct.Collection_updatedFrom__c=clonedProduct.Collection_updatedFrom__c;
        originalProduct.Collection_updatedTo__c=clonedProduct.Collection_updatedTo__c;
        originalProduct.Netbase_Classifications__c=clonedProduct.Netbase_Classifications__c;
        originalProduct.Subject_Classifications__c=clonedProduct.Subject_Classifications__c;
        originalProduct.IsActive=clonedProduct.IsSellable__c;
        originalProduct.Product_Category__c=clonedProduct.Product_Category__c;
        originalProduct.Collection_Banner_Image_S3_location__c=clonedProduct.Collection_Banner_Image_S3_location__c;
        originalProduct.Collection_Cover_Image_S3_location__c=clonedProduct.Collection_Cover_Image_S3_location__c;
        originalProduct.Collection_Banner_Image_Size__c=clonedProduct.Collection_Banner_Image_Size__c;
        originalProduct.Collection_Cover_Image_Size__c=clonedProduct.Collection_Cover_Image_Size__c;
        originalProduct.Abstract__c =clonedProduct.Abstract__c;
        originalProduct.Doi__c =clonedProduct.Doi__c;
        originalProduct.Product_Type__c =clonedProduct.Product_Type__c;
        originalProduct.Collection_Subject_Area__c =clonedProduct.Collection_Subject_Area__c;
        originalProduct.Collection_Auto_Rollover__c  =clonedProduct.Collection_Auto_Rollover__c;
        originalProduct.DiscountedPercentage__c =clonedProduct.DiscountedPercentage__c;
        originalProduct.Backlist__c =clonedProduct.Backlist__c;
        originalProduct.Is_collection_free__c = clonedProduct.Is_collection_free__c;
        
        //originalProduct.Last_Modified_By__c=clonedProduct.LastModifiedBy.Id;
        //originalProduct.LastModifiedUserName__c=clonedProduct.LastModifiedBy.Name;
        //originalProduct.Collection_Last_Modified_By__c=clonedProduct.CreatedBy.Id + ',' + clonedProduct.CreatedBy.Name + ', '+ clonedProduct.LastModifiedDate ;
        originalProduct.Collection_Last_Modified_By__c=clonedProduct.CreatedBy.Id + ',' + clonedProduct.CreatedBy.Name + ', '+ clonedProduct.LastModifiedDate.year()+'/' + clonedProduct.LastModifiedDate.month()+'/'+clonedProduct.LastModifiedDate.day();
        update originalProduct;
        
        String queryString = 'SELECT id FROM Bundle_Line_Item__c WHERE Product_Bundle_Parent__c =: orgPrdId ORDER BY Content_Position__c'; 
        
        return Database.getQueryLocator(queryString);
        
    }
    
    global void execute(Database.BatchableContext BC,  List<Bundle_Line_Item__c> bLItms) {
        Database.delete(bLItms, false);
    }
    
    global void finish(Database.BatchableContext BC) { 
        
        //String jobId = Database.executeBatch(new TF_Batch_restoreClonedProductToOriginal(orgPrdId,clonedPrdId), 9000);
        //System.debug('TF_Batch_restoreClonedProductToOriginal jobId : '+jobId );
         try
        {
            List<Pricebook2> priceBookId;
            Id standardPriceBookId;
            List<Pricebook2> priceEbookBookId;
            Id ebookPriceBookId;
            
            if (test.isrunningtest())
            {
                standardPriceBookId=Test.getStandardPricebookId();       
            }
            else
            {
                priceBookId=[select Id from Pricebook2 where isStandard=true];
                standardPriceBookId= priceBookId[0].id; 
                priceEbookBookId=[select Id from Pricebook2 where name='T&F - eBooks Pricebook'];
                ebookPriceBookId= priceEbookBookId[0].id; 
                
            }
            
            List <PricebookEntry> pbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where pricebook2id=:standardPriceBookId and product2id=:clonedPrdId];
            List <PricebookEntry> ebookPbe = [select UnitPrice,CurrencyIsoCode from Pricebookentry where pricebook2id=:ebookPriceBookId and product2id=:clonedPrdId];

            //Decimal UnitPriceInGBP=0.00;
            //Decimal UnitPriceInUSD=0.00;
             Decimal UnitPriceInGBP;
             Decimal UnitPriceInUSD;
             Decimal discountedPriceInGBP;
             Decimal discountedPriceInUSD;
            
            for(PricebookEntry pb: pbe)
            { if(pb.CurrencyIsoCode=='GBP')
            {
                UnitPriceInGBP=pb.UnitPrice;
            }
             else if(pb.CurrencyIsoCode=='USD')
             {
                 UnitPriceInUSD=pb.UnitPrice;
             }
            }
            
            
            for(PricebookEntry epb: ebookPbe)
            { if(epb.CurrencyIsoCode=='GBP')
            {
                discountedPriceInGBP=epb.UnitPrice;
            }
             else if(epb.CurrencyIsoCode=='USD')
             {
                 discountedPriceInUSD=epb.UnitPrice;
             }
            }
            
            
            if(UnitPriceInGBP!=null && UnitPriceInUSD!=null){
            String successMsg = TF_PPDProcessController.updatePricebookEntry(orgPrdId, UnitPriceInGBP, UnitPriceInUSD,discountedPriceInGBP,discountedPriceInUSD);
            system.debug('=====successMsg===='+successMsg);
                    }
            
            //copying the files uploaded in the cloned product to original products              
            list< ContentDocumentLink> ClonedContentDocumentLinkItms  = new list< ContentDocumentLink>();
            list< ContentDocumentLink> OriginalContentDocumentLinkItms  = new list< ContentDocumentLink>();
            list< ContentDocumentLink> OriginalExistingContentDocumentLinkItms  = new list< ContentDocumentLink>();
            
            ClonedContentDocumentLinkItms = [select ContentDocumentId ,LinkedEntityId  from ContentDocumentLink  where  LinkedEntityId = :clonedPrdId];
            OriginalExistingContentDocumentLinkItms= [select ContentDocumentId ,LinkedEntityId  from ContentDocumentLink  where  LinkedEntityId = :orgPrdId];
            
            
            for (ContentDocumentLink cdl : ClonedContentDocumentLinkItms) {   
                ContentDocumentLink lineItem = cdl.clone();
                //lineItem.ContentDocumentId = cdl.contentDocId ;
                lineItem.LinkedEntityId=orgPrdId; 
                lineItem.ShareType = 'V';
                OriginalContentDocumentLinkItms.add(lineItem);
            }
            
            if(ClonedContentDocumentLinkItms.size() > 0){
                delete ClonedContentDocumentLinkItms;
                delete OriginalExistingContentDocumentLinkItms;
                insert OriginalContentDocumentLinkItms;
                
            } 
            
            
            //delete the cloned product after restoring it
            product2 prd = new product2();
            prd.id = clonedPrdId ; 
            delete prd;
        }
        Catch(Exception ex){
            system.debug(ex.getMessage());
        }
       
    }   
}