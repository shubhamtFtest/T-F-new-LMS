({
    
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {          
            var recordTypeLst = response.getReturnValue();
            component.set("v.lstOfRecordType", recordTypeLst);         
            component.set('v.selectedValue', recordTypeLst[0]);
            
        });       
        $A.enqueueAction(action);   
    },
    
    createRecord: function(component, event, helper) {
        component.set("v.isOpen", true);       
        var action = component.get("c.getRecTypeId"); 
        var rId = component.get("v.recorId");
        var recordTypeLabel = component.find("selectid").get("v.value");       
        action.setParams({
            "recordTypeLabel": recordTypeLabel,
            "campId": component.get("{!v.recordId}") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var campReturn=JSON.parse( response.getReturnValue() );
            console.log(campReturn);      
            if (state === "SUCCESS"){
                var createRecordEvent = $A.get("e.force:createRecord");
              
                createRecordEvent.setParams({
                    "entityApiName": "Contact",
                    "recordTypeId": campReturn.recordTypeId,
                    "defaultFieldValues": {
                        
                        'AccountId' :campReturn.campusAccount,                        
                        'Campus__c' : campReturn.campusId,
                        'Mailing_Street__c':campReturn.campusMailingStreet,                      
                        'Mailing_Country_List__c':campReturn.campusMailingCountry,
                        'Mailing_State_List__c':campReturn.campusMailingState                      
                       
                    }
                });


                createRecordEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
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
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });       
        $A.enqueueAction(action);
    },
    
    closeModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
})