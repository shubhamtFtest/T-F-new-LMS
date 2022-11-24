({
    addMultipleProductHelper : function(component) {
        var updateId = [];
        var oppId = component.get("v.oppRecordId");
        var getAllId = component.find("boxPack");       
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                updateId.push(getAllId.get("v.text"));
            }
        }else{           
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    updateId.push(getAllId[i].get("v.text"));
                }
            }
        }   
        var action = component.get('c.updateRecord');
        action.setParams({
            "lstRecordId": updateId,
            "opportunityId": oppId,
            "priceBook2Id":"01s6E000000ol8O",
            "currencyISOCode":"INR"                            
        });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                this.fireSuccessToast(component);
                component.set("v.isOpen", false);
                location.reload();
            }
        });
        $A.enqueueAction(action);
    },    
    getPriceBookEntry : function(component) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getPriceBookEntry");    
        action.setParams({ 
            "oppId":recordID,
            "productName":component.find("productName").get("v.value"),
            "isbn":component.find("isbn").get("v.value"),
        });        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                //console.log('result.products'+ JSON.stringify(result.products));
                component.set("v.products", result.products);
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
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'Record has updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },
    
    fireRefreshEvt : function(component) {
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },    
})