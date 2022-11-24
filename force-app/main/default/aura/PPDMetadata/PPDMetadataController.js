({
    init : function(component, event, helper) {   
         var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'PPDProcessTabWizard',
            },
            state: {
                "recordId": component.get("v.recordId"),
                "IsRecordLocked" :component.get("v.IsRecordLocked"),
                "mainTabId":"Titles",
                "isFromFinishButton": "True"
            }
        };
        component.set("v.pageReference", pageReference);
        
        component.set('v.steps', [
            { label: 'Keywords', value: 'step1' },
            { label: 'Contributors', value: 'step2' },       
           // { label: 'Category', value: 'step3' },
           // { label: 'Classification', value: 'step3' },            
            { label: 'Collection Validity', value: 'step3' },
            { label: 'Collection Image', value: 'step4' },
            { label: 'Price Summary', value: 'step5' }
            
        ]);      
    },
    
    handleNext : function(component,event,helper){
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step1"){
            component.set("v.selectedStep", "step2");
        }
        else if(getselectedStep == "step2"){
            component.set("v.selectedStep", "step3");
        }
            else if(getselectedStep == "step3"){
                component.set("v.selectedStep", "step4");
            }
                else if(getselectedStep == "step4"){
                    component.set("v.selectedStep", "step5");
                }
        
                 /*   else if(getselectedStep == "step5"){
                        component.set("v.selectedStep", "step6");
                    }    */ 
    },
    
    handlePrev : function(component,event,helper){
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step2"){
            component.set("v.selectedStep", "step1");
        }
        else if(getselectedStep == "step3"){
            component.set("v.selectedStep", "step2");
        }
            else if(getselectedStep == "step4"){
                component.set("v.selectedStep", "step3");
            }
                else if(getselectedStep == "step5"){
                    component.set("v.selectedStep", "step4");
                }
                  /*  else if(getselectedStep == "step6"){
                        component.set("v.selectedStep", "step5");
                    }*/
    },
    
    handleFinish : function(component,event,helper){
        // alert('Finished...');
        helper.checkIfValidityDatesExist(component,event,helper);
        helper.checkIfPriceEntryExist(component,event,helper);
        
    },
    
    selectStep : function(component,event,helper){
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step1"){
            component.set("v.selectedStep", "step2");
        }
        else if (getselectedStep == "step2"){
            component.set("v.selectedStep", "step3");
        }
            else if (getselectedStep == "step3"){
                component.set("v.selectedStep", "step4");
            }
                else if (getselectedStep == "step4"){
                    
                    component.set("v.selectedStep", "step5");
                }
                   /* else if (getselectedStep == "step5"){
                        component.set("v.selectedStep", "step6");
                    }*/
    },   
    
})