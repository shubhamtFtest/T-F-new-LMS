public with sharing class TFOAC_OpprotunityController {

  public String userAvailableHostAreas{get;set;}
  public Boolean isAllowedToSwithcProduct{get;set;}
  public Boolean isDigitalContentUser{get;set;}
  public Boolean hasAlignesJournals{get;set;}
    public Id opportunityId{get;set;}

  public TFOAC_OpprotunityController(ApexPages.StandardController std) {
    setAvailableHoserAreas();
    isAllowedToSwithcProduct = checkIfUserCanSwitchProductToDifferentOpportunity();
    this.opportunityId = std.getId();
    this.hasAlignesJournals = checkIfOpportunityHasAlignedJournal();
  }

  private void setAvailableHoserAreas(){
        this.userAvailableHostAreas ='';
        List<GroupMember> groupMembers = [SELECT Id,Group.DeveloperName FROM GRoupMember WHERE Group.DeveloperName IN: TFOAC_JournalController.groupNameToHostAreaMapping().keySet() AND UserOrGroupId =: UserInfo.getUserId()];//CHG0073825 

        for(GroupMember gm : groupMembers){
            if(gm.Group.DeveloperName == 'T_F_HA_Digital_Content_Edit'){
                isDigitalContentUser = true;
                continue;
            }
            this.userAvailableHostAreas += TFOAC_JournalController.groupNameToHostAreaMapping().get(gm.Group.DeveloperName)+';';//CHG0073825
        }
        system.debug('check available host areas: '+userAvailableHostAreas);
            
        
    }

    private Boolean checkIfUserCanSwitchProductToDifferentOpportunity(){
        for(Profile p: [Select id From Profile where Name = 'System Administrator' or Name = 'T&F Acquisition Power Plus User' or Name = 'T&F Acquisition Super User' or Name = 'T&F Acquisition Administrator' or Name = 'T&F OAC Power Plus User' or Name = 'T&F OAC Super User' or Name = 'T&F OAC Administrator']){
          if(p.id == UserInfo.getProfileId()){
              return true;
            }
        }
        return false;
        
    }

    private Boolean checkIfOpportunityHasAlignedJournal(){

      if(this.opportunityId != null){
        List<TFOAC_Journal__c> alignedJournals = [Select id FROM TFOAC_Journal__c WHERE OACOpportunity__c =: this.opportunityId];
        return !alignedJournals.isEmpty();
      }

      return false;
    }
}