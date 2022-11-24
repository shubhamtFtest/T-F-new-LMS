/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-29 CHG0065975
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-04-03
**####### Sends Feedback Email
***************************************************************************/
global class CAS_TextbookFeedbackEmail implements Database.Batchable<Sobject>
{
	public Boolean isTesting = false;// to manually test/debug to limit records
    public String orgId = ''; // Stops emails from going out in sandboxes
    public String templateId; // Used to process each process
	
	global database.querylocator start(Database.BatchableContext BC)  
	{
		
		String soql ='';
		String soqlStandardRule = '((Do_Not_Send__c = false AND Sent_Email_Failure__c=false AND Adoption_Short__c = null and Adoption_Stage__c = null) AND (NOT(Order_Type__c Like \'%Vitalsource e-Exam copy\')) AND CreatedDate = LAST_N_DAYS:365)';
		
		if (templateId == '00X0Y000000sUhwUAE')// Request for Feedback 35 days after created email 
		{
			soql = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Opportunity_Product__c  from CAS_Inspection_Copy__c ';
        	soql += ' where Sent_Created_Notification__c != null AND Sent_Feedback_Notification__c = null AND Sent_Type__c = null';   
			soql += ' AND Sent_Created_Notification__c < LAST_N_DAYS:35';
			soql += ' AND ' + soqlStandardRule + ' Order by CreatedDate';
		}
        else if (templateId == '00X0Y000000sUhwUAE-ROW')// CHG0071403 - Request for Feedback 60 days ROW/APAC
		{
            templateId = '00X0Y000000sUhwUAE';
			soql = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Shipping_Date__c, Opportunity_Product__c  from CAS_Inspection_Copy__c'; 
        	soql += ' where Sent_Created_Notification__c != null AND Sent_Feedback_Notification__c = null AND Sent_Type__c = \'ROW\' ';
        	soql += ' AND Sent_Created_Notification__c < LAST_N_DAYS:60';
        	soql += ' AND ' + soqlStandardRule + ' Order by CreatedDate';
		}
		else if (templateId == '00X0Y000000sUhyUAE')// Request for Feedback Singapore 60 days after created email
		{
			soql = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Shipping_Date__c, Opportunity_Product__c  from CAS_Inspection_Copy__c'; 
        	soql += ' where Sent_Created_Notification__c != null AND Sent_Feedback_Notification__c = null AND Sent_Type__c = \'Singapore\' AND Shipping_Date__c != null';
        	soql += ' AND Sent_Created_Notification__c < LAST_N_DAYS:60';
        	soql += ' AND ' + soqlStandardRule + ' Order by CreatedDate';
		}
		else if (templateId == '00X0Y000000sUhxUAE')// Request for Feedback - FollowUp 14 days  after Feedback or feedback for Singapore
		{
		  	soql = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Opportunity_Product__c  from CAS_Inspection_Copy__c'; 
            soql += ' WHERE Opportunity__r.IsClosed = false and Sent_Feedback_Notification__c != null AND Sent_Feedback_FollowUp__c = null';
            soql += ' AND Sent_Feedback_Notification__c < LAST_N_DAYS:14'; 
            soql += ' AND ' + soqlStandardRule + ' Order by Sent_Feedback_Notification__c';
		}
		else if (templateId == '00X0Y000000sUmNUAU')// Request for Feedback - Shortform 90 days after Feedback or Feedback for Singapore if the product family not CRC and less than 50 students
		{
			soql = 'Select Contact_Email__c, Contact_Name__c, CreatedDate, Id,Sent_Created_Notification__c, Sent_Feedback_Notification__c, Opportunity_Product__c  from CAS_Inspection_Copy__c ';
            soql += ' WHERE Opportunity__r.IsClosed = false AND Sent_Feedback_Notification__c != null AND Sent_Feedback_ShortForm__c = null AND Product__r.Family != \'CRC Press\' AND Number_of_Students__c <= 50';
           	soql += ' AND Sent_Feedback_Notification__c < LAST_N_DAYS:90'; 
            soql += ' AND ' + soqlStandardRule + ' Order by Sent_Feedback_Notification__c';
		}
		
		
		
		
		Integer queryLimit = 3000;
		
		if(Test.isRunningTest() || isTesting) queryLimit = 25;
		
		
		soql += ' LIMIT ' + queryLimit;
		
		System.debug('#### Textbook Feedback In-Process soql=' + soql); 
		return Database.getQueryLocator(soql);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
		List<CAS_Inspection_Copy__c> ics= (List<CAS_Inspection_Copy__c>) scope;
		
		if (ics.size() > 0)
        {
        	DateTime currentDate = System.now();
		
			List<CAS_Inspection_Copy__c> sendIC = new CAS_Inspection_Copy__c[]{};
        	List<CAS_Inspection_Copy__c> updateIC = new CAS_Inspection_Copy__c[]{};
        	Set<String> oppProductIds = new Set<String>();
        	Map<ID, OpportunityLineItem> oppProductICopy = new Map<ID, OpportunityLineItem>();
        
	    	for(CAS_Inspection_Copy__c ic : ics)//get oppProduct ids to get data
			{
	       		oppProductIds.add(ic.Opportunity_Product__c);
	    	}
        
        	If (oppProductIds.size()>0)//Map products
			{
				oppProductICopy = new Map<ID, OpportunityLineItem>([Select o.Id, o.PricebookEntryId, o.PricebookEntry.Product2Id,o.Adoption_Stage__c,
		                                                o.PricebookEntry.Product2.UK_Inventory_Status__c, o.PricebookEntry.Product2.UK_Publication_Date__c, o.PricebookEntry.Product2.US_Inventory_Status__c, o.PricebookEntry.Product2.US_Publication_Date__c,  o.Recipient__c, o.Recipient__r.Account.Locale__c, o.Recipient__r.AccountId from OpportunityLineItem o 
		                                                where  o.Id IN:oppProductIds]);//((o.PricebookEntry.Product2.US_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.US_Publication_Date__c != null) or (o.PricebookEntry.Product2.UK_Inventory_Status__c = 'Available' And o.PricebookEntry.Product2.UK_Publication_Date__c != null)) and o.Recipient__r.Account.Locale__c != null and
		        
		        	System.debug('##### oppProductICopy.size(): ' + oppProductICopy.size());	
			} 
        	
        	
        	
        	
        	
        	for(CAS_Inspection_Copy__c ic : ics)//get oppProduct ids to get data
			{
				OpportunityLineItem oppProdLine = oppProductICopy.get(ic.Opportunity_Product__c);
				
				if(oppProdLine  == Null)
				{
					System.debug('##### OpportunityLineItem does not exist!');
					updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id,Do_Not_Send__c=true,Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Opportunity Product doesn\'t exist!' ));
				}
				else if(oppProdLine.Recipient__r  == Null ||  oppProdLine.Recipient__r.Account == Null )
				{
				System.debug('##### Recipient or Account doesn\'t exist!');
				updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id,Do_Not_Send__c=true,Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Recipient or Account doesn\'t exist!' ));
				}
				else if (oppProdLine.Adoption_Stage__c != null && (oppProdLine.Adoption_Stage__c.contains('Completed') || oppProdLine.Adoption_Stage__c == 'Never Received Product'))//!= 'In-Process'
            	{
              		updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Do_Not_Send__c=true, Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Opportunity Product Adoption Stage is in "' + oppProdLine.Adoption_Stage__c +'"!', Adoption_Stage__c =oppProdLine.Adoption_Stage__c ));
            	}
            	else
            	{
					sendIC.add(ic);
            	}
			}
        	
        	if (updateIC !=null && updateIC.size() > 0)
           	{
                Update(updateIC);           
           	}     
        	//Send Emails
        	
       		if (sendIC !=null && sendIC.size() > 0)
           	{  
                if (templateId == '00X0Y000000sUhwUAE-ROW') templateId='00X0Y000000sUhwUAE';
                System.debug('@@AVI templateId :'+templateId); 
                CASEmail.SendCASEmail(SendIC, templateId,orgId);       
           	}
        	
        }
		
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
						TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
			// Send an email to the Apex job's submitter notifying of job completion.
		if (a.NumberOfErrors > 0 || Test.isRunningTest())
		{
		
		CASEmail.SendErrorEmail(a.CreatedBy.Email + ';Shay.Spoonmore@informaUSA.com;Do_Not_Reply.SFDC@informausa.com','CAS Textbook Feedback Created Email ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
		}
		
	}
	
}