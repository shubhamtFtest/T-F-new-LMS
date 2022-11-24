public class TF_IndiaRePrintCloneOpportunity {
    
    public class wrapdatadup {      
        @AuraEnabled
        public String ISBN { get;set; }        
        @AuraEnabled
        public String Quantity { get;set; } 
        @AuraEnabled
        public String Binding { get;set; } 
    }    
    
    @AuraEnabled
    public static void cloneOpportunity(String OpptyId) {
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        List <Opportunity> opptsToInsert = new List <Opportunity>();
        Opportunity newOppt = new Opportunity();       
        Opportunity opp = [Select Id, RecordTypeId, Name, OwnerId, Proposal_Type__c, AccountId From Opportunity where Id =: OpptyId limit 1];       
        Opportunity newOppObj = new Opportunity(
            Name = opp.Name + '-Cloned',
            AccountId = opp.AccountId,            
            CloseDate = Date.Today() + 30,
            OwnerId = opp.OwnerId,
            StageName = 'Prospect',
            Proposal_Type__c = opp.Proposal_Type__c,
            RecordTypeId = oppRecordtypeId,
            Cloned__c = true,
			ClonedOppId__c = OpptyId          
        );
        insert newOppObj;               
    }
}