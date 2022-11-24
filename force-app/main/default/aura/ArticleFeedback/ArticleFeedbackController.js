({
    
    createArticleFeedbackFunction: function(component, event, helper) {
        //Get the article feedback from the UI.
        var feedbackString = component.get("{!v.feedback}");
        var name = component.get("{!v.name}");
        var email = component.get("{!v.email}");
        //Display an error message if the article feedback is blank.
       var url=window.location.href;     
        if(url.includes("book_authors")){
            if(email.length>0){
                var filter = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/;
                var validEmailAddress = String(email).search (filter) != -1;
                if(validEmailAddress == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error!",
                        message: "Invalid email address.",
                        type: "error"
                    });
                    toastEvent.fire(); 
                }
            }
        }
        if(feedbackString == ''){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Feedback can't be blank",
                type: "error"
            });
            toastEvent.fire(); 
            
        } else {
            //Set up the call to the apex controller.
            var action = component.get("c.createArticleFeedback");
            action.setParams({
                'articleId' : component.get("{!v.parentId}"),
                'name'		: name,
                'email'		: email,
                'feedback'  : feedbackString
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    //Display a thank you message if the response is a success.
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Thank You!",
                        message: "Your feedback is appreciated.",
                        type: "success"
                    });
                    toastEvent.fire(); 
                    component.set("v.showFeedbackSubmit", "false");                   
                }
                else if (state === "INCOMPLETE") {
                    var toastEvent = $A.get("e.force:showToast");
                    //Display an error message if the response is incomplete.
                    toastEvent.setParams({
                        title: "Sorry!",
                        message: "It has not been possible to process your request at this time, please try again later.",
                        type: "Error"
                    });
                    toastEvent.fire();
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                                //Display an error message if there is an error in the response.
                                toastEvent.setParams({
                                    title: "Sorry!",
                                    message: "It has not been possible to process your request at this time, please try again later.",
                                    type: "Error"
                                });
                                toastEvent.fire()                       
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);               
        }
    },
    
    onButtonClick: function(component, event, helper) {
        var firstButtonClick = component.get("{!v.buttonClicked}");
        component.set("v.showFeedbackSubmit", true);
        component.set("v.showVoting", false);
        //Get the id of the clicked button to identify if the user said yes or no.
        var answerValue = event.getSource().getLocalId();
        var votingOutcomeValue;
        if(answerValue == "yesButton"){
            votingOutcomeValue = 'Yes'; 
            //Hide the no button.
            component.set("v.disableNoButton", true);
            component.set("v.buttonClicked", true);
        }
        if(answerValue == "noButton"){
            votingOutcomeValue = 'No'; 
            //Hide the yes button.
            component.set("v.disableYesButton", true);
            component.set("v.buttonClicked", true);
        }
        
        if(firstButtonClick == false){
            component.set("v.voteOutcome", votingOutcomeValue);      
            helper.addVoting(component, event, helper);
        }
    }    
})