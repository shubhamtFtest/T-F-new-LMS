({    
    
    init : function(component, event, helper) {
        var recordID = component.get("v.recordId");
       
       // component.set('v.implicitFltrValues', [{name: 'defaultName',value: 'defaultValue',prdType: 'defaultValue'}]);
        helper.checkForClonedProduct(component, event, helper);
        console.log("CollectionName123: " + event.getParam("businessId"));
        //businessId validation
        if(event.getParam("businessId") !== undefined){
            component.set('v.busId',event.getParam("businessId"));                  
        }
        
        //Collection name validation
        if(event.getParam("title") !== undefined){
            component.set('v.collectionName', event.getParam("title"));
        }
        
    },
    
    setAttributeValue: function(component, event, helper) {  
        component.find("accordion").set('v.activeSectionName', component.get("v.activeAccordion"));
    },
    
    //to download eBooks
    downloadCatalogue: function(component, event, helper) {
        component.set("v.disableDownload", true);
        var url = '';
        //var recordID = component.get("v.recordId");
        
        var action = component.get("c.downloadeBookCatalogue"); 
        /*action.setParams({
            "bundleId":recordID
        });*/
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                
                if(result != null && result != 'Error' && result != 'File not found'){
                    url = result;
                    window.location.href = url;                    
                }else if(result != null && result == 'File not found'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Could not downlaod",
                        "message": result,
                        "type": 'warning'
                    });
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Could not downlaod",
                        "message": "There was an issue downloading the file, please try later or contact SFDC system admin.",
                        "type": 'warning'
                    });
                    toastEvent.fire();
                }
                
                
            }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
            }
            component.set("v.disableDownload", false);
            
        });
        $A.enqueueAction(action);  
    },
    
    
})