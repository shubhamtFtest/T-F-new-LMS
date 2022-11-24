({
    init: function (component,event,helper) {
        /*var items = [];
        for (var i = 0; i < 15; i++) {
            var item = {
                "label": "Option " + i,
                "value": "opt" + i,
            };
            items.push(item);
        }
        cmp.set("v.options", items);
        // "values" must be a subset of values from "options"
        cmp.set("v.values", ["opt10", "opt5", "opt7"]);*/
        helper.getSubjectCodesHelper(component, event);
    },
    
    handleChange: function (component,event,helper) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value").toString();
        var appEvent = $A.get("e.c:TF_AG_SendSelectSubjectCodeEvt");
        appEvent.setParams({
            "selectedSubjectCodes" : selectedOptionValue});
        appEvent.fire();
    },
    searchSubjectCodes:function(component,event,helper){
        //component.set("v.disableSearch",true);
        var values=component.get("v.values");
        component.set("v.selectedSubjectCodeValues",values);
        helper.getSubjectCodesFilterHelper(component,event);
    },
    filterSubjectCodeEnter:function(component,event,helper){
        helper.checkFilterDataValidationsOnEnter(component,event);
    },
    displayCount:function(component,event,helper){
        helper.getDisplayCount(component,event);
    },
    checkAllSubjectCode:function(component,event,helper){
        var lstSubjectCode=component.get("v.lstSubjectCodes");
        var lstCheckedValuesListBox=component.get("v.checkedValuesListBox");
        console.log('lstSubjectCode---->'+JSON.stringify(lstSubjectCode));
        var codeData=[];
        for(var i=0;i<lstSubjectCode.length;i++){
            lstSubjectCode[i].isSelected=true;
            codeData.push(lstSubjectCode[i]);
        }
        console.log(codeData.length);
        //var gets=codeData.concat(lstCheckedValuesListBox);
        //console.log('listData--'+JSON.stringify(gets));
        component.set("v.lstSubjectCodes",codeData)
       
        /*var appEvent = $A.get("e.c:TF_AG_SendSelectListValueEvt");
        appEvent.setParams({
            "selectedSubjectListValues" : gets});
        appEvent.fire();*/
        helper.getDisplayCount(component,event);
    },
    unCheckAllSubjectCode:function(component,event,helper){
        var lstSubjectCode=component.get("v.lstSubjectCodes");
        var codeData=[];
        for(var i=0;i<lstSubjectCode.length;i++){
            lstSubjectCode[i].isSelected=false;
            codeData.push(lstSubjectCode[i]);
        }
        console.log('lstSubjectCode---->'+JSON.stringify(lstSubjectCode));
       
        component.set("v.lstSubjectCodes",codeData)
    	helper.getDisplayCount(component,event);
    },
    viewSelectedCodes:function(component,event,helper){
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