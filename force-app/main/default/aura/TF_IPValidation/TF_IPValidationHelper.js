({
    getResponse: function(component) {
        // create a server side action.       
        var action = component.get("c.getCalloutResponseContents");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && (response.getReturnValue()) != null && response.getReturnValue().length > 0) {      
                component.set("v.objectList", response.getReturnValue());
                component.set("v.Spinner", false);
                var lstObject=component.get("v.objectList");
                var partyIdList= [];
                for(var i=0;i<lstObject.length;i++){
           			if(lstObject[i].errorMsg != null){
                        partyIdList.push(lstObject[i].errorMsg);
           	 		}
        		}
                var allowRejectcheck = false;
        		for(var i=0;i<lstObject.length;i++){
           			if(lstObject[i].allowReject == true){
                        allowRejectcheck = true;
                        for(var j=0;j<partyIdList.length;j++){
                            if(lstObject[i].errorMsg != partyIdList[j]){
                               allowRejectcheck = false; 
                            }
                        }
                        component.set("v.errorMsg",lstObject[i].errorMsg );
                        component.set("v.validateFailed",true );
           	 		}
        		}
                var tempd = component.get("v.validateFailed");
                component.set("v.allowReject", allowRejectcheck);
                
            }
            else{
                
                component.set("v.Spinner", false);
                component.set("v.showErrors", true);
            }
        });        
        $A.enqueueAction(action);
    },
    thirdPartyRejectRequest : function(component, event) {
		var updateAction = component.get("c.updateThirdPartyAccountRejStatus");
        updateAction.setParams({
            "recordId": component.get("v.recordId"),
            "partyIdExAcc": component.get("v.errorMsg"),
            "ipList": JSON.stringify(component.get("v.objectList"))
        });
 
        $A.enqueueAction(updateAction);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    }
})