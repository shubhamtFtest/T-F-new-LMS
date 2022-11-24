({
	 updateNetBaseClassificationForProduct: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
         var NetBaseCollections=component.get("v.valueInp");
         
        var action = component.get("c.updateNetBaseClassification");    
        action.setParams({
            "bundleID": parentProductID,
            "NetbaseCollections":NetBaseCollections
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
    
    fetchNetBaseClassificationForProduct: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");         
        var action = component.get("c.getNetBaseClassification");    
        action.setParams({
            "bundleID": parentProductID
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            //alert(result.Netbase_Classifications__c);
            if(result!=null || result!=''){                
              component.set("v.valueInp",result.Netbase_Classifications__c);
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

    }
})