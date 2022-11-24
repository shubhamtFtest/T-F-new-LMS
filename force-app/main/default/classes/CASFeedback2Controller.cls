/**************************************************
* Created by Shay Spoonmore
* Shay.Spoonmore@informausa.com 
* Controller for the CAS Sites ICFeedback2 page.
* Last Modified 
**************************************************/

public class CASFeedback2Controller {
    
 Boolean isAdoptionShort = true;
 



 public CAS_Inspection_Copy__c ic {get; set;}
    
    
    /**
    public Boolean renderRequiredTextbook {
        get {
            if (renderRequiredTextbook == null)
            return false;
            else 
            return true;            
        }
        set;
    }**/
    
    public Boolean showReasonLost {
        get {
            if (ic.Adoption_Short__c == 'No')
                return true;
            else
                return false;
        }
        set;
    }
    
    public Boolean showAdoptionLevel {
        get {
            if (ic.Adoption_Short__c == 'Yes')
                return true;
            else
                return false;
        }
        set;
    }
    
    public Boolean showButton {
        get {
            if (ic.Adoption_Short__c != null)
                return true;
            else
                return false;
        }
        set;
    }
    
    public CASFeedback2Controller() {
        
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            
            List<CAS_Inspection_Copy__c> records = [Select c.Year_of_Study__c, c.Title_3__c, c.Title_2__c, 
                c.Title_1__c, c.SystemModstamp, c.Required_Text__c, c.Publisher_3__c, c.Publisher_2__c, 
                c.Publisher_1__c, c.OwnerId, c.Opportunity__c, c.Opportunity_Product__c, c.Number_of_Students__c, 
                c.Level_of_Recommendation_3__c, c.Level_of_Recommendation_2__c, c.Level_of_Recommendation_1__c, 
                c.Id, c.ISBN__c,  c.Course_Start_Date__c, c.Contact_Name__c, c.Contact_Email__c, 
                c.Bookstore_Phone__c, c.Bookstore_Name__c, c.Bookstore_Manager__c, c.Book_Weaknesses__c, 
                c.Book_Title__c, c.Book_Strengths__c, c.Book_Order__c, c.Author_3__c, c.Author_2__c, 
                c.Author_1__c,  c.Adoption_Stage__c
                ,c.Adoption_Level__c
                , c.Adoption_Short__c, c.Contact_Rep__c, c.Additional_Comments__c
                , c.IsAdoptionShort__c, c.Reason_Lost__c
                From CAS_Inspection_Copy__c c Where Id = :ApexPages.currentPage().getParameters().get('id')];
                
                
                 
            if (records.size() > 0)
                ic = records.get(0); 

        }
        
    }  
    
    // determine whether or not to display the required text
    /**public PageReference renderRequiredText() {

        if (ic.Adoption_Short__c == null || ic.Adoption_Short__c == 'No' || ic.Adoption_Short__c == 'Yes') { 
            renderRequiredTextbook = true;
        
        } else 
        {
            renderRequiredTextbook = false;
            
        }
        return null;
    }**/    
    
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
    public String getMappedAdoptionShort(String val) {
 
        if (val == 'Yes') { 
            return 'Completed - Adopted'; 

        } else if (val == 'No') {       
            return 'Completed - Not appropriate';       


        } else if (val == 'Under Review') { 
            return 'Open - Under Consideration';

        } else {
            return 'Completed - No Response'; 
        }
    }   
    public String getMappedStage(String val) {
 
        if (val == 'Completed - Adopted') { 
            return 'Closed Won'; 

        } else if (val == 'Completed - Not appropriate') {          
            return 'Closed Lost';       
        } else if (val == 'Open - Under Consideration') {       
            return 'Inspection Copy Sent - Pending Adoption';       
        } else {
            return 'Investigating'; 
        }
    }   
    
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
    
    public String getMappedReasonLost(String val) {
        if (val == 'Chose a book from another publisher' ) {
            return 'Lost to external competitor';
        } else if (val == 'Chose another Taylor and Francis book') {
            return 'Lost to internal competition';
        } else {
            return val;
        }
    }  
    
    public PageReference save() { 
        
        PageReference redirPage;
        
        OpportunityLineItem[] olis = [Select Adoption_Stage__c //, Adoption_Level__c, Book_Strengths__c, Book_Weaknesses__c 
            From OpportunityLineItem Where Id = :ic.Opportunity_Product__c];
            
        Opportunity[] oppty = [Select StageName //, Adoption_Level__c, Book_Strengths__c, Book_Weaknesses__c 
            From Opportunity Where Id = :ic.Opportunity__c];    
            
         system.debug('CAS Sites' + ic.Opportunity_Product__c);
        if (olis.size() == 1) {
            OpportunityLineItem oli = olis[0];
            Opportunity opp = oppty[0];
        
            // update the opportunity line item values
            //oli.Adoption_Level__c = getMappedAdoptionLevel(ic.Adoption_Level__c);
            String adoptionStage = getMappedAdoptionShort(ic.Adoption_Short__c);
            oli.Adoption_Stage__c = adoptionStage;
            opp.StageName = getMappedStage(adoptionStage);
            oli.Adoption_Level__c = getMappedAdoptionLevel(ic.Adoption_Level__c);
            
            //nullify reason if Adoption short has changed
            opp.Reason_Lost__c = null;
            if (ic.Adoption_Short__c == 'No')  
            {opp.Reason_Lost__c = getMappedReasonLost(ic.Reason_Lost__c);
            }
            else
            {ic.Reason_Lost__c = null;}
            //nullify adoption level if Adoption short != yes
            if (ic.Adoption_Short__c != 'Yes' )  
            {
                ic.Adoption_Level__c = null;
                oli.Adoption_Level__c = null;
            }
            
            
            
            try {
                ic.IsAdoptionShort__c = isAdoptionShort; 
                
                upsert ic;
                upsert oli;
                upsert opp;           
                
            } catch(System.DMLException e) {
                ApexPages.addMessages(e);
                return null;
            }
        }
        
       if (ic.Adoption_Short__c != Null ) { 
            redirPage = Page.ICFeedback_Recommend; 
        
        } 
        //else {
        //  redirPage = Page.ICFeedback_Recommend; 
       // }

        //redirPage.setRedirect(true);    
        return redirPage; 


    }         


}