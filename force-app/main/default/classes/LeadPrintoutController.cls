// Updated by : Ashish Purwar on 27/04/2018
// Made changes for DF-866 CHG0043615
public with sharing class LeadPrintoutController {
    public LeadPrintoutController(ApexPages.StandardSetController controller){
        leadIds=controller.getSelected() ;//DF-866 CHG0043615
        //String ids = ApexPages.currentPage().getParameters().get('ids'); DF-866 CHG0043615
        //List<String> leadIds = ids.split(','); DF-866 CHG0043615
        if(leadIds.size()>0){
            List<Lead> leads = [SELECT Id, Company, Owner.Name, Name, Email, Department__c, Status, Website, Phone,
                                Industry, LeadSource, Sub_Industry__c, MobilePhone, Lead_Ranking__c, Functional_Role__c,
                                Decision_Maker_Role__c, Bookstore_Name__c, Decision_Date__c, Bookstore_Phone_Number__c,
                                Desk_Copies_Needed__c,
                                Street, City, State, PostalCode, Country, Other_Street__c, Other_City__c,
                                Other_State_Province__c, Other_Postal_Code__c, Other_Country__c,
                                Locale__c, Sales_Region__c,
                                Course_Name__c, Qualification__c, Institution_Course_Code__c, Year_of_Study__c,
                                Anticipated_Enrollment__c, Course_Start_Date__c, Book_Title_Requested__c, Course_Frequency__c,
                                ISBN__c, Current_Text__c, Book_Requested_Type__c, Order_Type__c,
                                Author__c, Website_Source__c, Publisher__c, Promo_Code_C__c, Delivery_Instructions__c,
                                Description,
                                CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate,
                                RecordType.Name
                                FROM Lead
                                WHERE Id IN :leadIds];
            LeadWrappers = new List<LeadWrapper>();
            for (Integer i=0; i<leads.size(); i++) {
                Boolean pb = true;
                if (i==leads.size()-1) pb = false;
                LeadWrapper lw = new LeadWrapper(leads[i], pb);
                LeadWrappers.add(lw);
            }       
        }        
    }
    /*public PageReference InitialCheck() {       
        if(leadIds.size()<=0){
            PageReference pageRef = new PageReference('/apex/No_Leads_found');
            return pageRef;
        }
        return null;
    }
    public PageReference RedirectToLeadsList(){
        Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix());           
        pageRef.setRedirect(true); 
        return pageRef; 
    }*/
    public List<Lead> leadIds=new List<Lead>();
    public List<LeadWrapper> LeadWrappers { get; set; }
    public class LeadWrapper {
        public Lead lead { get; set; }
        public String conditionalPageBreak { get; set; }
        public LeadWrapper(Lead l, Boolean pb) {
            lead = l;
            if (pb) conditionalPageBreak = 'pageBreak';
        }
    }
}