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
      component.set("v.isOpen", true);
       
      var action = component.get("c.getContactRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
       
      action.setParams({
         "recordTypeLabel": recordTypeLabel,
          "contactId": component.get("{!v.recordId}"),
          "Primary_Contact__c":component.get("{!v.recordId}")
      });
          
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS"){
            
            var createRecordEvent = $A.get("e.force:createRecord");
            var opportunityDetails = JSON.parse( response.getReturnValue() );
            console.log(opportunityDetails);
             // alert(opportunityDetails.contactId);
            createRecordEvent.setParams({
               "entityApiName": "Opportunity",
               "recordTypeId": opportunityDetails.recordTypeId,
                "defaultFieldValues": {
               		'AccountId' : opportunityDetails.accountId,
                    'Campus__c' : opportunityDetails.campusId,
                    'Department__c' : opportunityDetails.departmentId,
                    'Primary_Contact__c':opportunityDetails.contactId
              
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