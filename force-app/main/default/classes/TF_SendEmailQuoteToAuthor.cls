public class TF_SendEmailQuoteToAuthor {
    public static List<SBQQ__Quote__c> quoteList;
    public static List<SBQQ__QuoteLine__c> quoteLineList;
    public static Id emailTemplateId;
    
    @InvocableMethod
    public static void sendNotification(List<Id> lstId) {
    send(lstId);
    }
    
    @future(callout=true)
    public static void send(List<Id> lstId){
    
      System.debug('lstId*****'+lstId);   
      if(null != lstId){
      try{
          quoteList = [SELECT id,Name,Manual_Check__c,No_MPDL_Process__c,Use_Prepay_Budget__c,Society_Manual_Check__c,SBQQ__Account__c,SBQQ__Account__r.Type,Payer_Account__r.Prepay_Account_Count__c,Primary_Contact_Name__c,Primary_Contact_s_email_id__c,Author_Status__c,CSD_Approval_Status__c,Previous_Quote_Rejection_Reason__c,(SELECT Id,Name,Product_Open_Access_Category__c FROM SBQQ__LineItems__r) from SBQQ__Quote__c where Id in :lstId];
          System.debug('quoteList******quoteList');
          Contact contact = [SELECT Id FROM Contact LIMIT 1];
          OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
          System.debug('owea' + owea);
    
          // Define the email
          List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        
          // Reference the attachment page and pass in the quote ID
          PageReference pdf =  Page.Quote;
          //PageReference pdf =  new PageReference('/apex/c__Quote');
          system.debug('******pdf' +pdf);
          
          //Define list of Quotes
          List<SBQQ__Quote__c> quoteList2 = new List<SBQQ__Quote__c>();
          
          
                system.debug('***before for loop****');
                for(SBQQ__Quote__c quoteObj : quoteList){
                // system.debug('List of quotes**'+ quoteList);
                system.debug('****inside for loop');
              //String str = JSON.serialize(quoteObj.id);
              pdf.getParameters().put('id',quoteObj.id); // getHeaders
              system.debug('*****pdf id'+pdf);
              //pdf.getHeaders().put('X-Json',str);
              pdf.setRedirect(true);
              System.debug('pdf*****'+pdf);

              // Take the PDF content
             // Blob b = pdf.getContent();
             // System.debug('BODY*****'+b);
               Blob b;
              if (Test.IsRunningTest())
              {
                 b = Blob.valueOf('UNIT.TEST');
              }
              else
              {
                 b = pdf.getContent();
              }
              
              // Create the email attachment
              Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
              efa.setFileName('Quote.pdf');
              efa.setBody(b);
              
              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
              // Sets the paramaters of the email
              
             // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea[0].Id);
                System.debug('owea ID set ' + owea[0].Id);
              }
              
              
              email.setTargetObjectId(contact.Id);
              email.setTreatTargetObjectAsRecipient(false);
              email.saveAsActivity = false;
              email.setToAddresses(new List<String>{quoteObj.Primary_Contact_s_email_id__c});

              email.setWhatId(quoteObj.Id);
              email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
              
              if(quoteObj.Payer_Account__r.Prepay_Account_Count__c > 0 && quoteObj.Author_Status__c == 'Accepted' && quoteObj.CSD_Approval_Status__c == 'Approved'){
                  emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Approved Quote Details Notification To Author'].Id;
              }
              else if(quoteObj.Use_Prepay_Budget__c == true && quoteObj.CSD_Approval_Status__c == 'Rejected'){
              //else if((quoteObj.Payer_Account__r.Manual_Check__c  == true || quoteObj.Manual_Check__c == true) && quoteObj.Use_Prepay_Budget__c == true && quoteObj.CSD_Approval_Status__c == 'Rejected'){
              //else if(quoteObj.Author_Status__c == Null && quoteObj.CSD_Approval_Status__c == Null && !quoteObj.SBQQ__LineItems__r.isEmpty() && quoteObj.Previous_Quote_Rejection_Reason__c == 'Prepay Rejected'){
                  if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Prepay Rejection Fully Open Notification To Author vf_template'].Id; 
                  }
                if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Prepay Rejection Open Select Notification To Author vf_template'].Id; 
                  }
              }
 
  
              if(quoteObj.No_MPDL_Process__c == True && quoteObj.Author_Status__c == 'Accepted' && (quoteObj.CSD_Approval_Status__c == 'Approved' || quoteObj.CSD_Approval_Status__c == 'Automatic Approval') && quoteObj.Use_Prepay_Budget__c == False){
                  emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Manual Approved Quote Details Notification To Author'].Id;
              }
              else if(quoteObj.Author_Status__c == Null && quoteObj.CSD_Approval_Status__c == Null && !quoteObj.SBQQ__LineItems__r.isEmpty() && quoteObj.Previous_Quote_Rejection_Reason__c == 'CSD Rejected'){
                  if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Manual Rejection Fully Open Notification To Author'].Id; 
                      system.debug('*******Manual rejection***');
                  }
                  if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF Manual Rejected Open Select Details to Notification'].Id; 
                      system.debug('&&&&&&&&&&&&Maula rejcetion&&&&&&&&&');
                  }
                  }
      
              
              
              if(quoteObj.Society_Manual_Check__c == True && quoteObj.Author_Status__c == 'Accepted' && (quoteObj.CSD_Approval_Status__c == 'Approved' || quoteObj.CSD_Approval_Status__c == 'Automatic Approval') && quoteObj.Use_Prepay_Budget__c == False){
                  emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Approved Quote Details Notification To Author'].Id;
              }
              else if(quoteObj.Author_Status__c == Null && quoteObj.CSD_Approval_Status__c == Null && !quoteObj.SBQQ__LineItems__r.isEmpty() && quoteObj.Previous_Quote_Rejection_Reason__c == 'Society Rejected'){
                  if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Rejection Fully Open Notification To Author'].Id; 
                  }
                  if(quoteObj.SBQQ__LineItems__r[0].Product_Open_Access_Category__c == 'Open Select'){
                      emailTemplateId = [SELECT id from EmailTemplate where Name = 'TF_Society Rejection Open Select Notification To Author'].Id; 
                  }
              }
              
              
              

              email.setTemplateId(emailTemplateId);
              emailList.add(email);            
              
              //update Quote Status field
              //quoteList2.add(new SBQQ__Quote__c(Id = quoteObj.Id, Approved_Date__c = System.Today()));  
         }//for 
         
         //Sends the email
         Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList); 
         
         //update quoteList2;
        } 
        catch(Exception e){
            System.debug('Error'+e.getMessage());
        }
       } 
    }
}