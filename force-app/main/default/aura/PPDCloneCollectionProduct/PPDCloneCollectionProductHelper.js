({
    cloneBundleItems: function(component, event, helper) {     
        
        var recId = component.get("v.recordId");
        var clonedRecId = component.get("v.clonedProductId"); 
        var totalRecords = component.get("v.totalRecs");         
        var processedRecords = component.get("v.processedRecs");  
        var pos = component.get("v.pstn");         
        
        //cloning the product
        var action=component.get("c.cloneBundleItems");
        action.setParams({
            "bundleID":recId,
            "CloneProductId":clonedRecId,
            "position":pos.toString(),
            "processedRecCount":processedRecords.toString(),
            "totalRecCount":totalRecords.toString()
        });
        action.setCallback(this, function(response) {   
            var state = response.getState();
            if(state=="SUCCESS"){
                var result = response.getReturnValue(); 
                component.set("v.processedRecs",result.processedRecords); 
                component.set("v.pstn",result.position);
                console.log('processedRecords'+result.processedRecords);
                console.log('position'+result.position);
                
                if(result.moreRecsToProcess == 'True'){
                    var cloneEvt = $A.get("e.c:PPDGenericEvent");
                    cloneEvt.setParam("porcessBundelItems",true);
                    cloneEvt.fire();
                    
                    var progPercent = Math.floor((result.processedRecords / totalRecords) * 100)
                    var cloneProgressEvt = $A.get("e.c:PPDProgressEvent");
                    cloneProgressEvt.setParam("showStatusBar",true);
                    cloneProgressEvt.setParam("progressPercent",progPercent);
                    cloneProgressEvt.setParam("progressFor",'Product clone progress status :');
                    cloneProgressEvt.fire();
                    
                }else{
                    component.set("v.IsSpinner", false);  
                    var cloneProgressEvt = $A.get("e.c:PPDProgressEvent");
                    cloneProgressEvt.setParam("showStatusBar",false);
                    cloneProgressEvt.setParam("progressPercent",0);
                    cloneProgressEvt.setParam("progressFor",'Progress status :');
                    cloneProgressEvt.fire();
                    
                   // this.reDirectToClonedRecord(component, event, helper);
                   
                }
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
        
        //redirecting the user to the cloned Product
        
    },
    
    reDirectToClonedRecord: function(component, event, helper) {
        
        //redirecting the user to the cloned Product
        var clonedRecordId= component.get("v.clonedProductId");
        if(clonedRecordId!='' || clonedRecordId!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": clonedRecordId
            });
            navEvt.fire(); 
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Some Problem has occured,please contact system administrator!!'
            });
            toastEvent.fire(); 
        }
    },
    
    cloneBundleItemsFromParts: function(component, event, helper){
     var clonedRecordId= component.get("v.clonedProductId");
    var originalProductId=component.get("v.recordId");
    var action=component.get("c.copyBundleLineItemsFromPartsAPI");
        action.setParams({ 
            "OriginalbundleId":originalProductId,
            "clonedProductId":clonedRecordId
                    });

	action.setCallback(this, function(response) {   
            var state = response.getState();
            if(state=="SUCCESS"){
                var result = response.getReturnValue(); 
               
                
                var cloneProgressEvt = $A.get("e.c:PPDProgressEvent");
                    cloneProgressEvt.setParam("showStatusBar",false);
                    cloneProgressEvt.setParam("progressPercent",0);
                    cloneProgressEvt.setParam("progressFor",'Progress status :');
                    cloneProgressEvt.fire();
                    
                    
            }
        });
        var startTime = performance.now();
        $A.enqueueAction(action);
	}
    
    
})