({
    //Fetching country and state dependent picklist on Page Load
    doInit : function(component, event, helper) {
        //Hide box on contact lookup on load
        $A.util.removeClass(component.find('LookupOnload'),'slds-dropdown');
        
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        var recordId=component.get("v.recordId");
        helper.handlePostalCode(component, event, helper,recordId);
    },
    //Action performed on buttonClick of Add Sap Bp
    VerifyAddress : function(component, event, helper) {
        debugger;
        var recordId=component.get("v.recordId");
        var addressLine1 = component.get("v.addressLine1");
        var addressLine2 = component.get("v.addressLine2");
        var addressLine3 = component.get("v.addressLine3");
        var postalCode = component.get("v.postalCode");
        var phone = component.get("v.phone");
        var careOf = component.get("v.careOf");
        var department = component.get("v.department");
        var state = component.find("state").get("v.value");  
        var city = component.get("v.city");
        var country = component.find("country").get("v.value");  
        var emailAddress = component.get("v.emailAddress");
        var title=component.get("v.title");
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var statesize =component.get("v.listDependingValues");
        console.log('addressLine1 ==========>',addressLine1);
        console.log('addressLine2 ==========>',addressLine2);
        console.log('country ==========>',country);
		//alert('department.length '+department.length);
        console.log('state ==========>',statesize.length);
        if ($A.util.isEmpty(addressLine1) || $A.util.isUndefinedOrNull(addressLine1) || 
            $A.util.isEmpty(emailAddress) || $A.util.isUndefinedOrNull(emailAddress) || emailAddress.indexOf("@") <0||
            $A.util.isEmpty(firstName) || $A.util.isUndefinedOrNull(firstName)||
            $A.util.isEmpty(lastName) || $A.util.isUndefinedOrNull(lastName)||
            $A.util.isEmpty(country) || $A.util.isUndefinedOrNull(country)|| country=="--- None ---"||
            $A.util.isEmpty(city) || $A.util.isUndefinedOrNull(city)||
            $A.util.isEmpty(postalCode) || $A.util.isUndefinedOrNull(postalCode))
        {
            helper.showToastMessage(component,event,helper,'Required field is missing.','Error');                                             
            component.find('addressLine1').showHelpMessageIfInvalid();
            component.find('emailAddress').showHelpMessageIfInvalid();
            component.find('firstName').showHelpMessageIfInvalid();
            component.find('lastName').showHelpMessageIfInvalid();
            component.find('country').showHelpMessageIfInvalid();
            component.find('city').showHelpMessageIfInvalid();
            component.find('postalCode').showHelpMessageIfInvalid();
            
            return;
        }
        
        
        if(!$A.util.isEmpty(department) && !$A.util.isUndefinedOrNull(department) && department.length>50)
        {
            helper.showToastMessage(component,event,helper,'Department can not be greater than 50 character.','Error');
        	return;
        }
        if(!$A.util.isEmpty(careOf) && !$A.util.isUndefinedOrNull(careOf) && careOf.length>50)
        {
            helper.showToastMessage(component,event,helper,'CareOf can not be greater than 50 character.','Error');
        	return;
        }
        //Account required validation
        if($A.util.isUndefinedOrNull(component.get("v.recordId")) || $A.util.isEmpty(component.get("v.recordId"))){
            helper.showToastMessage(component,event,helper,'Account is required.','Error');
            return;
        }
        
        
        
        if(state=="--- None ---"){
            state="";
            console.log(state);
        }
        console.log(state);
        component.set("v.spinner",true);
        component.set("v.isAddVerificationFailed",false);
        var obj={RecordId : recordId, AddressLine1 : addressLine1 , AddressLine2 : addressLine2, AddressLine3 : addressLine3 , PostalCode : postalCode, Phone : phone, State : state, City : city , Country : country, EmailAddress : emailAddress, Title : title, FirstName : firstName, LastName :lastName,careOf :careOf,department:department };
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
                                       console.log('obj '+JSON.stringify(obj));
                                       helper.verifySapBp(component,helper,obj);                    
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
    
    
    
    
    
    
    
    
    
    
    
    
    // When a keyword is entered in search box
	searchRecords : function( component, event, helper ) {
        //On load we remove this class so, here we are adding it again
        $A.util.addClass(component.find('LookupOnload'),'slds-dropdown');
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
		    helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
	},

    // When an item is selected
	selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            
    		var recordsList = component.get('v.recordsList');
    		var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            
            //On contact lookup record selection setting values
            component.set('v.firstName',selectedRecord.conObj.FirstName);
            component.set('v.lastName',selectedRecord.conObj.LastName);
            component.set('v.emailAddress',selectedRecord.conObj.Email);
            component.set('v.phone',selectedRecord.conObj.Phone);
            
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            
        }
	},
    
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
	},

    // To remove the selected item.
	removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
    	$A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    
    //For Account lookup
    handleChange : function(component, event, helper) { 
        debugger;       
        var lookupAccId = event.getParam("value")[0];
        if(!$A.util.isEmpty(lookupAccId) && !$A.util.isUndefinedOrNull(lookupAccId))
        {
            component.set("v.recordId", lookupAccId); 
        }else{
            component.set("v.recordId",'');
        }
        helper.handlePostalCode(component, event, helper,lookupAccId);
    },
    
    
    
})