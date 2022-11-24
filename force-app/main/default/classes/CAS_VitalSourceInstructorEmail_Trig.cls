/*
** Tested by: Tests_CASVitalSource.cls
**
** Modified by Shay Spoonmore - 2014-07-21
** Modified by Jeff Lup - 2015.02.26 - Moved trigger into this class
**Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2015-05-28 CHG0065975
**Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2016-01-05 CHG0069838 stop prompts to redeem/request feedback going out to lecturers who have objected to the EIC process
** Last Modified by Matt Smith on 2020-11-10 Updating line 22, so the code runs for any order type where the text contains "Vitalsource e-Exam copy" - 01672236
** Last Modified by Renil Rejith on 2022-02-16, for SAL-5362 - Line 29, added another condition to check if Vistalsource Bookshelf code is NULL for BackOrder email.
*/
public without sharing class CAS_VitalSourceInstructorEmail_Trig implements TriggerInterface_OLI.Runnable {
    public void run(TriggerInterface_OLI.Trig trig) {
        if (trig.isAfter && trig.isUpdate) {
            //List<OpportunityLineItem> olisEmail =new List<OpportunityLineItem>();
            List<OpportunityLineItem> olisEmailVS =new List<OpportunityLineItem>();
            List<OpportunityLineItem> olisEmailVSBackOrderCheck = new List<OpportunityLineItem>();
            Set<Id> productIds = new Set<Id>();
            for (Integer i=0;i<trig.newList.size();i++) 
            { 
                System.debug('#### trig.newList[i].VitalSource_Instructor_Email_Date__c:' + trig.newList[i].VitalSource_Instructor_Email_Date__c);
                System.debug('#### trig.newList[i].VitalSource_Bookshelf_Code__c:' + trig.newList[i].VitalSource_Bookshelf_Code__c);
                
                if (trig.newList[i].Feedback_Notification__c != 'Do Not Send' && trig.newList[i].Order_Type__c != null && trig.newList[i].Order_Type__c.contains('Vitalsource e-Exam copy')) //&& trig.newList[i].Order_Type__c !='Vitalsource e-Exam copy')// TEMP - Order_Type__c !='Vitalsource e-Exam copy' because some records have this old value that should be updated with correct order type //WRQ0436296
                {
                     if (trig.newList[i].VitalSource_Instructor_Email_Date__c == null && trig.newList[i].VitalSource_Bookshelf_Code__c != null) 
                     {
                        olisEmailVS.add(trig.newList[i]);
                     }
                     else if (trig.newList[i].VitalSource_Backorder_Email_Date__c == null && trig.newList[i].VitalSource_Bookshelf_Code__c == null)
                     {
                        System.debug('#### Check if product is in backorder');
                        olisEmailVSBackOrderCheck.add(trig.newList[i]);
                        productIds.add(trig.newList[i].Product2Id); 
                        
                     }
                        
                }
                
                
            }
            
            
            
            
            
            if (olisEmailVSBackOrderCheck.size() > 0) 
            { //Process Backorder emails
                Map<Id, String> productVitalSourceStatus = new Map<Id, String>();
                // Add Vitalsource Statuses here that == backorder
                for (Product2 product : [Select Id, VitalSource_Status__c from Product2 Where (VitalSource_Status__c = Null or VitalSource_Status__c Not In ('Live','In Inventory'))  AND Id=:productIds]) 
                {
                    productVitalSourceStatus.put(product.Id, 'Back Order!!!!');//product.VitalSource_Status__c
                }
                
                if(productVitalSourceStatus.size() > 0) {
                    System.debug('#### Products are in backorder:' + productVitalSourceStatus.size());
                    List<OpportunityLineItem> olisEmailVSBackOrders = new List<OpportunityLineItem>();
                    for (OpportunityLineItem oli : olisEmailVSBackOrderCheck) {
                        if (productVitalSourceStatus.get(oli.Product2Id) != null) {
                            olisEmailVSBackOrders.add(oli);
                        }
                    }
                    
                    if(olisEmailVSBackOrders.size() > 0) 
                    { //Send Backorder emails (Email 6)
                        System.debug('#### Sending backorder emails:' + olisEmailVSBackOrders.size());
                        
                        CAS_VitalSource.SendInstructorEmail(olisEmailVSBackOrders, system.Userinfo.getOrganizationId(),'VitalSource_Backorder_Email_Date__c');
                    }
                }
            }
            
               
            if (olisEmailVS.size() >0) 
            {   //Send Bookshelf code Email 1
                
                CAS_VitalSource.SendInstructorEmail(olisEmailVS, system.Userinfo.getOrganizationId(),'VitalSource_Instructor_Email_Date__c');
            }
            
            //if (olisEmail.size() >0) {
            //    //NOTE: double check template is the same in production '00X60000004HH0M'
            //    CAS_VitalSource.SendInstructorEmail(olisEmail,'00X60000004HH0M', system.Userinfo.getOrganizationId(),'VitalSource_Instructor_Email_Date__c');
           // }
        }
    }
}