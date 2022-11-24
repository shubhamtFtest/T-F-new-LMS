/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2014-11-04
***************************************************************************/


public class CAS_VitalSource 
{
	public static String apiKey;
	public static String reporterKey;
	public static String apiUrl;
	public static String reporterUrl;
	
	
	
		public static Boolean GetSettings(String company)
		{
			Boolean active= false;
			List<Setting_Item__c> settings =[Select s.Text_5__c, s.Text_4__c, s.Text_3__c, s.Text_2__c, s.Text_1__c, s.Setting__r.Name, s.Setting__c, s.Checkbox_1__c From Setting_Item__c s where s.Setting__r.Name ='VitalSource' and s.Text_5__c=: company];
		
			for (Setting_Item__c setting: settings)
	        {
	        
	        	apiKey= setting.Text_3__c;
				reporterKey= setting.Text_4__c;
				apiUrl= setting.Text_1__c;
				reporterUrl= setting.Text_2__c;
				active = setting.Checkbox_1__c;//active
	        
	        
	        }
		
			return active;
		}
	
	
	    public static HttpResponse VitalSourceRequest(String requestURL, String requestMethod, String setBody, String setKey)
    {
    	String urlType = '';
    	
    	If (Userinfo.getOrganizationId() != '00D0Y0000035IjiUAE')
    	{urlType = '-staging';
    		
    		requestURL= requestURL.Replace('api.', 'api-staging.');
    		requestURL= requestURL.Replace('reporter.', 'reporter-staging.');
    		
    	}
    	
    	String url = requestURL;
        
                    
         //Blob headerValue = Blob.valueOf(username + ':' + password);            
         //String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);                                              
         Httprequest request = new Httprequest();  
         request.setTimeout(120000);           
         request.setEndpoint(url);            
         request.setMethod(requestMethod);                        
         //request.setHeader('Authorization', authorizationHeader);
         if (setKey != null && setKey !='')  request.setHeader('X-VitalSource-API-Key', setKey);
         if (setBody != null && setBody !='')  request.setBody(setBody) ;             
         Http http = new Http();
         HTTPresponse res = new HTTPresponse();
                               
         if(!Test.isRunningTest()) res = http.send(request);
         
         System.debug(res.getBody()); 
        return res;
    }
    
    
    @future (callout=true)
    public static void GetBookshelfCode(String id,String sku, String accessPeriod, String company) 
    { //testing: CAS_VitalSource.GetBookshelfCode('00k6000000NzjQ0','9780203878187','60','Routledge');
    	Boolean active = GetSettings(company);
    	if(active)
    	{
    		accessPeriod = accessPeriod.Replace('Days', '');
    		accessPeriod = accessPeriod.Replace('Day', '');
    		accessPeriod = accessPeriod.Replace('Access', '');
    		accessPeriod = accessPeriod.Trim();
    		
    		List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
    		Dom.Document doc = new Dom.Document();
    		
    		String xmlBody= '';
    		if (accessPeriod == 'Perpetual')//Added 20141104 
    		{
    			xmlBody='<codes sku="'+sku+'" license-type="perpetual" num-codes="1" code-type="comp" tag="'+id+'" />';
    		}
    		else
    		{
    			xmlBody='<codes sku="'+sku+'" license-type="numdays" num-days="'+accessPeriod+'" num-codes="1" code-type="comp" tag="'+id+'" />';
    		}
    		
    		
    		//String xmlBody='<codes sku="'+sku+'" license-type="numdays" num-days="'+accessPeriod+'" num-codes="1" code-type="comp" tag="'+id+'" />';
    		HttpResponse response = new HttpResponse();
    		
    		System.debug('*******xmlBody='+xmlBody);  
    		response = VitalSourceRequest(apiUrl + '/codes.xml', 'POST', xmlBody, apiKey);
    		
    		if(Test.isRunningTest())
    		{
    			response.setStatusCode(200);
    			response.setStatus('Testing');
    		}
    		
    		
    		System.debug('*******response.getStatus()='+response.getStatus());
    		System.debug('*******response.getStatusCode()='+response.getStatusCode());
    		if (Test.isRunningTest() || response.getStatusCode()== 200)
    		{
    			if(!Test.isRunningTest())
        		{
	    		doc = response.getBodyDocument(); 
        		}
        		else
        		{
        			doc.load(TestVitalSourceCodeResponse());
        		}
        		
        		
	    		Dom.XMLNode codes = doc.getRootElement();
	        	//LIST<Dom.Xmlnode> bookshelfCodes = xml.getChildElements();
	        	String bookshelfCode = '';
	            for(Dom.XMLNode code : codes.getChildElements()) 
	            {//System.debug('*******bookshelfCode='+child.getText());
	    			 bookshelfCode = code.getText();//child.getChildElement('code', null).getText();
	    			 System.debug('*******bookshelfCode='+bookshelfCode);
	    			 
	            }
	            
	            if (codes.getChildElements().size() == 1)//if more than one?error
	            {
	            	OpportunityLineItem oli = new OpportunityLineItem(id=id,VitalSource_Bookshelf_Code__c= bookshelfCode,VitalSource_Bookshelf_Date__c = system.now(), VitalSource_Message__c= 'Response Status('+ system.now() +'):' + response.getStatus() + '('+ response.getStatusCode() +')\n\r'  );
	    			olis.add(oli);
	    		}
	    		else
	    		{
	    			OpportunityLineItem oli = new OpportunityLineItem(id=id, VitalSource_Message__c= 'Response Status('+ system.now() +'):' + response.getStatus() + '('+ response.getStatusCode() +')\n\r' +  response.getBody() + '\n\rRequest:' + xmlBody);
	    			olis.add(oli);
	    		}
	    		
    		}
    		else
    		{
    			OpportunityLineItem oli = new OpportunityLineItem(id=id, VitalSource_Message__c= 'Response Status('+ system.now() +'):' + response.getStatus() + '('+ response.getStatusCode() +')\n\r' +  response.getBody() + '\n\rRequest:' + xmlBody);
	    		olis.add(oli);
    		}
    		
    		
    		
            if (olis.size() > 0)
            {
            update olis;
            }
    	}
    	
    
    
    
    }
    
    public static Map<String, Setting_Item__c> GetEmailTemplates()
    {
    	Map<String, Setting_Item__c> vsTemplates = new Map<String, Setting_Item__c>();
    	
    	for (Setting_Item__c vsTemplate: [SELECT Name,Setting__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c,Text_7__c,Setting__r.Name FROM Setting_Item__c Where Setting__r.Name = 'VitalSource Email Templates'])
        {
        	vsTemplates.put(vsTemplate.Text_1__c, vsTemplate);
        }
        
        return vsTemplates;
    }
    
    
    
    public static void SendInstructorEmail(OpportunityLineItem[] sendOLIs, String OrgId, String sentField)
    {
    	Boolean testing = true;
    
    	if (!sendOLIs.isEmpty())
       	{
            
          if ((Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()))
          {
          	
              //Get templates from settings 
              Map<String, Id> settingTemplates = new Map<String, Id>(); //Order Type to Template Id
              for (Setting_Item__c settingTemplate: GetEmailTemplates().values())
              {
                    if (sentField == 'VitalSource_Backorder_Email_Date__c')
                    {
                        settingTemplates.put(settingTemplate.Text_1__c,settingTemplate.Text_7__c);//Email 6 :  Backorders
                    
                    }
                    else
                    {
                        System.debug('*****settingTemplate.Text_1__c = ' + settingTemplate.Text_1__c + ' -- ' +settingTemplate.Text_2__c);
                        settingTemplates.put(settingTemplate.Text_1__c.Trim(),settingTemplate.Text_2__c);//Email 1 :  BookShelfCode
                    }
                
              }	    
          	
              Map<Id, EmailTemplate> emailTemplates = new Map<Id, EmailTemplate>([Select e.Subject, e.Name, e.Id, e.HtmlValue, e.Body From EmailTemplate e where  id =: settingTemplates.values() ]);
              System.debug('*****emailTemplates.size() = ' + emailTemplates.size());
              System.debug('*****settingTemplates.size() = ' + settingTemplates.size());
          
          
          
	          	//Get Recipient emails
	          	Set<Id> recipientId = new Set<Id>();
	          	Set<Id> productId = new Set<Id>();
	          	Set<Id> opportunityId = new Set<Id>();
              	//Added by Renil for Marketing team to test.
	          	Set<String> toAddressToExclude = new Set<String> {'phaedra.roberts@tandf.co.uk','davina.millwood@informa.com', 'renata.schiavinato@informa.com', 'jenny.hunt@tandf.co.uk', 'emilie.littlehales@taylorandfrancis.com', 'laura.maisey@tandf.co.uk',
                    'laura.holliday@tandf.co.uk','umar.masood@informa.com','kathryn.beechey@tandf.co.uk','erica.barbero@taylorandfrancis.com','michael.roberts@taylorandfrancis.com', 'toji.varghese@taylorandfrancis.com','amy.kahlau@taylorandfrancis.com',
                    'phaedra.ryce@informa.com','phaedra.ryce@yahoo.com','davina.millwood@tandf.co.uk','umar.masood@tand.co.uk'};
	          	
                for (OpportunityLineItem sendOLI: sendOLIs)
                {
                    recipientId.add(sendOLI.Recipient__c);
                    productId.add(sendOLI.Product2Id);
                    opportunityId.add(sendOLI.OpportunityId);
                    
                }
              	
          		Map<ID,Contact> oliRecipient = new Map<ID,Contact>([Select Email, Id, Name, Salutation From Contact Where Id in :recipientId AND Email NOT IN:toAddressToExclude]);
          		Map<ID,Product2> oliProduct = new Map<ID,Product2>([Select  Id, Name, Edition_Number__c, Lead_Author_Editor__c From product2 Where Id in :productId]);
    			Map<ID,Opportunity> oliOpportunity = new Map<ID,Opportunity>([Select  Id, Owner.Name, Owner.Phone, Owner.Email From Opportunity Where Id in :opportunityId]);
          	       
                        //Production Organization Id = '00D0Y0000035IjiUAE'
                        If (OrgId == '00D0Y0000035IjiUAE')testing = false; 
                        
                        System.debug('*****sendOLIs = ' + sendOLIs.size());
                        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                        //List<OpportunityLineItem> updateOLI = new OpportunityLineItem[sendOLIs.size()];
                        Integer currentRecord= 0;
                        for (OpportunityLineItem sendOLI: sendOLIs)
                            {
                            	
                            	//Get Email Body/Subject
                            	String templateId = settingTemplates.get(sendOLI.Order_Type__c.trim());
                            	System.debug('*****templateId = ' + templateId + ' -- ' + sendOLI.Order_Type__c);
                            	String templateBody = emailTemplates.get(templateId).Body;
          						String templateSubject = emailTemplates.get(templateId).Subject;
                            	
                            	if (oliRecipient.get(sendOLI.Recipient__c) != null )
                            	{
                                System.debug('*****currentRecord = ' + currentRecord);
                                System.debug('*****SendingICI.Id = ' + sendOLI.Id);
                                String emailBody = templateBody;
                                String emailSubject = templateSubject;
                                PricebookEntry pde = sendOLI.PricebookEntry;
                                String contactEmail = oliRecipient.get(sendOLI.Recipient__c).Email;
                                String contactName = oliRecipient.get(sendOLI.Recipient__c).Name;
                                String productName = oliProduct.get(sendOLI.Product2Id).Name;
                                Integer productEditionNumber = Integer.valueOf(oliProduct.get(sendOLI.Product2Id).Edition_Number__c);
                                String productLeadAuthorEditor = oliProduct.get(sendOLI.Product2Id).Lead_Author_Editor__c;
                                User ownerName = oliOpportunity.get(sendOLI.OpportunityId).Owner;
                                //String ownerOpportunity = oliOpportunity.get(sendOLI.OpportunityId);
                                
                                
                                
                                String contactSalutation ='';
                                if (oliRecipient.get(sendOLI.Recipient__c).Salutation != null)
                                {
                                contactSalutation = oliRecipient.get(sendOLI.Recipient__c).Salutation;
                                }
                                
                                emailSubject = emailSubject.replace('{!CAS_Inspection_Copy__c.Book_Title__c}',productName);
                                emailSubject = emailSubject.replace('{!Opportunity.Book_Requested__c}',productName);
                                
                                emailBody = emailBody.replace('{!Contact.Name}',contactName);
                                emailBody = emailBody.replace('{!OpportunityLineItem.VitalSource_Access_Period__c}',sendOLI.VitalSource_Access_Period__c);
                                emailBody = emailBody.replace('{!CAS_Inspection_Copy__c.Contact_Name__c}',contactName);
                                emailBody = emailBody.replace('{!Contact.Salutation}',contactSalutation == null ? '' :contactSalutation);
                                emailBody = emailBody.replace('{!OpportunityLineItem.VitalSource_Bookshelf_Code__c}',sendOLI.VitalSource_Bookshelf_Code__c == null ? '' : sendOLI.VitalSource_Bookshelf_Code__c);
                                emailBody = emailBody.replace('{!Opportunity.Book_Requested__c}',productName);
                                emailBody = emailBody.replace('{!CAS_Inspection_Copy__c.Book_Title__c}',productName);
                                emailBody = emailBody.replace('{!CAS_Inspection_Copy__c.Edition_Number__c}',String.valueOf(productEditionNumber ) == null ? '' : String.valueOf(productEditionNumber));
                                emailBody = emailBody.replace('{!CAS_Inspection_Copy__c.Lead_Author_Editor__c}',productLeadAuthorEditor == null ? '' : productLeadAuthorEditor);
                                emailBody = emailBody.replace('{!Opportunity.OwnerFullName}',ownerName.Name);
                                emailBody = emailBody.replace('{!Opportunity.OwnerPhone}',ownerName.Phone == null ? '' :ownerName.Phone);
                                emailBody = emailBody.replace('{!Opportunity.OwnerEmail}',ownerName.Email == null ? '' :ownerName.Email);
                                
                               // if (templateId == '00X60000004HH0M')//VS Distribution Email 1
                               // {
                                    //sentCreatedNotification.add(SendingICI.Id);
                                    
                               //     updateOLI[currentRecord] = new OpportunityLineItem(Id = sendOLI.Id, VitalSource_Instructor_Email_Date__c = System.now());
                                    
                               // }
                                
                                 
                                //**
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                String[] toAddresses;
                                
                                //Check if code is firing in a Dev environment
                                //Production Organization Id = '00D0Y0000035IjiUAE'
                                if (Testing)
                                {
                                    toAddresses = new String[] {'matthew.smith.gb1@tandf.co.uk','renil.rejith@taylorandfrancis.com'};
                                    //errorEmail.setSubject('Error - Sending Inspection Copy Emails');
                                }
                                else
                                {	
                                 	toAddresses = new String[] {oliRecipient.get(sendOLI.Recipient__c).Email}; //, 'Shay.Spoonmore@informaUSA.com' ,'SASInforma@gmail.com', 'Haley.McCarthy@informausa.com'
                                }
                                    
                                mail.setToAddresses(toAddresses);
                                //mail[currentRecord].setTemplateId(templateId);
                                mail.setPlainTextBody(emailBody);
                                mail.setSubject(emailSubject);
                                //templateSubject
                                //The Target object is a Contact and will not work with out one
                                //A Contact setup with the do_not_reply_textbookfeedback@taylorandfrancis.com email is the only way to make this work
                                //mail[currentRecord].setTargetObjectId(sendOLI.Id);//'0036000000sg1QMAAY'sendOLI.Recipient__c
                                //mail[currentRecord].setwhatId(sendOLI.OpportunityId);
                                mail.setSaveAsActivity(false);
                                mail.setBccSender(false);
                                mail.setUseSignature(false);
                                
                                mail.setOrgWideEmailAddressId('0D20Y000000L2FpSAK');
                                //**/
                                    emails.Add(mail);
                                currentRecord = currentRecord + 1;
                            	}
                        }
                            
                             //= NEW Messaging.SendEmailResult();
                             
                        if(emails.size()>0)
                        {
                        	List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
                        	if (!test.isRunningTest())
                        		sendEmailResults = Messaging.sendEmail(emails, false);
                        	System.debug('******EMAIL RESULTS:' + sendEmailResults.size()); 
                         
                        
               //loop through email results and update only successful related Inspection Copy
               List<OpportunityLineItem> updateOLIs = new List<OpportunityLineItem>();
               Integer errorCount = 0;
               Integer successCount = 0;
               String emailMessage = '';
               for(Integer i = 0, j = 0; i < sendEmailResults.size(); i++)
               { 
               	
                    if(sendEmailResults[i].isSuccess())
                    { 
                        if (sentField == 'VitalSource_Backorder_Email_Date__c')//Email 6: BackOrders
                        {
                         	updateOLIs.add(new OpportunityLineItem(Id = sendOLIs[i].Id, VitalSource_Backorder_Email_Date__c = System.now()));
                        }
                         else
                        {
                         	updateOLIs.add(new OpportunityLineItem(Id = sendOLIs[i].Id, VitalSource_Instructor_Email_Date__c = System.now()));
               			}
                         successCount++;
                    }
                    else{
                         for (Messaging.Sendemailerror sendEmailError : sendEmailResults[i].getErrors()) 
                              {
                                        
                                        System.debug('******Error Message:' + sendEmailError.Message);
                                        
                                        String errorFields = '';
                                        for(String field :sendEmailError.getFields())
              								 { 
              								 	errorFields = errorFields + field + '; ';
              								 }
                                        
                                        String errorMessage = 'Id=' + sendOLIs[i].id + '::Message=' + sendEmailError.getMessage() + '::StatusCode=' + sendEmailError.getStatusCode()  + '::TargetObjectId=' +  sendEmailError.getTargetObjectId() + '::errorFields=' + errorFields + '::EmailTotalcount='+ sendEmailResults.size();
                                        
                                      
                                        //Build Email Error Message
                                        emailMessage = emailMessage +  errorMessage + '\n\r';
                                        
                                        errorCount++;// keep count of how many records errored
                              }
                     
                     }  
               
               }
               
               System.debug('******How Many OppLineItems updated? ' + updateOLIs.size()); 
 				 if (updateOLIs != null && updateOLIs.size() >0) 
                        {
                            update updateOLIs;//update the date
                            System.debug('******Update Record Sent:' + sendEmailResults.size()); 
                        }
                        
                        
                if (errorCount >0 || Test.isRunningTest() )
                    {
                       //System.debug('##### Error Count:' + errorCount); 
                       //System.debug('##### Update IC Error Records:' + updateICopyError.size()); 'getEmailInvocations:' + Limits.getEmailInvocations + 
                       String countMessage = 'getEmailInvocations:' + Limits.getEmailInvocations() + '\n\rError Count:' + errorCount + '\n\r';
                       System.debug('##### ' + countMessage); 
                       try
                       {
                       
                       }
                       catch(Exception e)
                       {
                        emailMessage = emailMessage + '\n\r' + e;
                       }
                       finally
                       {
                        
                       CAS_VitalSource.SendErrorEmail('Shay.Spoonmore@informaUSA.com','Error - VitalSource Instructors Emails',countMessage + 'Error sending...\n\r' + emailMessage);
                      
                        System.debug('#### Sent Error Message:' + emailMessage);
                       }
                        
                    
                    }
            }
          
          }
       }
    }
    
    
    Public static void SendErrorEmail(string emailTo,String emailSubject, String emailMessage )
    {
        if (Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
    	{
            //Send Error Email
            Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
            //Build Email Error Message
            errorEmail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {emailTo}; 
            errorEmail.setToAddresses(toAddresses);
            errorEmail.setSubject(emailSubject); 
            errorEmail.setBccSender(false);
            errorEmail.setEmailPriority('High');
            errorEmail.setUseSignature(false);
            errorEmail.setPlainTextBody(emailMessage);
            
            List<Messaging.SendEmailResult> sendEmailErrorResults = new List<Messaging.SendEmailResult>();
            if (!test.isRunningTest())
                sendEmailErrorResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { errorEmail });
        }
    }
    
    
    public static String TestVitalSourceCodeResponse()
    {
        String x = '<?xml version="1.0" encoding="UTF-8"?>';
        
        //for (Integer i = 0; i < 5; i++) { 
        x=x + '<codes><code>TEST-2K2X5CBH3QGHZFKYUEFW-TEST</code></codes>';
        
        System.debug(x);
        return x;
     }
     
    public static void TestCreateSettingsEmailTemplates()
    {
        if(test.isRunningTest())
        {
        	String createTemplateId = null;
        	List<EmailTemplate> et = [SELECT Id,Name FROM EmailTemplate WHERE Name LIKE 'CRC VS%' or Name LIKE 'GS VS%' or Name LIKE 'HSS VS%'  ORDER BY Name ASC NULLS FIRST ];
        	if(et.size() == 0)//create
        	{
        		EmailTemplate createET = new EmailTemplate();
        		createET.Name = 'CRC vs Template';
        		createET.Body = 'Test vs Template';
        		createET.Subject = 'Test vs Template';
        		createET.IsActive =true;
                createET.TemplateType='custom';
        		createET.DeveloperName = 'Test_vs_Template';
                createET.FolderId = [SELECT Id FROM Folder WHERE accessType = 'Public' LIMIT 1].Id;
        		insert createET;
        		createTemplateId=createET.Id;
        	}
        	
        	
        	List<Setting_Item__c> setItems = [SELECT Name,Setting__c,Text_1__c,Text_2__c,Text_3__c,Text_4__c,Text_5__c,Text_6__c,Text_7__c,Setting__r.Name FROM Setting_Item__c Where Setting__r.Name = 'VitalSource Email Templates'];
        	if(setItems.size() == 0)
        	{
        		Setting__c setting= new Setting__c(Name = 'VitalSource Email Templates');
        		insert setting;
        		setItems = new List<Setting_Item__c>();
        		if (et.size() == 0)
        		{
        			setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='CRC Vitalsource e-Exam copy',Text_2__c=createTemplateId,Text_3__c=createTemplateId,Text_4__c=createTemplateId,Text_5__c=createTemplateId,Text_6__c=createTemplateId,Text_7__c=createTemplateId));
        			setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='HSS Vitalsource e-Exam copy',Text_2__c=createTemplateId,Text_3__c=createTemplateId,Text_4__c=createTemplateId,Text_5__c=createTemplateId,Text_6__c=createTemplateId,Text_7__c=createTemplateId));
        			setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='Garland Vitalsource e-Exam copy',Text_2__c=createTemplateId,Text_3__c=createTemplateId,Text_4__c=createTemplateId,Text_5__c=createTemplateId,Text_6__c=createTemplateId,Text_7__c=createTemplateId));
        		}
        		else //create from existing email templates
        		{
        		
        		List<string> crc= new List<string>();
        		List<string> gs = new List<string>();
        		List<string> hss = new List<string>();
	        		for(EmailTemplate temps: et)
	        		{
	        			if(temps.Name.contains('CRC VS'))crc.add(temps.Id);
	        			if(temps.Name.contains('GS VS'))gs.add(temps.Id);
	        			if(temps.Name.contains('HSS VS'))hss.add(temps.Id);
	        		}
	        		String email1 = (crc[0] != Null)? crc[0] : createTemplateId;
	        		String email2 = (crc[1] != Null)? crc[1] : createTemplateId;
	        		String email3 = (crc[2] != Null)? crc[2] : createTemplateId;
	        		String email4 = (crc[3] != Null)? crc[3] : createTemplateId;
	        		String email5 = (crc[4] != Null)? crc[4] : createTemplateId;
	        		String email6 = (crc[5] != Null)? crc[5] : createTemplateId;
	        		setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='CRC Vitalsource e-Exam copy',Text_2__c=email1,Text_3__c=email2,Text_4__c=email3,Text_5__c=email4,Text_6__c=email5,Text_7__c=email6));
	        		
	        		email1 = (hss[0] != Null)? hss[0] : createTemplateId;
	        		email2 = (hss[1] != Null)? hss[1] : createTemplateId;
	        		email3 = (hss[2] != Null)? hss[2] : createTemplateId;
	        		email4 = (hss[3] != Null)? hss[3] : createTemplateId;
	        		email5 = (hss[4] != Null)? hss[4] : createTemplateId;
	        		email6 = (hss[5] != Null)? hss[5] : createTemplateId;
	        		setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='HSS Vitalsource e-Exam copy',Text_2__c=email1,Text_3__c=email2,Text_4__c=email3,Text_5__c=email4,Text_6__c=email5,Text_7__c=email6));
	        		
	        		email1 = (gs[0] != Null)? gs[0] : createTemplateId;
	        		email2 = (gs[1] != Null)? gs[1] : createTemplateId;
	        		email3 = (gs[2] != Null)? gs[2] : createTemplateId;
	        		email4 = (gs[3] != Null)? gs[3] : createTemplateId;
	        		email5 = (gs[4] != Null)? gs[4] : createTemplateId;
	        		email6 = (gs[5] != Null)? gs[5] : createTemplateId;
	        		setItems.add(new Setting_Item__c(Setting__c=setting.Id, Text_1__c='Garland Vitalsource e-Exam copy',Text_2__c=email1,Text_3__c=email2,Text_4__c=email3,Text_5__c=email4,Text_6__c=email5,Text_7__c=email6));
	        		
        		}
        		
        		if (setItems.size() > 0)
        		{
        			insert setItems;
        		}
        		
        	
        	}
        	
        	
        	
        	
        }
        
     }
    
    
    
    

}