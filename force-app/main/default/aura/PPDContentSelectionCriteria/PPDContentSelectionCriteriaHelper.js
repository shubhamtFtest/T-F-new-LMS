({
    
    loadPicklistValues: function (component, event, settingName) {
        
        var action = component.get("c.getDropDownListValues"); 
        action.setParams({
            "settingName": settingName
        });
        
        action.setCallback(this, function(response) {        
            var result = response.getReturnValue();
            result.sort();
            result.unshift('choose one...');
            if(settingName == 'TextTypeValues'){
                component.set('v.textTypeLst', result);
                
            }else if(settingName == 'PublisherImprint'){
                component.set('v.publisherImprintLst', result);
            }
            component.set("v.IsSpinner",false);
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true);
    }
    
})