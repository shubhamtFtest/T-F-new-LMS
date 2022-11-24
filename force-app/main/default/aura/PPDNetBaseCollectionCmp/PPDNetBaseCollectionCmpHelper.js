({
    getNetbasesHelper : function(component, event) {
        var selecteddData = component.get("v.checkedValuesListBox");
          var typeOfClassification=component.get("v.typeOfClassification");
        console.log('ClassificationType: ' + typeOfClassification);
         if(typeOfClassification=='NetBase'){
        var action = component.get("c.getNetBaseClassifications");
         }
        if(typeOfClassification=='WC_Code'){
        var action = component.get("c.getWCClassifications");
         }
        
        if(typeOfClassification=='Country-Select'){
        var action = component.get("c.getCountryForRestrictions");
         }
        
        if(typeOfClassification=='BISAC'){
            component.set("v.IsSpinner",true);
        var action = component.get("c.getBISACCodes");
         }
       
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            component.set("v.NetbaseReturnList",rtnValue);
            var options = [];
            var codeOptions=component.get("v.lstNetbases");
            component.set("v.IsSpinner",false);
            
            if(rtnValue.length>0){
                for(var i=0;i<rtnValue.length;i++){
                    var recTrueFlag = false
                        for(var k=0;k<selecteddData.length;k++){
                            if(selecteddData[k]==rtnValue[i].Text_1__c){
                                recTrueFlag = true
                            }
                        }
                    if(recTrueFlag == false){
                    var code={value:rtnValue[i].Text_1__c,isSelected:false};
                    }
                    else{
                        var code={value:rtnValue[i].Text_1__c,isSelected:true};
                    }
                    if(i<=3999){
                        codeOptions.push(code);
                        options.push(code);
                    }
                    else{
                        codeOptions.push(code);
                    }
                    
                }
                console.log(options.length);
                console.log(codeOptions.length);
                component.set("v.lstAllNetbases",codeOptions);
                component.set("v.lstNetbases",options);
                component.set("v.lstPreservedNetbase",options);
                component.set("v.countSelected",selecteddData.length);
            }            
            
        });
        $A.enqueueAction(action);
    },
    getNetbasesFilterHelper:function(component, event){
        component.set("v.lstFilterResultNetbases",[]);
        var filterValue=component.get("v.term");
        var lstAllNetbases=component.get("v.lstAllNetbases");
        var lstNetbase=component.get("v.lstNetbases");
        console.log('lstAllNetbases:='+JSON.stringify(lstAllNetbases));
        var filterRgValue = new RegExp(filterValue, 'gi');
        if(filterValue.length>0){
            
            var lstCodesOption=component.get("v.NetbaseReturnList");
            var result = component.get("v.lstFilterResultNetbases");
            
            for(var j in lstAllNetbases){
                if (lstAllNetbases[j].value.match(filterRgValue)) {
                    console.log('Code Value'+lstAllNetbases[j].value);
                    result.push(lstAllNetbases[j]);
                }
            }
            console.log('result='+JSON.stringify(result));
            component.set("v.lstNetbases",result);
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
            component.set("v.lstNetbases",component.get("v.lstPreservedNetbase"));
         	console.log('list---'+JSON.stringify(component.get("v.lstNetbases")));
            /*var lstCodesOption=component.get("v.NetbaseReturnList");
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
        
        //console.log("ddf55="+component.get("v.selectedNetbaseValues"));
        //component.set("v.values",component.get("v.selectedNetbaseValues"))
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
            this.getNetbasesFilterHelper(component,event);
        }else{
            this.showToastMessage(component,event,'Please provide filter informations','Alert','error');
        }
    },
    getDisplayCount:function(component,event){
        debugger;
       // alert('fire');
    	var value=event.getSource().get("v.checked");        
        var lstNetbases=component.get("v.lstAllNetbases");
        var totalSelectedValues=[];
            for(var j in lstNetbases){
                if (lstNetbases[j].isSelected){
                    console.log(lstNetbases[j].value);
                    totalSelectedValues.push(lstNetbases[j]);
                }
            }
        console.log('totalSelectedValues.length'+totalSelectedValues.length);
        component.set("v.checkedValuesListBox",totalSelectedValues);
        var value=totalSelectedValues;
        
        for(var j in value){
            var netBaseListval = value[j].value
            var netbaseSplit = netBaseListval.split(" - ");
            value[j]=netbaseSplit[0];
        }
        
        component.set("v.valueInp",value.toString());
        
       // alert( component.get("v.valueInp"));
        /*var appEvent = $A.get("e.c:TF_AG_SendSelectNetbaseEvt");
        appEvent.setParams({
            "selectedNetbases" : totalSelectedValues});
        appEvent.fire();*/
        component.set("v.countSelected",totalSelectedValues.length);
        console.log('checked'+JSON.stringify(component.get("v.checkedValuesListBox")));
    }
})