({
    init: function (component, event, helper) {
        var options = [
        ];
        var action = component.get("c.getConsortiumMemebrs");
        action.setParams({
            "licenseID": component.get("v.recordId"),
        }); 
        component.set("v.listOptions", options);
        //component.set("v.requiredOptions", ["Test Account1 220119"]);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                //alert(JSON.stringify(response.getReturnValue()));   
                var resultArray = response.getReturnValue()[1];
                var selectedAccount = response.getReturnValue()[2];
                
                resultArray.forEach(function(result)  { 
                    options.push({ value: result.Id, label: result.Name});
                });
                component.set("v.listOptions", options);                
                component.set("v.defaultOptions", selectedAccount);
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
    
    handleChange: function (component, event,helper) {
        var selectedOptionsList = event.getParam("value");
        //alert('=======>'+event.getParam("value")+'\n'+'=======>'+component.get("v.defaultOptions"));
        console.log(selectedOptionsList);
        console.log(selectedOptionsList.toString());        
        component.set("v.selectedArray", selectedOptionsList);
        helper.updateConsortiumMemebersHelper(component, event,selectedOptionsList);
    },
})