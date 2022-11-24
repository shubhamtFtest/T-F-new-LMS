({
    
    init: function (component, event,helper) {
        
        helper.fetchProductValidity(component, event, helper);
    },
    saveValidity : function(component, event, helper) {
        if(component.get("v.typeOfCollection")=='Manual Curation'){
            if(component.get("v.valueValidFrom")==undefined ){
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Required fields missing!",
                    "message": 'Please enter all the required values!'
                });
                toastEvent.fire();   
                return;
            }
        }
        if(component.get("v.typeOfCollection")=='Rule based'){
            if(component.get("v.valueValidFrom")==undefined  ||component.get("v.valueUpdatedFrom")==undefined ||component.get("v.valueUpdatedTo")==undefined){
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Required fields missing!",
                    "message": 'Please enter all the required values!'
                });
                toastEvent.fire();   
                return;
            }
        }
        helper.updateProductValidity(component, event, helper);
    },
    
    fetchValidity : function(component, event, helper) {
        helper.fetchProductValidity(component, event, helper);
    },
    
     checkValidity : function(component, event, helper) {
          var ValidFromDate =  component.get("v.valueValidFrom"); 
          var validToDate=  component.get("v.valueValidTo"); 
          var inputValidTodateCmp = component.find("ValidTo");
         var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
         
           inputValidTodateCmp.setCustomValidity("");
         
          if (validToDate <= ValidFromDate) {
              inputValidTodateCmp.setCustomValidity("Date should be greater than ValidFrom date!");
              component.set("v.dateValidationError" , true);
          }
         else if(validToDate<today){
             inputValidTodateCmp.setCustomValidity("Date should be greater than/equal to the current date");
              component.set("v.dateValidationError" , true);
         }
         else{
             component.set("v.dateValidationError" , false);
         }
     },
     checkUpdateValidity : function(component, event, helper) {
          var UpdateFromDate =  component.get("v.valueUpdatedFrom"); 
          var UpdateToDate=  component.get("v.valueUpdatedTo"); 
          var inputUpdateTodateCmp = component.find("updatedTo");
         var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
           inputUpdateTodateCmp.setCustomValidity("");
         
          if (UpdateToDate <= UpdateFromDate) {
              inputUpdateTodateCmp.setCustomValidity("Date should be greater than UpdateFrom date!");
              component.set("v.dateValidationError" , true);
          }
         else if(UpdateToDate<today){
             inputUpdateTodateCmp.setCustomValidity("Date should be greater than/equal to  the current date");
              component.set("v.dateValidationError" , true);
         }
         else{
             component.set("v.dateValidationError" , false);
         }
     }
    
})