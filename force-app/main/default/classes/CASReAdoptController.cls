//***********************
// Updated 2018-11-09: Tom Reed: Case: 01071840 - 
// Updated stage value from 'Closed Won - Adoption Confirmed' to 'Acceptance'.
// Updated 2018-11-12: Ashish Purwar: Case: 01074151 -
// Updated course start date for cloned opportunity to following year from the course start date of original opp.
// Updated 2022-10-06: Gopinath Punniakotti: https://taylorfrancis.atlassian.net/browse/BAU-16858
// Inserted Primary Contact for cloned opportunity, queried from OpportunityContactRole and assigned to opportunity.
// Updated 2022-07-29: Gopinath Punniakotti: https://taylorfrancis.atlassian.net/browse/BAU-18121 [GRQ0314892]
// Commented the line CHG0033756 which is UnitPrice is not equal to ListPrice and while clone the OpportunityLineItem added extra field to get cloned.
// 
// 
//**********************

public with sharing class CASReAdoptController {
    private ApexPages.StandardController controller {get; set;}
    private final Opportunity opp;
    public Id newOppId {get; set;}
    public boolean adoptionAllowed {get; set;}
    public string errorMessage {get; set;}
    
    public CASReAdoptController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
    
    public Pagereference doAction() {
        if (!(opp.isClosed && opp.isWon)) {
            errorMessage = 'This opportunity cannot be re-adopted, becuase it is not Closed Won.';
            adoptionAllowed = false;
        } else if (opp.Next_Renewal__c != null) {
            errorMessage = 'This opportunity has been previously re-adopted, so cannot be re-adopted again.';
            adoptionAllowed = false;
        } else {
            adoptionAllowed = true;
            //Clone Opportunity
            sObject originalSObject = (sObject)opp;
            List<sObject> originalSObjects = new List<sObject>{originalSObject};
            List<sObject> clonedSObjects = SObjectAllFieldCloner.cloneObjects(
                                          originalSobjects,
                                          originalSobject.getsObjectType());
            
    		OpportunityContactRole ocrList = [SELECT Id, ContactId, OpportunityId, Role, IsPrimary FROM OpportunityContactRole
                                                 	WHERE OpportunityId = :opp.Id AND IsPrimary=true LIMIT 1]; 
            system.debug('OpportunityContactRole '+ocrList);
            system.debug('ocrList.Id '+ocrList.ContactId);
            Opportunity clonedOpp = (Opportunity)clonedSObjects.get(0);
            clonedOpp.CloseDate = system.today();
            clonedOpp.StageName = 'Acceptance'; //Tom Reed: Case: 01071840
            clonedOpp.Probability = 100;
            clonedOpp.Previous_Renewal__c = opp.Id;
            clonedOpp.OwnerId = UserInfo.getUserId(); //CHG0075180             
            clonedOpp.Course_Start_Date__c=clonedOpp.Course_Start_Date__c.addYears(1);//Ashish Purwar: case : 01074151 
            clonedOpp.Primary_Contact__c = ocrList.ContactId;
            insert clonedOpp;
            
            //Update old opp
            opp.Next_Renewal__c = clonedOpp.Id;
            update opp;
                
            //Clone OpportunityLineItem
            List<OpportunityLineItem> olis = 
                [SELECT Id, OpportunityId, PricebookEntryId, Quantity, Description, ListPrice, UnitPrice, 
                     Lead_Author_Editor__c, Recipient__c, Adoption_Level__c, Adoption_Stage__c,
                     Book_Order__c,
                     IC_Quantity__c, 
                     Future_Ship_Date__c,Extra_Info_Special_Deals__c, VitalSource_Access_Period__c, Recipient_Address__c, 
                     Adoption_Type__c, ServiceDate, Fulfillment_House__c,Adoption_Date__c,Adoption_Owner__c,Rep_Verified__c,Delivery_Instructions__c 
                 FROM OpportunityLineItem
                 WHERE OpportunityId = :opp.Id and Adoption_Stage__c IN:getAdoptionStage()]; //CHG0075180 ('Completed - Adopted','Committee Review','Completed - Order Confirmed','Completed - Purchased','Completed - Library Purchase')];
            List<OpportunityLineItem> clonedOlis = new List<OpportunityLineItem>();
            
            for (OpportunityLineItem oli : olis) {
                OpportunityLineItem clonedOli = oli.clone(false, true);
                clonedOli.OpportunityId = clonedOpp.Id;
                clonedOli.Feedback_Notification__c = 'Do Not Send';
              //  clonedOli.Rep_Verified__c = false; //@@Avi
              //  clonedOli.Adoption_Stage__c = 'Completed - Adopted';
                clonedOli.Adoption_Type__c = 'Re-Adopted';
                clonedOli.Order_Type__c = null;
              //  clonedOli.UnitPrice = clonedOli.ListPrice; // CHG0033756  @@ added by avi on 9-5-2017  price of product into the unit price of oli at the time of cloning oli.
                if(clonedOli.Rep_Verified__c){
                    clonedOli.Adoption_Owner__c = UserInfo.getName();
                    clonedOli.Adoption_Date__c = System.today();
                }
                clonedOlis.add(clonedOli);
            }
            if (clonedOlis.size() > 0)
                insert clonedOlis;
            
            system.debug('@@@@@@ ');
            //Clone OpportunityContactRole
            List<OpportunityContactRole> ocrs = 
                [SELECT Id, ContactId, OpportunityId, Role, IsPrimary
                 FROM OpportunityContactRole
                 WHERE OpportunityId = :opp.Id];
            system.debug('OpportunityContactRole '+ocrs);
            List<OpportunityContactRole> clonedOcrs = new List<OpportunityContactRole>();
            for (OpportunityContactRole ocr : ocrs) {
                OpportunityContactRole clonedOcr = ocr.clone(false, true);
                clonedOcr.OpportunityId = clonedOpp.Id;
                clonedOcrs.add(clonedOcr);
            }
            if (clonedOcrs.size() > 0)
                insert clonedOcrs;  
    	system.debug('Contact Role '+clonedOcrs);
            //Navigate to new Opportunity
            newOppId = clonedOpp.id;
        }
        return null;        
    }
    
    public List<String> getAdoptionStage(){
        List<Setting_Item__c> sItems =[Select Text_1__c from Setting_Item__c where Setting__r.Name ='Adoption Stages For ReAdopt'];
        List<String> stageList = new List<String>();
        for(Setting_Item__c si : sItems){
            stageList.add(si.Text_1__c);
        }
        return stageList;
    }
}