({
    cloneProductRecord: function(component, event, helper) {     
        
        var recId=component.get("v.recordId");         
        //cloning the product
        var action=component.get("c.getClonedProduct");
        action.setParams({
            "bundleID":recId
        });
        action.setCallback(this, function(response) {   
            var state = response.getState();
            if(state=="SUCCESS"){
                var result = response.getReturnValue(); 
              
                component.set("v.clonedProductId",result.productId); 
                component.set("v.totalRecs",result.totalRecords);
                component.set("v.pstn",result.position);
                
                var cloneEvt = $A.get("e.c:PPDGenericEvent");
                cloneEvt.setParam("porcessBundelItems",true);
                cloneEvt.fire();
               // closing modal box
                component.set("v.IsSpinner", false);  
                component.set("v.ShowModal", false);
                
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success",
                "message": 'Your request is under process, You will get a confirmation email.'
            });
            toastEvent.fire(); 
            }            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
       // var cloneProgressEvt = $A.get("e.c:PPDProgressEvent");
        //cloneProgressEvt.setParam("showStatusBar",true);
        //cloneProgressEvt.setParam("progressPercent",0);
        //cloneProgressEvt.setParam("progressFor",'Product clone progress status :');
        //cloneProgressEvt.fire();
        component.set("v.IsSpinner", true);  
        
        
        // alert(component.get("v.clonedProductId"));
        //redirecting the user to the cloned Product
        
    },
    // (String bundleID, String CloneProductId, String position, String processedRecCount, String totalRecCount) { 
    copyBundleItems: function(component, event, helper) {     
        
        if (event.getParam("porcessBundelItems") !== undefined && event.getParam("porcessBundelItems") == true) {
            helper.cloneBundleItems(component, event, helper);
        }
        
        
    },
    
    closeModal: function(component, event, helper) {     
        component.set("v.ShowModal", false);
    },
    
    copyBundleLineItemsFromParts :function(component, event, helper){
        if (event.getParam("porcessBundelItems") !== undefined && event.getParam("porcessBundelItems") == true) {
     helper.cloneBundleItemsFromParts(component, event, helper);
        }
	}
})