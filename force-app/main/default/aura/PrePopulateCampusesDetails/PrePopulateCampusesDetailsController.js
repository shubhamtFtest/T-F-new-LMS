({   
   fetchMyCampusDetails: function(component, event, helper) {
      var action = component.get("c.fetchCampusDetails");
      action.setParams({
         "campId": component.get("{!v.recordId}") 
      });
     action.setCallback(this, function(response) {
         var state = response.getState();
         if (state == "SUCCESS") {
           var campRecord = response.getReturnValue();
           console.log(campRecord);
           var createRecordEvent = $A.get("e.force:createRecord");
             if(campRecord != null ){	          
                 createRecordEvent.setParams({
	               "entityApiName": "Department__c",
	               "defaultFieldValues": {
	                    'Account__c' : campRecord.Account__c, 
                        'Campus__c' : campRecord.Id,                     
                        'Mailing_Street__c': campRecord.Mailing_Street__c,
	                    'Mailing_City__c': campRecord.Mailing_City__c,
						'Mailing_Country_List__c' : campRecord.Mailing_Country_List__c,
						'Mailing_State_Province_List__c': campRecord.Mailing_State_Province_List__c,                      
                        'Mailing_ZIP_Postal_Code__c': campRecord.Mailing_ZIP_Postal_Code__c,
                        'Phone__c': campRecord.Phone__c,
               		}
            	});
           		 createRecordEvent.fire();
             }else{
                createRecordEvent.setParams({
	               "entityApiName": "Department__c",
                    "defaultFieldValues": {
	                    'Account__c' : campRecord.Id,             		
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