/* 
 * Updated by Tom Reed 2018.02.24 - CHG0041784 - Add additional HA Groups
 *updated by chetan Bhatla 13/06/2018 - CHG0044797 - add UK and USA public groups
*/

public with sharing class TFOAC_OpportunityTriggerClass {

    public static void checkHostAreaForInsert(List<TFOAC_Opportunity__c> newOpps){
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Opportunity__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        List<TFOAC_Opportunity__c> newHostAreaOpps = new List<TFOAC_Opportunity__c>();
        for(TFOAC_Opportunity__c opp: newOpps){
            if(opp.RecordTypeId == rt.get(0).Id){
                updateHostAreaTextField(opp);
                newHostAreaOpps.add(opp);
            }
        }
        List<GroupMember> groupMembers = [SELECT Id, GroupId, Group.DeveloperName FROM GroupMember WHERE Group.DeveloperName IN: getHostAreaEditGroupNames() AND UserOrGroupId =: UserInfo.getUserId()];
        Map<String, String> nameMapping = getGroupNameToHostAreaMapping();
        for(TFOAC_Opportunity__c opp : newHostAreaOpps){
            Boolean hasPermission = false;
            //allow for empty host areas
            if(opp.Host_Areas__c == null){
                continue;
            }
            for(GroupMember gm : groupMembers){
                if(opp.Host_Areas__c != null && (opp.Host_Areas__c == 'Multiple Host Areas' || opp.Host_Areas__c.contains(nameMapping.get(gm.Group.DeveloperName)))){
                    hasPermission = true;
                    break;
                }
            }
            
            if(!hasPermission){
                opp.addError('Doesn\'t have access to opportunity with host areas: ' + opp.Host_Areas__c);
            }
        }
    }
    
    public static void checkPublishOfficeValidation(List<TFOAC_Opportunity__c> newOpps){
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Opportunity__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        List<TFOAC_Opportunity__c> newPubOffOpps = new List<TFOAC_Opportunity__c>();
        for(TFOAC_Opportunity__c opp: newOpps){
            if(opp.RecordTypeId == rt.get(0).Id){
                newPubOffOpps.add(opp);
            }
        }
        List<GroupMember> groupMembers = [SELECT Id, GroupId, Group.DeveloperName FROM GroupMember WHERE Group.DeveloperName IN: getGroupNameToPublishingOfficeMapping().keySet() AND UserOrGroupId =: UserInfo.getUserId()];
        if(groupMembers.isEmpty()){
            //if user don't belongs to publick office it's mean he he is UK or US based user
            //and is allowed to create under any publishing office
            return;
        }
        
        for(TFOAC_Opportunity__c opp : newPubOffOpps){
            Boolean hasPermission = false;
            //allow for empty host areas
            if(opp.Publishing_office__c == null){
                continue;
            }
            for(GroupMember gm : groupMembers){
           // updated by chetan Bhatla 13/06/2018 - CHG0044797
              if((opp.Publishing_office__c != null && opp.Publishing_office__c.contains(getGroupNameToPublishingOfficeMapping().get(gm.Group.DeveloperName))) || checkIfUserIsAdministrator()||checkIfUserIsAssignedPermissionSet()){
                    hasPermission = true;
                    break;
                }
            }
            
            if(!hasPermission){
                opp.addError('Doesn\'t have access to opportunity with Publishing office: ' + opp.Publishing_office__c);
            }
        }
    }
    
    public static void checkPublishOfficeProductValidation(List<TFOAC_Journal__c> newProducts){
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Journal__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){ return;}
           
        
        Map<Id,TFOAC_Journal__c> newPubOffProduct = new Map<Id,TFOAC_Journal__c>();
        for(TFOAC_Journal__c prod: newProducts){
            if(prod.RecordTypeId == rt.get(0).Id){
                newPubOffProduct.put(prod.id,prod);
            }
        }
        List<GroupMember> groupMembers = [SELECT Id, GroupId, Group.DeveloperName FROM GroupMember WHERE Group.DeveloperName IN: getGroupNameToPublishingOfficeMapping().keySet() AND UserOrGroupId =: UserInfo.getUserId()];
        if(groupMembers.isEmpty()){
            //if user don't belongs to publick office it's mean he he is UK or US based user
            //and is allowed to create under any publishing office
            return;
        }
        
        for(TFOAC_Journal__c joural : [Select OACOpportunity__r.Publishing_office__c From TFOAC_Journal__c Where Id in :newPubOffProduct.keySet()]){
            Boolean hasPermission = false;
            //allow for empty host areas
            if(joural.OACOpportunity__r.Publishing_office__c == null){
                continue;
            }
            for(GroupMember gm : groupMembers){
                if((joural.OACOpportunity__r.Publishing_office__c != null && joural.OACOpportunity__r.Publishing_office__c.contains(getGroupNameToPublishingOfficeMapping().get(gm.Group.DeveloperName))) || checkIfUserIsAdministrator()||checkIfUserIsAdministrator()){
                    hasPermission = true;
                    break;
                }
            }
            
            if(!hasPermission){
                newPubOffProduct.get(joural.id).addError('Doesn\'t have access to opportunity with Publishing office: ' + joural.OACOpportunity__r.Publishing_office__c);
            }
        }
    }
     
   
    public static void checkHostAreaForUpdate(Map<Id, TFOAC_Opportunity__c> newMap, Map<Id, TFOAC_Opportunity__c> oldMap){
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Opportunity__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        List<TFOAC_Opportunity__c> changedHostAreaOpps = new List<TFOAC_Opportunity__c>();
        for(Id oppId: newMap.keySet()){
            if(newMap.get(oppId).RecordTypeId == rt.get(0).Id){
                updateHostAreaTextField(newMap.get(oppId));
                if(newMap.get(oppId).Host_Areas__c != oldMap.get(oppId).Host_Areas__c){
                    changedHostAreaOpps.add(newMap.get(oppId));
                }else if(newMap.get(oppId).NDA_status__c != oldMap.get(oppId).NDA_status__c){
                    changedHostAreaOpps.add(newMap.get(oppId));
                }
            }
        }
        
        List<GroupMember> groupMembers = [SELECT Id, GroupId, Group.DeveloperName FROM GRoupMember WHERE Group.DeveloperName IN: getHostAreaEditGroupNames() AND UserOrGroupId =: UserInfo.getUserId()];
        Map<String, String> nameMapping = getGroupNameToHostAreaMapping();
        for(TFOAC_Opportunity__c opp : changedHostAreaOpps){
            Boolean hasPermission = false;
             if((opp.Host_Areas__c == null || opp.Host_Areas__c  == 'Multiple Host Areas')){
                continue;
            }
            for(GroupMember gm : groupMembers){
                if(opp.Host_Areas__c != null && opp.Host_Areas__c.contains(nameMapping.get(gm.Group.DeveloperName))){
                    hasPermission = true;
                    break;
                }
            }
           
            if(!hasPermission){
                opp.addError('Doesn\'t have access to opportunity with host areas: ' + opp.Host_Areas__c);
            }
        }
        
        //update opportunity Relationships
        if(!changedHostAreaOpps.isEmpty()){
            List<TFOAC_Relationship__c> relationsToUpdate = new List<TFOAC_Relationship__c>();
            for(TFOAC_Relationship__c rel : [Select Host_Area_Text__c,OpportunityID__c From TFOAC_Relationship__c where OpportunityID__c in : changedHostAreaOpps]){
                rel.Host_Area_Text__c = newMap.get(rel.OpportunityID__c).Host_Area_Text__c;
                rel.OpportunityNDAStatus__c = newMap.get(rel.OpportunityID__c).NDA_status__c;
                relationsToUpdate.add(rel);
            }
            
            update relationsToUpdate;
        }
    }
    
    public static void updateHostAreaForRelationships(Map<Id,TFOAC_Journal__c> newProductMap, Map<Id,TFOAC_Journal__c> oldProductMap){
        //proceess only T&F - Journal Products
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE SobjectType = 'TFOAC_Journal__c' AND DeveloperName = 'TFOAC' LIMIT 1];
        if(rt.size() == 0){
            return;
        }
        
        Set<Id> recordsToProcess = new Set<Id>();
        Set<Id> hierarchyCodeIds = new Set<Id>();
        Map<Id,TFOAC_Hierarchy_Code__c> hierarchyCodeMap = new Map<Id,TFOAC_Hierarchy_Code__c>();
         for(Id prodId: newProductMap.keySet()){
            if(newProductMap.get(prodId).RecordTypeId == rt.get(0).Id && newProductMap.get(prodId).Host_AreaCode__c != oldProductMap.get(prodId).Host_AreaCode__c){
                recordsToProcess.add(prodId);
                hierarchyCodeIds.add(newProductMap.get(prodId).Host_AreaCode__c);
            }else if(newProductMap.get(prodId).RecordTypeId == rt.get(0).Id && (newProductMap.get(prodId).AcqType__c != oldProductMap.get(prodId).AcqType__c) && newProductMap.get(prodId).AcqType__c =='Digital Content'){
                recordsToProcess.add(prodId);
            }
        }
        system.debug('check hierarchy Code List: '+hierarchyCodeIds);
        if(!hierarchyCodeIds.isEmpty()){
            hierarchyCodeMap = new Map<Id,TFOAC_Hierarchy_Code__c>([Select id,Name FROM TFOAC_Hierarchy_Code__c WHERE id in: hierarchyCodeIds]);
        }

        if(!recordsToProcess.isEmpty()){
            //gather relationships records which refering to updated journal 
            List<TFOAC_Relationship__c> relationshipsToUpdate = new List<TFOAC_Relationship__c>();
            for(TFOAC_Relationship__c relationItem : [Select Host_Area_Text__c,ProductID__c From TFOAC_Relationship__c where ProductID__c in : recordsToProcess]){
                if(newProductMap.get(relationItem.ProductID__c).AcqType__c == 'Digital Content'){
                    relationItem.Host_Area_Text__c = getHostAreaTextField(newProductMap.get(relationItem.ProductID__c).AcqType__c);
                }else if(hierarchyCodeMap.containsKey(newProductMap.get(relationItem.ProductID__c).Host_AreaCode__c)){

                    relationItem.Host_Area_Text__c = getHostAreaTextField(hierarchyCodeMap.get(newProductMap.get(relationItem.ProductID__c).Host_AreaCode__c).Name);    
                }
                
                relationItem.OpportunityNDAStatus__c = 'None';
                relationshipsToUpdate.add(relationItem);
            }
            
            update relationshipsToUpdate;
        }
        
        
    }
    
    private static Map<String, String> getGroupNameToHostAreaMapping(){
        Map<String, String> nameMapping = new Map<String,String>();
        nameMapping.put('T_F_HA_Politics_Planning_Sport_Edit', 'Politics, Sport, Planning & Area Studies');
        nameMapping.put('T_F_HA_Arts_Humanities_Edit', 'Arts & Humanities');
        nameMapping.put('T_F_HA_Behavioral_Science_Social_Edit', 'Behavioral Sciences & Social Care');
        nameMapping.put('T_F_HA_Business_Economics_Sociology_Edit', 'Business, Economics and Sociology');
        nameMapping.put('T_F_HA_Education_Edit', 'Education');
        nameMapping.put('T_F_HA_Allied_Public_Health_Edit', 'Allied & Public Health');
        nameMapping.put('T_F_HA_Biological_Earth_Environment_Edit', 'Biological, Earth and Environmental Science');
        nameMapping.put('T_F_HA_Engineering_IT_App_Science_Edit', 'Engineering IT & Applied Sciences');
        nameMapping.put('T_F_HA_Medicine_Health_Sciences_Edit', 'Medicine & Health Science');
        nameMapping.put('T_F_HA_Science_Mathematics_Edit', 'Physical Sciences & Mathematics');
        nameMapping.put('T_F_HA_Digital_Content_Edit','Digital Content');
        nameMapping.put('T_F_Physical_Science_and_Engineering','Physical Science and Engineering'); //CHG0041784
        nameMapping.put('TF_HA_GeogInfoScienceSportheritage_Edit','Geography, Information Science, Sport, Heritage'); //CHG0041784
        return nameMapping;
    }
    
    public static Map<String, String> getGroupNameToPublishingOfficeMapping(){
        Map<String, String> nameMapping = new Map<String,String>();
        nameMapping.put('T_F_HA_Australia_Edit','Australia');
        nameMapping.put('T_F_HA_Canada','Canada');
        nameMapping.put('T_F_HA_India_Edit','India');
        nameMapping.put('T_F_HA_Scandinavia_Edit','Scandinavia');
        nameMapping.put('T_F_HA_South_Africa_Edit','South Africa');
        nameMapping.put('T_F_HA_Asia_Pacific_China','Asia Pacific & China');
        //updated by chetan Bhatla 13/06/2018 - CHG0044797 - add UK and USA public groups
        nameMapping.put('T_F_HA_UK_Edit','UK');
        nameMapping.put('T_F_HA_USA_Edit','USA');
        return nameMapping;
    }
    
    public static Set<String> getHostAreaEditGroupNames(){
        Set<String> groupNames = new Set<String>();
        groupNames.add('T_F_HA_Politics_Planning_Sport_Edit');
        groupNames.add('T_F_HA_Arts_Humanities_Edit');
        groupNames.add('T_F_HA_Behavioral_Science_Social_Edit');
        groupNames.add('T_F_HA_Business_Economics_Sociology_Edit');
        groupNames.add('T_F_HA_Education_Edit');
        groupNames.add('T_F_HA_Allied_Public_Health_Edit');
        groupNames.add('T_F_HA_Biological_Earth_Environment_Edit');
        groupNames.add('T_F_HA_Engineering_IT_App_Science_Edit');
        groupNames.add('T_F_HA_Medicine_Health_Sciences_Edit');
        groupNames.add('T_F_HA_Science_Mathematics_Edit');
        groupNames.add('T_F_HA_Digital_Content_Edit');
        groupNames.add('T_F_Physical_Science_and_Engineering'); //CHG0041784
        groupNames.add('TF_HA_GeogInfoScienceSportheritage_Edit'); //CHG0041784
        return groupNames;
    }
    
    
    private static void updateHostAreaTextField(TFOAC_Opportunity__c opp){
        system.debug('************ opp: ' + opp);
        if(opp.Host_Areas__c == null) return;
        String hostAreaText = '';
        if(opp.Host_Areas__c == 'Allied & Public Health'){
            hostAreaText += 'APH;';
        }
        if(opp.Host_Areas__c == 'Politics, Sport, Planning & Area Studies'){
            hostAreaText += 'APIPS;';
        }
        if(opp.Host_Areas__c == 'Arts & Humanities'){
            hostAreaText += 'AH;';
        }
        if(opp.Host_Areas__c == 'Behavioral Sciences & Social Care'){
            hostAreaText += 'BSSC;';
        }
        if(opp.Host_Areas__c == 'Biological, Earth and Environmental Science'){
            hostAreaText += 'BEES;';
        }
        if(opp.Host_Areas__c == 'Business, Economics and Sociology'){
            hostAreaText += 'BES;';
        }
        if(opp.Host_Areas__c == 'Education'){
            hostAreaText += 'EDC;';
        }
        if(opp.Host_Areas__c == 'Engineering IT & Applied Sciences'){
            hostAreaText += 'EIAS;';
        }
        if(opp.Host_Areas__c == 'Medicine & Health Science'){
            hostAreaText += 'MHS;';
        }
        if(opp.Host_Areas__c == 'Physical Sciences & Mathematics'){
            hostAreaText += 'PSM;';
        }
        
        if(opp.Host_Areas__c == 'Digital Content'){
            hostAreaText += 'DC;';
        }
        
       if(opp.Host_Areas__c == 'Physical Science and Engineering'){ //CHG0041784
            hostAreaText += 'PSE;';
        }
        
       if(opp.Host_Areas__c == 'Geography, Information Science, Sport, Heritage'){ //CHG0041784
            hostAreaText += 'GISH;';
       }
        
        if(hostAreaText != ''){
            hostAreaText = hostAreaText.substring(0,hostAreaText.length()-1);
        }
        
        opp.Host_Area_Text__c = hostAreaText;
        system.debug('************ opp2: ' + opp);
    }
    
    public static String getHostAreaTextField(String hostArea){
        system.debug('************ execute getHostAreaTextField: ' + hostArea);
        
        String hostAreaText = '';
        
        if(hostArea == 'Allied & Public Health'){
            hostAreaText += 'APH';
        }
        if(hostArea == 'Politics, Sport, Planning & Area Studies'){
            hostAreaText += 'APIPS';
        }
        if(hostArea == 'Arts & Humanities'){
            hostAreaText += 'AH';
        }
        if(hostArea == 'Behavioral Sciences & Social Care'){
            hostAreaText += 'BSSC';
        }
        if(hostArea == 'Biological, Earth and Environmental Science'){
            hostAreaText += 'BEES';
        }
        if(hostArea == 'Business, Economics and Sociology'){
            hostAreaText += 'BES';
        }
        if(hostArea == 'Education'){
            hostAreaText += 'EDC';
        }
        if(hostArea == 'Engineering IT & Applied Sciences'){
            hostAreaText += 'EIAS';
        }
        if(hostArea == 'Medicine & Health Science'){
            hostAreaText += 'MHS';
        }
        if(hostArea == 'Physical Sciences & Mathematics'){
            hostAreaText += 'PSM';
        }
        if(hostArea == 'Digital Content'){
            hostAreaText += 'DC';
        }
        if(hostArea == 'Physical Science and Engineering'){ //CHG0041784
            hostAreaText += 'PSE';
        }
        if(hostArea == 'Geography, Information Science, Sport, Heritage'){ //CHG0041784
            hostAreaText += 'GISH';
       }
         system.debug('************ exit getHostAreaTextField: ' + hostAreaText);
        return hostAreaText;
       
    }
    
    private static Boolean checkIfUserIsAdministrator(){
        for(Profile p: [Select id From Profile where Name = 'System Administrator' or  Name = 'T&F Acquisition Super User' or Name = 'T&F Acquisition Administrator' or Name = 'T&F OAC Power Plus User' or Name = 'T&F OAC Super User' or Name = 'T&F OAC Administrator']){
            if(p.id == UserInfo.getProfileId()){
                return true;
            }
        }
        return false;
        
    }
    
    //updated by chetan Bhatla 13/06/2018 - CHG0044797 
    private static Boolean checkIfUserIsAssignedPermissionSet(){
    
        List<AggregateResult> results = [SELECT count(Id) from PermissionSetAssignment where AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'T_F_OAC_System_Admin'];
        if(results.Size()> 0){
            return true;
        }
        else
        { return false;
        
        }
    }
}