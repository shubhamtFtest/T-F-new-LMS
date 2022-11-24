//Last Modified by Hailey Niemand 2013.12.19 - CHG0055533
//Last Modified by Jeff Lup - 2014.06.18 - CHG0059168
//Last Modified by Jeff Lup - 2014.06.18 - INC1477204

public with sharing class TFOpportunityOwnershipController {
    private Map<String, Account> consortiumMembers =  new Map<String, Account>();
    private List<Account_To_Opportunity__c> accsToOpps = new List<Account_To_Opportunity__c>();
    
    private final String OPT_PRICEAGREEMENT = 'Price Agreement';
    private final String OPT_DIRECTDEAL = 'Direct Deal';
    private final String OPT_CONS_MEM = 'Consortium Member';
    private final String CONSORTIUM = 'Consortium';
    
    private String oppId = '';
    public Opportunity opp{get;set;}
    public boolean selectall{get;set;}
    
    public boolean showCheckboxes {get;set;} //CHG0059168
        
    public List<String> selectedMembers{get;set;} {selectedMembers = new List<String>();}
    
    public List<SelectOption> memberOptions{get;set;}{memberOptions = new List<SelectOption>();}
    public List<SelectOption> dealOptions{get;set;}{dealOptions = new List<SelectOption>();}
    
    public String selectedDeal{get;set;} 
    public Boolean isConsortium{get;set;} {isConsortium = false;}
    
    public boolean isError{get;set;} {isError = false;}
    
    public TFOpportunityOwnershipController(){
        String accId;
        
        try{
            oppId = ApexPages.CurrentPage().getParameters().get('id');
            //opp = [SELECT id, accountId, account.type, deal_type__c, Stagename FROM Opportunity WHERE id=:oppId];
            opp = [SELECT id, RecordTypeId, accountId, account.type, deal_type__c, Stagename FROM Opportunity WHERE id=:oppId]; //CHG0059168
            //CHG0059168
            if (opp.RecordTypeId == '01260000000J2hpAAC' //T&F eBooks Consortium Opportunity (Price Agreement)
            || opp.RecordTypeId == '01260000000J08fAAC') //T&F Journals Consortium Opportunity (Price Agreement)
        		showCheckboxes = false;
        	else
        		showCheckboxes = true;
            
            selectedDeal = opp.deal_type__c;
        
            accId = ApexPages.CurrentPage().getParameters().get('accid'); // 'New Opp button clicked on Account page'
            if(accId == null && opp.AccountId <> null)
                accId = opp.AccountId;
                            
        }catch(System.QueryException e){
            System.debug(e);
            isError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity Not Found.');
            ApexPages.addMessage(myMsg);
        }
        
        if(accId <> null){
            List<TandF_Account_to_Consortium__c> accs2consorts = [SELECT id, consortium_member__r.id, consortium_member__r.name, consortiumParent__r.type 
            
                                                       FROM TandF_Account_to_Consortium__c 
                                                      WHERE ConsortiumParent__c=:accId AND consortium_member__c != null //WRQ0147815
                                                      ORDER BY consortium_member__r.name];
                                                      
            if(accs2consorts.size() == 0){
                selectedDeal = OPT_DIRECTDEAL;
            }else{
                
                if (selectedDeal == null) //INC1477204
                    selectedDeal = OPT_DIRECTDEAL;
                                                          
                for(TandF_Account_to_Consortium__c a2c: accs2consorts){
                    System.debug('Parent Relationship Type: '+a2c.consortiumParent__r.type);
                    if(a2c.consortiumParent__r.type==CONSORTIUM && !isConsortium){
                        isConsortium = true;
                    }
                    
                    memberOptions.add(new SelectOption(a2c.consortium_member__r.id, a2c.consortium_member__r.name));
                    
                    consortiumMembers.put(a2c.consortium_member__r.id, a2c.consortium_member__r);
                }
                
                refreshMemberList();
                
                // Fetch all previous Opp ownership junction records
                //accsToOpps = [SELECT id,account__c FROM Account_To_Opportunity__c WHERE opportunity__c = :oppId AND account__c IN :consortiumMembers.keyset()];
                accsToOpps = [SELECT id,account__c FROM Account_To_Opportunity__c WHERE opportunity__c = :oppId]; //INC1477204
                for(Account_To_Opportunity__c a2c: accsToOpps){
                    selectedMembers.add(a2c.account__c);    
                }
            }
        }else{
            // Account Id for the Opp is missing
            isError = true;
        }
        
        // Both options are only displayed for consortiums
        dealOptions.add(new SelectOption(OPT_DIRECTDEAL, OPT_DIRECTDEAL));
        dealOptions.add(new SelectOption(OPT_PRICEAGREEMENT, OPT_PRICEAGREEMENT));
                
        System.debug('Selected Deal: '+selectedDeal);        
    }
    
    public PageReference saveRecord(){
        //CHG0055533
        //PageReference pr = ApexPages.CurrentPage();
        //pr.setRedirect(true);
        
        delete accsToOpps;
        accsToOpps.clear();
        
        if(selectedDeal==OPT_PRICEAGREEMENT || selectedDeal== OPT_DIRECTDEAL){
            for(String memberId: selectedMembers){
                Account_To_Opportunity__c a2c = new Account_To_Opportunity__c(Account__c=memberId,Opportunity__c=oppId);
                accsToOpps.add(a2c);
            }
            
            insert accsToOpps;
        }       
        
        opp.deal_type__c = selectedDeal;
        update opp;
        
        //return pr; //CHG0055533
        return null; 
    }
    
    // Refresh the list of members - used to disable/enable the checkoptions as dictated by
    // the selected deal type
    public void refreshMemberList(){
        System.debug('rSelected Deal: '+selectedDeal);
      
      /*
        for(SelectOption opt: memberOptions){
            if(selectedDeal==OPT_DIRECTDEAL){
                opt.setDisabled(true);
            }else{
                opt.setDisabled(false);
            }
        }
      */  
    }
       
 
}