public class CASTextBookFeedbackLink {


private ApexPages.StandardController controller {get; set;}
    private String feedbackId;
    private final List<CAS_Inspection_Copy__c> obj;
    
    
    public CASTextBookFeedbackLink(ApexPages.StandardController controller)
    { 
        OpportunityLineItem oli;
        String icId = null;
        
        this.controller = controller;
        List<OpportunityLineItem> records= [Select Book_Order__c, OpportunityId From OpportunityLineItem Where Book_Order__c != null and id = :ApexPages.currentPage().getParameters().get('id')];
        if (records.size() > 0)
        {oli = records.get(0);
        
        this.obj = [Select c.Id from CAS_Inspection_Copy__c c WHERE c.Book_Order__c = :oli.Book_Order__c  and c.Opportunity__c = :oli.OpportunityId];
        //feedbackId = [Select c.Id from CAS_Inspection_Copy__c c WHERE c.Opportunity_Product__c = :ApexPages.currentPage().getParameters().get('id') + '%'].Id;
        if (obj.size() != 0)
        icId = obj[0].Id;
        
        }
        
        GetTextLink = icId;
        
        //ApexPages.currentPage().getParameters().get('id');
         
        //if(feedbackId != null) 
        //GetTextLink ='dd';//feedbackId;
    }
    
    public String GetTextLink
    {get
        {
        if (GetTextLink == null)
        {
            GetTextLink = 'No Textbook Feedback Record.';
        }
        else
        {
        String link = 'http://taylorandfrancis.force.com/ICFeedback?id=' + GetTextLink;
        GetTextLink = link; //'<a href="' + link + '">' + link + '</a>';
        }
            return GetTextLink;
        }
    set;
    }
    
    //public Boolean isRender {
    //  get {
    //      if (isRender == null)
    //          isRender = true;
    //      
    //      return isRender;    
    //  }
    //  set;
    //}
    



}