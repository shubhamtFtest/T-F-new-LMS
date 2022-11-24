public with sharing class TF_CsvGDPRUpload {
    public class WrapperEmpfDisplay{
        @AuraEnabled public string Email{get;set;}
        @AuraEnabled public string Status{get;set;}
        @AuraEnabled public string Reason{get;set;}
        @AuraEnabled public string SuccessOrFailure{get;set;}
    }
    @AuraEnabled
    public static list<WrapperEmpfDisplay> csvFileRead(Id contentDocumentId){
        list<Email_Preference__c> empfList = new list<Email_Preference__c>();
        Map<string,WrapperEmpfDisplay> mapstringempftoDisplay = new Map<string,WrapperEmpfDisplay>();
        List<WrapperEmpfDisplay> ListEmpfDisplay = new List<WrapperEmpfDisplay>();
       
         system.debug('hiiiiiii');
        system.debug('contentDocumentId'+contentDocumentId);
        
        if(contentDocumentId != null) {
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];

            system.debug('contentVersionObj'+contentVersionObj);
            // split the file data
            
             String hexResult = EncodingUtil.convertToHex(contentVersionObj.VersionData);
            final Integer bytesCount = hexResult.length() >> 1;
            String[] bytes = new String[bytesCount];
            for(Integer i = 0; i < bytesCount; ++i){
                bytes[i] =  hexResult.mid(i << 1, 2);
            }
           String csvAsString = EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'ISO-8859-1');
            
            


            
            // String csvBody = EncodingUtil.base64Encode(contentVersionObj.VersionData);
            list<String> csvRecordsList = csvAsString.split('\n');
             system.debug('csvRecordsList'+csvRecordsList);
            List<string> csvFileLinessplitting = new List<string>();
            csvFileLinessplitting=csvRecordsList[0].toLowerCase().split(',');
            system.debug('csvFileLinessplitting'+csvFileLinessplitting);
            integer indexEMail=csvFileLinessplitting.indexOf('email');
            system.debug('indexEMail'+indexEMail);
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                WrapperEmpfDisplay EmpfDisplay=new WrapperEmpfDisplay();
                
               Email_Preference__c emailprfrnce = new Email_Preference__c();
                list<String> csvRowData = csvRecordsList[i].split(',');
                System.debug('csvRowData====> '+csvRowData);
                emailprfrnce.email__c = csvRowData[indexEMail];             
                emailprfrnce.Reason__c = 'Book Purchasing Page Opt Out';
                emailprfrnce.Status__c = 'Unsubscribed';
                EmpfDisplay.Email=csvRowData[indexEMail];
                EmpfDisplay.Reason = 'Book Purchasing Page Opt Out';
                EmpfDisplay.Status = 'Unsubscribed';
                EmpfDisplay.SuccessOrFailure ='Success';
                empfList.add(emailprfrnce);
                if(emailprfrnce!=null && csvRowData[indexEMail]!=null){
                    mapstringempftoDisplay.put(string.valueOf(csvRowData[indexEMail].toLowerCase()),EmpfDisplay);
                    system.debug('mapstringempftoDisplay'+mapstringempftoDisplay);
                  //  mapstringempf.put(string.valueOf(csvRecordData[indexEMail].toLowerCase()),emailprfrnce);
                }
            }
Map<String,String> EmailErrorMap = new Map<String,String>();
            try{    
                Database.SaveResult[] SR = Database.insert(empfList, False);
                    System.debug('SaveResult: ' + SR);
                    System.debug('empfList: ' + empfList);        
                    
                    for(Integer i=0;i<SR.size();i++){
                        if(SR[i].isSuccess()){//only look at failures, or NOT Successes
                            System.debug('Successfully inserted account. Account ID: ' + sr[i].getId());
                        }
                        else{
                            system.debug('$$$$$$$$$'+SR[i].getErrors()[0].getMessage());
                            System.debug('$$$$$$$$$'+empfList[i].Email__c); //instead of debug, you could have an email processor something else that looks at that record and the error message
                            EmailErrorMap.put(empfList[i].Email__c,SR[i].getErrors()[0].getMessage());
                        }
                    }
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        List<Email_Preference__c> empfUpdateList= new List<Email_Preference__c>();
        if(!EmailErrorMap.isEmpty()){
            for(String errorEmail:EmailErrorMap.keySet()){
                system.debug('errorEmail'+errorEmail); 
                        if(EmailErrorMap.get(errorEmail).containsignorecase('duplicate value found:')){
                            system.debug('Hi'+ EmailErrorMap.get(errorEmail).substring(68));
                             Email_Preference__c empfUpdate=new Email_Preference__c();
                           id empfid;
                            system.debug(empfid);
                          if(!test.isRunningTest()){
                               empfid=EmailErrorMap.get(errorEmail).substring(68);
                            empfUpdate.id=empfid;
                            
                            }
                            if(empfUpdate.id!=null && empfUpdate.id!=''){
                                empfUpdate.Status__c='Unsubscribed';
                            empfUpdate.Reason__c='Book Purchasing Page Opt Out';
                            
                            empfUpdateList.add(empfUpdate);
                            }
                            
                            
                            mapstringempftoDisplay.get(errorEmail.toLowerCase()).SuccessOrFailure='Update Success';
                            system.debug('errorEmail'+errorEmail);
                            system.debug('EmailErrorMap'+EmailErrorMap);
                          // EmailErrorMap.remove(errorEmail);
                        }
                        if(!EmailErrorMap.get(errorEmail).containsignorecase('duplicate value found:')){
                            system.debug('inside EmailErrorMapLoop');
                            
                            mapstringempftoDisplay.get(errorEmail.toLowerCase()).SuccessOrFailure='Unsuccessful';
                            if(EmailErrorMap.get(errorEmail).containsignorecase('Required fields are missing: [Email]')){
                                
                            }
                            else{
                               // throw new AuraHandledException(ex.getMessage());
                               // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,''+EmailErrorMap.get(errorEmail))); 
                            }
                           
                        }
            }
            //system.debug('*****'+empfUpdate.id);
            Boolean NoException=true;
            if(!empfUpdateList.isEmpty() && empfUpdateList!=null ){
                try{
             update empfUpdateList;  
           }
           catch(exception e){
               NoException=false;
               throw new AuraHandledException(e.getMessage());
           }
           }
           system.debug('mapstringempftoDisplay'+mapstringempftoDisplay);
           
           
        }
        }
        for(string mapkeyset:mapstringempftoDisplay.keySet()){
            // system.debug(mapstringempftoDisplay);
            ListEmpfDisplay.add(mapstringempftoDisplay.get(mapkeyset.toLowerCase())) ; 
            system.debug('ListEmpfDisplay'+ListEmpfDisplay);
        }

        delete [SELECT Id FROM ContentDocument WHERE Id =:contentDocumentId];
        return ListEmpfDisplay;    
    }
}