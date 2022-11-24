public class setupCountryCode {

    public static void afterInsertProcess(Map<Id,Product2> newMapProduct){
        List<Product2> listToUpdate = new List<Product2>();
        for(Product2 prod : newMapProduct.values()){
            if(prod.Distribution_Rights_Excluded_Countries__c != null && prod.Distribution_Rights_Excluded_Countries__c != ''){
                List<String> codesList = new List<String>();
                codesList = prod.Distribution_Rights_Excluded_Countries__c.split(',');
                if(codesList.size()>0){
                    string picklistValue1 = '';
                    string picklistValue2 = '';
                    string picklistValue3 = '';
                    integer count = 1;
                    for(String cde : codesList){
                        if(count > 0 && count <= 100){
                          picklistValue1 += cde+';';
                        }
                        if(count > 100 && count <= 200){
                          picklistValue2 += cde+';';
                        }
                        if(count > 200 && count <= 300){
                          picklistValue3 += cde+';';
                        }
                        count ++;
                    }
                    Product2 prodToAdd = new Product2();
                    prodToAdd.Id = prod.Id;
                    prodToAdd.Distribution_Rights_Excluded_Countries_1__c = picklistValue1;
                    prodToAdd.Distribution_Rights_Excluded_Countries_2__c = picklistValue2;
                    prodToAdd.Distribution_Rights_Excluded_Countries_3__c = picklistValue3;
                    listToUpdate.add(prodToAdd);
                }
            }
        }
        if(listToUpdate.size()> 0){
            update listToUpdate;        
        }
    }
    
    public static void afterUpdateProcess(Map<Id,Product2> newMapProduct,Map<Id,Product2> oldMapProduct){
        List<Product2> listToUpdate = new List<Product2>();
        for(Product2 prod : newMapProduct.values()){
            if(prod.Distribution_Rights_Excluded_Countries__c != null && prod.Distribution_Rights_Excluded_Countries__c != '' && oldMapProduct.get(prod.Id).Distribution_Rights_Excluded_Countries__c != prod.Distribution_Rights_Excluded_Countries__c){
                List<String> codesList = new List<String>();
                codesList = prod.Distribution_Rights_Excluded_Countries__c.split(',');
                system.debug('codesList'+codesList);
                if(codesList.size()>0){
                    string picklistValue1 = '';
                    string picklistValue2 = '';
                    string picklistValue3 = '';
                    integer count = 1;
                    for(String cde : codesList){
                        if(count > 0 && count <= 100){
                          picklistValue1 += cde+';';
                        }
                        if(count > 100 && count <= 200){
                          picklistValue2 += cde+';';
                        }
                        if(count > 200 && count <= 300){
                          picklistValue3 += cde+';';
                        }
                        count ++;
                    }
                    Product2 prodToAdd = new Product2();
                    prodToAdd.Id = prod.Id;
                    prodToAdd.Distribution_Rights_Excluded_Countries_1__c = picklistValue1;
                    prodToAdd.Distribution_Rights_Excluded_Countries_2__c = picklistValue2;
                    prodToAdd.Distribution_Rights_Excluded_Countries_3__c = picklistValue3;
                    listToUpdate.add(prodToAdd);
                }
            }
        }
        if(listToUpdate.size()> 0){
            update listToUpdate;        
        }
    }
}