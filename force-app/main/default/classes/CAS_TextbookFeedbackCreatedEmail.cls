/**************************************************************************
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-04-03
**####### Sends First Email
***************************************************************************/
global class CAS_TextbookFeedbackCreatedEmail implements Database.Batchable<Sobject> 
{
	public Boolean isTesting = false;// to manually test/debug to limit records
    public Boolean isAvailable = true; // true = process new records, false = process products that are not available
    public String orgId = ''; // Stops emails from going out in sandboxes
	
	global database.querylocator start(Database.BatchableContext BC)  
	{
		Integer queryLimit = 3000;
		//Sends In-Process Notification 
		String soqlStandardRule = '((Do_Not_Send__c = false AND Sent_Email_Failure__c=false AND Adoption_Short__c = null and Adoption_Stage__c = null) AND (NOT(Order_Type__c Like \'%Vitalsource e-Exam copy\')) AND CreatedDate = LAST_N_DAYS:365)';
		
		String soql = 'Select Future_Feedback_Date__c,Contact_Email__c, Contact_Name__c, CreatedDate, Id, Opportunity_Product__c, Sent_Created_Notification__c, Sent_Feedback_Notification__c, Sent_Not_Available_Date__c,Sent_Type__c'; 
        soql += ' from CAS_Inspection_Copy__c where Sent_Created_Notification__c = null'; 
		
		if(isAvailable)
        {
            soql += ' and Sent_Not_Available_Date__c = null';// Process new records!
        }
        else
        {
        	queryLimit = 10000;
            soql += ' and Sent_Not_Available_Date__c != null AND Sent_Not_Available_Date__c < LAST_N_DAYS:1';// process records that are not available once a day
        }
		
		soql += ' AND ' + soqlStandardRule + ' Order by CreatedDate DESC';
		
		
		
		if(Test.isRunningTest() || isTesting) queryLimit = 25;
		
		
		soql += ' LIMIT ' + queryLimit;
		
		
		System.debug('#### Textbook Feedback In-Process soql=' + soql); 
		return Database.getQueryLocator(soql);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
		List<CAS_Inspection_Copy__c> ics= (List<CAS_Inspection_Copy__c>) scope;
		System.debug('##### ics.size(): ' + ics.size());
		
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
        
        
        for(CAS_Inspection_Copy__c ic : ics)
		{
			OpportunityLineItem oppProdLine = oppProductICopy.get(ic.Opportunity_Product__c);
			
            
			if(oppProdLine  == Null)
			{
				System.debug('##### OpportunityLineItem does not exist!');
				updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id,Do_Not_Send__c=true,Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Opportunity Product doesn\'t exist!' ));
			}
			else if(oppProdLine.Recipient__r  == Null ||  oppProdLine.Recipient__r.Account == Null)
			{
				System.debug('##### Recipient, Account Local, or Account doesn\'t exist!');
				updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id,Do_Not_Send__c=true,Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Recipient or Account doesn\'t exist!' ));
			}
			else
			{ 
			
			Account  oppProdAccount =  oppProdLine.Recipient__r.Account;
			Product2 oppProd = oppProdLine.PricebookEntry.Product2;
			System.debug('##### oppProdLine.Id: ' + oppProdLine.Id );
			
            
            
            System.debug('##### InspectionCopy.Id : ' +ic.Id );
            System.debug('##### oppProdLine.Id: ' + oppProdLine.Id );
            System.debug('##### oppProdAccount.Locale__c: ' + oppProdAccount.Locale__c );
            System.debug('##### oppProd.US_Publication_Date__c: ' + oppProd.US_Publication_Date__c );
            System.debug('##### oppProd.US_Inventory_Status__c: ' + oppProd.US_Inventory_Status__c );
            System.debug('##### oppProd.UK_Publication_Date__c: ' + oppProd.UK_Publication_Date__c );
            System.debug('##### oppProd.UK_Inventory_Status__c: ' + oppProd.UK_Inventory_Status__c );
            System.debug('##### oppProdLine.Adoption_Stage__c: ' + oppProdLine.Adoption_Stage__c );
            System.debug('##### System.now().date: ' + System.now().date());
            
		
			if(ic.Contact_Email__c == Null)
			{
				updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id,Do_Not_Send__c=true,Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Email doesn\'t exist!' ));
			}
			else if (oppProdLine.Adoption_Stage__c != null && (oppProdLine.Adoption_Stage__c.contains('Completed') || oppProdLine.Adoption_Stage__c == 'Never Received Product'))//!= 'In-Process'
            {
              		updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Do_Not_Send__c=true, Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Opportunity Product Adoption Stage is in "' + oppProdLine.Adoption_Stage__c +'"!', Adoption_Stage__c =oppProdLine.Adoption_Stage__c ));
            }
			else if (ic.Sent_Type__c == 'Singapore')//Always send created notification to Singapore, this is setup in the IC trigger on OLI if fulfillment house isnt null
            {
              	sendIC.add(ic);
            }
            else if (oppProdAccount.Locale__c != 'AMERICAS' && oppProdAccount.Locale__c != 'EMEA' )//CHG0071403 - SEND ROW
            {
                sendIC.add(ic);
                updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Sent_Type__c='ROW'));
              	//updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Do_Not_Send__c=true, Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Recipient Account Local is not in AMERICAS or EMEA!' ));
            }
            else if(oppProdAccount.Locale__c == 'AMERICAS' && (oppProd.US_Inventory_Status__c != 'Available' || (oppProd.US_Publication_Date__c > System.now().date() || oppProd.US_Publication_Date__c == null)))
            {//product not available
            	updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Sent_Not_Available_Date__c = currentDate, Sent_Email_Message__c='US product not available!', Do_Not_Send_Reason__c='US product not available!'));
            }
            else if(oppProdAccount.Locale__c == 'EMEA' && (oppProd.UK_Inventory_Status__c != 'Available' || (oppProd.UK_Publication_Date__c > System.now().date() || oppProd.UK_Publication_Date__c == null)))
            {//product not available
            	updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Sent_Not_Available_Date__c = currentDate, Sent_Email_Message__c='UK product not available!', Do_Not_Send_Reason__c='UK product not available!'));
            }
            else if (oppProdAccount.Locale__c == 'AMERICAS' && oppProd.US_Inventory_Status__c == 'Available' && oppProd.US_Publication_Date__c <= System.now().date())
            {                  
                System.debug('##### Send Americas' );
                sendIC.add(IC);
            }
            else if (oppProdAccount.Locale__c == 'EMEA' && oppProd.UK_Inventory_Status__c == 'Available' && oppProd.UK_Publication_Date__c <= System.now().date())
            {
                System.debug('##### Send EMEA' );
                sendIC.add(IC);
            }
            else // Now process records
            {
            	System.debug('##### Research why record isnt processing ' + ic.Id); 
            	updateIC.add(new CAS_Inspection_Copy__c(Id=ic.Id, Do_Not_Send__c=true, Do_Not_Send_Date__c= currentDate, Do_Not_Send_Reason__c = 'Research reason why this record isn\'t processing!!' ));
	
            }
            
            
            
			}
		
		}
		
		
		   if (updateIC !=null && updateIC.size() > 0)
           {
                Update(updateIC);           
           }     
        	//Send Emails
       		 if (sendIC !=null && sendIC.size() > 0)
           {
                        
               CASEmail.SendCASEmail(SendIC, '00X0Y000000sUhWUAU',orgId);//In-Process Notification
                        
           } 
            
            
        	updateIC.clear();    
        	sendIC.clear(); 
		
        
        }
		
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
						TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id =:BC.getJobId()];
			// Send an email to the Apex job's submitter notifying of job completion.
		if (a.NumberOfErrors > 0 || Test.isRunningTest())
		{
		
		CASEmail.SendErrorEmail(a.CreatedBy.Email + ';Shay.Spoonmore@informaUSA.com;Do_Not_Reply.SFDC@informausa.com','CAS Textbook In-Process Feedback Created Email ' + a.Status, BC.getJobId() + ' The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.\n\n' + a.ExtendedStatus);
		}
		
	}

	


}