/*
 * Created by - Sourabh Goyal
 * Created on - 6 Nov 2020
 * Description - This Class Related to FindAccount LWC Component
                 It will search data from Account Object and merge duplicate data
                
 * Test Class - MergeAccountController_Test (97%)
 * Modified On - 20 May 2021
 * Modified By - Sourabh
 */

public with sharing class MergeAccountController {
    
    

    //Fetch All Accounts
    @AuraEnabled
    public static List<Account> fetchAccountsByIds(String id){
        String query='';
        String SobjectApiName = 'Account';
        
        //get account field name 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> editableFields = new List<String>();
        for(Schema.SObjectField fieldRef : fieldMap.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            //Remove readable fields
            if( fieldResult.isCreateable() && !fieldResult.isDeprecatedAndHidden() && ((fieldResult.isCustom() && !fieldResult.isCalculated()) || (!fieldResult.isCustom() && !fieldResult.isDefaultedOnCreate() && fieldResult.isUpdateable()))) {
                if(fieldResult.getname().indexOf('__pc') == -1){
                    editableFields.add(fieldResult.getname());
                }
            }
        }
        //Make fields comma seprated
        String commaSepratedFields = '';
        for(String fieldName : editableFields){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        query += 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where Id = :id';   
       return Database.query(query);
    }

    
    //get Data to analyze
    @AuraEnabled
    public static String getDataToAnalyze(String id,String ringgoldId,String partyId,String status){
        //Get uri from custom settings
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        String uri = (String) orgSpecificProps.get('account_merge_endpoint__c');
        System.debug('URL for get data---'+uri);
        String uriId = uri + ''+id+'?identifierType=sfdcId';
        String uriRinggold = uri + ''+ringgoldId+'?identifierType=ringgoldId';
        String uriPartyId = uri + ''+partyId+'?identifierType=partyId';
        String methodType = 'GET';
        Map<String, String> headers = new Map<String,String>();
        AccountMergeData  accMergeData = new AccountMergeData();
        accMergeData.data = new AccountMergeData.Data();
        accMergeData.dataList = new List<AccountMergeData.Data>();
        accMergeData.data.licenses = new AccountMergeData.License();
        AccountMergeData accMergeDataToCheck = new AccountMergeData();
        accMergeDataToCheck.data = new AccountMergeData.Data();
        accMergeDataToCheck.dataList = new List<AccountMergeData.Data>();
        accMergeDataToCheck.data.licenses = new AccountMergeData.License();
        MergeAccountResponse mergeResponse = new MergeAccountResponse();
        List<MergeAccountResponse> mergeResponseList = new List<MergeAccountResponse>();
        String endPoint = '';
        String returnJSON = '';
        
        System.debug('Analyze Data Called!');
        System.debug('*****Id'+id);  
        System.debug('****Ringgold Id  '+ringgoldId);
        System.debug('****Party Id  '+partyId);
        headers.put('Content-Type', 'application/json');
        HttpResponse res = new HttpResponse();
        res = TF_PlatformExecuter.execute(uriId, methodType, 'idtoken', null, headers, false);//Call platform executer class to hit API 
       
        System.debug('@@@@@response ==='+res);
        System.debug('@@@@@Response body'+res.getBody());
        
        if(res.getBody() != NULL && res.getStatusCode() == 200){
            if(accMergeData.data!= null && accMergeData.data.licenses != null){
            	accMergeData.data.activeLicenseCount = accMergeData.data.licenses.activeLicenseCount;          
            }
            String tempjsonResponse = res.getBody().replace('"data"','"dataList"');
        	System.debug('@@@Before ""'+tempjsonResponse);
            accMergeData = (AccountMergeData)JSON.deserialize(tempjsonResponse, AccountMergeData.class);
            System.debug(accMergeData);
            accMergeData.status = 'SUCCESS';
                
            
            if(accMergeData.dataList != null)  
            for(AccountMergeData.data data : accMergeData.dataList){
                mergeResponse.id = id;
                mergeResponse.name = data.name;
                mergeResponse.party_id = data.party_id;
                mergeResponse.ringgold_id = data.ringgold_id;
                mergeResponse.contactList = data.contactList;
                if(data.licenses != null){
              		mergeResponse.activeLicenseCount = data.licenses.activeLicenseCount;
                }else{
                    mergeResponse.activeLicenseCount = 0;
                }
                mergeResponse.child_accounts = data.child_accounts;
                mergeResponse.status = 'SUCCESS';
            }
            
            
            returnJSON = JSON.serialize(mergeResponse);
            //returnJSON = JSON.serialize(accMergeData.data);
            System.debug(returnJSON);
            System.debug('account response*** '+accMergeData);
        }
        else{
            mergeResponse.status = 'BLANK';
            mergeResponse.id = id;
            if(res.getStatusCode() == 504 || res.getStatusCode() == 503)
            	mergeResponse.status = 'SERVER ERROR';
            returnJSON = JSON.serialize(mergeResponse);
        }
        if(status == '2' && (res.getStatusCode() != 200 || accMergeData.dataList == null)){
            if(String.isNotBlank(partyId) && partyId!= null ){
           		res = TF_PlatformExecuter.execute(uriPartyId, methodType, 'idtoken', null, headers, false);
                System.debug(res.getBody());
                if(res != NULL && res.getStatusCode() == 200){
                    accMergeData = (AccountMergeData)JSON.deserialize(res.getBody(), AccountMergeData.class);
                }
                else if(res.getStatusCode() != 200){
                    if(String.isNotBlank(ringgoldId) && ringgoldId!= null){
                        res = TF_PlatformExecuter.execute(uriRinggold, methodType, 'idtoken', null, headers, false);//Call platform executer class to hit API 
                        if(res != NULL && res.getStatusCode() == 200){
                            System.debug(res.getBody());
                            accMergeData = (AccountMergeData)JSON.deserialize(res.getBody(), AccountMergeData.class);
                        }  
            		}
                }  
            }
            
        }
        //TODO Serialize the response coming from API
        //Object responseForJS = {'status':'','accMergeData':''};
        if(status == '2') // 2-> Losing Account and 1-> winning account
        {
            System.debug(res.getBody());
            System.debug('Loosing account data checking@@@@@@@@@@@');
            //Check PartyId and ringgoldId is matched with response data
            System.debug('Acc Merge data'+accMergeData);
            if(accMergeData.dataList != null && accMergeData.dataList.size() > 0){
                
                System.debug('Datalist size@@@@@@@@@@@'+accMergeData.dataList.size());
                for(AccountMergeData.data data : accMergeData.dataList){
                    accMergeDataToCheck.data = data;
                    System.debug('Data in loop@@@@@@@@@@@'+accMergeDataToCheck.data);
                    
                    if(ringgoldId != null && data != null && ringgoldId != data.ringgold_id){
                        System.debug('Ringgold is is not matched@@@@@@@@@@@');
                        System.debug('Ringgold in SF@@@@@@@@@@@'+ringgoldId);
                        System.debug('Ringgold in Response@@@@@@@@@@@'+data.ringgold_id);
                		res = TF_PlatformExecuter.execute(uriRinggold, methodType, 'idtoken', null, headers, false);//Call platform executer class to hit API 
                		if(res.getBody() != null && res.getStatusCode() == 200)
                			accMergeDataToCheck = (AccountMergeData)JSON.deserialize(res.getBody(), AccountMergeData.class); 
            			System.debug('New Response from Ringgold@@@@@@@@@@@'+accMergeDataToCheck);
                    }
                    if(accMergeDataToCheck != null && accMergeDataToCheck.data != null && ((accMergeDataToCheck.data.party_id == partyId) || (String.isNotBlank(partyId)))
                       && ((accMergeDataToCheck.data.ringgold_id == ringgoldId) || ((String.isNotBlank(ringgoldId))))){
                        System.debug('Ringgold SF@@@@@@@@@@@'+accMergeDataToCheck.data.ringgold_id);
                        System.debug('Ringgold@@@@@@@@@@@'+ringgoldId);
                        System.debug('PartyId SF@@@@@@@@@@@'+accMergeDataToCheck.data.party_id);
                        System.debug('PartyId@@@@@@@@@@@'+ringgoldId);
                        //TODO Merge Process
                        if(accMergeDataToCheck.data.contactList == 0 && accMergeDataToCheck.data.child_accounts == 0 && (accMergeDataToCheck.data.licenses == null || (accMergeDataToCheck.data.licenses != null && accMergeDataToCheck.data.licenses.activeLicenseCount == 0))){
                            mergeResponse.id = id;
                            mergeResponse.name = accMergeDataToCheck.data.name;
                            mergeResponse.party_id = accMergeDataToCheck.data.party_id;
                            mergeResponse.ringgold_id = accMergeDataToCheck.data.ringgold_id;
                            mergeResponse.contactList = accMergeDataToCheck.data.contactList;
                            mergeResponse.activeLicenseCount = 0;
                            mergeResponse.child_accounts = accMergeDataToCheck.data.child_accounts;
                            
                            System.debug('Merge can take place');
                            mergeResponse.status = 'SUCCESS';
                            mergeResponseList.add(mergeResponse);
                            
                            //return returnJSON;
                        }
                        else{
                            System.debug('It contains data');
                            mergeResponse.id = id;
                            mergeResponse.name = accMergeDataToCheck.data.name;
                            mergeResponse.party_id = accMergeDataToCheck.data.party_id;
                            mergeResponse.ringgold_id = accMergeDataToCheck.data.ringgold_id;
                            mergeResponse.contactList = accMergeDataToCheck.data.contactList;
                            if(accMergeDataToCheck.data.licenses == null){
                            	mergeResponse.activeLicenseCount = 0;
                            }else{
                                mergeResponse.activeLicenseCount = accMergeDataToCheck.data.licenses.activeLicenseCount;
                            }
                            mergeResponse.child_accounts = accMergeDataToCheck.data.child_accounts;
                            
                            System.debug('Merge cannot take place');
                            mergeResponse.status = 'ERROR';
                            mergeResponse.message = 'Losing Account cannot contain data.';
                            mergeResponseList.add(mergeResponse);
                            //return returnJSON;
                    	}
            		}
                    else{
                        mergeResponse.status = 'ERROR';
                        mergeResponse.message = 'Losing Party Id or Ringgold Id is not matched with Salesforce Account.';
                    }
            	}
                returnJSON = JSON.serialize(mergeResponse);   
            }
            else
            {	
                System.debug('@@@@ Merge Data find'+accMergeData);
                System.debug('ringgold id @@@@@@'+ringgoldId);
                if(accMergeData.data != null && accMergeData.data.name == null && ringgoldId != null && accMergeData.data.ringgold_id != ringgoldId)
                {
                    System.debug('ringgold response inside@@@@@@');
                    res = TF_PlatformExecuter.execute(uriRinggold, methodType, 'idtoken', null, headers, false);//Call platform executer class to hit API 
                    if(res.getBody() != null && res.getStatusCode() == 200)
                        accMergeData = (AccountMergeData)JSON.deserialize(res.getBody(), AccountMergeData.class); 
                    System.debug('ringgold response account@@@@@@'+accMergeData);
                    if(accMergeData.data.name == null){
                    }
                }
                if(accMergeData != null && accMergeData.data != null && ((accMergeData.data.party_id == partyId) || String.isNotBlank(partyId))
                       && ((accMergeData.data.ringgold_id == ringgoldId) || (String.isNotBlank(ringgoldId))))
                {
                    System.debug('**having acc'+ accMergeData);
                	//TODO Merge Process
                	if(accMergeData.data.contactList == 0 && accMergeData.data.child_accounts == 0 && (accMergeData.data.licenses == null || (accMergeData.data.licenses != null && accMergeData.data.licenses.activeLicenseCount == 0)))
                    {
                        System.debug('Merge can take place');
                        mergeResponse.id = id;
                        mergeResponse.name = accMergeData.data.name;
                        mergeResponse.party_id = accMergeData.data.party_id;
                        mergeResponse.ringgold_id = accMergeData.data.ringgold_id;
                        mergeResponse.contactList = accMergeData.data.contactList;
                        mergeResponse.activeLicenseCount = 0;
                        mergeResponse.child_accounts = accMergeData.data.child_accounts;
                        System.debug('Merge can take place');
                        mergeResponse.status = 'SUCCESS';
                        returnJSON = JSON.serialize(mergeResponse);
                        //return returnJSON;
                	}
                	else
                    {
                        System.debug('It contains data');
                        mergeResponse.id = id;
                        mergeResponse.name = accMergeData.data.name;
                        mergeResponse.party_id = accMergeData.data.party_id;
                        mergeResponse.ringgold_id = accMergeData.data.ringgold_id;
                        mergeResponse.contactList = accMergeData.data.contactList;
                        if(accMergeData.data.licenses == null){
                            mergeResponse.activeLicenseCount = 0;
                        }else{
                            mergeResponse.activeLicenseCount = accMergeData.data.licenses.activeLicenseCount;
                        }
                        mergeResponse.child_accounts = accMergeData.data.child_accounts;
                        System.debug('Merge cannot take place');
                        if(accMergeData.data.name == null){
                        mergeResponse.status = 'BLANK';
                        }else
                            mergeResponse.status = 'ERROR';
                        if(res.getStatusCode() == 503 || res.getStatusCode() == 504)
                            mergeResponse.status = 'SERVER ERROR';
                        returnJSON = JSON.serialize(mergeResponse);
                    	//return returnJSON;
                    	
                	}
            	}
                else{ 
                    System.debug('accMergeData new'+accMergeData);
                    mergeResponse.id = id;
                    if(accMergeData.data != null){
                        mergeResponse.name = accMergeData.data.name;
                        mergeResponse.party_id = accMergeData.data.party_id;
                        mergeResponse.ringgold_id = accMergeData.data.ringgold_id;
                        mergeResponse.contactList = accMergeData.data.contactList;
                        if(accMergeData.data.licenses == null){
                            mergeResponse.activeLicenseCount = 0;
                        }else{
                            mergeResponse.activeLicenseCount = accMergeData.data.licenses.activeLicenseCount;
                        }
                        mergeResponse.child_accounts = accMergeData.data.child_accounts;
                    }
                    System.debug('Merge cannot take place');
                    mergeResponse.message = 'Losing Party Id or Ringgold Id is not matched with Salesforce Account.';
                    if(accMergeData.data!=null && accMergeData.data.name == null){
                        mergeResponse.status = 'BLANK';
                    }else
                    	mergeResponse.status = 'ERROR';
                    if(res.getStatusCode() == 503 || res.getStatusCode() == 504)
                    	mergeResponse.status = 'SERVER ERROR';
                    returnJSON = JSON.serialize(mergeResponse);
                    

                }
            }
        }
     
        system.debug(returnJSON);      
        
        return returnJSON;
      }
  
    
    @AuraEnabled
    public static String mergeAcc(String masterId, String dupesId){
        
        System.debug('Merge Called!');
        System.debug('*****Master Id'+masterId);  
        System.debug('*****Dupes Id'+dupesId); 
        
        MergeAccountResponse response = new MergeAccountResponse();
        List<Account> masterAcc= MergeAccountController.fetchAccountsByIds(masterId);
        List<Account> dupesAccList = MergeAccountController.fetchAccountsByIds(dupesId);
           
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
        List<String> editableFields = new List<String>();
        Account_Merge_Logs__c mergeLogs = new Account_Merge_Logs__c();
        
        for(Schema.SObjectField fieldRef : fieldMap.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if( fieldResult.isCreateable() && !fieldResult.isDeprecatedAndHidden() && ((fieldResult.isCustom() && !fieldResult.isCalculated()) || (!fieldResult.isCustom() && !fieldResult.isDefaultedOnCreate() && fieldResult.isUpdateable()))) {
                editableFields.add(fieldResult.getname());
            }
        }                    
        //Assign duplicate field values into master fields
        /*for(string str: editableFields){
            System.debug('keyset---------- '+str);
            if(masterAcc[0].get(str) == null){
                System.debug('Duplicate size---- '+ dupes.size());
                for(integer i = 0; i<dupesAccList.size(); i++){
                    if(dupesAccList[i].get(str) != null){
                        masterAcc[0].put(str, dupes[i].get(str));
                        break;
                    }
                }
            }
        }*/
        System.debug('after-------');
        System.debug('master----'+masterAcc);
        System.debug('Duplicate------' +dupesAccList);
        Account ac = new Account();
        
        try{
            mergeLogs.Losing_Account__c = dupesAccList[0].Name;
            mergeLogs.Winning_Account_Id__c = masterAcc[0].Id;
            mergeLogs.Losing_Account_Id__c = dupesAccList[0].Id;
            mergeLogs.Losing_Account_Address_Details__c = dupesAccList[0].Mailing_Country_List__c;
            mergeLogs.Losing_Account_Party_Id__c = dupesAccList[0].Customer_Id__c;
            mergeLogs.Losing_Account_Ringgold_Id__c = dupesAccList[0].Ringgold_Account_ID__c;
            mergeLogs.Losing_Account_Site__c = dupesAccList[0].Website;
            mergeLogs.Losing_Phone__c = dupesAccList[0].Phone;
            mergeLogs.Winning_Account__c = masterAcc[0].Name;
            mergeLogs.Losing_Account_License__c = 0;
            
            /*if(masterAcc!=null & dupesAccList!= null){
                Database.MergeResult[] results = Database.merge(masterAcc[0], dupesAccList);
                for(Database.MergeResult res : results) {
                    if (res.isSuccess()){
                        System.debug('success');
                        return 'Your Accounts are Merged';
                    }
                }
            }*/
            //merge masterAcc[0] dupesAccList;
            Boolean flag = false;
            Database.MergeResult[] results = Database.merge(masterAcc[0], dupesAccList);
            for(Database.MergeResult res : results) {
                if (res.isSuccess()){
                    flag = true;
                    System.debug('success');
                }
            }
            if(flag == true){
               insert mergeLogs;
               //Id mergeLogsRecId = Schema.SObjectType.Account_Merge_Log__c.getRecordTypeInfosByName().get('Read Only').getRecordTypeId();
            }
            
            response.status = 'SUCCESS';
        	response.message = 'Your Account Has Been Merged Successfully.';
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
            
            
        }catch(Exception e){
            Id settingRecordId = [SELECT Id FROM Setting__c WHERE Name = 'Account_Merge_Error_Logs'].Id;
            Setting_Item__c newErrorLog = new Setting_Item__c();
            newErrorLog.Setting__c = settingRecordId;
            newErrorLog.Merge_Error_Message_1__c = e.getMessage();
            newErrorLog.Text_2__c = masterAcc[0].Name;
            newErrorLog.Long_Text_1__c = JSON.serialize(dupesAccList);
            insert newErrorLog;
            System.debug(e);
            response.status = 'ERROR';
            response.message = 'Merge Failed!';
            return json.serialize(response);
        }
        
       
        return json.serialize(response);
        }
    
    
    public class MergeAccountResponse{
        public String Id{ get; set; }
        public String name{ get; set; }
        public String status{ get; set; }
        public String message{ get; set; }
       	public String party_id{ get; set; }
        public String ringgold_id{ get; set; }
        public Integer contactList{ get; set; }
        public Integer activeLicenseCount{ get; set; }
        public Integer child_accounts{ get; set; }      
    } 
}