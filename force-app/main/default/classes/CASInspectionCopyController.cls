/**************************************************
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
* Controller for the CAS Sites ICFeedback page.
* Last Modified by Jeff Lup - 2009.11.2 (Cases 10622 & 11377)
* Last Modified by Shay S - 2011.10.10 (CHG0037916)
* Last Modified by Shay.Spoonmore@informausa.com - 2012.11.28 (CHG0045867)
* http://informa.uat.cs10.force.com/taylorandfrancis/ICFeedback?id=a1F60000000A7K0EAK
**************************************************/

public class CASInspectionCopyController {

    public CAS_Inspection_Copy__c ic {get; set;}
    
    public Boolean renderRequiredTextbook {
        get {
            if (renderRequiredTextbook == null)
                renderRequiredTextbook = false;  
            return renderRequiredTextbook;
                    
        }
        set;
    }
       
      public Boolean showDecisionDate {
        get {
            if (ic.Adoption_Stage__c == 'This book is under committee review' || ic.Adoption_Stage__c == 'I\'m still reviewing this book')
            {   return true;}
            else
            {//ic.Decision_Date__c = null; 
                return false;
            }   
        } 
        set;
    }
    
    
    public Boolean NeedHelp{
        get {
            if (ic.Contact_Rep__c == 'Yes' )
            {   return true;}
            else
            {    
                return false;
            }   
        } 
        set{
        
            if ( value )
            {
                ic.Contact_Rep__c = 'Yes';
            }
            else
            {
                ic.Contact_Rep__c = null;
            }
           
        
        }
    }
    
    public CASInspectionCopyController() {
        
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            
            List<CAS_Inspection_Copy__c> records = [Select c.Year_of_Study__c, c.Title_3__c, c.Title_2__c, 
                c.Title_1__c, c.SystemModstamp, c.Required_Text__c, c.Publisher_3__c, c.Publisher_2__c, 
                c.Publisher_1__c, c.OwnerId, c.Opportunity__c, c.Opportunity_Product__c, c.Number_of_Students__c, 
                c.Level_of_Recommendation_3__c, c.Level_of_Recommendation_2__c, c.Level_of_Recommendation_1__c, 
                c.Id, c.ISBN__c,  c.Course_Start_Date__c, c.Contact_Name__c, c.Contact_Email__c, 
                c.Bookstore_Phone__c, c.Bookstore_Name__c, c.Bookstore_Manager__c, c.Book_Weaknesses__c, 
                c.Book_Title__c, c.Book_Strengths__c, c.Book_Order__c, c.Author_3__c, c.Author_2__c,
                c.Author_1__c, c.Adoption_Stage__c, c.Adoption_Level__c, c.Recommend_title__c, c.Decision_Date__c, c.Potential_Leads__c, c.Contact_Rep__c,c.QuestionAboutT_FProduct__c
                From CAS_Inspection_Copy__c c Where Id = :ApexPages.currentPage().getParameters().get('id')];
                
                
                
            if (records.size() > 0)
            {
                ic = records.get(0);
                
                
                
            }
                
                 

        }
        
    }  
    
    // determine whether or not to display the required text
    public PageReference renderRequiredText() {
    
       // string AdoptionStage = 'I\'m still reviewing this book';
        //if (ic.Adoption_Stage__c == 'I will not recommend this book but will purchase it for personal use') {
        //if (ic.Adoption_Stage__c == 'I would not like to adopt this book for my course') { //case#9944 - Jeff Lup - 2009.08.31
        if (ic.Adoption_Stage__c == 'I will not adopt this book for my course' || ic.Adoption_Stage__c == 'I would like to return this book' || ic.Adoption_Stage__c == 'I\'m still reviewing this book' || ic.Adoption_Stage__c == 'I never received this book' || ic.Adoption_Stage__c == 'I have not adopted the book on my course BUT I have recommended a copy for our library' ) { //cases 10622 & 11377 - Jeff Lup - 2009.11.2
            renderRequiredTextbook = true;
        } else {
            renderRequiredTextbook = false;
        }
          return null;
    }   
 
    // this page is called when the page loads and checks for a valid id.
    // if the inspection copy is null, then redirect them to the home page
    // else show them the form.
    public PageReference isValidId(){
        if (ic == null) {
            PageReference newRef = Page.ICHome;
            newRef.setRedirect(true);
            return newRef;
        } 
        else 
        {
            //if Sales Rep has verified the feedback, redirect to recommend page
            OpportunityLineItem oli = [Select Id, Rep_Verified__c FROM OpportunityLineItem WHERE ID =: ic.Opportunity_Product__c];
            if (oli != null && oli.Rep_Verified__c == true)
            {
                PageReference newRef = Page.ICFeedback_VerifiedFeedback;
                newRef.getParameters().put('id',ic.Id);
                newRef.setRedirect(true);
                return newRef;  
            }
            else
            {
                return null;
            }
        }
    }        
    
    // returns the correct picklist value for the selected adoption stage - public for testing
    public String getMappedAdoptionStage(String val) {
        //if (val == 'I would like to recommend this book on my course') {
        //if (val == 'I would like to adopt this book for my course') { //case#9944 - Jeff Lup - 2009.08.31
        if (val == 'I will be adopting this book for my course') { //cases 10622 & 11377 - Jeff Lup - 2009.11.2
            //return 'Completed – Adopted'; //this was a large dash
            return 'Completed - Adopted'; //case#9574 - Jeff Lup - 2009.08.26
        } else if (val == 'I never received this book') { //CHG0037916 - Shay - 20110927    
            return 'Never Received Product';    
        } else if (val == 'I\'m still reviewing this book') { //CHG0037916 - Shay - 20110927
            return 'Open - Under Consideration';        
        } else if (val == 'I will not adopt this book for my course') { //cases 10622 & 11377 - Jeff Lup - 2009.11.2
            //return 'Completed – Purchased'; //this was a large dash
            //return 'Completed - Purchased'; //case#9574 - Jeff Lup - 2009.08.26       
            return 'Completed - Not appropriate'; //cases 10622 & 11377 - Jeff Lup - 2009.11.2          


        //} else if (val == 'I would like to recommend this book but it is currently under committee review') {
        //else if (val == 'I would like to adopt this book but it is currently under committee review') { //case#9944 - Jeff Lup - 2009.08.31
        } else if (val == 'This book is under committee review') { //chg0037916 - Shay - 2011.10.10
            return 'Committee Review';


        } else if (val == 'I would like to recommend this book as a library purchase') {
            //return 'Completed – Library Purchase'; //this was a large dash    
            return 'Completed - Library Purchase'; //case#9574 - Jeff Lup - 2009.08.26


        } else if (val == 'I would like to return this book') {
                
            return 'Completed - Returned'; 

        }
          else if(val == 'I have adopted the book on my course AND recommended a copy for our library') {

          
           return 'Completed - Library Purchase and Adopted';

           
          } 
           else if(val == 'I have not adopted the book on my course BUT I have recommended a copy for our library') {

          
           return 'Completed - Library Purchase not Adopted';
           
          } 
        
        else {
            //return 'Completed – Not appropriate'; //this was a large dash
            //return 'Completed - Not appropriate'; //case#9574 - Jeff Lup - 2009.08.26
            //return 'Completed - Returned'; //cases 10622 & 11377 - Jeff Lup - 2009.11.02
            return 'Completed - No Response'; //case 32301 - Jeff Lup - 2010.12.02
        }
    }   
    
    // returns the correct picklist value for the selected adoption level - public
    public String getMappedAdoptionLevel(String val) {
        if (val == 'Required Textbook') {
            return 'Core Text';
        } else if (val == 'Highly Recommended') {
            return 'Highly Recommended';
        } else if (val == 'Additional Reading'){
            return 'Supplementary Reading';
        }else
        {
        return null;
        }
    }  
    
      public String getMappedAdoptionType(String val) {
        if (val == 'No - New to Course') {
            return 'New';
        } else if (val == 'Yes - Same Edition') {
            return 'Re-Adopted';
        } else if (val == 'Yes - Previous Edition'){
            return 'Rollover';
        }
          else if (val == 'This is replacing a text from a previous publisher'){
            return 'Take Away';
        }
          else if (val == 'I am an Author or Contributor'){
            return 'Author/Reviewer/Contributor';
        }    
        else
        {
        return null;
        }
    }  
    
    public PageReference save() { 
        
        PageReference redirPage;
        
        // get the opportunity line item
        //OpportunityLineItem oli = [Select Adoption_Stage__c, Adoption_Level__c, Book_Strengths__c, Book_Weaknesses__c 
        //  From OpportunityLineItem Where Id = :ic.Opportunity_Product__c];
        
        //Sometimes an OLI is deleted after a request for feedback. - Case 11530
        OpportunityLineItem[] olis = [Select Adoption_Stage__c, Adoption_Level__c, Adoption_Type__c , Book_Strengths__c, Book_Weaknesses__c, OpportunityId, Opportunity.OwnerId, Recipient__c 
            From OpportunityLineItem Where Id = :ic.Opportunity_Product__c];
        
        if (olis.size() == 1) {
            OpportunityLineItem oli = olis[0];
        
            // update the opportunity line item values
            oli.Adoption_Level__c = getMappedAdoptionLevel(ic.Adoption_Level__c);
            oli.Adoption_Stage__c = getMappedAdoptionStage(ic.Adoption_Stage__c);
            oli.Adoption_Type__c = getMappedAdoptionType(ic.Recommend_title__c);
            oli.Potential_Leads__c = ic.Potential_Leads__c;
            //oli.Decision_Date__c = ic.Decision_Date__c;
            
            if (ic.Book_Strengths__c != null) {
                if (oli.Book_Strengths__c != null) {
                    oli.Book_Strengths__c = oli.Book_Strengths__c + '; ' + ic.Book_Strengths__c + ' (feedback form)';
                } else {
                     oli.Book_Strengths__c = ic.Book_Strengths__c + ' (feedback form)';
                }
            }
    
            if (ic.Book_Weaknesses__c != null) {
                if (oli.Book_Weaknesses__c != null) {
                    oli.Book_Weaknesses__c = oli.Book_Weaknesses__c + '; ' +ic.Book_Weaknesses__c + ' (feedback form)';         
                } else {
                    oli.Book_Weaknesses__c = ic.Book_Weaknesses__c + ' (feedback form)';        
                }
            }
            
            
            
            if (!showDecisionDate)//null field if adoption stage items aren't correct
            {
                ic.Decision_Date__c = null;
            }
            else//Create a Task
            {   //01260000000DTdqAAG T&F - Tasks
                //Test - 005600000013UsfAAE elizabeth.renner@taylorandfrancis.com
                //Test - 00530000000taxnAAA shay.spoonmore@informausa.com
                System.debug('******oli.Opportunity.OwnerId:' + oli.Opportunity.OwnerId);
                Task createTask = new Task();
                createTask.OwnerId = oli.Opportunity.OwnerId;//'00530000000taxnAAA'; //olis.Opportunity.OwnerId
                //createTask.RecordTypeId = '01260000000DTdqAAG';
                createTask.RecordTypeId = MiscFunctions.getRecordtypeId('Task', 'T&F - Tasks'); //CHG0038379
                createTask.WhatId = oli.OpportunityId;
                createTask.WhoId = oli.Recipient__c;
                createTask.Status = 'Not Started';
                createTask.Priority = 'Normal';
                createTask.Type = 'Email';
                createTask.Subject = 'Follow up on Pending Adoption';
                createTask.Description = null;
                createTask.IsReminderSet = true;
                
                if (ic.Number_of_Students__c >= 50)
                {
                    createTask.Priority = 'High';
                    createTask.Type = 'Call';
                }
                
                Datetime reminderDate;
                
                if (ic.Decision_Date__c >= date.today().addDays(7))
                {
                createTask.ActivityDate = ic.Decision_Date__c.addDays(-7);
                //reminderDate = datetime.valueOf(createTask.ActivityDate + ' 16:00:00');
                }
                else //if(ic.Decision_Date__c <= date.today())
                {
                createTask.ActivityDate = date.today();
                //reminderDate = datetime.valueOf(date.today() + ' 16:00:00');
                }
                //else
                //{
                // integer numberDaysDue = ic.Decision_Date__c.daysBetween(date.today());
                // createTask.ActivityDate = ic.Decision_Date__c.addDays(numberDaysDue);
                // reminderDate = datetime.valueOf(createTask.ActivityDate + ' 16:00:00');
                //}
                reminderDate = datetime.newInstance(createTask.ActivityDate.year(), createTask.ActivityDate.month(),createTask.ActivityDate.day(), 8,0,0 );
                createTask.ReminderDateTime = reminderDate;
                
                ///Database.DMLOptions dlo = new Database.DMLOptions();
                //dlo.EmailHeader.triggerUserEmail = true;
                //dlo.EmailHeader.triggerAutoResponseEmail = true;
                database.insert(createTask);//, dlo);
                
                //insert createTask
            }
            Opportunity updateOpportunity = new Opportunity(Id = oli.OpportunityId,Decision_Date__c =ic.Decision_Date__c);//, Potential_Leads__c = ic.Potential_Leads__c
            
             
            
            
            try {
                update updateOpportunity;
                upsert ic;
                upsert oli;           
                
            } catch(System.DMLException e) {
                ApexPages.addMessages(e);
                return null;
            }
        }
        
        if (ic.Adoption_Stage__c == 'I would like to return this book') {
            redirPage = Page.ICFeedback_Return; 
            
        //} else if (ic.Adoption_Stage__c == 'I will not recommend this book but will purchase it for personal use') { 
        //} else if (ic.Adoption_Stage__c == 'I would not like to adopt this book for my course') { //case#9944 - Jeff Lup - 2009.08.31 
        } else if (ic.Adoption_Stage__c == 'I will not adopt this book for my course') { //cases 10622 & 11377 - Jeff Lup - 2009.11.2 
            //redirPage = Page.ICFeedback_Purchase; 
            redirPage = Page.ICFeedback_Recommend; //cases 10622 & 11377 - Jeff Lup - 2009.11.2
        
        } else {
            redirPage = Page.ICFeedback_Recommend; 
        }

        redirPage.setRedirect(true);    
        return redirPage; 


    }         

}