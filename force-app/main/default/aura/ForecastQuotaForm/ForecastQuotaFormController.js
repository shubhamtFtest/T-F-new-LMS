({
    onInit :  function(cmp, event, helper) {      
        var typefore = cmp.get("v.InsertQuotaType") ;
        console.log('init type-'+typefore);      
        var editMode= cmp.get("v.editMode");
        var a = cmp.get('c.showFieldsAccordingType');
        $A.enqueueAction(a);

    },
    showFieldsAccordingType :  function(cmp, event, helper) { 
        console.log('type-'+cmp.get("v.InsertQuotaType"));      
        // <!--  InsertQuotaType == territory , producttype , Revenue  var == showTerritory showProducttype showRevenue -->
        if (!$A.util.isEmpty(cmp.get("v.InsertQuotaType")) && cmp.get("v.InsertQuotaType") == 'producttype' ) {
            $A.util.addClass(cmp.find('divTerritory'),'slds-hide');
            $A.util.removeClass(cmp.find('divProductFamily'),'slds-hide');
        } else if(!$A.util.isEmpty(cmp.get("v.InsertQuotaType")) && cmp.get("v.InsertQuotaType") == 'territory' ){
            $A.util.removeClass(cmp.find('divTerritory'),'slds-hide');
            $A.util.addClass(cmp.find('divProductFamily'),'slds-hide');
        }else{
            $A.util.addClass(cmp.find('divProductFamily'),'slds-hide');
            $A.util.addClass(cmp.find('divTerritory'),'slds-hide');
        }

    },
    showList : function(cmp,event,helper){
        cmp.set("v.showTable",true);  
        cmp.set("v.showFormQuota",false);
        console.log('showing list');
        cmp.set("v.showMenu",false);
    },
    // * call apex only if required fields are filled up - missing 
    clickCreate : function(cmp, event, helper) {
        console.log('territory-'+cmp.get("v.selItem.val"));
        console.log('user-'+cmp.get("v.selItem2.val"));
        console.log('forcating typ -'+cmp.get("v.selItem3.val"));
        cmp.set("v.Spinner", true);
        console.log('creating data js');
        var inputField = cmp.find('StartDate');
        if($A.util.isEmpty(inputField.get("v.value")))
        {
            inputField.set('v.validity', {valid:false, valueMissing :true});
            inputField.showHelpMessageIfInvalid();
            cmp.set("v.Spinner", false);
            return; 
            
        }
        if( !$A.util.isEmpty(cmp.find("QuotaAmount").get("v.value")) && !$A.util.isEmpty(cmp.find("QuotaQuantity").get("v.value")))
        {
            //alert('Both revenue and quantity values cannot be specified simultaneously');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error Message',
                message:'Both revenue and quantity values cannot be specified simultaneously',
                duration:'7000',
                type: 'error'
                
            });
            toastEvent.fire();
            cmp.set("v.Spinner", false);
            return;
        }        
        // Required field is missing : Forecasting Type endDate
        if(  $A.util.isEmpty( cmp.get("v.selItem3.val") ) ||  $A.util.isEmpty( cmp.find("CurrencyIsoCode").get("v.value") ) || $A.util.isEmpty( cmp.find("StartDate").get("v.value") ) || $A.util.isEmpty( cmp.find("endDate").get("v.value") ) )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error Message', message:'Please complete the Required fields',duration:'7000', type: 'error'                
            });
            toastEvent.fire();
            cmp.set("v.Spinner", false);
            return;
        }
        console.log('cmp.get("v.QuotaAmount")-'+cmp.find("QuotaAmount").get("v.value"));
        console.log('cmp.get("v.QuotaQuantity")-'+ cmp.find("QuotaQuantity").get("v.value"));
        console.log('cmp.get("v.StartDate")-'+JSON.stringify(cmp.find("StartDate").get("v.value")));
        console.log('cmp.get("v.CurrencyIsoCode")-'+cmp.find("CurrencyIsoCode").get("v.value"));
        console.log('cmp.get("v.ProductFamily")-'+cmp.find("ProductFamily").get("v.value"));
        console.log('cmp.get("v.ProductFamily")-'+cmp.get("v.editMode"));
        console.log('cmp.get("v.ProductFamily")-'+cmp.get("v.recordId") );
		console.log('cmp.get("v.StartDate")-'+ typeof cmp.find("StartDate").get("v.value"));
        
        
        if(!$A.util.isEmpty(cmp.find("StartDate").get("v.value")) && !$A.util.isEmpty(cmp.find("endDate").get("v.value"))  ){
            var startDated = cmp.find("StartDate").get("v.value");            
            var parts =startDated.split('-');
			var newstart = new Date(parts[0], parts[1] - 1, parts[2]); 
            var endDated = cmp.find("endDate").get("v.value");
            var parts1 =endDated.split('-');
			var newEnd = new Date(parts1[0], parts1[1] - 1, parts1[2]); 
            console.log('newstart-'+newstart);
            console.log('newEnd-'+newEnd);
            console.log('yhi h');
            if(newstart > newEnd) {
                console.log('start date bigger '); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message', message:'Start date can not be greater than end date.',duration:'7000',
                    type: 'error'
                });
                toastEvent.fire();
                cmp.set("v.Spinner", false);
                return;
            }
            
        }
        console.log('calling server side ');
        var action = cmp.get("c.createRecordDubDub");     
        //  QuotaOwner  Territory   ForecastingType
        action.setParams({
            ProductFamily : cmp.find("ProductFamily").get("v.value"),
            QuotaAmount : cmp.find("QuotaAmount").get("v.value"),
            QuotaQuantity : cmp.find("QuotaQuantity").get("v.value"),
            StartDate : JSON.stringify(cmp.find("StartDate").get("v.value")),
            CurrencyIsoCode : cmp.find("CurrencyIsoCode").get("v.value"),
            QuotaOwner : cmp.get("v.selItem2.val"),
            Territory : cmp.get("v.selItem.val"),
            ForecastingType : cmp.get("v.selItem3.val"),
            endDate : JSON.stringify(cmp.find("endDate").get("v.value"))         
        });  
        action.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){        
                cmp.set("v.Spinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message:'Action Completed Successfully',
                    duration:'7000',
                    type: 'Success'
                });
                toastEvent.fire();
                var actionShowlist = cmp.get("c.showList");
                $A.enqueueAction(actionShowlist);
            } else if(state == "ERROR"){
                var errors = a.getError();
                cmp.set("v.Spinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                        
                        // first error: DUPLICATE_VALUE, duplicate value found: <unknown> duplicates value on record
                        if(errors[0].message.includes('first error: DUPLICATE_VALUE, duplicate value found: <unknown> duplicates value on record'))
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message', message:'This record already exist. Please insert a new record',duration:'7000',
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                        else if(errors[0].message.includes('INVALID_OPERATION, __MISSING LABEL__ PropertyFile - val missing_territory not found in section api_ForecastingQuota')){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message', message:'This Forecasting Type can only be used with terrritory',duration:'7000',
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                        else if(errors[0].message.includes('You provided a territory ID, but the forecast type isn\'t territory-based')){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message', message:'This Forecasting Type can not be used with terrritory',duration:'7000',
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                        else if(errors[0].message.includes('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY, You can\'t add or remove a quota because either 1) you\'re not the forecast manager of any parent of this territory, or 2) the owner doesn\'t own the forecast on the territory.: [QuotaOwnerId, Territory2Id]')){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message', message:'You can\'t add a quota because either 1) you\'re not the forecast manager of any parent of this territory, or \n 2) the owner doesn\'t own the forecast on the territory',duration:'9000',
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                        else 
                        {                            
                            //alert for any error 
                            var lastComma = errors[0].message.lastIndexOf(",");
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message',
                                message:errors[0].message.substring(lastComma+1),
                                duration:'7000',
                                type: 'error'
                            });
                            toastEvent.fire();
                            //alert(errors[0].message.substring(lastComma+1));
                        }
                        
                    }
                } 
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
})