({
    doInit: function(component, event, helper) {
        component.set("v.isOpen", true);
        component.set('v.isSending', true);
        helper.getPriceBookEntry(component);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    search: function(component, event, helper) {
        helper.getPriceBookEntry(component);
    },    
    addMultipleProducts: function(component, event, helper) {
       helper.addMultipleProductHelper(component,event,helper);
    },    
    createOLI: function(component, event, helper) {
        var prodId = event.getSource().get("v.value");
        var oppId = component.get("v.oppRecordId");       
        var action = component.get("c.createOpportunityLineItem");    
        action.setParams({ 
            "productId":prodId,
            "opportunityId": oppId,
            "priceBook2Id":"01s6E000000ol8O",
            "currencyISOCode":"INR"
        });        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result == 'done'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({ 
                        'title' : 'Success', 
                        'message' : 'Product added sucessfully.' ,
                        'type':'success'
                    }); 
                    component.set("v.isOpen", false);
                    location.reload();
                    toastEvent.fire(); 
                    //$A.get('e.force:refreshView').fire();                    
                }
                //console.log('result'+ JSON.stringify(result));
                //component.set("v.products", result.products);
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
                    "message": "There was an issue while processing, please contact SFDC system admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.isSending", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.isSending", false);
    }    
})