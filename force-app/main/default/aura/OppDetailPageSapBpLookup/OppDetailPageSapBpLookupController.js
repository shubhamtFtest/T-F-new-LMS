({
    init : function(component, event, helper) {
        var recId = component.get("v.recordId");
        component.set('v.mySpinner',true);
        helper.getRecordsofBP(component, event);
    },
    
    accountInputValue : function(component, event, helper){
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.issearching', true);
            helper.getRecordsFromBPTable(component, event);
        }
        component.get("v.accountNameUserInput");		
    }, 
    
    BilltoClick : function(component,event,helper){
        component.set('v.showSearchComponent',true);
        component.set('v.mySpinner',true);
        component.set('v.bpDetail','BillTo');
        component.set('v.oppRecordId',component.get("v.recordId"));
        helper.getRecordsFromBPTable(component, event);
    },
    
    ShiptoClick : function(component,event,helper){
        component.set('v.showSearchComponent',true);
        component.set('v.mySpinner',true);
        component.set('v.bpDetail','ShipTo');
        component.set('v.oppRecordId',component.get("v.recordId"));
        helper.getRecordsFromBPTable(component, event);
    },
    
    closeSearchComponent : function(component,event,helper){
        component.set('v.showSearchComponent',false);
    }, 
    
    createNewSapBp : function(component,event,helper){
        debugger;
        if($A.util.isUndefinedOrNull(component.get("v.selectedRecord")) || $A.util.isEmpty(component.get("v.selectedRecord"))){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Alert!",
                "message": 'Account is required.'
            });
            toastEvent.fire();
            return;
        }else{
            component.set('v.isShowSapBpCreationCmp',true);
        	component.set('v.showSearchComponent',false);
        }
    },
    
    closeCreateNewSapBpCmp : function(component,event,helper){
        component.set('v.isShowSapBpCreationCmp',false);
    },
    
    handleClick : function(component,event,helper){
        component.set('v.mySpinner',true);
        var bpValue = component.get('v.bpDetail');
        helper.saveBP(component,event,bpValue);
    },
    
    copyBillToSapBP : function(component, event, helper){
        helper.copyBillTo(component,event);
    },
    
    sapBpResponse : function(component, event, helper){
        helper.sapBpResponseHelper(component,event);
    },
    
    handleChange : function(component, event, helper) { 
        debugger;       
        var lookupAccId = event.getParam("value")[0];
        if(!$A.util.isEmpty(lookupAccId) && !$A.util.isUndefined(lookupAccId))
        {
            component.set("v.selectedRecord.Id" , lookupAccId); 
            //Fetch list of sap bp on account selection
            var action = component.get("c.fetchsapBpRecords");
            action.setParams({
                "accountId": component.get("v.selectedRecord.Id"),
            });
            action.setCallback(this, function(response){
                component.set('v.mySpinner',false);
                if (response.getState() == "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    console.log('returnValue '+JSON.stringify(returnValue));
                    if(returnValue.length>0){
                        component.set('v.wrapperData.sapBPList',returnValue);
                        component.set('v.originalSapList', returnValue);
                        component.set('v.noRecordsFoundMsg',false);
                        component.set('v.isSapBpListPresent',true);
                    }
                    else {
                        component.set('v.noRecordsFoundMsg',true);
                        component.set('v.isSapBpListPresent',false);
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.selectedRecord", {} );
        }
    },
    
    searchExistingBpRecord: function(component, event, helper){
        var searchBpName = component.get('v.searchBpName').toLowerCase().replace(/\s/g, '');;
        var sapBPList = component.get('v.wrapperData.sapBPList');
        var originalSapList = component.get('v.originalSapList');
        var sapBpSearchList = [];
        
        if(!$A.util.isUndefinedOrNull(originalSapList) && !$A.util.isEmpty(originalSapList))
        {
            for(var i in originalSapList)
            { 
                var tempFirstName
                var tempLastName;
                var tempFullName;
                
                if(!$A.util.isUndefinedOrNull(originalSapList[i].First_Name__c) && !$A.util.isEmpty(originalSapList[i].First_Name__c))
                { 
                    tempFirstName = originalSapList[i].First_Name__c;
                    tempFirstName = tempFirstName.toLowerCase().replace(/\s/g, '');
                    tempFullName = tempFirstName;   
                }
                if(!$A.util.isUndefinedOrNull(originalSapList[i].Last_Name__c) && !$A.util.isEmpty(originalSapList[i].Last_Name__c))
                {
                    tempLastName = originalSapList[i].Last_Name__c; 
                    tempLastName = tempLastName.toLowerCase().replace(/\s/g, '');
                    tempFullName = tempFullName + tempLastName;
                }
                if(tempFullName.match(searchBpName))
                    sapBpSearchList.push(originalSapList[i]);
                
            }
            component.set('v.wrapperData.sapBPList',sapBpSearchList);
        }
        else{
            component.set('v.wrapperData.sapBPList',originalSapList);
        }
    },
    emailSearchExistingBpRecord: function(component, event, helper){
        component.set('v.searchBpName',null);
        var sapBPList = component.get('v.wrapperData.sapBPList');
        var originalSapList = component.get('v.originalSapList');
        var sapBpSearchList = [];
        var searchBpEmailStr = component.get('v.searchBpEmail');
        if(!$A.util.isUndefinedOrNull(originalSapList) && !$A.util.isEmpty(originalSapList))
        {
            for(var i in originalSapList)
            { 
                var emailStr;
                if(!$A.util.isUndefinedOrNull(originalSapList[i].Email__c) && 
                   !$A.util.isEmpty(originalSapList[i].Email__c)){
                    emailStr = originalSapList[i].Email__c; 
                }
                if((emailStr.match(searchBpEmailStr) && !$A.util.isUndefinedOrNull(searchBpEmailStr))){
                    console.log('111');
                    sapBpSearchList.push(originalSapList[i]);
                }
                                
            }
            component.set('v.wrapperData.sapBPList',sapBpSearchList);
        }
        else{
            component.set('v.wrapperData.sapBPList',originalSapList);
        }
    }
    
})