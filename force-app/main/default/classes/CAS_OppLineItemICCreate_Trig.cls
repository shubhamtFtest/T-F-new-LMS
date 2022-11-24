/************************************************************************** 
* Created by Jeff Douglas
*
** Tested by: zTEST_CAS.cls
*
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)20150225
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2016-01-05 CHG0069838 stop prompts to redeem/request feedback going out to lecturers who have objected to the EIC process
***************************************************************************/

public without sharing class CAS_OppLineItemICCreate_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) 
    {
        if (trig.isBefore && trig.isUpdate) 
        {
        
         Map<Integer,OpportunityLineItem> casLineItems = new Map<Integer,OpportunityLineItem>();
         Set<String> oliIds = new Set<String>();
         Set<ID> opportunityIds = new Set<ID>();
         Set<ID> contactIds = new Set<ID>();
         Set<ID> pricebookIds = new Set<ID>();
        
         for (Integer i=0;i<trig.newList.size();i++) 
         {
            //if(recordtypesEnabled.contains(trig.newList[i].OpportunityRecordtypeId__c))
            //{
              
              if (((trig.newList[i].Feedback_Notification__c == 'Send' || trig.newList[i].Feedback_Notification__c == 'Do Not Send' || trig.newList[i].Feedback_Notification__c == 'Send VS Code, No Feedback') && trig.newList[i].Adoption_Stage__c == 'In-Process')//Ceate IC 
                || 
                (trig.newList[i].Order_Type__c != null && trig.newList[i].Order_Type__c.contains('Vitalsource e-Exam copy') && trig.newList[i].VitalSource_Bookshelf_Code__c != NULL && trig.newList[i].VitalSource_Instructor_Email_Date__c != NULL)//Update/Create Vitalsource IC - Instructor email date and redeemed date to start process
                ||
                (trig.newList[i].Fulfillment_House__c != null && trig.newList[i].Shipping_Date__c != trig.oldlist[i].Shipping_Date__c)//Check to see if Singapore Ship date has been updated and update the Feedback with Ship date
                ) 
                {
                  
                    System.debug('#### Trigger.CAS_OppLineItemICCreate: Id = ' + trig.newList[i].Id);
                    casLineItems.put(i, trig.newList[i]);
                    oliIds.add(trig.newList[i].Id);
                    opportunityIds.add(trig.newList[i].OpportunityId);
                    contactIds.add(trig.newList[i].Recipient__c);
                    pricebookIds.add(trig.newList[i].PricebookEntryId);
                  
                }
              
            //}
          }
          
          if (casLineItems.size() > 0) 
          {
            
            List<CAS_Inspection_Copy__c> inspectionCopies = new List<CAS_Inspection_Copy__c>();
            Map<ID,Opportunity> opportunities = new Map<ID,Opportunity>([Select Year_of_Study__c, Course_Start_Date__c, Number_of_Students__c, OwnerId from Opportunity Where Id IN :opportunityIds]);
            Map<ID,Contact> contacts = new Map<ID,Contact>([Select Name, Email from Contact Where Id IN :contactIds]);
            Map<ID,PricebookEntry> pricebookEntries = new Map<ID,PricebookEntry>([Select p.Product2Id, p.Product2.ISBN__c, p.Pricebook2Id, p.Name From PricebookEntry p Where p.Id IN :pricebookIds]); 
            Map<ID,CAS_Inspection_Copy__c> existingInspectionCopies = new Map<ID,CAS_Inspection_Copy__c>([Select Id, Opportunity_Product__c,Shipping_Date__c,Sent_Type__c,Order_Type__c,Sent_VS_Instructor__c,Sent_VS_Redeemed__c,Sent_VS_Bookshelf_Code__c,Sent_VS_Back_Order__c,Do_Not_Send__c,Do_Not_Send_Reason__c  From CAS_Inspection_Copy__c Where Opportunity_Product__c IN :oliIds]);
            System.debug('#### opportunities.Size() = ' + opportunities.Size());
            System.debug('#### oliIds.Size() = ' + oliIds.Size());
            System.debug('#### contacts .Size() = ' + contacts.Size());
            System.debug('#### existingInspectionCopies.Size() = ' + existingInspectionCopies.Size());
            Map<String,Id> existingOliToIc = new Map<String,Id>();
            for (CAS_Inspection_Copy__c existingIC : existingInspectionCopies.values())//map OLI TO IC  
            {
              existingOliToIc.put(existingIC.Opportunity_Product__c, existingIC.Id);
            }
            
            System.debug('#### existingOliToIcSize() = ' + existingOliToIc.Size());
            for (OpportunityLineItem oli : casLineItems.values()) 
            {
              // the email address of the recepient. if blank then workflow will not send email
              String contactEmail;
              String contactName;
              String Fulfillment_House = null;
              String icId = existingOliToIc.get(oli.Id);
              String oldFeedbackNotification = trig.oldMap.get(oli.Id).Feedback_Notification__c;
              String newFeedbackNotification = oli.Feedback_Notification__c;
                
              //Do Not Send
              Boolean icDoNotSend = false;
              Datetime icDoNotSendDate = null;
              String icDoNotSendReason ;
              if (oli.Feedback_Notification__c == 'Do Not Send' || oli.Feedback_Notification__c == 'Send VS Code, No Feedback') 
              {
                 icDoNotSend= true;
                 icDoNotSendDate = system.now();
                 icDoNotSendReason = system.UserInfo.getUserName() + ' set this to not email recepient! ' + system.now();
              } 
                  
                  
                  if (icId == null)//Create
                  {
                    
                    if (oli.Feedback_Notification__c == 'Send' || oli.Feedback_Notification__c == 'Do Not Send'|| oli.Feedback_Notification__c == 'Send VS Code, No Feedback') 
                    {  
                        System.debug('#### Create: CAS_Inspection_Copy__c  = ' + icId);
                        
                    
                        if (contacts.get(oli.Recipient__c) != null)
                        {
                          if(oli.Feedback_Notification__c == 'Send')oli.Feedback_Notification__c = 'Email Sent';
                          
                          contactEmail = contacts.get(oli.Recipient__c).Email;
                          contactName = contacts.get(oli.Recipient__c).Name;
                          
                          if(oli.Fulfillment_House__c != null)
                            {
                              Fulfillment_House = 'Singapore';      
                            }
                    
                    
                          // create a new inspection copy record
                          CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c
                            (   Id=icId,
                                Opportunity__c = oli.OpportunityId,
                                Opportunity_Product__c = oli.Id,
                                Book_Order__c = oli.Book_Order__c,
                                Book_Title__c = pricebookEntries.get(oli.PricebookEntryId).Name,
                                ISBN__c = pricebookEntries.get(oli.PricebookEntryId).Product2.ISBN__c,
                                OwnerId = opportunities.get(oli.OpportunityId).OwnerId,
                                Year_of_Study__c = opportunities.get(oli.OpportunityId).Year_of_Study__c,
                                Course_Start_Date__c = opportunities.get(oli.OpportunityId).Course_Start_Date__c,
                                Number_of_Students__c = opportunities.get(oli.OpportunityId).Number_of_Students__c,
                                Contact_Email__c = contactEmail,
                                Contact_Name__c = contactName,
                                Sent_Type__c = Fulfillment_House,// added to handle Sinapore requirement
                                Shipping_Date__c = oli.Shipping_Date__c,// added to handle Sinapore requirement
                                Product__c = pricebookEntries.get(oli.PricebookEntryId).Product2Id,// added to handle to product family requirement for the 4th email
                                IsTesting__c = oli.IsTesting__c, // added so Test Methods run for single record
                                Order_Type__c = oli.Order_Type__c,
                                Sent_VS_Instructor__c=   oli.VitalSource_Instructor_Email_Date__c,
                                Sent_VS_Redeemed__c  =   oli.VitalSource_Redeemed_Date__c,
                                Sent_VS_Bookshelf_Code__c = oli.VitalSource_Bookshelf_Code__c,
                                Sent_VS_Back_Order__c = oli.VitalSource_Backorder_Email_Date__c,
                                Do_Not_Send__c=icDoNotSend,
                                Do_Not_Send_Date__c=icDoNotSendDate,
                                Do_Not_Send_Reason__c=icDoNotSendReason
                            );
                    
                          inspectionCopies.add(ic);
                        }
                        else
                        {
                            oli.Feedback_Notification__c = 'No Contact/Recipient';//Default Notification
                        }
                
                        System.debug('#### Trigger.CAS_OppLineItemICCreate: Adding to IC Object = ' + oli.Id);
                    }
                  }
                  else//Update
                  {  
                    
                    System.debug('#### Update: CAS_Inspection_Copy__c  = ' + icId);
                    CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c();
                    ic.Id= icId;
                    
                    //Update Singapore Shipping Date
                    if (oli.Fulfillment_House__c != null && oli.Shipping_Date__c != existingInspectionCopies.get(icId).Shipping_Date__c)
                      {
                        ic.Shipping_Date__c = oli.Shipping_Date__c ;
                              ic.Sent_Type__c = 'Singapore';
                              ic.Do_Not_Send__c = false;
                              ic.Do_Not_Send_Date__c=null;
                              
                      }
                    
                    //Update Do Not Send values if changed.
                    if(oldFeedbackNotification != newFeedbackNotification)
                    {
                        ic.Do_Not_Send__c=icDoNotSend;
                        ic.Do_Not_Send_Date__c=icDoNotSendDate;
                        ic.Do_Not_Send_Reason__c=icDoNotSendReason;
                            
                        if(newFeedbackNotification == 'Send' &&(oldFeedbackNotification == 'Do Not Send' || oldFeedbackNotification == 'Send VS Code, No Feedback'))
                        {
                            icDoNotSendReason = system.UserInfo.getUserName() + ' set this to continue/start emailing recepient again! ' + system.now() ;
                            
                            if(existingInspectionCopies.get(icId).Do_Not_Send_Reason__c != null)
                            {icDoNotSendReason= icDoNotSendReason + '\n' + existingInspectionCopies.get(icId).Do_Not_Send_Reason__c;}
                            
                            
                            if(icDoNotSendReason.length() > 255)
                            {
                            ic.Do_Not_Send_Reason__c = icDoNotSendReason.left(255);
                            }else
                            {ic.Do_Not_Send_Reason__c = icDoNotSendReason;}
                        
                        }
                        
    
                    }
                  
                      //Update HSS VitalSource fields
                      ic.OwnerId = opportunities.get(oli.OpportunityId).OwnerId;
                      ic.Order_Type__c = oli.Order_Type__c;
                      ic.Sent_VS_Instructor__c =   oli.VitalSource_Instructor_Email_Date__c;
                      ic.Sent_VS_Redeemed__c  =   oli.VitalSource_Redeemed_Date__c;
                      ic.Sent_VS_Bookshelf_Code__c = oli.VitalSource_Bookshelf_Code__c;
                      ic.Sent_VS_Back_Order__c = oli.VitalSource_Backorder_Email_Date__c;
                      inspectionCopies.add(ic);
                  }
                  
              
            
            
            }// end for
            
            
            if (inspectionCopies.size() > 0)
              {
                upsert inspectionCopies Id;
              }
            
              System.debug('#### Trigger.CAS_OppLineItemICCreate: upsert '+ inspectionCopies.size() + ' records into CAS_Inspection_Copy__c' );
            
              // iterate over the list of keys in the map of oli being processed (0,2,3,5 etc)
              // and update the feedback notification field in the processed records so the trigger updates them
              // Get ic ids
              existingInspectionCopies = new Map<ID,CAS_Inspection_Copy__c>([Select Id, Opportunity_Product__c,Shipping_Date__c,Sent_Type__c,Order_Type__c,Sent_VS_Instructor__c,Sent_VS_Redeemed__c,Sent_VS_Bookshelf_Code__c,Sent_VS_Back_Order__c  From CAS_Inspection_Copy__c Where Opportunity_Product__c IN :oliIds]);
              System.debug('#### New List of IC to Update OLI - existingInspectionCopies.Size() = ' + existingInspectionCopies.Size());
              existingOliToIc = new Map<String,Id>();
                for (CAS_Inspection_Copy__c existingIC : existingInspectionCopies.values())//map OLI TO IC  
                {
                  existingOliToIc.put(existingIC.Opportunity_Product__c, existingIC.Id);
                }
              
              for (Integer key : casLineItems.keySet())
              {
                  trig.newList[key].Feedback_Notification__c = casLineItems.get(key).Feedback_Notification__c;
                  trig.newList[key].Textbook_Feedback__c =existingOliToIc.get(casLineItems.get(key).Id);
              } 
            
            
          }
            
        
        
        
        }
    }
}

//OLD CODE
/************************************************************************** 
* Created by Jeff Douglas
* jeff.douglas@informausa.com / 941-554-3584
* Since there is no RecordTypeId for OpportunityLineItems and the value
* of the Opportunity.RecordTypeId is null due to related object not loaded
* during triggers, we simply check the values of Adoption_Stage__c to see
* if the values are the target ones we are looking for.
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)20090610
** Last Modified by 22427 (shay.spoonmore@informausa.com)2010.05.24
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)CASE 40105 06-21-2011
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)20150107 CHG0062786
*************************************************************************


 Map<ID,Date> casLineItemsShipDate = new Map<ID,Date>();
    Set<ID> opportunityLineItemIds = new Set<ID>();
    Map<Integer,OpportunityLineItem> casLineItems = new Map<Integer,OpportunityLineItem>();
    
    Set<ID> opportunityIds = new Set<ID>();
    Set<ID> contactIds = new Set<ID>();
    Set<ID> pricebookIds = new Set<ID>();
    Map<ID, OpportunityLineItem> vitalsourceIC = new Map<ID, OpportunityLineItem>();
    
    // find all of the line items that fit the created/in-process criteria for the trigger
     for (Integer i=0;i<Trigger.new.size();i++) 
     {
         //if (Trigger.old[i].Adoption_Stage__c == 'Created' && Trigger.new[i].Adoption_Stage__c == 'In-Process') {
         //replaced above line with below line, Alex de Santiago, 2009.06.10 
        if (Trigger.new[i].Feedback_Notification__c == 'Send' && Trigger.new[i].Adoption_Stage__c == 'In-Process') 
          {
              //Trigger.old[i].Feedback_Notification__c == NULL && // taken out the above line because trigger wasn't sending email
              // add the matching oli to a map with the row as the key
              // so that we can update the oli later when trigger executes
              System.debug('#### Trigger.CAS_OppLineItemICCreate: Id = ' + Trigger.new[i].Id);
              casLineItems.put(i, Trigger.new[i]);
              // add these specific ids to sets for soql queries          
              opportunityIds.add(Trigger.new[i].OpportunityId);
              contactIds.add(Trigger.new[i].Recipient__c);
              pricebookIds.add(Trigger.new[i].PricebookEntryId);
          }
        
        //Check to see if Singapore Ship date has been updated and update the Feedback with Ship date
        if (Trigger.new[i].Fulfillment_House__c != null && Trigger.new[i].Shipping_Date__c != Trigger.old[i].Shipping_Date__c)
          {
              System.debug('*****SHIP DATE= ' + Trigger.new[i].Shipping_Date__c);
              casLineItemsShipDate.put(Trigger.new[i].id, Trigger.new[i].Shipping_Date__c);
              opportunityLineItemIds.add(Trigger.new[i].Id);
              //opportunityLineItemShipDates.add(Trigger.new[i].Shipping_Date__c);
          }
        
        //Update Vitalsource Instructor email date and redeemed date to start process
        if(Trigger.new[i].Order_Type__c == 'HSS Vitalsource e-Exam copy' && (Trigger.new[i].VitalSource_Instructor_Email_Date__c != Trigger.old[i].VitalSource_Instructor_Email_Date__c
        || Trigger.new[i].VitalSource_Redeemed_Date__c != Trigger.old[i].VitalSource_Redeemed_Date__c 
        || Trigger.new[i].VitalSource_Bookshelf_Code__c != Trigger.old[i].VitalSource_Bookshelf_Code__c 
        || Trigger.new[i].VitalSource_Backorder_Email_Date__c != Trigger.old[i].VitalSource_Backorder_Email_Date__c))
          {
            vitalsourceIC.put(Trigger.new[i].Id, Trigger.new[i]);
          }
        
        
    }
    
    //Check for IC to update with vitalsource dates
    if (vitalsourceIC.size() > 0)
    {
      List<CAS_Inspection_Copy__c> vitalsourceUpdate = new List<CAS_Inspection_Copy__c>();
      for (CAS_Inspection_Copy__c iCopy : [Select Id, Opportunity_Product__c from CAS_Inspection_Copy__c Where Opportunity_Product__c != null and Opportunity_Product__c IN :vitalsourceIC.keySet()])
        {
          OpportunityLineItem vsDates = vitalsourceIC.get(iCopy.Opportunity_Product__c);
          if (vsDates != null)
          {
            vitalsourceUpdate.Add(new CAS_Inspection_Copy__c(
            id=iCopy.Id,
            Sent_VS_Instructor__c=   vsDates.VitalSource_Instructor_Email_Date__c,
            Sent_VS_Redeemed__c  =   vsDates.VitalSource_Redeemed_Date__c,
            Sent_VS_Bookshelf_Code__c = vsDates.VitalSource_Bookshelf_Code__c,
            Sent_VS_Back_Order__c = vsDates.VitalSource_Backorder_Email_Date__c,
            Order_Type__c = vsDates.Order_Type__c  ));
          }
        
        }
        
        if (vitalsourceUpdate.size() > 0) update vitalsourceUpdate;
      
    }
    
    //Check if any singapore items can be updated with shipping date
    if (casLineItemsShipDate.size() > 0) 
    {
      System.debug('*****###casLineItemsShipDate.size()= ' + casLineItemsShipDate.size());
        System.debug('*****###opportunityLineItemIds.size()= ' + opportunityLineItemIds.size());
         //System.debug('*****###opportunityLineItemIds= ' + opportunityLineItemIds);
       
        
        List<CAS_Inspection_Copy__c> inspectionCopiesUpdate = new List<CAS_Inspection_Copy__c>();
        for (CAS_Inspection_Copy__c iCopy : [Select Id, Opportunity_Product__c from CAS_Inspection_Copy__c Where Opportunity_Product__c != null and Opportunity_Product__c IN :opportunityLineItemIds limit 300])
        {
                System.debug('*****iCopy.Id' + iCopy.Id);
                System.debug('*****casLineItemsShipDate.get(iCopy.Opportunity_Product__c)=' + casLineItemsShipDate.get(iCopy.Opportunity_Product__c));
                CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c(
                    Id = iCopy.Id,
                    Shipping_Date__c = casLineItemsShipDate.get(iCopy.Opportunity_Product__c),
                    Sent_Type__c = 'Singapore');   
            
                inspectionCopiesUpdate.add(ic);
        
        }
        
        if (inspectionCopiesUpdate.size() > 0) Update inspectionCopiesUpdate;
    }
    
    
    
    
    
    
    
    
    // if there are any cas items in the maps, then process them
    if (casLineItems.size() > 0) {
        
        // the list of inspection objects to insert
        List<CAS_Inspection_Copy__c> inspectionCopies = new List<CAS_Inspection_Copy__c>();
        // get all of the opportunities for the line items
        Map<ID,Opportunity> opportunities = new Map<ID,Opportunity>([Select Year_of_Study__c, Course_Start_Date__c, Number_of_Students__c, OwnerId from Opportunity Where Id IN :opportunityIds]);
        // get all of the contacts/recipeints for the line items
        Map<ID,Contact> contacts = new Map<ID,Contact>([Select Name, Email from Contact Where Id IN :contactIds]);
        // get all of the pricebookentries for the line items
        Map<ID,PricebookEntry> pricebookEntries = new Map<ID,PricebookEntry>([Select p.Product2Id, p.Product2.ISBN__c, p.Pricebook2Id, p.Name From PricebookEntry p Where p.Id IN :pricebookIds]);  
                
        // iterate over the list of values in the map of oli being processed -  the actual opportunity line items
        for (OpportunityLineItem oli : casLineItems.values()) {
            
            // the email address of the recepient. if blank then workflow will not send email
            String contactEmail;
            String contactName;
            String Fulfillment_House = null;
           
            
            
            // set the opportunity line item to email sent and add the email address
            if (oli.Feedback_Notification__c == 'Send') 
            {
                oli.Feedback_Notification__c = 'No Contact/Recipient';//Default Notification
                
                if (contacts.get(oli.Recipient__c) != null)
                {
                  oli.Feedback_Notification__c = 'Email Sent';
                  
                  contactEmail = contacts.get(oli.Recipient__c).Email;
                  contactName = contacts.get(oli.Recipient__c).Name;
                  
                  
                  if(oli.Fulfillment_House__c != null)
                    {
                        Fulfillment_House = 'Singapore';
                            
                    }
            
            
                  // create a new inspection copy record
                  CAS_Inspection_Copy__c ic = new CAS_Inspection_Copy__c
                    (
                      Opportunity__c = oli.OpportunityId,
                      Opportunity_Product__c = oli.Id,
                      Book_Order__c = oli.Book_Order__c,
                      Book_Title__c = pricebookEntries.get(oli.PricebookEntryId).Name,
                      ISBN__c = pricebookEntries.get(oli.PricebookEntryId).Product2.ISBN__c,
                      OwnerId = opportunities.get(oli.OpportunityId).OwnerId,
                      Year_of_Study__c = opportunities.get(oli.OpportunityId).Year_of_Study__c,
                      Course_Start_Date__c = opportunities.get(oli.OpportunityId).Course_Start_Date__c,
                      Number_of_Students__c = opportunities.get(oli.OpportunityId).Number_of_Students__c,
                      Contact_Email__c = contactEmail,
                      Contact_Name__c = contactName,
                      Sent_Type__c = Fulfillment_House,// added to handle Sinapore requirement
                      Shipping_Date__c = oli.Shipping_Date__c,// added to handle Sinapore requirement
                      Product__c = pricebookEntries.get(oli.PricebookEntryId).Product2Id,// added to handle to product family requirement for the 4th email
                      IsTesting__c = oli.IsTesting__c, // added so Test Methods run for single record
                    Order_Type__c = oli.Order_Type__c,
                    Sent_VS_Instructor__c=   oli.VitalSource_Instructor_Email_Date__c,
                Sent_VS_Redeemed__c  =   oli.VitalSource_Redeemed_Date__c,
                Sent_VS_Bookshelf_Code__c = oli.VitalSource_Bookshelf_Code__c,
                Sent_VS_Back_Order__c = oli.VitalSource_Backorder_Email_Date__c
                    );
            
                  inspectionCopies.add(ic);
                  
                }
            
               
        System.debug('#### Trigger.CAS_OppLineItemICCreate: Adding to IC Object = ' + oli.Id);
            } //ends if block of oli.Feedback_Notification__c == 'Send' (Jeff Lup, 2009.06.02)
            
        }
        
        // insert the inspection copy records - just fail on an error
        if (inspectionCopies.size() > 0)
        {
          insert inspectionCopies;
        }
        
        System.debug('#### Trigger.CAS_OppLineItemICCreate: Insert '+ inspectionCopies.size() + ' records into CAS_Inspection_Copy__c' );
        // iterate over the list of keys in the map of oli being processed (0,2,3,5 etc)
        // and update the feedback notification field in the processed records so the trigger updates them
        for (Integer key : casLineItems.keySet())
            Trigger.new[key].Feedback_Notification__c = casLineItems.get(key).Feedback_Notification__c; 
        
    }
 **/