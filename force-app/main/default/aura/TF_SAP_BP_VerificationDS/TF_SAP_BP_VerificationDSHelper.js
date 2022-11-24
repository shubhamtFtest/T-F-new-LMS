({
    //This method shows toast messages
    showToastMessage : function(component,event,helper,message,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : type,
            message: message,
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 50',
            key: 'info_alt',
            type: type,
            mode: 'Timed'
        });
        toastEvent.fire();
    },
    //this method is checking if the addess is valid for the SAP BP if Valid it is calling another method CreateSapBp
    verifySapBp : function(component,helper,obj){
        console.log('verifySapBp '+JSON.stringify(obj));
        var action= component.get("c.shippingAddressVerify");  
        action.setParams({  
            "sapBp" : obj
        });
        console.log('verifySapBp');
        action.setCallback(this, function(result){
            console.log('hi');
            var state = result.getState();
            console.log('state',state);
            if (state === "SUCCESS") 
            {
                var RespAccountAddressVer = result.getReturnValue();
                if(RespAccountAddressVer=='200'){
                    //Radhikay's method
                    this.CreateSapBp(component,helper,obj);
                    
                    //end
                    this.showToastMessage(component,event,helper,"Address Verification completed.. SAP BP creation request submitted!!.","Success");
                    console.log('RespAccountAddressVer'+RespAccountAddressVer);
                    component.set("v.isAddVerificationFailed",false);
                }
                else{
                    //this.showToastMessage(component,event,helper,"Address Verification failed.. "+result.getReturnValue(),"Error");
                    component.set("v.spinner",false);
                    //Show an error message on UI as address is not verified
                    component.set("v.addVerificationFailedErrorMsg", 'Address Not Verified, ' +result.getReturnValue());
                    component.set("v.isAddVerificationFailed",true);
                    console.log('Error ==========>hi');
                }
                
                
            }
            
        });
        $A.enqueueAction(action);  
    },
    
    
    //----Dependent Picklist---
    
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
                component.set("v.spin",false);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
    //This method creates the SAP BP in salesforce.
    CreateSapBp:function(component,helper,obj) {
        debugger;
        console.log('CreateSapBp obj'+JSON.stringify(obj));
        var action= component.get("c.CreateSAPBP");  
        action.setParams({  
            "sapBp" : obj,
            "bpDetail" : component.get("v.bpDetail"),
            "oppId" : component.get("v.oppRecordId"),
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.spinner",false);
                //Layout Refereshing
                component.set("v.addressLine1",'');
                component.set("v.addressLine2",'');
                component.set("v.addressLine3",'');
                component.set("v.postalCode",'');
                component.set("v.city",'');
                component.find("country").set("v.value", '--- None ---');
                component.find("state").set("v.value", '--- None ---');
                component.set("v.emailAddress",'');
                component.set("v.title",'');
                component.set("v.firstName",'');
                component.set("v.lastName",'');
                component.set("v.department",'');
                component.set("v.careOf",'');
                component.set("v.phone",'');
                component.set("v.selectedRecord",'');
                component.set("v.recordId",'');
                
                //Handelling this event in OppDetailPageSapBpLookup component
                if(component.get("v.isEventFire")){
                    console.log('Sap Bp Details '+result.getReturnValue());
                    var bpResponseTransferEvent = $A.get("e.c:SapBpCreationResponse");
                    bpResponseTransferEvent.setParams({"sapBpCreationResponse": result.getReturnValue()});
                    bpResponseTransferEvent.fire();
                }
                
            }
            else{
                console.log('Error ==========>');
                component.set("v.spinner",false);
                helper.showToastMessage(component, event, helper, 'Something went wrong. Please try again later','Error','Error');
            }
        });
        $A.enqueueAction(action);   
        
    },
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    searchRecordsHelper : function(component, event, helper, value) {
		debugger;
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);
		// Calling Apex Method
    	var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'value' : value,
            'accountId' : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
            //alert('result '+JSON.stringify(result) );
        	if(response.getState() === 'SUCCESS') {
    			if(result.length > 0) {
    				// To check if value attribute is prepopulated or not
					if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
					} else {
                        component.set('v.selectedRecord', result[0]);
					}
    			} else {
    				component.set('v.message', "No Records Found for '" + searchString + "'");
    			}
        	} else {
                // If server throws any error
                /*var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }*/
                //If account Id is not present then show error message
                component.set('v.message', 'Account is required to search the contact.');
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        	$A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
	},
    handlePostalCode : function(component, event, helper,lookupAccId) {
        console.log('lookupAccId->'+lookupAccId);
        var action = component.get("c.fetchPostalCodeDetails");
        action.setParams({
            "AccountId":lookupAccId
        });
        action.setCallback(this,function(result){
            var state = result.getState();
            console.log('state',state);
            if (state === "SUCCESS"){
                var resList = result.getReturnValue();
                console.log('resList->'+resList);
                for(var i=0; i<resList.length; i++){
                    var c = resList[i];
                    if(c.Id == lookupAccId){
                        component.set('v.country',c.BillingCountry);
                        component.set('v.state',c.Mailing_State_List__c);
                        component.set('v.city',c.BillingCity);
                        component.set('v.addressLine1',c.BillingStreet);
                        component.set('v.postalCode',c.BillingPostalCode);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
})