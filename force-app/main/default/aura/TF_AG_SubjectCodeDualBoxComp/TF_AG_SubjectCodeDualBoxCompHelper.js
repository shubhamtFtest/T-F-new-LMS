({
    getSubjectCodesHelper : function(component, event) {
        var value=component.get("v.backToProductDetail");
        var action = component.get("c.getSubjectCodes");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            component.set("v.SubjectCodeReturnList",rtnValue);
            var options = [];
            var codeOptions=component.get("v.lstSubjectCodes");
            
            if(rtnValue.length>0){
                for(var i=0;i<rtnValue.length;i++){
                    var code={value:rtnValue[i].Text_1__c,isSelected:false};
                    if(i<=999){
                        codeOptions.push(code);
                        options.push(code);
                    }
                    else{
                        codeOptions.push(code);
                    }
                }
                if(value.length !== 0){
                    var selectedCount=0;
                    for(var j=0;j<value.length;j++){
                        for(var k=0;k<options.length;k++){
                            if(options[k].value === value[j]){
                                options[k].isSelected=true;
                                selectedCount=selectedCount+1;
                            }
                        }
                    }
                    component.set("v.countSelected",selectedCount);
                }
                console.log('selectedCount:='+selectedCount);
                console.log(JSON.stringify(options));
                component.set("v.lstAllSubjectCodes",codeOptions);
                component.set("v.lstSubjectCodes",options);
                component.set("v.lstPreservedSubjectCode",options);
            }            
            
        });
        $A.enqueueAction(action);
    },
    getSubjectCodesFilterHelper:function(component, event){
        component.set("v.lstFilterResultSubjectCodes",[]);
        var filterValue=component.get("v.term");
        var lstAllSubjectCodes=component.get("v.lstAllSubjectCodes");
        var lstSubjectCode=component.get("v.lstSubjectCodes");
        console.log('lstAllSubjectCodes:='+JSON.stringify(lstAllSubjectCodes));
        var filterRgValue = new RegExp(filterValue, 'gi');
        if(filterValue.length>0){
            
            var lstCodesOption=component.get("v.SubjectCodeReturnList");
            var result = component.get("v.lstFilterResultSubjectCodes");
            
            for(var j in lstAllSubjectCodes){
                if (lstAllSubjectCodes[j].value.match(filterRgValue)) {
                    console.log('Code Value'+lstAllSubjectCodes[j].value);
                    result.push(lstAllSubjectCodes[j]);
                }
            }
            console.log('result='+JSON.stringify(result));
            component.set("v.lstSubjectCodes",result);
            var options = [];
            /*if(result.length>0){
                for(var i=0;i<result.length;i++){
                    //options.push({ label: result[i].Text_1__c,value: result[i].Text_1__c});
                }
                component.set("v.options",options);
            }  */
        }
        if(filterValue.length === 0)
        {	
            component.set("v.lstSubjectCodes",component.get("v.lstPreservedSubjectCode"));
            console.log('list---'+JSON.stringify(component.get("v.lstSubjectCodes")));
            /*var lstCodesOption=component.get("v.SubjectCodeReturnList");
            var result = [];
            for(var j in lstCodesOption){
                result.push(lstCodesOption[j]);
            }
            var options = [];
            if(result.length>0){
                for(var i=0;i<result.length;i++){
                    options.push({ label: result[i].Text_1__c,value: result[i].Text_1__c});
                }
                component.set("v.options",options);
            }*/  
        }
        
        //console.log("ddf55="+component.get("v.selectedSubjectCodeValues"));
        //component.set("v.values",component.get("v.selectedSubjectCodeValues"))
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
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    checkFilterDataValidationsOnEnter:function(component,event){
        
        if(event.which === 13){
            this.checkFilterDataValidations(component,event);
        }
    },
    checkFilterDataValidations:function(component,event){
        
        
        var searchText=component.get('v.term');
        var doSearch=true;
        if(searchText === '' || searchText === undefined)
        {
            //doSearch=false;
        }
        
        
        
        if(doSearch){
            this.getSubjectCodesFilterHelper(component,event);
        }else{
            this.showToastMessage(component,event,'Please provide filter informations','Alert','error');
        }
    },
    getDisplayCount:function(component,event){
        var value=event.getSource().get("v.checked");
        var lstSubjectCodes=component.get("v.lstAllSubjectCodes");
        var totalSelectedValues=[];
        for(var j in lstSubjectCodes){
            if (lstSubjectCodes[j].isSelected){
                console.log(lstSubjectCodes[j].value);
                totalSelectedValues.push(lstSubjectCodes[j]);
            }
        }
        console.log('totalSelectedValues.length'+totalSelectedValues.length);
        component.set("v.checkedValuesListBox",totalSelectedValues);
        var appEvent = $A.get("e.c:TF_AG_SendSelectSubjectCodeEvt");
        appEvent.setParams({
            "selectedSubjectCodes" : totalSelectedValues});
        appEvent.fire();
        component.set("v.countSelected",totalSelectedValues.length);
        console.log('checked'+JSON.stringify(component.get("v.checkedValuesListBox")));
    }
})