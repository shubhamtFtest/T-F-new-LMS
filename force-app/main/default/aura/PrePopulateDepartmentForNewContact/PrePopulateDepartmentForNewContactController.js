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
        var action = component.get("c.getRecTypeIdAndDepDetails"); 
        var rId = component.get("v.recordId");
        var recordTypeLabel = component.find("selectid").get("v.value");       
        action.setParams({
            "recordTypeLabel": recordTypeLabel,
            "depId": component.get("{!v.recordId}") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var createRecordEvent = $A.get("e.force:createRecord");
                var departmentDetails=JSON.parse( response.getReturnValue() );                
                console.log(departmentDetails);
                createRecordEvent.setParams({
                    "entityApiName": "Contact",
                    "recordTypeId": departmentDetails.recordTypeId,
                    "defaultFieldValues": {
                        'AccountId' :departmentDetails.depAccount,                        
                        'Department_Object__c' : departmentDetails.depId,
                        'Campus__c':departmentDetails.depCampus,
                        'Mailing_Country_List__c':departmentDetails.depMailingCountry,
                        'Mailing_State_List__c':departmentDetails.depMailingState,
                        'MailingCity':departmentDetails.depMailingCity,
                        'MailingStreet':departmentDetails.depMailingStreet,
                        'MailingPostalCode':departmentDetails.depMailingPostalCode,
                        'MailingState':departmentDetails.depMailingState,
                        'MailingCountry':departmentDetails.depMailingCountry
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