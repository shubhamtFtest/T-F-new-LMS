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
        console.log('obj '+JSON.stringify(obj));
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
                    console.log('SUCCESS ==========>');
                    
                }
                else{
                    this.showToastMessage(component,event,helper,"Address Verification failed.. "+result.getReturnValue(),"Error");
                    component.set("v.spinner",false);
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
        console.log('obj'+obj);
        var action= component.get("c.CreateSAPBP");  
        action.setParams({  
            "sapBp" : obj
        });
        action.setCallback(this, function(result){
            console.log('hi');
            var state = result.getState();
            console.log('state131',state);
            if (state === "SUCCESS") 
            {
                component.set("v.spinner",false);
                //    $A.get("e.force:closeQuickAction").fire();
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
                
                
            }
            else{
                console.log('Error ==========>');
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);   
        
    },
    checkPostalCodeReq:function(component,helper) {
        
        var thisCountry = component.find("country").get("v.value");
        var action= component.get("c.checkIfPostalCodeReq");  
        action.setParams({  
            "country" : thisCountry
        });
        action.setCallback(this, function(result){
            if ( result.getReturnValue() != null) 
            {
                component.set("v.reqPostalCode",result.getReturnValue());
            }
        });
        $A.enqueueAction(action);   
        
    }
    
    
    
})