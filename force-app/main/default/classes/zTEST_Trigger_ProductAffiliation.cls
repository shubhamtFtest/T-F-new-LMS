@isTest
private class zTEST_Trigger_ProductAffiliation {
	
	/****************************************************************************************
     This method is used to create Affiliation Types records.
    *****************************************************************************************/
    Public static Affiliation_Types__c createAffiliationType(String Name) {
        Affiliation_Types__c afftype = new Affiliation_Types__c();
        afftype.Name = Name;
        return afftype;
    }
    
    /****************************************************************************************
     This method is used to create Product records.
    *****************************************************************************************/
    Public static Product2 createProduct() {
        Id TFProductsRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('T&F - Products').getRecordTypeId();
        Product2 prodObject = new Product2(Name = 'Test Product', 
                                           RecordTypeId = TFProductsRecordTypeId,
                                           CPQ_Category__c = 'Technology',
                                           Article_Type__c = 'Letter',
                                           Sales_Organization__c = 'NA',
                                           Open_Access_Category__c = 'Open',
                                           Readership_Level__c = 'Test');
        return prodObject;
    }
    
    /****************************************************************************************
     This method is used to create Product Affiliation records.
    *****************************************************************************************/
    Public static Product_Affiliation__c createProductAffiliation (Id ProductId, Id afftypeId) {
        Product_Affiliation__c prodaffObj = new Product_Affiliation__c();
        prodaffObj.Product__c = productId;
        prodaffObj.Affiliation_Type__c = afftypeId;
        return prodaffObj;
    }
    
    /****************************************************************************************
     This method is used to test TF_productUpdateOnAffiliation trigger.
    *****************************************************************************************/
    @isTest static void PreventDuplicateAffiTypeTriggerTest() {
        Integer i = 0;
        List<Id> recordTypes = new List<Id>();
        for (Id recordTypeId : Schema.SObjectType.Product_Affiliation__c.getRecordTypeInfosById().keySet()) {
          TriggerInterfaceHelper.runTrigger('TF_ProductAffiliation_UpNesliVsnu_Trig', 'Product_Affiliation__c', ++i, 'aud,ai,au,ad', recordTypeId, null);
          TriggerInterfaceHelper.runTrigger('TF_ProductAffiliation_PreventDup_Trig', 'Product_Affiliation__c', ++i, 'bi,bu,aud', recordTypeId, null);
          recordTypes.add(recordTypeId);
        }

        system.runAs( new User( ID = UserInfo.getUserId() ) ) {
            Product2 prodObj = createProduct();
            Affiliation_Types__c afftyp1 = createAffiliationType('NESLI');
            Affiliation_Types__c afftyp2 = createAffiliationType('VSNU');
            
            List<TF_Product_Affiliation__c> prodAffiCSList = new List<TF_Product_Affiliation__c>();
            TF_Product_Affiliation__c prodAffiCSObj1 = new TF_Product_Affiliation__c(Name='NESLI',Proudct_Field_Name__c = 'NESLI__c');
            prodAffiCSList.add(prodAffiCSObj1);
            TF_Product_Affiliation__c prodAffiCSObj2 = new TF_Product_Affiliation__c(Name='VSNU',Proudct_Field_Name__c = 'VSNU__c'); 
            prodAffiCSList.add(prodAffiCSObj2);
            insert prodAffiCSList;
            
            Test.startTest();
            try {
                insert prodObj;
                insert afftyp1;
                insert afftyp2;
                Product_Affiliation__c prodaffObj1 = createProductAffiliation (prodObj.id,afftyp1.id);
                insert prodaffObj1; 
                Product_Affiliation__c prodaffObj2 = createProductAffiliation (prodObj.id,afftyp2.id);
                insert prodaffObj2;
                Product2 prod = [select Nesli__c,VSNU__c from product2 where id = :prodObj.id];
                //system.assertEquals(true, prod.NESLI__c);
                //system.assertEquals(true, prod.VSNU__c);
                
                update prodaffObj1;
                delete prodaffObj2;
                 prod = [select Nesli__c,VSNU__c from product2 where id = :prodObj.id];
                //system.assertEquals(false, prod.VSNU__c);
                
                undelete prodaffObj2;
                 prod = [select Nesli__c,VSNU__c from product2 where id = :prodObj.id];
                //system.assertEquals(true, prod.VSNU__c);
                
                delete prodaffObj1;
                 prod = [select Nesli__c,VSNU__c from product2 where id = :prodObj.id];
                //system.assertEquals(false, prod.NESLI__c);
                
                undelete prodaffObj1;
                 prod = [select Nesli__c,VSNU__c from product2 where id = :prodObj.id];
                //system.assertEquals(true, prod.NESLI__c);
                
                Product_Affiliation__c prodaffObj3 = createProductAffiliation (prodObj.id,afftyp2.id);
                insert prodaffObj3;
            }
            catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains('Duplicate Affiliation Type records with same Product ID & Affiliation Type cannot be inserted.') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);           
            }
            Test.stopTest();
        }  
    }
	
}