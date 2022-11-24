({
	updateSubjectClassificationForProduct: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
         var SubjectCollections=component.get("v.valueInp");
         
        var action = component.get("c.updateSubjectClassification");    
        action.setParams({
            "bundleID": parentProductID,
            "SubjectClassifications":SubjectCollections
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
                               
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
        
    },
    
    fetchSubjectClassificationForProduct: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");         
        var action = component.get("c.getSubjectClassification");    
        action.setParams({
            "bundleID": parentProductID
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            //alert(result.Netbase_Classifications__c);
            if(result!=null || result!=''){                
              component.set("v.valueInp",result.Subject_Classifications__c);
            }
                   
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  

    }
})