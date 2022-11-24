({
    
    //Set Default Values
    init : function(component, event, helper) {
        var url=window.location.href;     
        var vfOrigin;
        
        if(url.includes("tandfonline"))
        {           
            
            component.set("v.CommunityName", "TFO"); 
            //vfOrigin ="https://uat-tandf.cs128.force.com";
            vfOrigin = "https://help.tandfonline.com";
        }
        else if (url.includes("taylorfrancis"))
        {   
           vfOrigin = "https://help.taylorfrancis.com";   
           //vfOrigin = "https://uat-tandf.cs128.force.com";
            if(url.includes("book_authors"))
            {
             component.set("v.CommunityName", "book_authors");
            }else
            component.set("v.CommunityName", "UBX"); 
            
        }
        helper.setDefaultValues(component, event);  
        
        //Call the helper method to check if the code is running in a sandbox.
        helper.sandboxCheck(component, event);     
        
        
        
        //Handle the response from the reCAPTCHA.
        //let vfOrigin = "https://help.taylorfrancis.com";
        window.addEventListener("message", function(event) {
            console.log(event.data);
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            } 
            if (event.data==="Unlock"){            	
                let myButton = component.find("submit button");
                //myButton.set('v.disabled', false);    
                component.set("v.recaptchaConfirmed", true);
                
            }  else{
               component.set("v.recaptchaConfirmed", false);
            }          
        }, false);                
    },    
    goBack: function (component, event, helper){
        
        window.scrollTo(0, 150);
        //component.set("v.isViewingArticle", true);
        //Hide the help article.
        component.set("v.showHelpArticle", false); 
        //Hide the back button.
        component.set("v.showBackButton", false);
        
        //Make sure the "Continue with request" button doesn't try to submit the case on click.
        component.set("v.toggleCaseSubmit", false);
        
        //Add the components which are to be hidden into the list.
        var componentsToHide = component.get("{!v.itemsToHide}");
        
        //All components should be hidden if the user clicks the back button.
        componentsToHide.push("showAddressMsg","showBankMsg","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField","showFirstButton","showContactReason","showName","showEmailAddress"
                              ,"showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                              ,"showISBN","showAdditionalComments","helpMessage", "showFileUpload","showSecondButton");
        
        //Run the helper to hide the components above.
        helper.hideFieldsHelper(component, event);
        
        //Add the components which are to be shown into the list.
        var componentsToShow = component.get("{!v.itemsToShow}");
        //Show the suggested articles list and the continue with request button.
        componentsToShow.push("showArticles","ArticlesSection");
        
        //Run the helper to show the components above.
        helper.showFieldsHelper(component, event);
    },    
    
    removeFile : function(component, event, helper) {
        var currentFileName = component.get("{!v.fileName}");
        if(currentFileName != 'No File Selected..'){
            //Make the link disappear.
            component.set("v.removeButtonLabel", "");
            component.set("v.fileName", "");
            component.set("v.fileTooLarge", false);
        }
        
    },
    onReasonSelect:function(component, event, helper) {
       
        helper.onReasonSelectHelper(component, event);        
        var NoCase=component.get("{!v.NoCase}");
        
        if(NoCase==true)
        {     
            
            var FileUploader = component.find("showFileUpload");
            $A.util.addClass(FileUploader, "hideCmp");
            $A.util.removeClass(FileUploader, "showCmp");
            
        }
        
    },
    onTopicSelect : function(component, event, helper) {
        
        //Hide the back button.
        component.set("v.showBackButton", false);
        
        //Set the picklist values to blank because the user might have already filled these out.
        helper.resetFieldsHelper(component, event); 
        
        //Show the top section of the page.
        component.set("v.showFullPage", true);
        
        //If this is the first time the topic has been selected
        var showState = component.get("{!v.firstSelect}");
        if(showState == true) {
            
            //Add the components which are to be shown into the list.
            var componentsToShow = component.get("{!v.itemsToShow}");
            componentsToShow.push("showArticles","ArticlesSection");
            
            //Run the helper to show the components above.
            helper.showFieldsHelper(component, event);
            
            //Add the components which are to be hidden into the list.
            var componentsToHide = component.get("{!v.itemsToHide}");
            componentsToHide.push("showAddressMsg","showBankMsg","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField","showFirstButton","showContactReason","showName","showEmailAddress"
                                  ,"showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                                  ,"showISBN","showAdditionalComments","helpMessage");
            
            //Run the helper to hide the components above.
            helper.hideFieldsHelper(component, event);
            
            //So we know the first topic select has been completed.
            component.set("v.firstSelect", false);
            
            
        } else {
            
            //As a new topic has been selected don't allow the case to be submitted again.
            component.set("v.toggleCaseSubmit", false);
            component.set("v.AllowCaseSubmit", false);
            
            //Add the components which are to be hidden into the list.
            var componentsToHide = component.get("{!v.itemsToHide}");
            componentsToHide.push("showAddressMsg","showBankMsg","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField","showContactReason","showName","showEmailAddress"
                                  ,"showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                                  ,"showISBN","showAdditionalComments","showFileUpload","showSecondButton","showFirstButton","helpMessage");
            helper.hideFieldsHelper(component, event);
            
            //Add the components which are to be shown into the list.
            var componentsToShow = component.get("{!v.itemsToShow}");
            componentsToShow.push("ArticlesSection");
            
            //Run the helper to show the components above.
            helper.showFieldsHelper(component, event);
            
        }
        //Get the selected topic.
        var selectedTopicValue = component.get("{!v.selectedTopic}");        
        component.set("v.getListValueToSearch", selectedTopicValue);
        if(selectedTopicValue != ''){
            let button = component.find('disablebuttonid');
            button.set('v.disabled',false);
            //Helper to call out to Apex class to get related articles.
            if(component.get("{!v.CommunityName}")==="book_authors"){
                component.set("v.showSpiner", true);
            }
            helper.onTopicSelectHelper(component, event);
            //Helper to call out to the Apex class to get the correct screen to display.
            helper.getScreenToViewHelper(component, event);
            //Set the attribute to locate the contact reasons from the Apex class callout.
            component.set("v.getListValue", "getContactReason");
            //Helper to call out to the Apex class to get the related contact reasons.
            helper.getPicklistValuesHelper(component, event);
        }else{
            if(component.get("{!v.CommunityName}")==="book_authors"){
                component.set("v.showSpiner", true);
                component.set("v.data", null);
                component.set("v.showSpiner", false);
                let button = component.find('disablebuttonid');
                button.set('v.disabled',true);
            }
            
        }
      
    },   
    
    onCustomerTypeSelect : function(component, event, helper) {
        
        //Hide the back button.
        component.set("v.showBackButton", false);        
        
        //Show the top section of the page.
        component.set("v.showFullPage", true);
        
        //Set the picklist values to blank because the user might have already filled these out.
        helper.resetFieldsHelper(component, event); 
        
        //Set the values ready for the helper to find the topic picklist values.
        component.set("v.getListValue", "getTopic");
        var selectedCustomerValue = component.get("{!v.customerTypePicked}");
        component.set("v.getListValueToSearch", selectedCustomerValue);
        //Remove the current topic selected.
        component.set("v.selectedTopic", "");
        if(selectedCustomerValue != ''){
            helper.getPicklistValuesHelper(component, event);
        } else {
            component.set("v.topics", "");  
        }
        
        //Add the components which are to be hidden into the list.
        var componentsToHide = component.get("{!v.itemsToHide}");
        componentsToHide.push("showAddressMsg","showBankMsg","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField","showContactReason","showName","showEmailAddress"
                              ,"showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                              ,"showISBN","showAdditionalComments","showFileUpload"
                              ,"showSecondButton","showArticles","showArticles","ArticlesSection","helpMessage");
        
        //Run the helper to hide the components above.
        helper.hideFieldsHelper(component, event);
        
        //Add the components which are to be shown into the list.
        var componentsToShow = component.get("{!v.itemsToShow}");
        componentsToShow.push("showFirstButton");
        
        //Run the helper to show the components above.
        helper.showFieldsHelper(component, event);
        
        //As a new customer type has been selected remove the ability to submit the case.
        component.set("v.toggleCaseSubmit", false);
        
    },  
    
    onButtonClick : function(component, event, helper) {
        // Added conditional label text based ob product type-By Ashish Purwar on 28/05/2019
        var CommunityName=component.get("v.CommunityName");
        var customerTypePicked=component.get("v.customerTypePicked");
        var cmpISBN = component.find("lblISBN");
        var cmpTitle = component.find("lblTitle");
     
        if(CommunityName=="UBX")
        {            
            cmpISBN.set('v.label',"ISBN");
            cmpTitle.set('v.label',"Book Title");
        }
        else
        {
            
            if(customerTypePicked=="Agent")
            {
                cmpISBN.set('v.label',"Order Number");
            }
            else
            {
                cmpISBN.set('v.label',"ISSN");
            }
            
            cmpTitle.set('v.label',"Journal Title");
        }
        //Hide the suggested help articles.
        component.set("v.showHelpArticle", false);
        //Show the top section of the page.
        component.set("v.showFullPage", true);
        
        var toggleCaseSubmitValue = component.get("{!v.toggleCaseSubmit}");
        
        //If the user isn't trying to submit the case move them back to the top of the screen.
        if(toggleCaseSubmitValue == false){
            window.scrollTo(0, 150);
        }       
        
        //Show the back button.
        component.set("v.showBackButton", true);
        //As the user has continued they are no longer viewing an article.
        component.set("v.isViewingArticle", false);
        
        //If the customer type selected is 'other' display a message to the customer.
        var customerTypeSelected = component.get("{!v.customerTypePicked}");
        if(customerTypeSelected == "Other"){
            //Add the components which are to be shown into the list.
            var componentsToShow = component.get("{!v.itemsToShow}");
            componentsToShow.push("helpMessage");
            
            //Run the helper to show the components above.
            helper.showFieldsHelper(component, event);
            
        }
        //If the permission has not been granted to allow the button to submit the case.
        if(toggleCaseSubmitValue == false){
            //Add the components which are to be shown into the list.
            var componentsToShow = component.get("{!v.itemsToShow}");
            componentsToShow.push("showSecondButton","showFileUpload");
            
            //Run the helper to show the components above.
            helper.showFieldsHelper(component, event);
            
            //Add the components which are to be hidden into the list.
            var componentsToHide = component.get("{!v.itemsToHide}");
            componentsToHide.push("ArticlesSection");
            
            //Run the helper to hide the components above.
            helper.hideFieldsHelper(component, event);
            
            //Run helper method to call the Apex class to get the screen to show.
            helper.getScreenToViewHelper(component, event);
            
            //Allow the button to submit case.
            component.set("v.toggleCaseSubmit", true);
            
            //Display the correct screen returned from the Apex class.
            var screenToView = component.get("{!v.displayScreen}");
            if(screenToView == 1){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showContactReason","showName","showEmailAddress"
                                      ,"showInstitutionName","showTitle"
                                      ,"showISBN","showAdditionalComments");  
            }
            if(screenToView == 2){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showContactReason","showName","showEmailAddress"
                                      ,"showInstitutionName","showAdditionalComments");               
            }
            if(screenToView == 3){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showContactReason",
                                      "showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                                      ,"showISBN","showAdditionalComments");                 
            }
            if(screenToView == 4){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showContactReason",
                                      "showInstitutionName","showAgentName","showAdditionalComments","showAgentEmailAddress");             
                
            }
            if(screenToView == 5){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showDescriptionField","showEmailField","showRoyalityIdField","ShowNameField");             
                
            }
            if(screenToView == 6){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showBankMsg","showEmailField","showRoyalityIdField","ShowNameField");             
                
            }
            if(screenToView == 7){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showAddressMsg","showDescriptionField","showEmailField","showRoyalityIdField","ShowNameField");             
                
            }
            if(screenToView == 8){
                var componentsToShow = component.get("{!v.itemsToShow}");
                componentsToShow.push("showSubjectExpField","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField");             
                
            }
            
            //Run the helper to show the components above.
            helper.showFieldsHelper(component, event);
        } else {
            //If the button is clicked and the permission has been given to allow the case submit.
            //Validate the fields using the helper below. 
            helper.validateFieldsHelper(component, event);
            
            var allowCaseSubmitCheck = component.get("{!v.AllowCaseSubmit}");
            
            if(allowCaseSubmitCheck == true){
                
                //Add the components which are to be hidden into the list.
                var componentsToHide = component.get("{!v.itemsToHide}");
                componentsToHide.push("showAddressMsg","showBankMsg","showDescriptionField","showSubjectExpField","showEmailField","showRoyalityIdField","ShowNameField","helpMessage", "showSecondButton","showSpinner","showContactReason","showName","showEmailAddress"
                                      ,"showInstitutionName","showAgentName","showAgentEmailAddress","showTitle"
                                      ,"showISBN","showAdditionalComments","showTopLevelFields","showFileUpload");
                
                //Run the helper to hide the components above.
                helper.hideFieldsHelper(component, event);               
                
                //Run the helper to call the Apex class and create a case.
                helper.submitCaseHelper(component, event);
                
                //Show the thank you message on the screen and hide the back button.
                component.set("v.showBackButton", false);
                component.set("v.showFullPage", false);
                component.set("v.showThankYou", true);
                window.scrollTo(0, 0);
                
                
            }
        }      
    }, 
    
    handleFilesChange: function(component, event, helper) {
        
        var fileName = 'No File Selected..';
        var MAX_FILE_SIZE = 2000000; //Max file size is 2MB
        //Set the maximum file size attribute to be used later in the helper.
        component.set("v.maxFileSize", MAX_FILE_SIZE);
        
        //Show the 'remove' button link next to the file.
        component.set("v.removeButtonLabel", "Remove");
        //If file size is under the limit.
        if (event.getSource().get("v.files").length > 0) {
            component.set("v.showRemoveBut", true);
            //If file length is ok.
            component.set("v.fileTooLarge", false);
            fileName = event.getSource().get("v.files")[0]['name'];
            helper.changeFileNameFontColourOk(component, event);
        }
        
        //If the max file size is over the limit flag to the user.
        if(event.getSource().get("v.files")[0].size > MAX_FILE_SIZE){
            component.set("v.fileTooLarge", true);
            helper.changeFileNameFontColour(component, event);
            fileName = 'Please ensure file size is less than 2MB';
        }
        component.set("v.fileName", fileName);
    },
    
    caseDeflection : function(component, event, helper) {
        
        //Set the previous article id so any deflections are removed if another article is selected.
        var previousArticleIdValue = component.get("{!v.selectedArticleId}");
        
        component.set("v.previousArticleId", previousArticleIdValue);
        window.scrollTo(0, 150);
        component.set("v.isViewingArticle", true);
        var articleIdValue = event.getSource().get("v.name")
        component.set("v.showHelpArticle", true);
        component.set("v.showFullPage", false);
        component.set("v.selectedArticleId", articleIdValue);
        helper.caseDeflectionHelper(component, event);
    }
})