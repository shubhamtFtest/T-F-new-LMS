public class TF_upLoadEmailPrefrenceCtrl {
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Email_Preference__c> empfList{get;set;}
    public List<WrapperEmpfDisplay> ListEmpfDisplay{get;set;}
    
    Map<string,Email_Preference__c> mapstringempf{get;set;}
    Map<String,String> EmailErrorMap{get;set;}
    Map<string,WrapperEmpfDisplay> mapstringempftoDisplay{get;set;}
    List<String> CheckAccAlreadyExist{get;set;}
    public TF_upLoadEmailPrefrenceCtrl(){
        csvFileLines = new List<String>{};
            empfList = New List<Email_Preference__c>();  
    }
    public class WrapperEmpfDisplay{
        public string Email{get;set;}
        public string Status{get;set;}
        public string Reason{get;set;}
        public string SuccessOrFailure{get;set;}
    }
    public pagereference importCSVFile(){
       system.debug('******csvFileBody'+csvFileBody);
        system.debug('******csvAsString'+csvAsString);
        try{
            String hexResult = EncodingUtil.convertToHex(csvFileBody);
            final Integer bytesCount = hexResult.length() >> 1;
            String[] bytes = new String[bytesCount];
            for(Integer i = 0; i < bytesCount; ++i){
                bytes[i] =  hexResult.mid(i << 1, 2);
            }
            csvAsString = EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'ISO-8859-1');
            csvFileLines = csvAsString.split('\n');
            
            //
            integer mapsize;
            /* csvAsString = csvFileBody.toString();
system.debug('csvAsString'+csvAsString);
csvFileLines = csvAsString.split('\n'); 
system.debug('csvFileLines'+csvFileLines[0]);
// csvFileLines split with ,

*/  List<string> csvFileLinessplitting = new List<string>();
            csvFileLinessplitting=csvFileLines[0].toLowerCase().split(',');
            integer indexEMail=csvFileLinessplitting.indexOf('email');
            system.debug('csvFileLines'+csvFileLines[0].toLowerCase()); 
            
            CheckAccAlreadyExist = new List<string>();
            mapstringempf = new map<string,Email_Preference__c>();
            mapstringempftoDisplay= new map<string,WrapperEmpfDisplay>();
            empfList = New List<Email_Preference__c>(); 
            ListEmpfDisplay= New List<WrapperEmpfDisplay>();
            for(Integer i=1;i<csvFileLines.size();i++){
                Email_Preference__c emailprfrnce = new Email_Preference__c() ;
                WrapperEmpfDisplay EmpfDisplay=new WrapperEmpfDisplay();
                string[] csvRecordData = csvFileLines[i].split(',');
                system.debug('indexEMail'+indexEMail);
                emailprfrnce.email__c = csvRecordData[indexEMail] ;             
                emailprfrnce.Reason__c = 'Book Purchasing Page Opt Out';
                emailprfrnce.Status__c = 'Unsubscribed';
                EmpfDisplay.Email=csvRecordData[indexEMail];
                EmpfDisplay.Reason = 'Book Purchasing Page Opt Out';
                EmpfDisplay.Status = 'Unsubscribed';
                EmpfDisplay.SuccessOrFailure ='Success';
                if(emailprfrnce!=null && csvRecordData[indexEMail]!=null){
                    mapstringempftoDisplay.put(string.valueOf(csvRecordData[indexEMail].toLowerCase()),EmpfDisplay);
                    mapstringempf.put(string.valueOf(csvRecordData[indexEMail].toLowerCase()),emailprfrnce);
                }
                
            }
            system.debug(mapstringempf.size());
            mapsize=mapstringempf.size();
            system.debug(mapstringempf.keySet());
            EmailErrorMap = new Map<String,String>();
            
            for(string mapkeyset:mapstringempf.keySet()){
                empfList.add(mapstringempf.get(mapkeyset)) ; 
            }
            system.debug(empfList.size());
            system.debug(empfList);
            if(!empfList.isEmpty()){
                
                try{
                    //  insert empfList;
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
                catch(exception e){
                    system.debug('e.getMessage()'+e.getMessage());
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
                            empfUpdate.Status__c='Unsubscribed';
                            empfUpdate.Reason__c='Book Purchasing Page Opt Out';
                            empfUpdateList.add(empfUpdate);
                            
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
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,''+EmailErrorMap.get(errorEmail))); 
                            }
                           
                        }
                    }
                   Boolean NoException=true;
                    if(!empfUpdateList.isEmpty()){
                         try{
                      update empfUpdateList;  
                    }
                    catch(exception e){
                        NoException=false;
                    }
                    }
                   
                    system.debug(mapstringempftoDisplay);
                    for(string mapkeyset:mapstringempftoDisplay.keySet()){
                        // system.debug(mapstringempftoDisplay);
                        ListEmpfDisplay.add(mapstringempftoDisplay.get(mapkeyset.toLowerCase())) ; 
                    }
                 //   integer recordsSucceed=   mapstringempf.size();   
                    // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,));
                    if(NoException=true){
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' All records inserted successfully '));
                    }
                    else{
                        Integer recordsSucceed= mapstringempf.size()-empfUpdateList.size();
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' '+empfUpdateList.size()+ ' errors. '+' '+recordsSucceed+' success. '));
                    }
                    
                }
                else{
                    for(string mapkeyset:mapstringempftoDisplay.keySet()){
                        // system.debug(mapstringempftoDisplay);
                        ListEmpfDisplay.add(mapstringempftoDisplay.get(mapkeyset.toLowerCase())) ; 
                        
                    }
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' All records inserted successfully '));
                    
                }
                return null;
            } 
            else{
               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'All records already Exist.'));
                return null;}
        }
        catch (Exception e)
        {
            if(e.getMessage().contains('BLOB is not a valid UTF-8 string')){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data Please make sure input csv file is correct');
                ApexPages.addMessage(errorMessage);
                return null; }
            else{
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMessage);
                return null; }
        }  
    }
   

    
}