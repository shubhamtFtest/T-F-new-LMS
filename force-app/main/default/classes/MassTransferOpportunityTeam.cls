/*
    Updated by Faiz Case Ref no 01035423 
    Line 59-63  
*/
public without sharing class MassTransferOpportunityTeam {

    List<Id> lstRecordTypeId = new List<Id>();
    List<RecordType> lstRecordType;
    List<OpportunityTeamMember> oppList =new List<OpportunityTeamMember>(); 
    public MassTransferOpportunityTeam() {
        oOppTeamMem = new OpportunityTeamMember();
        opportunity = new Opportunity();
        oppSearch = new Opportunity ();
        acct = new Account();
        teamSearch= new OpportunityTeamMember ();
        
        if(Test.isRunningTest())
            lstRecordType = [Select Id,Name from RecordType where sObjecttype='Opportunity' AND Name IN('T&F - Journals Opportunity','T&F - eBook Opportunities','T&F eBooks Consortium Opportunity (Direct)','T&F eBooks Consortium Opportunity (Price Agreement)','T&F eBooks Customer Opportunity (Direct)','T&F Journals Consortium Opportunity (Direct)','T&F Journals Consortium Opportunity (Price Agreement)','T&F Journals Customer Opportunity (Direct)','T&F - Journals Opportunities','T&F One-Off Opportunity')];
        else
            lstRecordType = [Select Id,Name from RecordType where sObjecttype='Opportunity' AND Name=:getRecordTypeNames()];
       
        for(RecordType oRecordType : lstRecordType){
          lstRecordTypeId.add(oRecordType.Id);  
        }
        if(lstRecordTypeId != null && lstRecordTypeId.size() > 0){
          //totalRecs = [select count() from Opportunity WHERE Volume_Year__c =: String.valueOf(System.Today().year()) AND RecordTypeId IN: lstRecordTypeId LIMIT 500];
          totalRecs = [select count() from Opportunity WHERE Volume_Year__c IN ('2016','2017','2018','2019') AND RecordTypeId IN: lstRecordTypeId LIMIT 500];
        }
    }

    public String strSelectedOppId { get; set; }
    public Opportunity opportunity { get; set; }
    public Account acct{ get; set; }
    public OpportunityTeamMember oOppTeamMem{get;set;}
    //search opp
    public Opportunity oppSearch{ get; set; }
    public OpportunityTeamMember teamSearch{get;set;}
    
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 50;
    
    List<SelectOption> lstOpportunityAccessLevel = new List<SelectOption>();
    List<Opportunity> lstOpportunity;
  
    public List<OpportunityTeamMember> getOpportunities() {
        System.debug('oppSearch : '+oppSearch);
        System.debug('lstRecordTypeId : '+lstRecordTypeId);
       // System.debug('acct.Shipping_Country_List__c: '+acct.Shipping_Country_List__c);
        Boolean isSearch=false;
        if(lstRecordTypeId != null && lstRecordTypeId.size() > 0){
            //String strQr='Select Id, OpportunityId,Opportunity.Adoption_Probability__c, Opportunity.Name,TeamMemberRole, Opportunity.Account.Name, Opportunity.Amount, Opportunity.StageName,Opportunity.RecordType.Name,User.Name from OpportunityTeamMember where Opportunity.Volume_Year__c =\''+String.valueOf(System.Today().year())+'\' and ';
            String currentYear = String.valueOf(System.today().year());
            System.debug('currentYear-'+currentYear);
            System.debug('shipping-'+oppSearch.Account.Shipping_Country_List__c);
            String strQr='Select Id, OpportunityId, Opportunity.Name,TeamMemberRole,Opportunity.Volume_Year__c, Opportunity.Account.Name,Opportunity.Account.Shipping_Country_List__c, Opportunity.Amount, Opportunity.StageName,Opportunity.RecordType.Name,User.Name from OpportunityTeamMember where  ';
            strQr += ' Opportunity.RecordTypeID IN: lstRecordTypeId ';
            if(oppSearch.Lead_Passed_From__c !=null){
                //strQr +=  ' and UserId =\''+oppSearch.Lead_Passed_From__c +'\' and Opportunity.OwnerId !=\''+oppSearch.Lead_Passed_From__c +'\' ';
                strQr +=  ' and UserId =\''+oppSearch.Lead_Passed_From__c +'\'';
                isSearch =true;
            }
            if(acct.Shipping_Country_List__c !=null){
                
                strQr +=  ' and Opportunity.Account.Shipping_Country_List__c =\''+acct.Shipping_Country_List__c +'\'';
                isSearch =true;
            }
            if(oppSearch.Volume_Year__c !=null){
                //strQr +=  ' and UserId =\''+oppSearch.Lead_Passed_From__c +'\' and Opportunity.OwnerId !=\''+oppSearch.Lead_Passed_From__c +'\' ';
                strQr +=  ' and Opportunity.Volume_Year__c =\''+oppSearch.Volume_Year__c+'\'';
                isSearch =true;
            }
            
            if(teamSearch.TeamMemberRole !=null){
                strQr += ' and TeamMemberRole= \''+teamSearch.TeamMemberRole +'\'';
                isSearch =true;
            }
            
            strQr += '  LIMIT :LimitSize OFFSET :OffsetSize ';  
            System.Debug('strQr : '+strQr);
            if(isSearch){
                oppList = (List<OpportunityTeamMember>)Database.query(strQr);   
                System.Debug('oppList : '+oppList);
            }
            /*           
          oppList=[Select Id, Name, Account.Name, Amount, StageName,RecordType.Name from Opportunity where Volume_Year__c =: String.valueOf(System.Today().year()) and
            ID IN (Select OpportunityId from OpportunityTeamMember where Opportunity.RecordTypeID IN: lstRecordTypeId and UserId =:oppSearch.OwnerId and TeamMemberRole=: teamSearch.TeamMemberRole )  LIMIT :LimitSize OFFSET :OffsetSize];
            */
        }
        
        
        return oppList;
    }
    public PageReference Save(){
    
        List<String> lstOppIds = new List<String>();
        Map<Id,OpportunityTeamMember> oppRoleMap = new Map<Id,OpportunityTeamMember>();
        Map<Id,OpportunityTeamMember> oppRoleToDelete = new Map<Id,OpportunityTeamMember>();
        List<OpportunityTeamMember> oppTeamToInsert= new List<OpportunityTeamMember>();
        if(strSelectedOppId.length() != 0){
            lstOppIds = strSelectedOppId.split(',');
        }

        if(oOppTeamMem.TeamMemberRole ==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select opportunity team member role !'));
            return null;
        }
        
        if(oOppTeamMem.OpportunityAccessLevel==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Opportunity Access !'));
            return null;
        }
        
        if(lstOppIds !=null && lstOppIds.size() >0){
            //get records to update opportunity team
            System.debug('lstOppIds ' +lstOppIds);
        
            for(OpportunityTeamMember otm : [Select Id,OpportunityId,UserId,Opportunity.OwnerId,TeamMemberRole from OpportunityTeamMember where Id=:lstOppIds]){
                 oppRoleMap.put(otm.OpportunityId,new OpportunityTeamMember(Id=otm.Id)); 
                 if(otm.UserId !=otm.Opportunity.OwnerId && otm.TeamMemberRole ==oOppTeamMem.TeamMemberRole){
                     oppRoleToDelete.put(otm.OpportunityId,new OpportunityTeamMember(Id=otm.Id)); 
                 }
            }
    
            //get records to insert opportunity team
            for(String strId : oppRoleMap.keySet()){
               oppTeamToInsert.add(new OpportunityTeamMember(UserId=opportunity.Lead_Passed_From__c,OpportunityAccessLevel=oOppTeamMem.OpportunityAccessLevel,OpportunityId=strId,TeamMemberRole=oOppTeamMem.TeamMemberRole));
            }
            System.Debug('oppRoleMap : '+oppRoleMap);
            System.Debug('oppTeamToInsert : '+oppTeamToInsert);
            if(oppRoleMap !=null && oppRoleMap.Size() >0){
                Delete oppRoleToDelete.values();
             }   
             
            if(oppTeamToInsert !=null && oppTeamToInsert.size() >0){
                Insert oppTeamToInsert;
             }   
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated'));
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select atleast one opportunity !'));
        }
        
            
        
        return null;
    }
    
    public List<String> getRecordTypeNames(){
        List<String> rtNames = new List<String>();
        for(Setting_Item__c item : [Select Id,Text_1__c from Setting_Item__c where Setting__r.Name='T&F Mass Opp Role Change Access']){
            rtNames.add(item.Text_1__c);
        }
        System.Debug('rtNames : '+rtNames);
        return rtNames;
    }
    
    public void FirstPage(){
        OffsetSize = 0;
    }
    
    public void previous(){
        OffsetSize = OffsetSize - LimitSize;
    }
    
    public void next(){
        OffsetSize = OffsetSize + LimitSize;
    }
    
    public void LastPage(){
    OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
    }
    
    public boolean getprev(){
        if(OffsetSize == 0)
            return true;
        else
            return false;
    }
    
    public boolean getnxt(){
        if((OffsetSize + LimitSize) > totalRecs)
            return true;
        else
            return false;
    }
   
}