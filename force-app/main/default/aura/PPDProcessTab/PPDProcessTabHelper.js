({
    openRecordInEditMode: function(component, event, helper) {
        
        //redirecting the user to the cloned Product
        var recordID = component.get("v.recordId");
        var editRecordEvent  = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recordID
        });
        editRecordEvent.fire(); 
    },
    
    
    
    checkIfNewProductVersionExist: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.checkIfNewVersionExist");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            if(result=='true'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Record Edit Status!",
                    "message": 'Record can not be edited as it is already cloned for edit and under processing!'
                });
                toastEvent.fire();   
                return;
            }
            else if (result=='false')
            {
                component.set("v.ShowModal",true);
          
            }
                else{
                    component.set("v.ShowModal",false);
                    alert('Some Problem has occured,Please contact your system administrator!');
                }
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
        
    },
    
    CloneHideMe: function(component, event, helper) {
        component.set("v.ShowClonedModal", false);
    },
    
     getCloneDataforEdit: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getCloneDataForEdit");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
          component.find("clonedDescription").set("v.value",result);
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
         
    },
    
    getSubmitForApprovalStatusValue: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getSubmitForApprovalStatusValue");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
          component.set("v.approvalStatus",result);
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
         
    },
    
    
})