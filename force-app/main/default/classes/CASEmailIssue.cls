global class CASEmailIssue implements Database.Batchable<Sobject>{

public static Boolean Testing = true;
public Boolean isTesting;// used for test methods
public String query;
public String orgId;  
public String templateId;
public String recordLimit; 
	
public static void SendBacklog(boolean isTesting)
    {
    	/**
    	CASEmailIssue send = new CASEmailIssue();
    	send.query = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,System_Id__c, SystemModstamp from CAS_Inspection_Copy__c ' + 
    				'where Contact_Email__c != null AND System_Id__c != null and Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c > 2021-11-04T20:00:00Z  and (Opportunity__r.Start_Date__c >= Today or Opportunity__r.Start_Date__c = null) Order by CreatedDate DESC ';
   		send.orgId =[select Id from Organization].Id;
   		send.templateId = '00X60000000sksNEAQ';
		send.isTesting=isTesting;
		send.recordLimit = '3000';
		ID batchprocessid = Database.executeBatch(send);
   **/
    }	
	
	
	global database.querylocator start(Database.BatchableContext BC){
	//	System.debug('DEBUG: Start Sending emails');
		
	//if (isTesting){	query = query + ' LIMIT 2';} else { query = query + ' LIMIT ' + recordLimit;}
		
	return Database.getQueryLocator(query);
	
	
	}
	
	
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
	/**	
		Set<String> oppProductIds = new Set<String>();
        for(CAS_Inspection_Copy__c InspectionCopy : (CAS_Inspection_Copy__c[]) scope)
        {
            oppProductIds.add(InspectionCopy.Opportunity_Product__c);
        } 
        
        
        System.debug('##### oppProductIds.size(): ' + oppProductIds.size());
        Map<ID, OpportunityLineItem> oppProductICopy = new Map<ID, OpportunityLineItem>([Select o.Id, o.PricebookEntryId, o.PricebookEntry.Product2Id,
                                                o.PricebookEntry.Product2.UK_Inventory_Status__c, o.PricebookEntry.Product2.UK_Publication_Date__c, o.PricebookEntry.Product2.US_Inventory_Status__c, o.PricebookEntry.Product2.US_Publication_Date__c,  o.Recipient__c, o.Recipient__r.Account.Locale__c, o.Recipient__r.AccountId from OpportunityLineItem o 
                                                where ((o.PricebookEntry.Product2.US_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.US_Publication_Date__c != null) or (o.PricebookEntry.Product2.UK_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.UK_Publication_Date__c != null)) and o.Recipient__r.Account.Locale__c != null and o.Id IN:oppProductIds]);
		
		
		//Check the availability of a product and set it to get the first email when available
		DateTime notAvailableDate = System.now();
        
        List<CAS_Inspection_Copy__c> SendInspectionCopy = new CAS_Inspection_Copy__c[]{};
        List<CAS_Inspection_Copy__c> updateICNotAvailable = new CAS_Inspection_Copy__c[]{};
        
        Integer NotAvailableCount = 0;
    
        for (CAS_Inspection_Copy__c  CheckInspectionCopy: (CAS_Inspection_Copy__c[]) scope)
            {
                
            if (CheckInspectionCopy.Contact_Email__c != null)
                {
                    //System.debug('##### CheckInspectionCopy.Sent_Type__c: ' + CheckInspectionCopy.Sent_Type__c );
                    
                        
                            //Checking Availability, locale, and dates
                            if (oppProductICopy.containsKey(CheckInspectionCopy.Opportunity_Product__c) )//|| (CheckInspectionCopy.Sent_Not_Available_Date__c != null && !isAvailable)
                            {
                                OpportunityLineItem oppProdLine = oppProductICopy.get(CheckInspectionCopy.Opportunity_Product__c);
                                Product2 oppProd = oppProdLine.PricebookEntry.Product2;
                                Account  oppProdAccount =  oppProdLine.Recipient__r.Account;
                                Boolean processRecord = true;
                                
                                System.debug('##### CheckInspectionCopy.Id : ' + CheckInspectionCopy.Id );
                                System.debug('##### oppProdLine.Id: ' + oppProdLine.Id );
                                System.debug('##### oppProdAccount.Locale__c: ' + oppProdAccount.Locale__c );
                                System.debug('##### oppProd.US_Publication_Date__c: ' + oppProd.US_Publication_Date__c );
                                System.debug('##### oppProd.US_Inventory_Status__c: ' + oppProd.US_Inventory_Status__c );
                                System.debug('##### oppProd.UK_Publication_Date__c: ' + oppProd.UK_Publication_Date__c );
                                System.debug('##### oppProd.UK_Inventory_Status__c: ' + oppProd.UK_Inventory_Status__c );
                                System.debug('##### System.now().date: ' + System.now().date());
                                
                                
                                
                                if (oppProdAccount.Locale__c == 'AMERICAS' && oppProd.US_Inventory_Status__c == 'Available' && oppProd.US_Publication_Date__c <= System.now().date())
                                {
                                    
                                    System.debug('##### Send Americas:' + CheckInspectionCopy.Id);
                                    SendInspectionCopy.add(CheckInspectionCopy);
                                }
                                else if (oppProdAccount.Locale__c == 'EMEA' && oppProd.UK_Inventory_Status__c == 'Available' && oppProd.UK_Publication_Date__c <= System.now().date())
                                {
                                    
                                    System.debug('##### Send EMEA:' + CheckInspectionCopy.Id);
                                    SendInspectionCopy.add(CheckInspectionCopy);
                                }
                                else 
                                {
                                    NotAvailableCount ++;
                                    System.debug('##### Product isn\'t available in Locale: ' + CheckInspectionCopy.Opportunity_Product__c );
                                    CAS_Inspection_Copy__c updateICopyNotAvail = new CAS_Inspection_Copy__c(Id = CheckInspectionCopy.Id, Sent_Not_Available_Date__c = notAvailableDate, Sent_Created_Notification__c = null, Sent_Feedback_Notification__c = null, Sent_Feedback_FollowUp__c = null, Sent_Feedback_ShortForm__c = null);
                                    updateICNotAvailable.add(updateICopyNotAvail);
                                }
                            }
                            else
                            {
                                NotAvailableCount ++;
                                System.debug('##### Product isn\'t available: ' + CheckInspectionCopy.Opportunity_Product__c );
                                CAS_Inspection_Copy__c updateICopyNotAvail = new CAS_Inspection_Copy__c(Id = CheckInspectionCopy.Id, Sent_Not_Available_Date__c = notAvailableDate, Sent_Created_Notification__c = null, Sent_Feedback_Notification__c = null, Sent_Feedback_FollowUp__c = null, Sent_Feedback_ShortForm__c = null);
                                updateICNotAvailable.add(updateICopyNotAvail);
                                
                                
                            }
                            
                            
                            
                       
                   
                
                    //UpdateInspectionCopy.(Id = c.Id, Sent_Created_Notification__c = System.now());
                    
                }
            }
         
        System.debug('##### NotAvailableCount: ' + NotAvailableCount );    
        System.debug('##### SendInspectionCopy.size(): ' + SendInspectionCopy.size() );
        System.debug('##### updateICNotAvailable.size(): ' + updateICNotAvailable.size() ); 
        
         if (updateICNotAvailable !=null && updateICNotAvailable.size() != 0)
            {
                Update(updateICNotAvailable);           
            }     
        //Send Emails
        if (SendInspectionCopy !=null && SendInspectionCopy.size() != 0)
            {
                        
              SendCASEmail(SendInspectionCopy, templateId, orgId);
                        
            } 
            
            
        
        
        updateICNotAvailable.clear();    
        SendInspectionCopy.clear(); 
		
		
		
		
		
		
		//for(sObject s : scope){
		//Lead l = (Lead)s;
		//}
		//update accns;
		System.debug('DEBUG: Data Count -' + scope.Size());
		**/	
	}	
	


global void finish(Database.BatchableContext BC)
	{/**
	System.debug('DEBUG: Finish CASEmailIssue');
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	mail.setToAddresses(new String[] {'Shay.Spoonmore@informaUSA.com'});
	mail.setReplyTo('batch@acme.com');
	mail.setSenderDisplayName('Batch Processing');
	mail.setSubject('CAS Email Issues Sent ' + recordLimit + ' Emails');
	mail.setPlainTextBody('Batch Process has completed');
	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	**/
	}
	
	/**
	public static void SendCASEmail(CAS_Inspection_Copy__c[] SendInspectionCopy, String templateId,String OrgId)
    {
    
    
    if (!SendInspectionCopy.isEmpty())
       {
            
          if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()))
          {              
                        //Production Organization Id = '00D300000001NXOEA2'
                        If (OrgId == '00D300000001NXOEA2')testing = false; 
                        
                        System.debug('*****SendInspectionCopy.size = ' + SendInspectionCopy.size());
                        Messaging.SingleEmailMessage[] mail = new Messaging.SingleEmailMessage[SendInspectionCopy.size()];
                        List<CAS_Inspection_Copy__c> UpdateInspectionCopy = new CAS_Inspection_Copy__c[SendInspectionCopy.size()];
                        Integer currentRecord= 0;
                        for (CAS_Inspection_Copy__c SendingICI: SendInspectionCopy)
                            {
                                System.debug('*****currentRecord = ' + currentRecord);
                                System.debug('*****SendingICI.Id = ' + SendingICI.Id);
                                
                                //Update a different Field for each Process
                                if (templateId == '00X60000000sksNEAQ')
                                {
                     
                                    //Request for Regular Feedback(00X60000000sksNEAQ) & Singapore
                                    UpdateInspectionCopy[currentRecord] = new CAS_Inspection_Copy__c(Id = SendingICI.Id, Sent_Feedback_Notification__c = System.now(), Sent_Feedback_FollowUp__c = null, Sent_Feedback_ShortForm__c = null);
                                
                                }
                                
                                //**
                                mail[currentRecord] = new Messaging.SingleEmailMessage();
                                String[] toAddresses;
                                
                                //Check if code is firing in a Dev environment
                                //Production Organization Id = '00D300000001NXOEA2'
                                if (Testing)
                                {
                                    toAddresses = new String[] {'Shay.Spoonmore@informaUSA.com'};
                                    //errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                                }
                                else
                                {
                                    toAddresses = new String[] {SendingICI.Contact_Email__c}; //, 'Shay.Spoonmore@informaUSA.com' ,'SASInforma@gmail.com', 'Haley.McCarthy@informausa.com'
                                }
                                mail[currentRecord].setToAddresses(toAddresses);
                                mail[currentRecord].setTemplateId(templateId);
                                //The Target object is a Contact and will not work with out one
                                //A Contact setup with the do_not_reply_textbookfeedback@taylorandfrancis.com email is the only way to make this work
                                mail[currentRecord].setTargetObjectId('0036000000sg1QMAAY');//
                                mail[currentRecord].setwhatId(SendingICI.Id);
                                mail[currentRecord].setSaveAsActivity(false);
                                mail[currentRecord].setBccSender(false);
                                mail[currentRecord].setUseSignature(false);
                                //CHANGE THE ORG WIDE EMAIL WITH PRODUCTION!!!
                                mail[currentRecord].setOrgWideEmailAddressId('0D2600000004CA6CAM');
                                //**/
/**                                    
                                currentRecord = currentRecord + 1;
                            }
                            
                             //= NEW Messaging.SendEmailResult();
                        Messaging.SendEmailResult[] sendEmailResults = Messaging.sendEmail(mail, false);
                        System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                        
                        if (UpdateInspectionCopy != null)
                        {
                            update UpdateInspectionCopy;//update the date
                            System.debug('******Update Record Sent:' + sendEmailResults.size()); 
                        }
                                
                        
                        System.debug('******How Many InspectionCopy updated? ' + UpdateInspectionCopy.size());
                        
                        List<CAS_Inspection_Copy__c> updateICopyError = new CAS_Inspection_Copy__c[]{};
                        
                        
               //loop through email results and update only successful related Inspection Copy
               Integer errorCount = 0;
               String emailMessage = '';
               for(Integer i = 0, j = 0; i < sendEmailResults.size(); i++)
               { 
                    if(!sendEmailResults[i].isSuccess())
                    {       
                         for (Messaging.Sendemailerror sendEmailError : sendEmailResults[i].getErrors()) 
                              {
                                        
                                        System.debug('******Error Message:' + sendEmailError.Message);
                                        CAS_Inspection_Copy__c updateICopyErrorRecord = new CAS_Inspection_Copy__c(Id = UpdateInspectionCopy[i].Id, Sent_Email_Message__c = sendEmailError.Message);
                                        updateICopyError.add(updateICopyErrorRecord);
                                        
                                        //Build Email Error Message
                                        emailMessage = emailMessage + UpdateInspectionCopy[i].Id + ':' + sendEmailError.Message + '\n\r';
                                        
                                        errorCount++;// keep count of how many records errored
                              } 
                     
                     }  
               
               }
               

                        
                        
                if (errorCount > 0 && updateICopyError != null)
                    {
                       //System.debug('##### Error Count:' + errorCount); 
                       //System.debug('##### Update IC Error Records:' + updateICopyError.size()); 'getEmailInvocations:' + Limits.getEmailInvocations + 
                       String countMessage = 'getEmailInvocations:' + Limits.getEmailInvocations() + '\n\rError Count:' + errorCount + '\n\rUpdate IC Error Records:' + updateICopyError.size()+ '\n\r';
                       System.debug('##### ' + countMessage); 
                       try
                       {
                        if(updateICopyError.size() != 0)
                        {
                            update(updateICopyError);//update the date
                        }
                       }
                       catch(Exception e)
                       {
                        emailMessage = emailMessage + '\n\r' + e;
                       }
                       finally
                       {
                        
                       CASEmail.SendErrorEmail('Shay.Spoonmore@informaUSA.com','Error - Sending Inspection Copy Emails',countMessage + 'Error sending...\n\r' + emailMessage);
                        /**
                        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                        {
                        //Send Error Email
                        Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
                        //Build Email Error Message
                        errorEmail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'Shay.Spoonmore@informaUSA.com'}; 
                        errorEmail.setToAddresses(toAddresses);
                        errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                        errorEmail.setBccSender(false);
                        errorEmail.setEmailPriority('High');
                        //errorEmail.setOrgWideEmailAddressId('0D2R0000000005aKAA');
                        errorEmail.setUseSignature(false);
                        errorEmail.setPlainTextBody(countMessage + 'Error sending...\n\r' + emailMessage);
                        
                        
                        Messaging.SendEmailResult[] sendEmailErrorResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { errorEmail });
                        }
                        **/
/**                      System.debug('#### Sent Error Message:' + emailMessage);
                       }
                        
                    }
                        
            }
       }
    }
    
  **/
	
	
	

}