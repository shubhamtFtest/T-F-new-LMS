({
    //Fetching country and state dependent picklist on Page Load
    doInit : function(component, event, helper) {
        
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        
    },
    //Action performed on buttonClick of Add Sap Bp
    VerifyAddress : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var addressLine1 = component.get("v.addressLine1");
        var addressLine2 = component.get("v.addressLine2");
        var addressLine3 = component.get("v.addressLine3");
        var postalCode = component.get("v.postalCode");
        var phone = component.get("v.phone");
        var state = component.find("state").get("v.value");  
        var city = component.get("v.city");
        var country = component.find("country").get("v.value");  
        var emailAddress = component.get("v.emailAddress");
        var title=component.get("v.title");
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var statesize =component.get("v.listDependingValues");
        var postalcodecheck = component.get("v.reqPostalCode");
        console.log('addressLine1 ==========>',addressLine1);
        console.log('addressLine2 ==========>',addressLine2);
        console.log('country ==========>',country);
        console.log('postalCode ==========>',postalCode);
        console.log('state ==========>',statesize.length);
        console.log('postalcodecheck ==========>',postalcodecheck);
        if ($A.util.isEmpty(addressLine1) || $A.util.isUndefinedOrNull(addressLine1) || 
            $A.util.isEmpty(emailAddress) || $A.util.isUndefinedOrNull(emailAddress) || emailAddress.indexOf("@") <0||
            $A.util.isEmpty(firstName) || $A.util.isUndefinedOrNull(firstName)||
            $A.util.isEmpty(lastName) || $A.util.isUndefinedOrNull(lastName)||
            $A.util.isEmpty(country) || $A.util.isUndefinedOrNull(country)|| country=="--- None ---"||
            $A.util.isEmpty(city) || $A.util.isUndefinedOrNull(city))
        {
            helper.showToastMessage(component,event,helper,'Required field is missing.','Error');                                             
            component.find('addressLine1').showHelpMessageIfInvalid();
            component.find('emailAddress').showHelpMessageIfInvalid();
            component.find('firstName').showHelpMessageIfInvalid();
            component.find('lastName').showHelpMessageIfInvalid();
            component.find('country').showHelpMessageIfInvalid();
            component.find('city').showHelpMessageIfInvalid();
            if($A.util.isEmpty(postalCode) || $A.util.isUndefinedOrNull(postalCode) && postalcodecheck == true){
            	component.find('postalCode').showHelpMessageIfInvalid();
            	return;
        	}
            
            return;
        }
        if(state=="--- None ---"){
            state="";
            console.log(state);
        }
        console.log(state);
        component.set("v.spinner",true);
        var obj={RecordId : recordId, AddressLine1 : addressLine1 , AddressLine2 : addressLine2, AddressLine3 : addressLine3 , PostalCode : postalCode, Phone : phone, State : state, City : city , Country : country, EmailAddress : emailAddress, Title : title, FirstName : firstName, LastName :lastName };
       //This method Verifies if SAP BP already exist in the records or not if no duplicates SAP_BP found it calls next method verifySapBp.
        var action= component.get("c.VerifyAddressController");  
        action.setParams({  
            "SapBp" : obj,
            
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               console.log('addressLine2@@@',response.getReturnValue());
                               if (state === "SUCCESS") 
                               {
                                   var Res = response.getReturnValue();
                                   if(Res!='Party Id is not associated with this Account!!'){
                                                                          
                                   if(Res!=undefined){
                                       console.log('SUCCESS ==========>');
                                       var result = response.getReturnValue(); 
                                       console.log('id',result); 
                                       helper.showToastMessage(component,event,helper,'SAP BP might have a duplicate value.','Error');    
                                       component.set("v.spinner",false);
                                       
                                       
                                   }
                                   else{ 
                                       console.log('hi@@@@@@@@@');
                                       console.log('obj '+JSON.stringify(obj));
                                       helper.verifySapBp(component,helper,obj);                                 
                                       
                                   }
                                   }
                                       else{
                                       helper.showToastMessage(component,event,helper,'Account partyId is missing, please select a different account.','Error');    
                                       component.set("v.spinner",false);                                           
                                       }
                               
                               }
                               else 
                               {
                                   console.log('ERROR ==========>');
                               }
                               
                           });
        $A.enqueueAction(action);  
    },
    //-----Dependent Picklist set ----
    onControllerFieldChange: function(component, event, helper) {
        
        helper.checkPostalCodeReq(component,helper);
        var controllerValueKey = component.find("country").get("v.value");   // get selected controller field value
        console.log('controllerValueKey',controllerValueKey);
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        console.log('depnedentFieldMap',depnedentFieldMap);
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    
})