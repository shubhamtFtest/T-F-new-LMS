({
    doInit : function(component, event, helper) {
        var action=component.get('c.getDealInformation');
        action.setParams({
            recordID : component.get('v.recordId')
        });
        action.setCallback(this,function(result){
            var state=result.getState();
            if(state== 'SUCCESS'){
                var output=result.getReturnValue();
                if(output != 'Price Agreement'){
                    component.set('v.isPriceAggrement',false);
                    var toggleText = component.find("divUnavailable");
                    $A.util.toggleClass(toggleText, "showCmp");
                }
                else{
                    component.set('v.isPriceAggrement',true);
                    var toggleDiv = component.find("divAvailable");
                    $A.util.toggleClass(toggleDiv, "showCmp");
                    //var myvar = sforce.apex.execute("OPP_UpdateChildStages", "UpdateMembers", {id:"{!Opportunity.Id}"})
                    //     var myVar = sforce.apex.execute("OPP_UpdateChildStages", "getContextUserName", {id:"{!Opportunity.Id}"});
                    // alert(myVar);
                }
            }
            //  alert(output);
            
        });
        $A.enqueueAction(action);
    },
    updateStage : function(component, event, helper) {
        var action=component.get('c.updateStages');
        action.setParams({
            oppID : component.get('v.recordId')
        });
        action.setCallback(this,function(result){
            var state=result.getState();
            var toggleMessage = component.find("divMessage");
            $A.util.removeClass(toggleMessage, "hideCmp");
            var toggleText = component.find("divAvailable");
            $A.util.removeClass(toggleText, "showCmp");
            $A.util.addClass(toggleText, "hideCmp");
            console.log('succ');
            if(state=='SUCCESS'){
                var message= result.getReturnValue();
                var isPrice=component.get('v.isPriceAggrement');
                if(message == 'Update Succesful'){
                    component.set('v.resultMessage','Child Opportunity update successfully');
                    if(isPrice == true){
                        var togglePop = component.find("divColor");
                        $A.util.addClass(togglePop, "slds-theme_success");
                    }
                }
                else if(message == null ){
                    component.set('v.resultMessage','There was no Child Oppoprtunity for update');
                    console.log('Price'+isPrice);
                    if(isPrice == true){
                        console.log('PriceIs'+isPrice);
                        var togglePop = component.find("divColor");
                        $A.util.addClass(togglePop, "slds-theme_error");
                        
                    }
                }
                    else if(message.includes('error')== true ){
                        component.set('v.resultMessage',message);
                        if(isPrice == true){
                            var togglePop = component.find("divColor");
                            $A.util.addClass(togglePop, "slds-theme_error");
                        }
                    }
                // console.log(result.getReturnValue());
                //alert(result.getReturnValue());
                //  helper.closeModal(component, event, helper);
            }else{
                component.set('v.resultMessage','There was some error while updating record');
                if(isPrice == true){
                    var togglePop = component.find("divColor");
                    $A.util.toggleClass(togglePop, "slds-theme_error");
                }
            }
        });
        $A.enqueueAction(action);
        //  alert('IDFF'); 
        //    var myVar = sforce.apex.execute("OPP_UpdateChildStages", "getContextUserName", {id:"{!Opportunity.Id}"});
        //console.log(myVar);
        //  alert('myVar'+myVar); 
    },
    closePopUp : function(component, event, helper) {
        helper.closeModal(component, event, helper);
    }
})