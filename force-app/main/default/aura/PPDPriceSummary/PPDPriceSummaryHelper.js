({
    createPriceBookEntry: function (component, event) {
        var parentProductID = component.get("v.recordId");   
        var priceInGBP = component.find("unitPriceInGBP").get("v.value");        
        var priceInUSD = component.find("unitPriceInUSD").get("v.value");
        var discountedpriceInGBP = component.find("discountedpriceinGBP").get("v.value");        
        var discountedpriceInUSD = component.find("discountedpriceinUSD").get("v.value");
        var discountedPercentage = component.find("discountPercentage").get("v.value");
        var action = component.get("c.createPriceBookEntry");
        action.setParams({
            "parentProductID": parentProductID,
            "unitPriceInGBP": priceInGBP,
            "unitPriceInUSD":priceInUSD,
            "discountedPriceInGBP":discountedpriceInGBP,
            "discountedPriceInUSD":discountedpriceInUSD
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.showUpdate", "true");
                component.set("v.showSave", "false");
            }
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": result
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    
    //Update Discountedpercentage
     createDiscountedPercentage: function (component, event) {
        var parentProductID = component.get("v.recordId");   
        var discountedPercentage = component.find("discountPercentage").get("v.value");
         var action = component.get("c.addDiscountedPercentage");
        action.setParams({
            "parentProductID": parentProductID,
            "discountedPercentage":discountedPercentage
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
               
            }
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": result
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
         
     },
    //Update PriceBookEntry
    updatePriceBookEntry: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var priceInGBP = component.find("unitPriceInGBP").get("v.value");        
        var priceInUSD = component.find("unitPriceInUSD").get("v.value");
       
        
        var discountedpriceInGBP = component.find("discountedPriceInGBP").get("v.value");        
        var discountedpriceInUSD = component.find("discountedPriceInUSD").get("v.value");
        if(priceInGBP==undefined || priceInGBP=='undefined'){
            priceInGBP=0.00;
        }else if(priceInUSD==undefined || priceInUSD=='undefined'){
            priceInUSD=0.00;
        }
        
        if(discountedpriceInGBP==undefined || discountedpriceInGBP=='undefined'){
            discountedpriceInGBP=0.00;
        }else if(discountedpriceInUSD==undefined || discountedpriceInUSD=='undefined'){
            discountedpriceInUSD=0.00;
        }
        
        var action = component.get("c.updatePricebookEntry");              
        action.setParams({
            "parentProductID": parentProductID,
            "unitPriceInGBP": priceInGBP,
            "unitPriceInUSD":priceInUSD,
            "discountedPriceInGBP":discountedpriceInGBP,
            "discountedPriceInUSD":discountedpriceInUSD
            });         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.showUpdate", "true");
                component.set("v.showSave", "false");
            }
            var result = response.getReturnValue();
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": result
            });
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    },
    
    updatePriceBookEntryWithActiveFlag: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var priceInGBP = component.find("unitPriceInGBP").get("v.value");        
        var priceInUSD = component.find("unitPriceInUSD").get("v.value");
        var discountedpriceInGBP = component.find("discountedPriceInGBP").get("v.value");        
        var discountedpriceInUSD = component.find("discountedPriceInUSD").get("v.value");
        var action = component.get("c.updatePricebookEntryWithActiveFlag");              
        action.setParams({
            "parentProductID": parentProductID,
            "unitPriceInGBP": priceInGBP,
            "unitPriceInUSD":priceInUSD,
            "discountedPriceInGBP":discountedpriceInGBP,
            "discountedPriceInUSD":discountedpriceInUSD
        });         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.showUpdate", "true");
                component.set("v.showSave", "false");
            }
            var result = response.getReturnValue();
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": result
            });
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    },
    
    //getListPriceBookEntry
    getListPriceBookEntry: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getPriceBookEntry"); 
        action.setParams({
            "parentProductID": parentProductID            
        }); 
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result.length!=0){
            for (var i in result) {
                if (result[i].CurrencyIsoCode=='GBP' )
                  {
                 component.find("unitPriceInGBP").set("v.value",result[i].UnitPrice);    
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
                }
                else if (result[i].CurrencyIsoCode=='USD')
                {component.find("unitPriceInUSD").set("v.value",result[i].UnitPrice);
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
                }
                
                if(result[i].IsActive==true){
                    component.set("v.IsUpdatedByUser",'true');
                }
            }//loop ends 
           }
            else if(result.length==0){
                component.find("unitPriceInGBP").set("v.value",'0.00');
                component.find("unitPriceInUSD").set("v.value",'0.00');
                component.set("v.IsUpdatedByUser",'false');
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
            }
           
            
            /* if(component.get("v.IsRecordLocked")=='true'){
        if(component.get("v.typeOfCollection") == 'Rule based'){
            this.loadRulePrice(component);
        }else if(component.get("v.typeOfCollection") == 'Manual Curation'){
            this.loadStaticPrice(component);
        }
                     
            }*/
        });
        $A.enqueueAction(action); 
    },
    
    //getDiscountedPriceBookEntry
    getDiscountedPriceBookEntry: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getDiscountedPriceBookEntry"); 
        action.setParams({
            "parentProductID": parentProductID            
        }); 
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result.length!=0){
                
            for (var i in result) {
                //alert(result[i].CollectionDiscount__c);
                if (result[i].CurrencyIsoCode=='GBP' )
                  {
                 //component.find("unitPriceInGBP").set("v.value",result[i].UnitPrice);
                 component.find("discountedPriceInGBP").set("v.value",result[i].UnitPrice);     
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
                }
                else if (result[i].CurrencyIsoCode=='USD')
                {//component.find("unitPriceInUSD").set("v.value",result[i].UnitPrice);
                 component.find("discountedPriceInUSD").set("v.value",result[i].UnitPrice);
                 
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
                }
              
                if(result[i].IsActive==true){
                    component.set("v.IsUpdatedByUser",'true');
                }
            }//loop ends 
                 
           }
            else if(result.length==0){
                component.find("discountedPriceInGBP").set("v.value",'0.00');
                component.find("discountedPriceInUSD").set("v.value",'0.00');
                component.set("v.IsUpdatedByUser",'false');
                 component.set("v.showUpdate", "true");
                 component.set("v.showSave", "false");
            }
           
            
            /* if(component.get("v.IsRecordLocked")=='true'){
        if(component.get("v.typeOfCollection") == 'Rule based'){
            this.loadRulePrice(component);
        }else if(component.get("v.typeOfCollection") == 'Manual Curation'){
            this.loadStaticPrice(component);
        }
                     
            }*/
        });
        $A.enqueueAction(action); 
    },
    //getDiscountedPercentage
    
    getDiscountedPercentage: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getDiscountedPercentage"); 
        action.setParams({
            "parentProductID": parentProductID            
        }); 
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result.length!=0){
                if(result.DiscountedPercentage__c=='undefined' || result.DiscountedPercentage__c==undefined){
                    component.find("discountPercentage").set("v.value",0.00); 
                    component.set('v.DiscountedPercentage',0.00);
                }else{
                    component.find("discountPercentage").set("v.value",result.DiscountedPercentage__c);
                    component.set('v.DiscountedPercentage',result.DiscountedPercentage__c);
                }
                     
                  } else if(result.length==0){
                component.find("discountPercentage").set("v.value",'0.00');
               }
           
        });
        $A.enqueueAction(action); 
    },
    //getsum total of price in GBP and USD 
    getSumOfStaticBundleTitles: function (component, event) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getSumOfStaticBundleTitles");  
        
        action.setParams({
            "bundleID": parentProductID
        }); 
        action.setCallback(this, function(response) {
            var result=JSON.parse(response.getReturnValue()); 
            component.set("v.SumPriceinGBP", result.UnitPriceinGBP);
            component.set("v.SumPriceinUSD", result.UnitPriceinUSD);
        });
        $A.enqueueAction(action); 
    },    
    
    loadRulePrice : function(component) {
       
        this.getListPriceBookEntry(component);
        //this.getDiscountedPriceBookEntry(component);
        var position =0 ;
        var limitVal = 10;          
        //var action = component.get("c.getProductsFromPCM");
        var action=component.get("c.getCountsFromPCM_DynamicUI");
        action.setParams({
            "bundleId": component.get("v.recordId"),
            "queryObj": null,
            "savedRule": 'true',
            "offsetValue": position,
            "limitValue": limitVal,
            "searchCurrency": 'USD',
            "getAll":'false',
            "consumer":'Collections'
            
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                var querySaveElementVar = component.get("v.querySaveElement");
                var querySaveElementVarLst = [] ;
                if(result.msg=="Success"){
                    if(result.totalPriceUSD==undefined && result.totalPriceGBP==undefined){
                    component.set("v.SumPriceinUSD",0.00);
                    component.set("v.SumPriceinGBP",0.00);
                    component.set("v.IsSpinner",false);
                    }else if(result.totalPriceUSD!=undefined && result.totalPriceGBP!=undefined){
                    component.set("v.SumPriceinUSD",result.totalPriceUSD);
                    component.set("v.SumPriceinGBP",result.totalPriceGBP);
                    component.set("v.IsSpinner",false);
                    }
                    
                    
                    if(component.get("v.IsUpdatedByUser")=='false' && result.totalPriceUSD!=undefined && result.totalPriceGBP!=undefined){
                        component.set("v.priceinUSD",result.totalPriceUSD);
                        component.set("v.priceinGBP",result.totalPriceGBP);
                        component.set("v.DiscountedPriceinUSD",result.totalPriceUSD);
                        component.set("v.DiscountedPriceinGBP",result.totalPriceGBP);
                    }else if(component.get("v.IsUpdatedByUser")=='false' && result.totalPriceUSD==undefined && result.totalPriceGBP==undefined){
                        component.set("v.priceinUSD",'0.00');
                        component.set("v.priceinGBP",'0.00');
                    }
                    component.set("v.IsSpinner",false);
                     if(component.get("v.IsUpdatedByUser")=='false'){
                    this.updatePriceBookEntry(component, event);
                     }
                    
                }
                
                else if(result.msg=="Products not found"){                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Price not found!"
                    });
                    toastEvent.fire();
                    component.set("v.IsSpinner",false);
                }
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
            
        });        
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);                
        
    },
    
    loadStaticPrice  : function(component) {
        this.getListPriceBookEntry(component);
        //this.getDiscountedPriceBookEntry(component);
        var action = component.get("c.getStaticPkgPriceFromPCM");
        action.setParams({
            "parentProductID": component.get("v.recordId"),
            "listOfIds": null,
            "IdType": 'identifiers.doi',
            "useSF": 'false'
        }); 
        
        action.setCallback(this, function(response) {
            console.log('# getProducts callback %f', (performance.now() - startTime));
            var state = response.getState();
            
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();
                var querySaveElementVar = component.get("v.querySaveElement");
                var querySaveElementVarLst = [] ;
                if(result.msg=="Success"){
                    component.set("v.SumPriceinUSD",result.totalPriceUSD);
                    component.set("v.SumPriceinGBP",result.totalPriceGBP);
                    
                  /* if(component.get("v.priceinUSD")==undefined){
                    component.set("v.priceinUSD",result.totalPriceUSD);
                        }
                    if(component.get("v.priceinGBP")==undefined){
                    component.set("v.priceinGBP",result.totalPriceGBP);
                    }*/
                    if(component.get("v.IsUpdatedByUser")=='false'){
                         component.set("v.priceinUSD",result.totalPriceUSD);
                         component.set("v.priceinGBP",result.totalPriceGBP);
                         component.set("v.DiscountedPriceinUSD",result.totalPriceUSD);
                         component.set("v.DiscountedPriceinGBP",result.totalPriceGBP);
                    }
                    component.set("v.IsSpinner",false);
                     if(component.get("v.IsUpdatedByUser")=='false'){
                    this.updatePriceBookEntry(component, event);
                     }
                }
                
                else if(result.msg=="Products not found"){                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Price not found!"
                    });
                    toastEvent.fire();
                    component.set("v.IsSpinner",false);
                     component.set("v.SumPriceinUSD",'0.00');
                    component.set("v.SumPriceinGBP",'0.00');
                     if(component.get("v.IsUpdatedByUser")=='false'){
                         component.set("v.priceinUSD",'0.00');
                         component.set("v.priceinGBP",'0.00');
                    }
                     if(component.get("v.IsUpdatedByUser")=='false'){
                    this.updatePriceBookEntry(component, event);
                     }
                    
                    
                }
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
            
        });        
        var startTime = performance.now();
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);                
        
    },
     
    calculateDiscountedPercentage: function(component){
        
        var discountedPercentage=component.get("v.DiscountedPercentage");
        var discount=discountedPercentage/100;
        
        var priceInGBP=component.get("v.priceinGBP");
        var priceInUSD=component.get("v.priceinUSD");
        var DiscountedPriceinGBP=(priceInGBP*discount);
        var DiscountedPriceinUSD=(priceInUSD*discount);
        
        var ActualDiscountedPriceinGBP=(priceInGBP-DiscountedPriceinGBP);
        var ActualDiscountedPriceinUSD=(priceInUSD-DiscountedPriceinUSD);
        
        component.set("v.DiscountedPriceinGBP",ActualDiscountedPriceinGBP);
        component.set("v.DiscountedPriceinUSD",ActualDiscountedPriceinUSD);
        //alert(discountedPercentage);
        //alert(discount);
        //alert(DiscountedPriceinGBP);
        //alert(DiscountedPriceinUSD);
        
    }
    
})