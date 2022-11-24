({
    getSubjectListHelper : function(component, event) {
        var value=component.get("v.backToProductDetail");
        var action = component.get("c.getSubjectList");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            component.set("v.SubjectListReturnList",rtnValue);
            console.log(rtnValue);
            var options = [];
            var codeOptions=component.get("v.lstSubjectList");
            if(rtnValue.length>0){
                for(var i=0;i<rtnValue.length;i++){
                    var code={value:rtnValue[i].Text_1__c,isSelected:false};
                    options.push({ value: rtnValue[i].Text_1__c, label: rtnValue[i].Text_1__c});
                	codeOptions.push(code);
                }
                if(value.length !== 0){
                    var selectedCount=0;
                    for(var j=0;j<value.length;j++){
                        for(var k=0;k<codeOptions.length;k++){
                            if(codeOptions[k].value === value[j]){
                                codeOptions[k].isSelected=true;
                                selectedCount=selectedCount+1;
                            }
                        }
                    }
                    component.set("v.countSelected",selectedCount);
                }
                component.set("v.lstAllSubjectList",codeOptions);
                component.set("v.lstSubjectList",codeOptions);
             }            
            
        });
        $A.enqueueAction(action);
    },
    getSubjectListsFilterHelper:function(component, event){
        component.set("v.lstFilterResultSubjectList",[])
        var filterValue=component.get("v.term");
        component.set("v.flag",false);
        var lstAllSubjectList=component.get("v.lstAllSubjectList");
        var filterRgValue = new RegExp(filterValue, 'gi');
        if(filterValue.length>0){
            var lstCodesOption=component.get("v.SubjectListReturnList");
            var result = component.get("v.lstFilterResultSubjectList");
            
            for(var j in lstAllSubjectList){
                if (lstAllSubjectList[j].value.match(filterRgValue)) {
                    result.push(lstAllSubjectList[j]);
                }
            }
            component.set("v.lstSubjectList",result);
       }
        if(filterValue.length === 0){	
            component.set("v.flag",true);
            component.set("v.lstSubjectList",lstAllSubjectList);
        }
    },
    checkFilterDataValidationsOnEnter:function(component,event){
        if(event.which === 13){
            this.checkFilterDataValidations(component,event);
        }
    },
    checkFilterDataValidations:function(component,event){
        var searchText=component.get('v.term');
        var doSearch=true;
        if(searchText === '' || searchText === undefined){
            //doSearch=false;
        }
        if(doSearch){
            this.getSubjectListsFilterHelper(component,event);
        }else{
            this.showToastMessage(component,event,'Please provide filter informations','Alert','error');
        }
    },
    showToastMessage:function(component,event,message,title,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message:message,
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 5000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    getDisplayCount:function(component,event){
        var value=event.getSource().get("v.checked");
        var lstSubjectList=component.get("v.lstAllSubjectList");
        var totalSelectedValues=[];
        for(var j in lstSubjectList){
            if (lstSubjectList[j].isSelected) {
                console.log(lstSubjectList[j].value);
                totalSelectedValues.push(lstSubjectList[j]);
            }
        }
        console.log('totalSelectedValues.length'+totalSelectedValues.length);
        component.set("v.checkedValuesListBox",totalSelectedValues);
        var appEvent = $A.get("e.c:TF_AG_SendSelectListValueEvt");
        appEvent.setParams({
            "selectedSubjectListValues" : totalSelectedValues});
        appEvent.fire();
        component.set("v.countSelected",totalSelectedValues.length);
       	console.log('checked'+JSON.stringify(component.get("v.checkedValuesListBox")));
    }
    
})