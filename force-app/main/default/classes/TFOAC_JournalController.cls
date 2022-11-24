//Update By : Ashish Purwar
//Updated date : 12/09/2018
//Update: To allow all host areas to OAC users
public with sharing class TFOAC_JournalController {

    private ApexPages.StandardController controller; 
    public TFOAC_Opportunity__c currentOpportunity{get;set;}
    public TFOAC_Journal__c productToCreate{get;set;}
    public String oppCurrency { get; set; }
    public String userAvailableHostAreas{get;set;}
    public Boolean isDigitalContentUser{get;set;}
    public Boolean isAllowedToSwithcProduct{get;set;}
    public Boolean isAlignedToOpportunity{get;set;}
    private Integer recordsOnPage;
    public Boolean hasEditRights{get;set;}

    public void setContratType(String s){this.productToCreate.AcqType__c =s;}
    public String getContracType(){return this.productToCreate.AcqType__c;}
    public TFOAC_JournalController(ApexPages.StandardController controller) {
       
       this.isAlignedToOpportunity = false;
       this.controller = controller;
       Id opportunityIdToRetrive = null;
       Id jounralIdToRetrive = null;
       Map<String,String> pageParams =  ApexPages.currentPage().getParameters();
       for(String key : pageParams.keySet()){
            if(key != null && key.endsWith('lkid') && pageParams.get(key) != null){
                opportunityIdToRetrive = Id.valueOf(pageParams.get(key));
                
            }else if(key != null && key.toLowerCase() == 'id' && pageParams.get(key) != null){
                jounralIdToRetrive = Id.valueOf(pageParams.get(key));
                
            }
       }
       
       if(opportunityIdToRetrive != null){
            currentOpportunity  = [Select RecordTypeId, CurrencyIsoCode,id,Host_Areas__c,Name From TFOAC_Opportunity__c Where Id =:opportunityIdToRetrive Limit 1];
            oppCurrency = currentOpportunity.CurrencyIsoCode;   
       }

       if(jounralIdToRetrive != null){
            retriveJournalData(jounralIdToRetrive);

       }else{
            productToCreate = new TFOAC_Journal__c();
            productToCreate.OwnerId=UserInfo.getUserId();
       }

       if(opportunityIdToRetrive != null ){
            
            productToCreate.OACOpportunity__c = opportunityIdToRetrive;
            productToCreate.CurrencyIsoCode = currentOpportunity.CurrencyIsoCode;
       }

       if(productToCreate.OACOpportunity__c == null){
        
            productToCreate.CurrencyIsoCode = UserInfo.getDefaultCurrency();
       }

       isAllowedToSwithcProduct = checkIfUserCanSwitchProductToDifferentOpportunity();//CHG0073937 
       setAvailableHoserAreas();
       hasEditRights = checkIfUserHasEditAcess();
       
    }

    /*
        Method checks if current user has edit rights to current journal 
    */
    public Boolean checkIfUserHasEditAcess(){

        if(this.productToCreate != null && this.productToCreate.id != null){
            List<UserRecordAccess> editRecordAccess = [SELECT RecordId FROM UserRecordAccess Where RecordId =:this.productToCreate.id AND UserId =: UserInfo.getUserId() AND HasEditAccess = true];
            if(!editRecordAccess.isEmpty()){
                return true;
            }
        }
        return false;
        
    }
    
    /*
        Method retrive Devision records from TFOAC_Hierarchy_Code__c
        Devision are records which parent is null
    */
    public List<SelectOption> getDivision(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        for(TFOAC_Hierarchy_Code__c code : [Select id,Name from TFOAC_Hierarchy_Code__c where Parent__c = null]){
            options.add(new SelectOption(code.id,code.Name));
        }
        system.debug('available devision options: '+options);
        return options;

    }
    
    /*
        Method retrive Host Area records from TFOAC_Hierarchy_Code__c
    */
    public List<SelectOption> getHosArea(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        //check if division is populated
        system.debug('check selected division: '+productToCreate.DivisionCode__c);
        if(productToCreate.DivisionCode__c != null){
            for(TFOAC_Hierarchy_Code__c code : [Select id,Name from TFOAC_Hierarchy_Code__c where Parent__c =: productToCreate.DivisionCode__c]){
                options.add(new SelectOption(code.id,code.Name));
            }
        }
        system.debug('available Host Area options: '+options);    
        return options;

    }
    
    /*
        Method retrive Segment records from TFOAC_Hierarchy_Code__c
    */
    public List<SelectOption> getSegment(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));

        //check if host area is populated
        if(productToCreate.Host_AreaCode__c != null){
            for(TFOAC_Hierarchy_Code__c code : [Select id,Name from TFOAC_Hierarchy_Code__c where Parent__c =: productToCreate.Host_AreaCode__c]){
                options.add(new SelectOption(code.id,code.Name));
            }
        }
        system.debug('available Segment options: '+options);    
        return options;

    }

    public List<SelectOption> getSector(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));

        //check if segment is populated
        if(productToCreate.SegmentCode__c != null){
            for(TFOAC_Hierarchy_Code__c code : [Select id,Name from TFOAC_Hierarchy_Code__c where Parent__c =: productToCreate.SegmentCode__c]){
                options.add(new SelectOption(code.id,code.Name));
            }
        } 
        system.debug('available Sector options: '+options);   
        return options;

    }

    public List<SelectOption> getSubjectArea(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        //check if segment is populated
        if(productToCreate.SectorCode__c != null){
            for(TFOAC_Hierarchy_Code__c code : [Select id,Name from TFOAC_Hierarchy_Code__c where Parent__c =: productToCreate.SectorCode__c]){
                options.add(new SelectOption(code.id,code.Name));
            }
        }
        system.debug('available Subject Area options: '+options);    
        return options;
    }


    private Boolean checkIfUserCanSwitchProductToDifferentOpportunity(){//CHG0073937 
        List<String> lstOpportunityName = new List<String>();
        for(Setting_Item__c oSettingItem : [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.name = 'TFOAC Switch Opportunities']){
          lstOpportunityName.add(oSettingItem.Text_1__c);   
        }
        for(Profile p: [Select id From Profile where Name IN :lstOpportunityName]){
            if(p.id == UserInfo.getProfileId()){
                return true;
        }
        }
        return false;
        
    }
    
    private void setAvailableHoserAreas(){
        userAvailableHostAreas ='';
        List<GroupMember> groupMembers=new List<GroupMember>();      
        UserRole CurrentUserRole=[SELECT developerName FROM UserRole WHERE Id=:UserInfo.getUserRoleId()];
        if(CurrentUserRole.developerName=='T_F_Acqusition' || CurrentUserRole.developerName=='T_F_Acqusition_Manager')//Check if current user's role is OAC one
          groupMembers = [SELECT Id,Group.DeveloperName FROM GRoupMember WHERE Group.DeveloperName IN: groupNameToHostAreaMapping().keySet()];// Consider user to be available in all HA groups   
        Else
          groupMembers = [SELECT Id,Group.DeveloperName FROM GRoupMember WHERE Group.DeveloperName IN: groupNameToHostAreaMapping().keySet() AND UserOrGroupId =: UserInfo.getUserId()];//CHG0073825 
        Map<String, String> GroupNameToHostAreaMap = new Map <string, string>();// map collection local to this method
        GroupNameToHostAreaMap=groupNameToHostAreaMapping();//Added to get the map in local variable
        for(GroupMember gm : groupMembers){
            if(gm.Group.DeveloperName == 'T_F_HA_Digital_Content_Edit'){
                isDigitalContentUser = true;
                continue;
            }
            //userAvailableHostAreas += groupNameToHostAreaMapping().get(gm.Group.DeveloperName)+';';//CHG0073825 This code is causing a SOQl queries to run in a for loop.
            userAvailableHostAreas += GroupNameToHostAreaMap.get(gm.Group.DeveloperName)+';';//CHG0073825 AP added this code to loop through the local map variable.
        }
        system.debug('check available host areas: '+userAvailableHostAreas);
            
        
    }
    
    
    public static Map<String, String> groupNameToHostAreaMapping(){//CHG0073825
      Map<String, String> oHostMapGroup = new Map <string, string>();
      List<Setting_Item__c> lstSettingItem = [select Text_1__c, Text_2__c from Setting_Item__c where Setting__r.name = 'TFOAC Host Area Mapping' LIMIT 5000];
      for(Setting_Item__c oSettingItem: lstSettingItem){
        oHostMapGroup.put(oSettingItem.Text_1__c, oSettingItem.Text_2__c);    
      }
      return oHostMapGroup;
    }
    
    public void clearHiddenFields(){
        system.debug('clearHiddenFields method executed:');
        
        
        if(productToCreate.Media__c == 'Online'){
            productToCreate.PrintISSN__c = null;
        }
        if(productToCreate.Media__c == 'Print'){
            productToCreate.OnlineISSN__c = null;
        }
        system.debug('clearHiddenFields method exit:');
    }
    
    public PageReference saveProduct(){
        system.debug('saveProduct method executed:');
        if(validateProductRequiredFields()){
            clearHiddenFields();
            Savepoint sp = Database.setSavepoint();
            try{
                
                if(productToCreate.id == null){
                    insert productToCreate;
                }else{
                    update productToCreate;    
                }
                
                system.debug('record was processed without errors');

            }catch(Exception ex){
                    //handle validation rule exceptions if occured then change the message
                    String onlineError = 'Online ISSN field wrong format.';
                    String printError = 'Print ISSN field wrong format.';
                    String yearFormat = 'Require year format';
                    String errorMsg = ex.getMessage();
                    if(errorMsg.containsIgnoreCase(onlineError)){
                        errorMsg = onlineError;
                    }else if(errorMsg.containsIgnoreCase(printError)){
                        errorMsg = printError;
                    }else if(errorMsg.containsIgnoreCase(yearFormat)){
                        errorMsg = yearFormat;
                    }
                    system.debug('Error was thrown while saving the record:'+ex.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg));
                    Database.rollback(sp);
                    return null;
            }
            
            //method for creating a Price book entries and align opportunity line item with price book
        }else{
            return null;
        }
        system.debug('check if no errors thrown');
        Map<String,String> pageParams =  ApexPages.currentPage().getParameters();
        if(pageParams.containsKey('retURL')){
            return new PageReference(pageParams.get('retURL'));
        }
        String retPage = '/apex/'+Page.TFOAC_JournalPage+'?id='+productToCreate.id;
        return new PageReference(retPage);
    }
    
    
    public void retriveJournalData(Id journalId){
        productToCreate = [Select id,OwnerId,bid_lead__c,Name,CurrencyIsoCode,AcqType__c,Status__c,Status_Weight__c,SubStatus__c,
                           LaunchYear__c,OnlineISSN__c,CurrentPublisher__c,ContractExpires__c,JCRCovered__c,
                           ProductProfile__c,JournalAcronym__c,PurchaseType__c,Media__c,PrintISSN__c,YearFirstPublished__c,
                           Country__c,Purchase_price__c,CurrentAnnualTurnover__c,
                           EstimatedGrossMarginYear1__c,EstimatedYear1Turnover__c,SignOnFee__c,WeightedTurnoverYear1__c,
                           OACOpportunity__c,Current_Open_Acess__c,Open_Access_T_F_Year_1__c,DivisionCode__c,Host_AreaCode__c,SectorCode__c,SegmentCode__c,Subject_AreaCode__c
                           From TFOAC_Journal__c where id=:journalId Limit 1];
    }
    
    public Boolean validateProductRequiredFields(){
        Boolean vailidProduct = true;
        system.debug(productToCreate +'Validations under apex');
        if(productToCreate.OACOpportunity__c != null){
            currentOpportunity  = [Select RecordTypeId, CurrencyIsoCode,id,Host_Areas__c,Name From TFOAC_Opportunity__c Where Id =:productToCreate.OACOpportunity__c Limit 1];
            productToCreate.CurrencyIsoCode = currentOpportunity.CurrencyIsoCode;
        }else{
            currentOpportunity = null;
            productToCreate.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        } 
        
        if(productToCreate.Name == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Name is required'));
            productToCreate.Name.addError('Error Field is required');
            vailidProduct = false;
        }
        if(productToCreate.CurrencyIsoCode == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Product Currency is required'));
            productToCreate.CurrencyIsoCode.addError('Error Field is required');
            vailidProduct = false;
        }
        if(currentOpportunity != null && currentOpportunity.Host_Areas__c != null && (currentOpportunity.Host_Areas__c != 'Multiple Host Areas' && currentOpportunity.Host_Areas__c != 'Digital Content') &&  productToCreate.Host_AreaCode__c != null){
            //&& !currentOpportunity.Host_Areas__c.containsIgnoreCase(productToCreate.HostGroup__c)
            List<TFOAC_Hierarchy_Code__c> selectedCodeName = [Select Name FROM TFOAC_Hierarchy_Code__c WHERE id =:productToCreate.Host_AreaCode__c];
            if(!selectedCodeName.isEmpty() && !currentOpportunity.Host_Areas__c.containsIgnoreCase(selectedCodeName.get(0).Name)){
                productToCreate.Host_AreaCode__c.addError('Host area for the Journal must match the Host area for the Opportunity:'+currentOpportunity.Host_Areas__c.replace(';',' OR '));
                vailidProduct = false;    
            }
            
            
            
        }

        return vailidProduct;
    }
    
    public void resetFlag(){
        
    }
    
    public void setHostAreaVisibility(){
        
    }

    public void resetFieldsWhenDivisionChange(){
         productToCreate.Host_AreaCode__c = null;
         productToCreate.SectorCode__c = null;
         productToCreate.SegmentCode__c = null;
         productToCreate.Subject_AreaCode__c = null;
    }

    public void resetFieldsWhenHostAreaChange(){
         productToCreate.SectorCode__c = null;
         productToCreate.SegmentCode__c = null;
         productToCreate.Subject_AreaCode__c = null;
    }

    public void resetFieldsWhenSegmentChange(){
         productToCreate.SectorCode__c = null;
         productToCreate.Subject_AreaCode__c = null;
    }

    public void resetFieldsWhenSectorChange(){
         productToCreate.Subject_AreaCode__c = null;
    }

    public PageReference sharingPage(){
        return new PageReference('/p/share/CustomObjectSharingDetail?parentId='+this.productToCreate.id);
    }

    public PageReference checkCurrentAcqType(){
        ApexPages.getMessages().clear();
        system.debug(LoggingLevel.ERROR,'Current contract type is:'+productToCreate.AcqType__c+'AcqType__c');
        return null;
    }
}