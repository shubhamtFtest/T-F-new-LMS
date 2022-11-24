({   
    init: function (cmp, event, helper) {      
        helper.getListPriceBookEntry(cmp, event);  
        helper.getDiscountedPriceBookEntry(cmp, event);
        helper.getDiscountedPercentage(cmp, event);
       // helper.getSumOfStaticBundleTitles(cmp, event);
        if(cmp.get("v.IsRecordLocked")=='true'){
        if(cmp.get("v.typeOfCollection") == 'Rule based'){
            helper.loadRulePrice(cmp);
        }else if(cmp.get("v.typeOfCollection") == 'Manual Curation'){
            helper.loadStaticPrice(cmp);
        }
            }
    },
    
    setTotalPrice: function (cmp, event, helper) {
       
       // if( event.getParam("totalPriceUSD") != undefined && event.getParam("isStatic") == 'false'){
         if(event.getParam("isStatic") != undefined && event.getParam("isStatic") == 'false'){
            if(event.getParam("totalPriceUSD") != undefined && event.getParam("totalPriceGBP") != undefined){
                cmp.set("v.SumPriceinGBP", event.getParam("totalPriceUSD"));
                cmp.set("v.SumPriceinUSD", event.getParam("totalPriceGBP"));
                helper.loadRulePrice(cmp);
            }else{
                helper.loadRulePrice(cmp);
            }
        }else if(event.getParam("isStatic") != undefined && event.getParam("isStatic") == 'true'){
            helper.loadStaticPrice(cmp);
        }
    },
    
    createBundlePriceBookEntry : function(component, event, helper) { 
        var priceInGBP = component.find("unitPriceInGBP").get("v.value");        
        var priceInUSD = component.find("unitPriceInUSD").get("v.value");
        var discountedPriceInGBP = component.find("discountedPriceInGBP").get("v.value");  
        var discountedPriceInUSD = component.find("discountedPriceInUSD").get("v.value"); 
        
        var unitPriceInGBP = component.find("unitPriceInGBP");
        var unitPriceInUSD = component.find("unitPriceInUSD");
        if(priceInGBP<0.00){
            unitPriceInGBP.setCustomValidity('Please enter the valid value in GBP!');
            unitPriceInGBP.reportValidity();
            return;
        }
        else if(priceInUSD<0.00){
            unitPriceInUSD.setCustomValidity('Please enter the valid value in USD!'); 
            unitPriceInUSD.reportValidity();
            return;
        }
            else if(priceInGBP>=0.00 && priceInUSD>=0.00 ){
                unitPriceInGBP.setCustomValidity("");
                unitPriceInUSD.setCustomValidity("");
                unitPriceInGBP.reportValidity();
                unitPriceInUSD.reportValidity();
            }
        helper.createPriceBookEntry(component, event);  
        helper.createDiscountedPercentage(component, event);
        component.set("v.IsUpdatedByUser",'true');
    },
    
    
    updateBundlePriceBookEntry : function(component, event, helper) {   
        var priceInGBP = component.find("unitPriceInGBP").get("v.value");        
        var priceInUSD = component.find("unitPriceInUSD").get("v.value");
        var discountedPriceInGBP = component.find("discountedPriceInGBP").get("v.value");  
        var discountedPriceInUSD = component.find("discountedPriceInUSD").get("v.value"); 
       
        var unitPriceInGBP = component.find("unitPriceInGBP");
        var unitPriceInUSD = component.find("unitPriceInUSD");
        
        if(priceInGBP<0.00){ 
            unitPriceInGBP.setCustomValidity('Please enter the valid value in GBP!');
            unitPriceInGBP.reportValidity();
            return;
        }
        else if(priceInUSD<0.00){
            unitPriceInUSD.setCustomValidity('Please enter the valid value in USD!'); 
            unitPriceInUSD.reportValidity();
            return;
        }
            else if(priceInGBP>0.00 && priceInUSD>0.00 ){
                unitPriceInGBP.setCustomValidity("");
                unitPriceInUSD.setCustomValidity("");
                unitPriceInGBP.reportValidity();
                unitPriceInUSD.reportValidity();
            }
        
        helper.updatePriceBookEntryWithActiveFlag(component, event);
        helper.createDiscountedPercentage(component, event);
        
    },
    
    refreshPriceSummary: function(cmp, event, helper) {
        helper.getListPriceBookEntry(cmp, event);  
        //helper.getDiscountedPriceBookEntry(cmp, event);
        helper.getSumOfStaticBundleTitles(cmp, event);  
        helper.getDiscountedPercentage(cmp, event); 
    },
    
    onDiscountChange: function(cmp, event, helper) {
        
        helper.calculateDiscountedPercentage(cmp, event);
    }
    
})