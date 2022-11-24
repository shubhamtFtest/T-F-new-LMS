({
    openRecordInEditMode: function(component, event, helper) {
      
        //redirecting the user to the cloned Product
        var recordID = component.get("v.recordId");
       /* var editRecordEvent  = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recordID
        });
        editRecordEvent.fire(); */
        component.set("v.ShowNewEditRecordModal",true);
         //$A.get('e.force:refreshView').fire();
    },
    
    checkIfNewProductVersionExist: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.checkIfNewVersionExist");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
            if(result=='true'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Record Edit Status!",
                    "message": 'Record can not be edited as it is already cloned for edit and under processing!'
                });
                toastEvent.fire();   
                return;
            }
            else if (result=='false')
            {
                component.set("v.ShowModal",true);
          
            }
                else{
                    component.set("v.ShowModal",false);
                    alert('Some Problem has occured,Please contact your system administrator!');
                }
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
        
    },
    
    CloneHideMe: function(component, event, helper) {
        component.set("v.ShowClonedModal", false);
    },
    
    getCloneDataforEdit: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getCloneDataForEdit");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
          component.find("clonedDescription").set("v.value",result);
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
         
    },
    
    getSubmitForApprovalStatusValue: function(component, event, helper) {
        var parentProductID = component.get("v.recordId");
        var action = component.get("c.getSubmitForApprovalStatusValue");    
        action.setParams({
            "bundleID": parentProductID            
        }); 
        
        action.setCallback(this, function(response) {  
            var result = response.getReturnValue();
          component.set("v.approvalStatus",result);
            
        });
        var startTime = performance.now();
        $A.enqueueAction(action);  
         
    },
    
    getBusinessIdValidityStatus:function(component, event, helper){
      var recordID = component.get("v.recordId"); 
      var businessIdToValidate=component.get("v.businessIdToValidate");
        var action = component.get("c.checkIfBusinessIdExist"); 
        action.setParams({
            "bundleID":recordID,
            "businessIdToValidate":businessIdToValidate,
            "calledFrom":'ui'
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                 if(result==202 || result==200){
                     component.set("v.IsBusinessIdValid",'Invalid');
                     component.set("v.IsBusinessIdExist", 'true');
                     var msgBusinessIdValidity = component.find("msgBusinessIdValidity");
                      component.set("v.IsBusinessIdValidatedFromPCM",false);
                    msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>BusinessId already exists! Please try again.</b></span>');
                      component.set("v.IsSpinner",false);

                }
                else if(result==404){
                     component.set("v.IsBusinessIdValid",'valid');
                     component.set("v.IsBusinessIdExist", 'false');
                     component.set("v.IsBusinessIdValidatedFromPCM",true);
                    this.saveValidatedBusinessId(component, event, helper); 
                    component.set("v.IsSpinner",false);
                    $A.get('e.force:refreshView').fire();
                }

                
                 }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                 component.set("v.IsSpinner",false);
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
                      
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true); 
    },
    
    getCollectionNameValidityStatus:function(component, event, helper){
      var recordID = component.get("v.recordId"); 
      var titleToValidate=component.get("v.titleToValidate");
        console.log('getCollectionNameValidityStatus: ' + recordID);
        var action = component.get("c.checkCollectionNameExist"); 
        action.setParams({
            "bundleId":recordID,
            "collectionName":titleToValidate,
            "calledFrom":'ui'
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            console.log('stateTab: ' + state + ' **  ' + response.getReturnValue());
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                 if(result==202 || result==200){
                     component.set("v.IsCollectionNameValid",'Invalid');
                     component.set("v.IsCollectionNameExist", 'true');
                     var msgCollectionNameValidity = component.find("msgCollectionNameValidity");
                      component.set("v.IsCollNameValidatedFromPCM",false);
                      msgCollectionNameValidity.set("v.value", '<span style="color: #bf4040;"><b>Collection Name already exists! Please try again.</b></span>');
                      component.set("v.IsSpinner",false);

                }
                else if(result==404){
                     component.set("v.IsCollectionNameValid",'valid');
                     component.set("v.IsCollectionNameExist", 'false');
                     component.set("v.IsCollNameValidatedFromPCM",true);
                    this.saveValidatedTitle(component, event, helper); 
                    component.set("v.IsSpinner",false);
                    component.set("v.ShowCollectionNameModal", false);
                    $A.get('e.force:refreshView').fire();
                }

                
                 }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                 component.set("v.IsSpinner",false);
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false);
            }
                      
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true); 
    },
    
    saveValidatedBusinessId:function(component, event, helper){
      var recordID = component.get("v.recordId"); 
        var businessIdToValidate='';
        if(component.get("v.businessIdToValidate")!=undefined){
              businessIdToValidate=component.get("v.businessIdToValidate");
        }
        else {
            businessIdToValidate=null;
        }
     
      var isBusinessIdValid= component.get("v.IsBusinessIdValidatedFromPCM");
        var action = component.get("c.saveValidatedBusinessId"); 
        console.log('IdToValidate: ' + businessIdToValidate + ' isTitleValid: ' + isBusinessIdValid);
        action.setParams({
            "businessId":businessIdToValidate,
            "bundleID":recordID,
            "IsBusinessIdValidated":isBusinessIdValid
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                var msgBusinessIdValidity = component.find("msgBusinessIdValidity");
                if(result==true && component.get("v.IsmsgFromBusinessModal")=='true'){
                    if(msgBusinessIdValidity){
                        msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>BusinessId has been validated and saved successfully.</b></span>');
                    }
                    component.set("v.ShowBusinessIdModal", false);
                }else if(result==false && component.get("v.IsmsgFromBusinessModal")=='true' && msgBusinessIdValidity){
                    msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>BusinessId already exists! Please try again.</b></span>');

                }
               component.set("v.IsSpinner",false);   
                 }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
            }
                      
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true); 
    },
    
    getBusinessIdToUpdate:function(component, event, helper){
         var recordID = component.get("v.recordId");
         var action = component.get("c.getBusinessIdToUpdate"); 
        action.setParams({
            "bundleID":recordID
            });
        
         action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                if(result!=null){
                    component.set("v.businessIdToValidate",result);
                }
            }
         });
        $A.enqueueAction(action);
    },
    
    getNameToUpdate:function(component, event, helper){
         var recordID = component.get("v.recordId");
         var action = component.get("c.getNameToUpdate"); 
        action.setParams({
            "bundleID":recordID
            });
        
         action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                if(result!=null){
                    component.set("v.titleToValidate",result);
                }
            }
         });
        $A.enqueueAction(action);
    },
    
    getBusinessIdValiditycheck:function(component, event, helper){
     var businessId = component.get("v.businessIdToValidate");
          var msgBusinessIdValidity = component.find("msgBusinessIdValidity");
        msgBusinessIdValidity.set("v.value",'');
         var action = component.get("c.ValidateBusinessId"); 
        action.setParams({
            "businessId":businessId
            });
        
         action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                if(result!=null){
                    component.set("v.IsBusinessIdRegexValidated",result);
                }
                
                 if(component.get("v.IsBusinessIdRegexValidated")==true){
                helper.getBusinessIdValidityStatus(component, event, helper);
                //start
                
                //end
               // msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>Updated!</b></span>');
                
            }
            else if(component.get("v.IsBusinessIdRegexValidated")==false){
               msgBusinessIdValidity.set("v.value", '<span style="color: #bf4040;"><b>BusinessId can contain only letters/alphanumeric characters/hyphen with max length as 14!</b></span>');
             
            }
                component.set("v.IsSpinner",false); 
                
            }
         });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true); 
},
    
   deleteCollectionRecord:function(component, event, helper){
       var recordID = component.get("v.recordId");
       var action = component.get("c.deleteCollection"); 
       action.setParams({
           "parentProductID":recordID
       });
       
       action.setCallback(this, function(response) {  
           var state = response.getState();
           if (state === "SUCCESS"){
               //alert('success');
               var result = response.getReturnValue();  
               //alert(result);
               if(result=='Success'){
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       "title": "Record Deleted!",
                       "message": 'Record has been deleted successfully!'
                   });
                   toastEvent.fire(); 
                    
               }
               component.set("v.IsSpinner",false);
               this.gotoList(component, event, helper);
               
           }
       });
       $A.enqueueAction(action);
       component.set("v.IsSpinner",true);
   },
    
    gotoList : function (component, event, helper) {
    var action = component.get("c.getListViews");
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            var listviews = response.getReturnValue();
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": listviews.Id,
                "listViewName": null,
                "scope": "Product2"
            });
            navEvent.fire();
        }
    });
    $A.enqueueAction(action);
},
    
    saveValidatedTitle:function(component, event, helper){
      var recordID = component.get("v.recordId"); 
        var titleToValidate='';
        if(component.get("v.titleToValidate")!=undefined){
              titleToValidate=component.get("v.titleToValidate");
        }else {
            titleToValidate=null;
        }
        console.log('titleToValidate: ' + titleToValidate + ' isTitleValid: ' + isTitleValid);
      	var isTitleValid= component.get("v.IsCollNameValidatedFromPCM");
        var action = component.get("c.saveValidatedTitle"); 
        action.setParams({
            "title":titleToValidate,
            "bundleID":recordID,
            "isTitleValid":isTitleValid
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();  
                $A.get('e.force:refreshView').fire();
               component.set("v.IsSpinner",false); 
                 }else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error has occurred,Please contact your administrator!"
                });
                toastEvent.fire();
                component.set("v.IsSpinner",false); 
            }
                      
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner",true); 
    }
    
})