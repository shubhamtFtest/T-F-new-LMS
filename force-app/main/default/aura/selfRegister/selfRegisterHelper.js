({
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },
    
    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleSelfRegister: function (component, event, helpler) {
        debugger;
        var accountId = component.get("v.accountId");
        var regConfirmUrl = component.get("v.regConfirmUrl");
        var firstname = component.find("firstname").get("v.value");
        var lastname = component.find("lastname").get("v.value");
        var email = component.find("email").get("v.value");
        var includePassword = component.get("v.includePasswordField");
        var password = component.find("password").get("v.value");
        var confirmPassword = component.find("confirmPassword").get("v.value");
        var action = component.get("c.selfRegister");
        var extraFields = JSON.stringify(component.get("v.extraFields"));   // somehow apex controllers refuse to deal with list of maps
        var startUrl = component.get("v.startUrl");
        console.log('extraFields:='+extraFields);
        startUrl = decodeURIComponent(startUrl);
        component.set("v.disableSubmitButton",true);
        component.set("v.Spinner",true);
        action.setParams({firstname:firstname,lastname:lastname,email:email,
                          password:password, confirmPassword:confirmPassword, accountId:accountId, regConfirmUrl:regConfirmUrl, extraFields:extraFields, startUrl:startUrl, includePassword:includePassword});
        action.setCallback(this, function(a){
                component.set("v.Spinner",false);
             	var rtnValue = a.getReturnValue();
            	console.log('rtnValue:='+rtnValue);
            	if (rtnValue !== null) {
                component.set("v.disableSubmitButton",false);    
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
            	this.showToastMessage(component,event);
                }   
        });
        $A.enqueueAction(action);
        console.log('testing');
    },
    
    getExtraFields : function (component, event, helpler) {
        var action = component.get("c.getExtraFields");
        action.setParam("extraFieldsFieldSet", component.get("v.extraFieldsFieldSet"));
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.extraFields',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    setBrandingCookie: function (component, event, helpler) {        
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    },
	showToastMessage:function(component,event){
        var message=component.get("v.errorMessage");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Alert',
            message:message,
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'sticky'
        });
        toastEvent.fire();
    }    
})