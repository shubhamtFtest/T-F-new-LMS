//Created by Jeff Lup on 2016.12.06
//Modified by Jeff Lup on 2017.02.23 for CHG0032509
//
//Tested by zTEST_ProductInterest_UpdateProduct at 100%
//
//This trigger updates the ProductInterestID__c external Id field,
// based on the agreed upon format of ContactID__c:Product_Interest_Role__c_Role2_Role3:DOI__c:Product_Code__c
//It also looks up the Product2.Id and updates the ProductInterest__c.ProductID__c

trigger ProductInterest_UpdateProduct on ProductInterest__c (before insert, before update) {
    Set<String> productCodes = new Set<String>();
    for (Integer i = 0; i < Trigger.size; i++) {
        //Update ProductInterestID__c
        //Trigger.new[i].ProductInterestID__c = Trigger.new[i].ContactID__c + ':' + (Trigger.new[i].Product_Interest_Role__c == null ? '' : Trigger.new[i].Product_Interest_Role__c) + ':' + (Trigger.new[i].DOI__c == null ? '' : Trigger.new[i].DOI__c) + ':' + (Trigger.new[i].Product_Code__c == null ? '' : Trigger.new[i].Product_Code__c);
		String underscore = ((Trigger.new[i].Product_Interest_Role_Level_2__c != null || Trigger.new[i].Product_Interest_Role_Level_3__c != null) ? '_' : ''); //CHG0032509
        Trigger.new[i].ProductInterestID__c = Trigger.new[i].ContactID__c + ':' + (Trigger.new[i].Product_Interest_Role__c == null ? '' : Trigger.new[i].Product_Interest_Role__c) + underscore + (Trigger.new[i].Product_Interest_Role_Level_2__c == null ? '' : Trigger.new[i].Product_Interest_Role_Level_2__c) + underscore + (Trigger.new[i].Product_Interest_Role_Level_3__c == null ? '' : Trigger.new[i].Product_Interest_Role_Level_3__c) + ':' + (Trigger.new[i].DOI__c == null ? '' : Trigger.new[i].DOI__c) + ':' + (Trigger.new[i].Product_Code__c == null ? '' : Trigger.new[i].Product_Code__c); //CHG0032509
        //Add Product_Code__c to a Set to be used later to populate the ProductID__c 
        if(Trigger.new[i].Product_Code__c != null) // adding a null check to avoid Non-Selective query error
        { 
          productCodes.add(Trigger.new[i].Product_Code__c);
        }
    }
    
    
    if (productCodes.size() > 0 ){
        Map<String, Id> mapProductCodeToId = new Map<String, Id>();
        
       AggregateResult[] groupedPbesResults= [SELECT ProductCode, Product2Id 
                                     FROM PricebookEntry
                                     WHERE Pricebook2Id = '01s0Y00000832ctQAA' //T&F One-Off Price Book
                                        AND ProductCode IN :productCodes
                                        GROUP BY ProductCode, Product2Id];     

        List<Product2> products = [SELECT Id, ProductCode
                                   FROM Product2
                                   WHERE RecordtypeID IN ('0120Y000000WnAbQAK','0120Y000000WnAaQAK','0120Y000000WnAcQAK') //T&F - eBooks Products, T&F - Products, Taylor and Francis Academic
                                    AND ProductCode IN :productCodes];
        
         
        if (products.size() > 0) {
            //use Product from T&F One-Off Price Book (if found)
            
            for(AggregateResult ar : groupedPbesResults) 
            {
                String productCode=string.valueOf(ar.get('ProductCode'));
                String productId=string.valueOf(ar.get('Product2Id'));
                if (!mapProductCodeToId.containsKey(productCode))
                    mapProductCodeToId.put(ProductCode,productId );
            }
            groupedPbesResults.clear();
            
            /** System.QueryException: Non-selective query against large object type (more than 200000 rows)
            for(PricebookEntry pbe : pbes) {
                if (!mapProductCodeToId.containsKey(pbe.ProductCode))
                    mapProductCodeToId.put(pbe.ProductCode, pbe.Product2Id);
            }
            **/
            
            //use any other Product (if not found above)
            for(Product2 p : products) {
                if (!mapProductCodeToId.containsKey(p.ProductCode))
                    mapProductCodeToId.put(p.ProductCode, p.Id);
            }
            products.clear();
            
            //asign ProductId to all inserted records
            for (Integer i = 0; i < Trigger.size; i++) {
                if (mapProductCodeToId.containsKey(Trigger.new[i].Product_Code__c))
                    Trigger.new[i].ProductID__c = mapProductCodeToId.get(Trigger.new[i].Product_Code__c);
            }
        }
    }
}