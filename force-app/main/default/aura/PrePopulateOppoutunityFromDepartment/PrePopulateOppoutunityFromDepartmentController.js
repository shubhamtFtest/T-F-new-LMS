({
    
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchOppRecordTypeValues");
        action.setCallback(this, function(response) {          
            var recordTypeLst = response.getReturnValue();
            component.set("v.lstOfRecordType", recordTypeLst);         
            component.set('v.selectedValue', recordTypeLst[0]);
            
        });       
        $A.enqueueAction(action);   
    },
    
    createRecord: function(component, event, helper) {

        var action = component.get("c.getRecTypeIdAndOpportunityDetails"); 
      
        var recordTypeLabel = component.find("selectid").get("v.value");       
        action.setParams({
            "recordTypeLabel": recordTypeLabel,
            "depId": component.get("{!v.recordId}") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();           
                     
            if (state === "SUCCESS"){
                var createRecordEvent = $A.get("e.force:createRecord");
                 var OpportunityDetails=JSON.parse( response.getReturnValue() ); 
                
              
                
                createRecordEvent.setParams({
                    "entityApiName": "Opportunity",
                     "recordTypeId": OpportunityDetails.recordTypeId,
                    
                    "defaultFieldValues": {                        
                        'AccountId' :OpportunityDetails.depAccount,                       
                        'Department__c' : OpportunityDetails.depId,
                        'Campus__c':OpportunityDetails.depCampus                      
                       
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