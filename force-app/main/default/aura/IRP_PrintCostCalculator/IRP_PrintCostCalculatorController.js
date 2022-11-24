({
    doInit : function(component, event, helper) {
        console.log('@@@ Print Cost Calculator component loaded.');
        helper.getCoversionRateHelper(component,event,helper);       
    }, 
    handleActive: function (cmp, event, helper) {
        helper.handleActive(cmp, event);
    },
    onUMCValueChange: function (component, event, helper) {
        var qty = component.find("quantity").get("v.value");
        var trimSize = component.get("v.trimSize");
        helper.getPopularFormatValues(component, trimSize);
        console.log('trimSize::'+trimSize);
        if(qty > 300){
            component.set("v.isEstimatedUnitCostUKDisabled", false);
        } else if (qty < 300){
            component.set("v.isEstimatedUnitCostUKDisabled", true);
        }        
    },    
    onChangeVersionType : function(component, event, helper) {
        var versionTypeValue = component.find('versionType').get('v.value');
        component.set("v.requiredVersionType", versionTypeValue);
    },
    onChangeTextColour : function(component, event, helper) {
        var textColourValue = component.find('textColour').get('v.value');
        component.set("v.textColour", textColourValue);
        if(textColourValue == 'Mono') {
           component.set("v.isPaperTypeDisabled", false); 
        } else if(textColourValue == 'Colour'){
          component.set("v.isPaperTypeDisabled", true);  
        }       
    },
    onChangePaperType : function(component, event, helper) {
        var paperTypeValue = component.find('paperType').get('v.value');
        component.set("v.paperType", paperTypeValue);
    },    
    closeUMCCalulatorModal: function(component, event, helper) { 
        component.set("v.isOpenUMCCalulatorModal", false);
    },    
    generatePrices : function(component, event, helper) {
        var coversionRateVal = component.get('v.coversionRate');
        var trimSize = component.get("v.trimSize");        
        var extent = component.get("v.extent");
        var quantity = component.get("v.quantity");
        
        //var versionTypeValue = component.get("v.versionType");
        var versionTypeValue = component.get("v.requiredVersionType");
        var textColourValue = component.get("v.textColour");
        var paperTypeValue = component.get("v.paperType");
        
        //setting values based on size and quantity
        var hardCasePLCVal = component.get("v.hardCasePLCValue");
        var colorVal = component.get("v.colorValue");
        var sewingVal = component.get("v.sewingValue");
        var x70gsmVal = component.get("v.x70gsmValue");
        var x80gsmVal = component.get("v.x80gsmValue");
		
        console.log('hardCasePLC:'+hardCasePLCVal+',color:'+colorVal+',sewing:'+sewingVal+',x70gsm:'+x70gsmVal+',x80gsm:'+x80gsmVal);
        console.log('trimSize::'+trimSize+',extent::'+extent+',quantity::'+quantity+',versionType::'+versionTypeValue+',textColour::'+textColourValue+',paperType::'+paperTypeValue);

        if((trimSize === '' || trimSize === undefined) 
          || (extent === '' || extent === undefined)
          || (quantity === '' || quantity === undefined)
          || (versionTypeValue === '' || versionTypeValue === undefined)
          || (textColourValue === '' || textColourValue === undefined)
          || (textColourValue === 'Mono' && (paperTypeValue === '' || paperTypeValue === undefined))) {
            helper.fireFailureToast(component,event,'Please correct field value and regenerated.');
        } else { 
            var action = component.get("c.getPopularFormats");    
            action.setParams({ "size" : trimSize, "qty" : quantity });        
            action.setCallback(this, function(response) { 
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    var umcUK;                                                 
                    /*** Start Quantity Range -> 1 to 10 ***/
                    //formula1
                    if((quantity > 0 && quantity <= 10) && versionTypeValue == 'Hardback' && textColourValue == 'Mono') {
                        console.log('formula1-(extent*X70gsm or X80gsm+ hardCasePLCVal)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*result.X70gsm + hardCasePLCVal)/coversionRateVal; 
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*result.X80gsm + hardCasePLCVal)/coversionRateVal;
                        }
                    }
					
                    //formula2
                    if((quantity > 0 && quantity <= 10) && versionTypeValue == 'Hardback' && textColourValue == 'Colour') {
                        console.log('formula2-(extent*color + hardCasePLCVal)/coversionRateVal'); 
                        umcUK = (extent*result.color + hardCasePLCVal)/coversionRateVal;                        
                    } 
                    
                    //formula3
                    if((quantity > 0 && quantity <= 10) && (extent > 200) && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula3-(extent*X70gsm or X80gsm + hardCasePLCVal)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            //umcUK = (extent*result.X70gsm + hardCasePLCVal)/coversionRateVal;
                            umcUK = (extent*result.X70gsm)/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            //umcUK = (extent*result.X80gsm + hardCasePLCVal)/coversionRateVal;
                            umcUK = (extent*result.X80gsm)/coversionRateVal;
                        }
                    } 
                    
                    //formula4
                    if((quantity > 0 && quantity <= 10) && (extent > 200) && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula4-(extent*color)/coversionRateVal');
                        umcUK = (extent*result.color)/coversionRateVal; 
                    } 
                    
                    //formula5
                    if((quantity > 0 && quantity <= 10) && (extent <= 200) && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula5-((extent*X70gsm or X80gsm)+20)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = ((extent*result.X70gsm)+20)/coversionRateVal; 
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = ((extent*result.X80gsm)+20)/coversionRateVal;
                        }
                    }
                    
                    //formula6
                    if((quantity > 0 && quantity <= 10) && (extent <= 200) && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula6-((extent*color) +20)/coversionRateVal');
                        umcUK = ((extent*result.color) +20)/coversionRateVal; 
                    }
                    /*** End Quantity Range -> 1 to 10 ***/
                    
					/*** Start Quantity range -> 11 to 30 ***/
                    //formula7
                    if((quantity > 10 && quantity <= 30) && versionTypeValue == 'Hardback' && textColourValue == 'Mono') {                        
                        if(paperTypeValue == '70gsm'){
                            console.log('formula7 -((extent*(X70gsm + sewing)) + hardCasePLCVal)/coversionRateVal');
                            umcUK = ((extent*(result.X70gsm + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            console.log('formula7 -umcUK = ((extent*(X80gsm + sewing)) + hardCasePLCVal)/coversionRateVal');
                            umcUK = ((extent*(result.X80gsm + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                        }
                    }
					
                    //formula8
                    if((quantity > 10 && quantity <= 30) && versionTypeValue == 'Hardback' && textColourValue == 'Colour') {
                        console.log('formula8-((extent*.color + sewing)) + hardCasePLCVal)/coversionRateVal');
                        umcUK = ((extent*(result.color + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                    } 
                    
                    //formula9
                    if((quantity > 10 && quantity <= 30) && (extent > 200) && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula9-(extent*(X70gsm))/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*(result.X70gsm))/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*(result.X80gsm))/coversionRateVal;
                        }
                    } 
                    
                    //formula10
                    if((quantity > 10 && quantity <= 30) && (extent > 200) && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula10-(extent*color)/coversionRateVal');
                        umcUK = (extent*result.color)/coversionRateVal; 
                    } 
                    
                    //formula11
                    if((quantity > 10 && quantity <= 30) && (extent <= 200) && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula11-(extent*.X70gsm or 80gsm) +20)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*(result.X70gsm) +20)/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*(result.X80gsm) +20)/coversionRateVal;
                        }
                    }
                    
                    //formula12
                    if((quantity > 10 && quantity <= 30) && (extent <= 200) && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula12-((extent*color) +20)/coversionRateVal');
                        umcUK = ((extent*result.color) +20)/coversionRateVal; 
                    }
                    /*** End Quantity range -> 11 to 30 ***/
                    
                    /*** Start Quantity range -> 31 and Above ***/
                    //formula13
                    if(quantity > 30 && versionTypeValue == 'Hardback' && textColourValue == 'Mono') {
                        console.log('formula13-((extent*.X70gsm or X80gsm +.sewing)) + hardCasePLCVal)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){ 
                            umcUK = ((extent*(result.X70gsm + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = ((extent*(result.X80gsm + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                        }
                    }
					
                    //formula14
                    if(quantity > 30 && versionTypeValue == 'Hardback' && textColourValue == 'Colour') {
                        console.log('formula14-((extent*(color + sewing)) + hardCasePLCVal)/coversionRateVal');
                        umcUK = ((extent*(result.color + result.sewing)) + hardCasePLCVal)/coversionRateVal;
                    }                    

                    //formula15
                    if(quantity > 30 && extent >= 200 && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula15-(extent*(X70gsm or 80gsm + sewing))/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*(result.X70gsm + result.sewing))/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*(result.X80gsm + result.sewing))/coversionRateVal;
                        }
                    }

                    //formula16
                    if(quantity > 30 && extent >= 200 && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula16-(extent*(color + sewing))/coversionRateVal');
                        umcUK = (extent*(result.color + result.sewing))/coversionRateVal;
                    }

                    //formula17
                    if(quantity > 30 && (extent > 200 && extent < 400) && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula17-(extent*.X70gsm or 80gsm))/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*(result.X70gsm))/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*(result.X80gsm))/coversionRateVal;
                        }
                    }

                    //formula18
                    if(quantity > 30 && (extent > 200 && extent < 400) && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula18-(extent*(color))/coversionRateVal');
                        umcUK = (extent*(result.color))/coversionRateVal;
                    }    

                    //formula19
                    if(quantity > 30 && extent <= 200 && versionTypeValue == 'Paperback' && textColourValue == 'Mono') {
                        console.log('formula19-(extent*(X70gsm or X80gsm)+20)/coversionRateVal');
                        if(paperTypeValue == '70gsm'){
                            umcUK = (extent*(result.X70gsm)+20)/coversionRateVal;
                        } else if (paperTypeValue == '80gsm') { 
                            umcUK = (extent*(result.X80gsm)+20)/coversionRateVal;
                        }
                    }

                    //formula20
                    if(quantity > 30 && extent <= 200 && versionTypeValue == 'Paperback' && textColourValue == 'Colour') {
                        console.log('formula20- (extent*(color)+20)/coversionRateVal');
                        umcUK = (extent*(result.color)+20)/coversionRateVal;
                    }                    
                    component.set("v.estimatedUnitCostUK", umcUK.toFixed(2));
                    helper.fireSuccessToast(component,event,'Pricing generated sucessfully.');
                }else if (state == "INCOMPLETE") {
                    helper.fireFailureToast(component,event,'No internet connection');                
                } else if (state == "ERROR") {
                    helper.fireFailureToast(component,event,'There was an issue while generateing price.');
                }
            });
            $A.enqueueAction(action);
        }
    },
    submitUMC : function(component, event, helper){
        var estimatedUnitCostUK = component.get("v.estimatedUnitCostUK");        
        var extent = component.get("v.extent");
        var qty = component.get("v.quantity");
        var trimSize = component.get("v.trimSize");
        var formatHeight = component.get("v.formatHeight");
        var formatWidth = component.get("v.formatWidth");               
        var vType = component.get("v.versionType");
        var tColour = component.get("v.textColour");
        var pType = component.get("v.paperType");        
        var oliId = component.get("v.opportunityLineItemId");
        
        if(estimatedUnitCostUK > 0) {
            var action = component.get("c.updateUMC");    
            action.setParams({ 
                "oliId" : oliId,
                "umc": estimatedUnitCostUK,
                "qty" : qty,                
                "extent" : extent,
                "popularFormat" : trimSize,
                "formatHeight" : formatHeight,
                "formatWidth" : formatWidth,
                "versionType" : vType,
                "textColour" : tColour,
                "paperType" : pType
            });        
            action.setCallback(this, function(response) { 
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();                
                    helper.fireSuccessToast(component,event,'UMC has been updated sucessfully.');
                    component.set("v.isOpenUMCCalulatorModal", false);
                }else if (state == "INCOMPLETE") {
                    helper.fireFailureToast(component,event,'No internet connection');                
                } else if (state == "ERROR") {
                    var errors = response.getError();
                    alert(errors[0].message);
                    helper.fireFailureToast(component,event,'There was an issue while processing UMC.');z
                }
            });
            $A.enqueueAction(action);            
        }else{
            helper.fireFailureToast(component,event,'UMC not found. Please generate again.');            
        }
    },
    onChangeTrimSize : function(component, event, helper) {
        var trimSizeValue = component.find('trimSize').get('v.value');
        component.set("v.trimSize", trimSizeValue);
        if(trimSizeValue){
            helper.getPopularFormatValues(component, trimSizeValue);
        }else{
            component.set("v.formatHeight",'');
            component.set("v.formatWidth",'');
        }
    },  
    onSpecialFormatChange : function(component, event, helper) {
        var checkCmp = component.find("specialFormat").get("v.checked");
        component.set("v.isSpecialFormatSelected",checkCmp);
        var isSpecialFormatSelected = component.get('v.isSpecialFormatSelected');
        if(isSpecialFormatSelected == true) {            
            component.set("v.isPopularFormatsDisabled", true);
            component.set("v.isformatHeightDisabled", true);
            component.set("v.isformatWidthDisabled", true);
        } else if(isSpecialFormatSelected == false){
            component.set("v.isPopularFormatsDisabled", false);            
            component.set("v.isformatHeightDisabled", false);
            component.set("v.isformatWidthDisabled", false);            
        }       
    },   
})