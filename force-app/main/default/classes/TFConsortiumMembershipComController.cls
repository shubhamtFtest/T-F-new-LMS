public with sharing class TFConsortiumMembershipComController {
    public Account oAccount{get;set;}
    public list<Account> listConsortiumAccounts{get;set;}
    public list<TandF_Account_to_Consortium__c> ListAccountToConsortium {get;set;}
    public string newConsortiaValue {get; set;}    
    private List<SelectOption> consortiaListVar;
    public boolean ErrorMessagesIsRendered { get; private set; }
    public boolean membersDoNotExist { get; set; }
    public string editRowMemberId { get; set; }
    public string editRowMemberName { get; set; }
    public string editRowMemberParentId { get; set; }
    public string newMemberParentName {get; set;}
    public string newMemberParentId {get; set;}
    
    public  TFConsortiumMembershipComController  (){ 
        string accId = ApexPages.currentPage().getParameters().get('id');
        if (accId != null)
        {
          try {
            oAccount = [select Name from Account where id =:accId];
          } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account does not exist.'));
            return;
          }
        }
    }

    /* Selection option list of consortia names */
    public List<SelectOption> consortiaList {

        get{
          List<SelectOption> result = new List<SelectOption>();
          
          if (consortiaList == null)
          {
              //result.add(new SelectOption('none', '---none---'));
              for(Account a : [select Id,Name from Account where type = 'Consortium' AND RecordType.Name = 'T&F - Consortium' ORDER BY Account.name])
                {
                  result.add(new SelectOption(a.Id, a.Name));
                }
          }
          return result;
        }
    }

    public void addMember() {
        ErrorMessagesIsRendered = true;
        boolean isValid = true;

        // Duplicate parameter names not allowed
        if (memberNameIsDuplicate(newConsortiaValue)){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate membership not allowed.'));
          isValid = false;
        }
               
        // Save the parent object
        if (isValid) {
            TandF_Account_to_Consortium__c AccountToConsortium  = new TandF_Account_to_Consortium__c();
            AccountToConsortium.Consortium_Member__c = oAccount.Id;
            AccountToConsortium.ConsortiumParent__c = newConsortiaValue;
            try {
                insert AccountToConsortium;
                System.debug('Insert Complete');
            } catch (Exception e) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
            }
        }
    }

    /*public void editMember() {
        try {
          TandF_Account_to_Consortium__c oMember = [select id,Consortium_Member__c, ConsortiumParent__c, ConsortiumParent__r.Name
                                                          from TandF_Account_to_Consortium__c
                                                           where Id = :editRowMemberId];
          editRowMemberName = oMember.ConsortiumParent__r.Name;
          editRowMemberId = oMember.ConsortiumParent__c;
        } catch (Exception e) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); }
    }*/

    public void deleteMember() {
        ErrorMessagesIsRendered = true;
        try{
            Database.Deleteresult dbDeleteResult = Database.delete(editRowMemberId);
        } catch (Exception e) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
        editRowMemberId = null;
    }
    
    /*
    public void cancelEditMember() {
        editRowMemberId = null;
        editRowMemberName = null;
    }*/

    private boolean memberNameIsDuplicate(id memId)
    {
        boolean result = false;
                
        for (TandF_Account_to_Consortium__c p : [select id,Consortium_Member__c, ConsortiumParent__c, ConsortiumParent__r.Name
                                                        from TandF_Account_to_Consortium__c
                                                        where Consortium_Member__c = :oAccount.Id and ConsortiumParent__c = :memId])
        {
          if (p.Id != memId)
            result = true;
        }
        return result;
    }

    public List<TandF_Account_to_Consortium__c> memberList {
        get{
          List<TandF_Account_to_Consortium__c> result = new List<TandF_Account_to_Consortium__c>();
          
          for (TandF_Account_to_Consortium__c p : [select id,Consortium_Member__c, ConsortiumParent__c, ConsortiumParent__r.Name
                                                          from TandF_Account_to_Consortium__c
                                                          where Consortium_Member__c = :oAccount.Id
                                                          order by  ConsortiumParent__r.Name])
          {
            // Add function rows to list
            result.add(p);
          }
          membersDoNotExist = (result.isEmpty());
          return result;
        }
    }


    public void consortiaListSelectionChanged() {
        if (newMemberParentName != null && newMemberParentName != '')
          newMemberParentName = newMemberParentName;
          newMemberParentId = newMemberParentId;
    }
        
}