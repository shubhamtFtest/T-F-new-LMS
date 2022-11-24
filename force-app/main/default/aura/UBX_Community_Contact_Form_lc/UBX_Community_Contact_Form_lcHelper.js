({
    
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
    //Max file size in handled in the js controller handleFilesChange method.
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner  
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0] 
        var file = fileInput[0];
        var self = this;
        
        // create a FileReader object
        var objFileReader = new FileReader();
        // set onload function of FileReader object  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value  
        var fileContentsLenght = fileContents.length;
        var endPosition = Math.min(fileContentsLenght, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var caseIdToUse = component.get("{!v.caseId}");      
        
        action.setParams({
            parentId: caseIdToUse,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back
        action.setCallback(this, function(response) {
            // store the response / Attachment Id  
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                var fileContentsLength = fileContents.length;
                endPosition = Math.min(fileContentsLength, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion
                // then call again 'uploadInChunk' method ,
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //As the file upload is handled after the user submits the case this is not required.
                    //alert('your File is uploaded successfully');
                    //component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors       
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    fileUploadHelper: function(component, event) {
        //File upload.
        var fileName = component.get("{!v.fileName}");
        if(fileName != null &&  fileName != ''){
            this.uploadHelper(component, event);
        }     
    },
    
    sandboxCheck : function(component, event) {
        
        //Setup the call to the apex controller.
        var action = component.get("c.runningInASandbox");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedValue = response.getReturnValue();
                if(returnedValue == true){
                    component.set("v.recaptchaConfirmed", true);
                }              
            }
        });   
        
        // enqueue the action
        $A.enqueueAction(action);         
    },
    
    
    setDefaultValues : function(component, event) {        
        //Set the default values.
        if(component.get("{!v.CommunityName}")==="book_authors")
        {
            component.set("v.customerTypePicked","Authors");  
            component.set("v.prioritySelected", "Low");
            component.set("v.topics",["", "Login", "Personal details", "Address change","Bank details","Statements","Other"] );
        }else{
            if(component.get("{!v.CommunityName}")==="TFO")
            {
                component.set("v.customerType",["", "Author", "Agent", "Librarian/Institution","Student/Researcher","Other","Societies"]);  
            }
            else
            {
                component.set("v.customerType",["", "Agent", "Librarian/Institution","Student/Researcher","Other"]);  
            }
            component.set("v.priority",["Low", "Medium", "High"]);
        }
    },
    
    
    submitCaseHelper : function(component, event) {
        
        component.set("v.AllowCaseSubmit", true);
        
        /* Removed as a thank you message is being displayed on the community page.
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Thank You!",
            message: "Someone will be in touch shortly.",
            type: "success"
        });
        toastEvent.fire();
        */
        
        //Setup the call to the apex controller.
        var action = component.get("c.createCase");
        var customerTypeValue = component.get("{!v.customerTypePicked}");
        var institutionName = component.get("{!v.institutionName}");
        var title = component.get("{!v.title}");
        var isbn = component.get("{!v.isbn}");
        var additionalComments = component.get("{!v.additionalComments}");
        var prioritySelected = component.get("{!v.prioritySelected}");
        var contactReasonSelected = component.get("{!v.contactReasonSelected}");
        var articleIdSelected = component.get("{!v.selectedArticleId}");
        var agentNameSelected = component.get("{!v.agentName}");
        var agentEmailSelected = component.get("{!v.agentEmailAddress}");
        var agentEmailSelected = component.get("{!v.agentEmailAddress}");
        var customerType = component.get("{!v.customerType}");
        
        var name = component.get("{!v.name}");
        var queryType = component.get("{!v.queryType}");
        var emailAddress = component.get("{!v.emailAddress}");
        var additionalComments = component.get("{!v.additionalComments}");      
        var vendorId = component.get("{!v.vendorId}");      
        var topicSelected = component.get("{!v.selectedTopic}");
        
        var SourceCommunityValue=component.get("{!v.CommunityName}");
        
        action.setParams({
            "queryType" :queryType,
            "vendorId" :vendorId,
            "articleIdValue" : articleIdSelected,
            "customerTypeValue" : customerTypeValue,
            "emailAddressValue" : emailAddress,
            "institutionNameValue" : institutionName,
            "titleValue" : title,
            "nameValue" : name,
            "isbnValue" : isbn,
            "additionalCommentsValue" : additionalComments,
            "priorityValue" : prioritySelected,
            "topicValue" : topicSelected,
            "contactReasonValue" : contactReasonSelected,
            "agentNameValue" : agentNameSelected,
            "agentEmailValue" : agentEmailSelected,
            "SourceCommunity" : SourceCommunityValue
            
        });
        
        //Set the callback.
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedId = response.getReturnValue();
                //If case is not created as will happen in few picklist value combination, no file upload will happen.
                if(returnedId!=null)
                {                    
                    component.set("v.caseId", returnedId);                
                    //Run the file upload to the newly created case.
                    this.fileUploadHelper(component, event);
                }                
                
            }else if (state === "INCOMPLETE") {
                
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
                
            } else if (state === "ERROR") {
                
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            }
        });
        // enqueue the action
        $A.enqueueAction(action);         
        
    },
    
    validateFieldsHelper : function(component, event) {
        var fileSizeError = component.get("{!v.fileTooLarge}");
        var screenToView = component.get("{!v.displayScreen}");
        var institutionNameValue = component.get("{!v.InstitutionName}");
        
        var contactReasonValue = component.get("{!v.contactReasonSelected}");
        var agentNameValue = component.get("{!v.agentName}");
        
        var titleValue = component.get("{!v.title}");
        var agentEmailAddressValue = component.get("{!v.agentEmailAddress}");
        
        var validationError = false;
        var nameValue = component.get("{!v.name}");
        var emailAddressValue = component.get("{!v.emailAddress}");
        var commentsValue = component.get("{!v.additionalComments}");
        var queryType = component.get("{!v.queryType}");
        var vendorId = component.get("{!v.vendorId}");
        
        var isNameValid=((agentNameValue.length>79) ? true : false);
        var isVendorIdValid=false;//(vendorId.length<11  ? false : true);
        if((vendorId.length==10 && vendorId.startsWith('2')) || (vendorId.length==7 && (!vendorId.startsWith('SE') && !vendorId.startsWith('se')) && (vendorId.startsWith('S')|| vendorId.startsWith('s')) )||
           (vendorId.length==8 && (vendorId.startsWith('SE') || vendorId.startsWith('se'))) || vendorId.length<=6){
            if( vendorId.length<=6 && (vendorId.startsWith('S') || vendorId.startsWith('s') || vendorId.startsWith('2')))
            {
                isVendorIdValid=true;
            }
            else{  
                isVendorIdValid=false;
            }
        }else{
            isVendorIdValid=true;
        } 
        var isSubjectvalidationValid=((queryType.length>245) ? true : false);
        var isDescriptionValid=((commentsValue.length>32000) ? true : false);
        
        //var emailTest = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
        var recaptchaConfirmedValue = component.get("{!v.recaptchaConfirmed}");        
        console.log(recaptchaConfirmedValue);
        var filter = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/;
        var validEmailAddress = String(emailAddressValue).search (filter) != -1;
        var validAgentEmailAddress = String(agentEmailAddressValue).search (filter) != -1;
        
        if(screenToView == 1 && (commentsValue == '' || contactReasonValue == '' || recaptchaConfirmedValue == false || fileSizeError == true || institutionNameValue == '' || titleValue == '' || nameValue == '' || validEmailAddress == false) ){
            if( fileSizeError == true ){
                var errorValue = 'fileSizeError';
                this.errorMessageHelper(component, event, errorValue);                
                validationError = true;  
            }     
            if(validEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                 
            }         
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }         
            //If the error was caused by anything other than the above.
            if(fileSizeError != true && validEmailAddress == true && recaptchaConfirmedValue != false){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;
            }
        }
        
        if(screenToView == 2 && (nameValue == '' || commentsValue == '' || contactReasonValue == '' || recaptchaConfirmedValue == false || fileSizeError == true || institutionNameValue == '' || validEmailAddress == false)){         
            if( fileSizeError == true ){
                var errorValue = 'fileSizeError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                                
            }
            if(validEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
                
            }
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }         
            //If the error was caused by anything other than the above.
            if(fileSizeError != true && validEmailAddress == true && recaptchaConfirmedValue != false){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            }            
        }
        if(screenToView == 3 && (commentsValue == '' || contactReasonValue == '' || recaptchaConfirmedValue == false || fileSizeError == true || institutionNameValue == '' || agentNameValue == '' || titleValue == '' || validAgentEmailAddress == false)){
            if( fileSizeError == true ){
                var errorValue = 'fileSizeError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                                
            }
            if(validAgentEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
                
            } 
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }         
            //If the error was caused by anything other than the above.
            if(fileSizeError != true && recaptchaConfirmedValue != false && validAgentEmailAddress == true){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            } 
        }
        if(screenToView == 4 &&  (commentsValue == '' || contactReasonValue == '' || recaptchaConfirmedValue == false || fileSizeError == true || institutionNameValue == '' || agentNameValue == '' || validAgentEmailAddress == false)){
            if( fileSizeError == true ){
                var errorValue = 'fileSizeError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                                
            }
            if(validAgentEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
                
            } 
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }  
            //If the error was caused by anything other than the above.
            if(fileSizeError != true && recaptchaConfirmedValue != false && validAgentEmailAddress == true){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            } 
        }
        //added by sid
        if((screenToView == 5 ||  screenToView == 7) &&  (agentNameValue == ''||isNameValid==true || isVendorIdValid==true  ||  isDescriptionValid==true || commentsValue == '' || vendorId == '' || recaptchaConfirmedValue == false  || validEmailAddress == false)){
            if(validEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
            } 
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }  
            //If the error was caused by anything other than the above.
            if( validEmailAddress == true && recaptchaConfirmedValue != false && (commentsValue == '' || vendorId == '' ||agentNameValue == '')){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            }  
                
                if(isNameValid == true){
                    var errorValue = 'isNameValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
                if(isVendorIdValid == true){
                    var errorValue = 'isVendorIdValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
           
                
                if(isDescriptionValid == true){
                    var errorValue = 'isDescriptionValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
            }
        }
        
        if((screenToView == 6) &&  (agentNameValue == ''|| isNameValid==true || isVendorIdValid==true  || isDescriptionValid==true  ||  vendorId == '' || recaptchaConfirmedValue == false  || validEmailAddress == false)){
           console.log('!!!'+isNameValid);
            if(validEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
                
            } 
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }  
            //If the error was caused by anything other than the above.
            if( validEmailAddress == true && recaptchaConfirmedValue != false &&  (commentsValue == '' || vendorId == '' ||agentNameValue == '')){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            }  
                
                if(isNameValid == true){
                    var errorValue = 'isNameValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
                if(isVendorIdValid == true){
                    var errorValue = 'isVendorIdValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
            
                
                if(isDescriptionValid == true){
                    var errorValue = 'isDescriptionValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
            }
        }
        
        if(screenToView == 8 &&  (agentNameValue == ''||isNameValid==true || isVendorIdValid==true  || isSubjectvalidationValid==true || isDescriptionValid==true ||  queryType == '' || commentsValue == '' || vendorId == '' || recaptchaConfirmedValue == false  || validEmailAddress == false)){
            console.log('!!!'+isNameValid);
            if(validEmailAddress == false){
                var errorValue = 'emailError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true; 
                
            } 
            if(recaptchaConfirmedValue == false){
                var errorValue = 'reCaptchaError';
                this.errorMessageHelper(component, event, errorValue); 
                validationError = true;                   
            }  
            //If the error was caused by anything other than the above.
            if( validEmailAddress == true && recaptchaConfirmedValue != false &&   ( queryType==''|| commentsValue == '' || vendorId == '' ||agentNameValue == '')){              
                var errorValue = 'genericFieldError';
                this.errorMessageHelper(component, event, errorValue);
                validationError = true;
            }  
                
                if(isNameValid == true){
                    var errorValue = 'isNameValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
                if(isVendorIdValid == true){
                    var errorValue = 'isVendorIdValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
                if(isSubjectvalidationValid == true){
                    var errorValue = 'isSubjectvalidationValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
                }
                
                if(isDescriptionValid == true){
                    var errorValue = 'isDescriptionValid';
                    this.errorMessageHelper(component, event, errorValue); 
                    validationError = true;                   
            }
        }
        if(validationError == false){
            component.set("v.AllowCaseSubmit", true);      
        }
        
    },
    
    getScreenToViewHelper : function(component, event) {
        //Setup the call to the apex controller.
        var action = component.get("c.getScreen");
        var customerTypeSelected = component.get("{!v.customerTypePicked}");
        var topicSelected = component.get("{!v.selectedTopic}");
        var SourceCommunityValue=component.get("{!v.CommunityName}");
        action.setParams({
            "customerType" : customerTypeSelected,
            "topic" : topicSelected,
            "SourceCommunity" : SourceCommunityValue
        });
        
        //Set the callback.
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedData;
                returnedData = response.getReturnValue();             
                component.set("v.displayScreen", returnedData );
                
            }else if (state === "INCOMPLETE") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            } else if (state === "ERROR") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            }
        });
        // enqueue the action
        $A.enqueueAction(action);         
    },
    
    caseDeflectionHelper : function(component, event) {
        
        //Setup the call to the apex controller.
        var action = component.get("c.caseDeflectionMethod");
        var articleIdValue = component.get("{!v.selectedArticleId}");
        var previousArticleIdValue = component.get("{!v.previousArticleId}");
        
        action.setParams({
            "articleId" : articleIdValue,
            "previousArticleId" : previousArticleIdValue
        });
        
        //Set the callback.
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.selectedHelpArticleDetails", response.getReturnValue());
            }
        });
        // enqueue the action
        $A.enqueueAction(action);         
    },
    
    getPicklistValuesHelper : function(component, event) {
        //Setup the call to the apex controller.
        var action = component.get("c.getListDetails");
        var listTypeToGet = component.get("{!v.getListValue}");
        var valueToSearch = component.get("{!v.getListValueToSearch}");
        var customerTypeValue = component.get("{!v.customerTypePicked}");
        var parentValue = component.get("{!v.CommunityName}");
        action.setParams({
            "listType" : listTypeToGet,
            "valuePicked" : valueToSearch,
            "customerType" : customerTypeValue,
            "Parent" : parentValue
        });
        
        //Set the callback.
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var searchedForValue = component.get("{!v.getListValue}");
                var returnedData = [];
                returnedData = response.getReturnValue();
                if(searchedForValue == 'getTopic'){
                    component.set("v.topics", returnedData );
                }
                
                if(searchedForValue == 'getContactReason'){
                    component.set("v.contactReason", returnedData );   
                }
                
            }else if (state === "INCOMPLETE") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            } else if (state === "ERROR") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            }
        });
        // enqueue the action
        $A.enqueueAction(action);         
    },
    
    onTopicSelectHelper : function(component, event) {
        console.log(';;');
        //Setup the call to the apex controller.
        var action = component.get("c.getArticleTableData");
        var topicNameValue = component.get("{!v.selectedTopic}");
        var ProductPlatformValue = component.get("{!v.CommunityName}");
        
        action.setParams({
            "topicName" : component.get("{!v.selectedTopic}"),
            "ProductPlatform" : component.get("{!v.CommunityName}")
        });
        
        //Set the callback.
        action.setCallback(this, function(response) {
           component.set("v.showSpiner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpiner", false);
                var dataItems = [] ;
                var results = response.getReturnValue();
                
                results.forEach(function(item) {
             
                    console.log(item.articleName);
                    var data = {
                        dataName: item.articleName,
                        dataLink: item.link,
                        dataArticleId: item.articleId
                    }; 
                 
                      dataItems.push(data);  
                });

                component.set("v.data", dataItems);
            }else if (state === "INCOMPLETE") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            } else if (state === "ERROR") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
        
        
    },
    
    onReasonSelectHelper : function(component, event) {        
        //Setup the call to the apex controller.
        var action = component.get("c.getSettingItemEmailId");  
        action.setParams({
            "Topic" : component.get("{!v.selectedTopic}"),
            "ProductPLatform" : component.get("{!v.CommunityName}"),
            "Reason" : component.get("{!v.contactReasonSelected}"),
            "CustomerType" : component.get("{!v.customerTypePicked}")
        });
        //Set the callback.
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var results = response.getReturnValue();
                //if(JSON.stringify(results)!='')
                if(results != '' && results != null)    
                {
                    component.set("v.NoCase",true);                                     
                }
            }        	
            else if (state === "INCOMPLETE") {
                //Display an error message to the user.
                var errorValue = 'genericError';
                this.errorMessageHelper(component, event, errorValue);
            } 
                else if (state === "ERROR") {
                    //Display an error message to the user.
                    var errorValue = 'genericError';
                    this.errorMessageHelper(component, event, errorValue);
                }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    showFieldsHelper: function(component, event, helper) {
        
        var componentsToShowList = [];
        componentsToShowList = component.get("{!v.itemsToShow}")
        componentsToShowList.forEach(function(item) {
            
            var showComponent = component.find(item);
            $A.util.addClass(showComponent, "showCmp");
            $A.util.removeClass(showComponent, "hideCmp");
        });
        //Set the list back to blank.
        component.set("v.itemsToShow","");       
        
    },
    
    hideFieldsHelper: function(component, event, helper) {
        
        var componentsToHideList = [];
        componentsToHideList = component.get("{!v.itemsToHide}")
        componentsToHideList.forEach(function(item) {
            var hideComponent = component.find(item);
            $A.util.addClass(hideComponent, "hideCmp");
            $A.util.removeClass(hideComponent, "showCmp");
        });
        //Set the list back to blank.
        component.set("v.itemsToHide","");
    },
    
    //Update the fileName colour to show red when a file is uploaded over 2MB.
    changeFileNameFontColour: function(component, event) {
        var cmpTarget = component.find('fileName');
        $A.util.addClass(cmpTarget, 'fileNameError');
        $A.util.removeClass(cmpTarget, 'fileNameOk');
    },
    
    //Update the fileName colour to show black if the size is under 2MB again.
    changeFileNameFontColourOk: function(component, event) {
        var cmpTarget = component.find('fileName');     
        $A.util.addClass(cmpTarget, 'fileNameOk');
        $A.util.removeClass(cmpTarget, 'fileNameError');
    },
    
    //Set all fields to blank if the user selects another customer type/contact reason.
    resetFieldsHelper: function(component, event) {
        component.set("v.name","");  
        component.set("v.institutionName","");  
        component.set("v.agentEmailAddress","");  
        component.set("v.title","");  
        component.set("v.isbn","");  
        component.set("v.agentName",""); 
        component.set("v.additionalComments","");	
    },
    
    errorMessageHelper: function(component, event, errorValue) {
        if(errorValue == 'genericError'){
            var errorMessage = $A.get("e.force:showToast");
            errorMessage.setParams({
                title: "Error!",
                message: "There has been a problem with your request. Please try again later.",
                type: "error"
            });
            errorMessage.fire();
        }
        
        if(errorValue == 'fileSizeError'){
            //File size error   
            var fileSizeError = $A.get("e.force:showToast");
            fileSizeError.setParams({
                title: "Error!",
                message: "Attachment size is too large.",
                type: "error"
            });
            fileSizeError.fire();
        }
        if(errorValue == 'emailError'){
            var emailError = $A.get("e.force:showToast");
            emailError.setParams({
                title: "Error!",
                message: "Invalid Email address.",
                type: "error"
            });
            emailError.fire();
        }
        if(errorValue == 'genericFieldError'){
            //Generic field validation error.
            var fieldError = $A.get("e.force:showToast");
            fieldError .setParams({
                title: "Error!",
                message: "Please complete the required fields.",
                type: "error"
            });
            fieldError.fire();
        }
        if(errorValue == 'reCaptchaError'){
            //reCAPTHA validation error.
            var reCaptchaError = $A.get("e.force:showToast");
            reCaptchaError .setParams({
                title: "Error!",
                message: "Please confirm you're not a robot.",
                type: "error"
            });
            reCaptchaError.fire();
        }
        
        if(errorValue == 'isNameValid'){
            //reCAPTHA validation error.
            var isNameValid = $A.get("e.force:showToast");
            isNameValid .setParams({
                title: "Error!",
                message: "﻿Please reduce the length of the Name.",
                type: "error"
            });
            isNameValid.fire();
        }
        if(errorValue == 'isVendorIdValid'){
            //reCAPTHA validation error.
             var isVendorIdValid = $A.get("e.force:showToast");
            isVendorIdValid .setParams({
                title: "Error!",
                message: "The account number you have entered is not recognised, for help on how to find your number see the link below the Royalty ID/Account Number field.",
                type: "error",
                mode:"sticky" 
            });
            isVendorIdValid.fire();
        }
        if(errorValue == 'isSubjectvalidationValid'){
            //reCAPTHA validation error.
            var isSubjectvalidationValid = $A.get("e.force:showToast");
            isSubjectvalidationValid .setParams({
                title: "Error!",
                message: "Please reduce the length of the Subject Explanation.",
                type: "error"
            });
            isSubjectvalidationValid.fire();
        }
        if(errorValue == 'isDescriptionValid'){
            //reCAPTHA validation error.
            var isDescriptionValid = $A.get("e.force:showToast");
            isDescriptionValid .setParams({
                title: "Error!",
                message: "Please reduce the length of the Description.",
                type: "error"
            });
            isDescriptionValid.fire();
        }
    }
    
})