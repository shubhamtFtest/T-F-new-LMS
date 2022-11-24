({
  
   getAccDetails: function(component, event, helper) {
      var action = component.get("c.fetchAccDetails");
      action.setParams({
         'accId' : component.get("{!v.recordId}")
      });
       
     action.setCallback(this, function(response) {
         var state = response.getState();
         if (state == "SUCCESS") {
           var accRecord = response.getReturnValue();
           var createRecordEvent = $A.get("e.force:createRecord");

             if(accRecord != null ){

	            createRecordEvent.setParams({
	               "entityApiName": "Department__c",
	               "defaultFieldValues": {
	                    'Account__c' : accRecord.Id, 
	                    'Mailing_Street__c': accRecord.BillingStreet,
	                    'Mailing_City__c': accRecord.BillingCity,
	                    'Mailing_ZIP_Postal_Code__c': accRecord.BillingPostalCode,
	                    'Phone__c': accRecord.Phone,
	                    'Mailing_Country_List__c': accRecord.Mailing_Country_List__c,
	                    'Mailing_State_Province_List__c': accRecord.Mailing_State_List__c,

               		}
            	});
           		 createRecordEvent.fire();
             }else{

                createRecordEvent.setParams({
	               "entityApiName": "Department__c",
                    "defaultFieldValues": {
	                    'Account__c' : component.get("{!v.recordId}")
                        
                                      		}
            	});
				createRecordEvent.fire();
                 
             }
           
            $A.get("e.force:closeQuickAction").fire();
         } else if (state == "INCOMPLETE") {
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
 
})