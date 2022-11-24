({
    
    handleFilesChange : function (cmp, event) {
        var files = event.getSource().get("v.files");
        var recordID = cmp.get("v.recordId");
        var reader = new FileReader();
        var action = cmp.get("c.addListOfPrductsViaFile");
        var base64 = 'base64,';
        
        if(cmp.get("v.CollectionType")=='Rule based'){
            cmp.set("v.uniqueId",'ISBN');
        }
        
        reader.onload = function () {
            var fileContents = reader.result;
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            
            action.setParams({
                "parentProductID": recordID,
                "fileInpt": encodeURIComponent(fileContents),
                "uniqueId": cmp.get("v.uniqueId"),
                "CollectionType":cmp.get("v.CollectionType"),
                "IsInclude":cmp.get("v.optionValue")
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                cmp.set("v.IsSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "duration": 10000,
                    "message": result.Msg
                });
                toastEvent.fire();
                //var newEvent = $A.get("e.c:PPDTitleRefreshEvent");
                //newEvent.fire();
                var newEvent = $A.get("e.c:PPDRefreshListEvent");
                newEvent.setParam("listToRefresh","UnsiloList");
                newEvent.fire();
                
                if(result.errMsg!=null){
                    var errorMessage= cmp.find("errorMessage");
                    errorMessage.set("v.value", result.errMsg);
                }
                
                var infoMessage=cmp.find("infoMessage");
                infoMessage.set("v.value", result.formatErrMsg);
                
                var enableButtonEvt = $A.get("e.c:PPDGenericEvent");
                enableButtonEvt.setParam("disableButton","ApprovalButton");
                enableButtonEvt.setParam("buttonValue",true);
                
                enableButtonEvt.fire();
                
            });
            $A.enqueueAction(action);
        };
        cmp.set("v.IsSpinner",true);
        reader.readAsDataURL(files[0]);
    },
    
    onChange: function (cmp, evt, helper) {
        cmp.set("v.uniqueId", cmp.find('select').get('v.value'));
        var infoMessage=cmp.find("infoMessage");
        infoMessage.set("v.value", '');  
        var errorMessage= cmp.find("errorMessage");
        errorMessage.set("v.value", '');
        
    },
    
    handleRadioChange: function (cmp, evt, helper) {
        var changeValue = evt.getParam("value");
        cmp.set("v.optionValue",changeValue);     
    },
    
    getItemsFromPCM: function (cmp, evt, helper) {
        var files = evt.getSource().get("v.files");
        var reader = new FileReader();
        var base64 = 'base64,';
        var resetLst = [];
        cmp.set("v.availableIds",resetLst);
        cmp.set("v.uploadedIds",resetLst);   
        cmp.set("v.unAvailableIds",'');
        cmp.set("v.showDownloadBtn","false");

        reader.onload = function () {
            var fileContents = reader.result;
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            
            var jsonObject = atob(fileContents);
            var nonNullIds = [];
           // jsonObject = jsonObject.replace(/-/g,"");
            jsonObject = jsonObject.split(/\r?\n|\r/);
            for(var strId of jsonObject){
                if(strId.trim() != ""){
                    nonNullIds.push(strId.trim());
                }
            }
            cmp.set("v.fileContent",encodeURIComponent(nonNullIds));

            jsonObject = null;
            console.log('nonNullIds'+nonNullIds);
            cmp.set("v.uploadedIds",nonNullIds);
            cmp.set("v.pstn",0);
            
            if(nonNullIds && nonNullIds.length > 0 && nonNullIds.length <= 1000){
                helper.getItemsFromPCMandInsert(cmp, evt);
            }else if(nonNullIds && nonNullIds.length > 1000){
                var errorMessage= cmp.find("errorMessage");
                errorMessage.set("v.value", 'Number of rows/Ids exeeds 1000, please upload a file containing less than 1000 rows/Ids');
                cmp.set("v.IsSpinner",false);
                var infoMessage=cmp.find("infoMessage");
                infoMessage.set("v.value", '');
            }else if(!nonNullIds && nonNullIds.length == 1 && nonNullIds[0] == ""){
                var errorMessage= cmp.find("errorMessage");
                errorMessage.set("v.value", 'No content in file'); 
                cmp.set("v.IsSpinner",false);
                var infoMessage=cmp.find("infoMessage");
                infoMessage.set("v.value", '');
            }
        };
        cmp.set("v.IsSpinner",true);
        reader.readAsDataURL(files[0]);
        
    },
    
    getItemsFromPCMEvt: function(component, event, helper) {      
        if (event.getParam("fileUpload") !== undefined && event.getParam("fileUpload") == true ){
            helper.getItemsFromPCMandInsert(component, event, helper);
        }
    },
    
    downloadIds: function(component, event, helper) {
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = component.get("v.unAvailableIds");
        console.log('csfcontent'+component.get("v.unAvailableIds"));
        hiddenElement.target = '_self'; 
        hiddenElement.download = 'ExportData.csv'; 
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    }
    
})