({
    init: function (component,event,helper) {
        helper.getSubjectListHelper(component, event);
    },
    
    handleChange: function (component,event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value").toString();
        var appEvent = $A.get("e.c:TF_AG_SendSelectListValueEvt");
        appEvent.setParams({
            "selectedSubjectListValues" : selectedOptionValue});
        appEvent.fire();
        //alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
    },
    searchSubjectLists:function(component,event,helper){
        var values=component.get("v.values");
        component.set("v.selectedSubjectListValues",values);
        //component.set("v.disableSearch",true);
        helper.getSubjectListsFilterHelper(component,event);
    },
    filterSubjectCodeEnter:function(component,event,helper){
        
        helper.checkFilterDataValidationsOnEnter(component,event);
    },
    displayCount:function(component,event,helper){
        helper.getDisplayCount(component,event);
    },
    checkAllSubjectList:function(component,event,helper){
        var lstSubjectList=component.get("v.lstSubjectList");
        var lstCheckedValuesListBox=component.get("v.checkedValuesListBox");
        var count=component.get("v.countSelected");
        console.log('lstSubjectList---->'+JSON.stringify(lstSubjectList));
        var listData=[];
        //var flag=component.get("v.flag");
        for(var i=0;i<lstSubjectList.length;i++){
            lstSubjectList[i].isSelected=true;
            listData.push(lstSubjectList[i]);
        }
        /*var gets=listData.concat(lstCheckedValuesListBox);
        console.log('listData--'+JSON.stringify(gets));*/
        component.set("v.lstSubjectList",listData)
        //count=count+listData.length;
        //component.set("v.countSelected",count);
         
        /*var appEvent = $A.get("e.c:TF_AG_SendSelectListValueEvt");
        appEvent.setParams({
            "selectedSubjectListValues" : gets});
        appEvent.fire();*/
        helper.getDisplayCount(component,event);
        
    },
    unCheckAllSubjectList:function(component,event,helper){
        var lstSubjectList=component.get("v.lstSubjectList");
        var count=component.get("v.countSelected");
        var listData=[];
        console.log('lstSubjectList---->'+JSON.stringify(lstSubjectList));
        for(var i=0;i<lstSubjectList.length;i++){
            lstSubjectList[i].isSelected=false;
            listData.push(lstSubjectList[i]);
        }
        count=count-listData.length;
        component.set("v.lstSubjectList",listData);
        helper.getDisplayCount(component,event);
    },
    viewSelectedLists:function(component,event,helper){
        var isChecked=event.getSource().get("v.checked");
        if(component.get("v.countSelected") !== 0){
            component.set("v.isViewSelected",isChecked);
        }
        else{
            helper.showToastMessage(component,event,'Nothing is selected','Alert','error');
            event.getSource().set("v.checked",false)
        }
    }
})