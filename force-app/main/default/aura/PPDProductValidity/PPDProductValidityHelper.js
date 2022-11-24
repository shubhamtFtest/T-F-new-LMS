({
	  fetchProductValidity: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");         
        var action = component.get("c.getCollectionValidity");    
        action.setParams({
            "bundleID": parentProductID
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            //alert(result.Netbase_Classifications__c);
            if(result!=null || result!=''){                
              component.set("v.valueValidTo",result.Collection_Valid_To__c);
              component.set("v.valueValidFrom",result.Collection_Valid_From__c); 
              component.set("v.valueUpdatedTo",result.Collection_updatedTo__c);
              component.set("v.valueUpdatedFrom",result.Collection_updatedFrom__c); 
                
            }
                    else{
                    toastEvent.setParams({
                    "title": "Error!",
                    "message": 'Some Problem has occured,Please contact your system administrator!'
                });
                toastEvent.fire();   
                return;
                }
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  

    },
    
    updateProductValidity: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
         var ValidTo=component.get("v.valueValidTo");
         var ValidFrom=component.get("v.valueValidFrom");
          var UpdatedTo=component.get("v.valueUpdatedTo");
         var UpdatedFrom=component.get("v.valueUpdatedFrom");
        var action = component.get("c.updateCollectionValidity");    
        action.setParams({
            "bundleID": parentProductID,
            "ValidTo":ValidTo,
            "ValidFrom":ValidFrom,
            "UpdatedFrom":UpdatedFrom,
            "UpdatedTo":UpdatedTo
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            if(result!=null || result!=''){                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": result
                });
                toastEvent.fire();   
                return;
            }
                    else{
                    toastEvent.setParams({
                    "title": "Error!",
                    "message": 'Some Problem has occured,Please contact your system administrator!'
                });
                toastEvent.fire();   
                return;
                }
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
        
    },
})