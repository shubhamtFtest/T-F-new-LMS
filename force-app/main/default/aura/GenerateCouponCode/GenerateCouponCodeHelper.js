({
	setInit : function(component, event, helper) {        
        var action1 = component.get("c.getRecordTypeId");
        action1.setCallback(this, function(response) {
			component.set("v.recordTypeId", response.getReturnValue());
      	});
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.checkUserHasCustomPermissionAccess");     
        action2.setCallback(this, function(response) {
			component.set("v.isValidUser", response.getReturnValue());
      	});
        $A.enqueueAction(action2);  
        
        var action3 = component.get("c.getPickListValues"); 
        action3.setParams({
            "ObjectApiName": 'CPQ_Discount_Configuration__c',
            "fieldApiName": 'Discount_Category__c'
        });
        
        action3.setCallback(this, function(response) {        
            var result = response.getReturnValue();
            result.sort();
            //result.unshift('choose one..');
            component.set('v.discountCategoryLst', result);
        });
		$A.enqueueAction(action3);        
	},    
	searchProduct : function(component, event, helper) {
        var action = component.get("c.getProductTitle");
        var productCodeField = component.find("productcode");
        var productCode = productCodeField.get("v.value");        
		action.setParams({productCode: productCode});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		var result = response.getReturnValue();
                //console.log(result);
                let button = component.find('generatecode');
                if(result != null){
                    component.set('v.producttitle',result);
    				button.set('v.disabled',false);                    
                }else{
    				button.set('v.disabled',true);                      
                    component.set('v.producttitle','Invalid product code');                     
                }                
        	}
      	});
      $A.enqueueAction(action);        
	},   
	createCPQDisConfig : function(component, event, helper) {              
        var isValidInput = true;           
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.doSaveRecord"); //Calling the apex function 
                
        var productCodeField = component.find("productcode");
        var productCode = productCodeField.get("v.value");

        var emailField = component.find("email");
        var emaildValue = emailField.get("v.value");
        
        var couponCatField = component.find("couponcat");
        var couponCatValue = couponCatField.get("v.value");
        
        var startDateField = component.find("startdate");
        var startDateValue = startDateField.get("v.value");
        
        var endDateField = component.find("enddate");
        var endDateValue = endDateField.get("v.value");
        
        var discountValueField = component.find("discountvalue");
        var discountValue = discountValueField.get("v.value");

        var nosField = component.find("numberofuniquecouponcodes");
        var nosValue = nosField.get("v.value");

        var currencyField = component.find("pcurrency");
        var currencyValue = currencyField.get("v.value");       
        
        var singleUseField = component.find("singleuse");
        var singleUseValue = singleUseField.get("v.value");

        var discountTypeField = component.find("discounttype");
        var discountTypeValue = discountTypeField.get("v.value");
        
        var nosValueTot = (nosValue == '' || nosValue == null) ? 0 : nosValue;
        var discountVal = (discountValue == '' || discountValue == null) ? 0 : nosValue;
        var singleUseVal = (singleUseValue == '' || singleUseValue == null) ? 0 : singleUseValue;;

        if ($A.util.isEmpty(productCode) || productCode.length < 4 || productCode.length > 4 ) {
            productCodeField.set("v.errors", [{message:"Invalid product code"}]);
            isValidInput = false;
        } else {
            productCodeField.set("v.errors", null);
        }
        
        action.setParams({
                "TF_productCode" 		: productCode,
                "TF_couponcategory"   	: couponCatValue,
                "TF_startdate"   		: startDateValue,
                "TF_enddate"   			: endDateValue,
                "TF_couponcodelength"  	: nosValueTot,
                "TF_discounttype"   	: discountTypeValue,
                "TF_discountvalue"   	: discountValue,
                "TF_currency"   		: currencyValue,
                "TF_singleuse"   		: singleUseVal,
                "TF_email"   			: emaildValue
            });

            //Setting the callback
            action.setCallback(this,function(response){
                var today = new Date(); 
                var state = response.getState();
                var returnValue = response.getReturnValue();
                var errors = response.getError();
                console.log('returnValue::'+returnValue);            
                if(state == "SUCCESS"){ 
                    component.set("v.cpqdconf",[]);                
                    if(returnValue!=null){
                        component.find("productcode").set("v.value", "");
                        component.find("productname").set("v.value", "");
                        component.find("discountvalue").set("v.value", "");
                        component.find("discounttype").set("v.value", "");
                        component.find("numberofuniquecouponcodes").set("v.value", "");
                        component.find("singleuse").set("v.value", "");
                        component.find("couponcat").set("v.value", "");			                                            
                        component.find("startdate").set("v.value", "");
                        component.find("enddate").set("v.value", "");
                        component.find("email").set("v.value", "");
                        //component.find("pcurrency").set("v.value", "");
                        //$A.get('e.force:refreshView').fire();
                        let button = component.find('generatecode');
                        button.set('v.disabled',true);                        
                        component.set('v.recordList', returnValue);
                        toastEvent.setParams({"title": "Message!","type": "Success","message": "Record Inserted Successfully."});                     
                        toastEvent.fire();
                    }else{
                        toastEvent.setParams({"title": "Error!","type": "Error","message": "Invalid input field."});
                        toastEvent.fire();                        
                    }
                } else if (state == "INCOMPLETE") {
                    toastEvent.setParams({"title": "Oops!", "type": "error","message": "No Internet Connection."});
                    toastEvent.fire();                
                }else if(state == "ERROR"){               
                    toastEvent.setParams({"title": "Error!","type": "error","message": "Error in calling server side action."});
                    toastEvent.fire();                 
                }
            });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);            
	}    
})