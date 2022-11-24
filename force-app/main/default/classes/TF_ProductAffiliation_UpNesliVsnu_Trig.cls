public with sharing class TF_ProductAffiliation_UpNesliVsnu_Trig implements TriggerInterface_ProductAffiliation.Runnable {
    public void run(TriggerInterface_ProductAffiliation.Trig trig) {
        if( trig.isAfter && (trig.isUndelete || trig.isDelete || trig.isInsert || trig.isUpdate)) {

            List<Product_Affiliation__c> triggerRecords = trig.isDelete ? trig.oldList : trig.newList;
            Set<Id> productidSet = new Set<Id> ();
            for(Product_Affiliation__c pfa : triggerRecords) {
                productidSet.add(pfa.product__c);
            }
            if(!productidSet.isEmpty()) {
                updateNesliVsnuOnProduct(productidSet);
            }
        }
    }

    private void updateNesliVsnuOnProduct(Set<Id> productId) {
        List<Product2> Productlst = new List<Product2>();
        Map<Product2,Set<String>> productAffiliatedMap = new Map<Product2,Set<string>>();
        Map<Id,Product2> productMap = new Map<Id,Product2> ([select id,(select id,Affiliation_Type__r.name from Product_Affiliation__r ) from product2 where id in :productid ]);
        Map<String, TF_Product_Affiliation__c> affiliationTypes = TF_Product_Affiliation__c.getAll();
        for(Product2 Prod : productMap.values()) {
            set<String> strSet = new Set<String>();
            for(Product_Affiliation__c proAff : Prod.Product_Affiliation__r) {
                for(String affiType : affiliationTypes.keySet()){
                    if(proAff.Affiliation_Type__r.name == affiType){
                        strSet.add(affiType);
                        system.debug('affiType' + affiType );
                    }
                }

            }
            productAffiliatedMap.put(prod,strSet);

        }

        for(product2 pro : productAffiliatedMap.keyset()) {
            Set<String> str_set = new Set<String>();
            str_set = productAffiliatedMap.get(pro);
            system.debug('str_set ' + str_set );
            for(TF_Product_Affiliation__c prodAff : affiliationTypes.values()){
                if(str_set.contains(prodAff.Name)){
                    pro.put(prodAff.Proudct_Field_Name__c,true);
                }
                else{
                    pro.put(prodAff.Proudct_Field_Name__c,false);
                }
            }

            productlst.add(pro);
        }
        if(!Productlst.isEmpty()) {
            update Productlst;
        }
    }
}