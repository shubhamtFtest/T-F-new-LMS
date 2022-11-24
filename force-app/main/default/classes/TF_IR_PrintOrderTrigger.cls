/*
** Tested by: zTEST_TF_IR_PrintOrderTrigger.cls
**
** Modified by Sidhant Singh 7/18/2020
*/
public with sharing  class TF_IR_PrintOrderTrigger implements TriggerInterface_PrintOrder.Runnable {
    public void run(TriggerInterface_PrintOrder.Trig trig) {
     try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'apc@tandf.co.uk'];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
            Id currentUserProfileId = UserInfo.getProfileId();
            Id currentUserId = UserInfo.getUserId();
            String profileName = [Select Name from Profile where Id =: currentUserProfileId].Name;
            String userName=[Select Name from User where id=:currentUserId].Name;
            IR_CommunityURL__c commurl=[select URL__c from IR_CommunityURL__c  limit 1];
            map<id,Id>  useridprintorderidmap=new map<id,Id>();
            map<id,Id>  useridprintorderidmapprinter=new map<id,Id>();
            map<id,String>  useridemail=new map<id,String>();
            map<id,String>  useridname=new map<id,String>();
            map<id,String>  useridemailPrinter=new map<id,String>();
            map<id,String>  useridnamePrinter=new map<id,String>();
            Set<Id> printorderid=new Set<Id>();
            for (Print_Order__c printRec : trig.newList) {
                printorderid.add(printRec.Id);
            }
           
            
            if (trig.isAfter && trig.isUpdate) {
                 for(Print_Order__c pro:[select id,Customer__r.RelatedUserId__c,printer__r.RelatedUserId__c from Print_Order__c where id in:printorderid]){
                useridprintorderidmap.put(pro.Customer__r.RelatedUserId__c,pro.Id);
                useridprintorderidmapprinter.put(pro.printer__r.RelatedUserId__c,pro.Id);
            }
            system.debug(profileName+'useridprintorderidmap'+useridprintorderidmap);
            for(User us:[select id,email,Name from user where id in :useridprintorderidmap.keyset()]){
                useridemail.put(useridprintorderidmap.get(us.id),us.email);
                useridname.put(useridprintorderidmap.get(us.id),us.Name);
                
            }
            for(User us:[select id,email,Name from user where id in :useridprintorderidmapprinter.keyset()]){
                useridemailPrinter.put(useridprintorderidmapprinter.get(us.id),us.email);
                useridnamePrinter.put(useridprintorderidmapprinter.get(us.id),us.Name);
            }
                for (Print_Order__c printRec : trig.newList) {
                    if(profileName=='India Reprint Distributor' && printRec.Distr_Approve_Packing_Details__c==true && 
                       (trig.oldmap.get(printRec.Id).Distr_Approve_Packing_Details__c!=trig.newmap.get(printRec.Id).Distr_Approve_Packing_Details__c)){
                           //Send Email to printer and production   
                           Messaging.SingleEmailMessage secemail = new Messaging.SingleEmailMessage();
                           if ( owea.size() > 0 ) {
                               secemail.setOrgWideEmailAddressId(owea[0].Id);
                           }
                           secemail.setTreatTargetObjectAsRecipient(false);
                           secemail.saveAsActivity = false;
                           String bodyStrcommunity='<html><body><table width="550" border="0">';
                           String [] strlist=new string[] {printRec.Owner.Email};
                               secemail.setToAddresses(strlist);
                           secemail.setSubject('India Reprint – Distributor Approved Packaging Detail');
                           bodyStrcommunity+='<tr><td>Dear '+ printRec.Owner.Name +'<br><br>';
                           bodyStrcommunity+=' Please note that the Print Order Packaging Detail <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                           bodyStrcommunity+=' has Been Approved By Distributor.</td></tr>';
                           bodyStrcommunity+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                           bodyStrcommunity+='</table></body></html>';
                           secemail.setHtmlBody(bodyStrcommunity);            
                           emailList.add(secemail);            
                           Messaging.SendEmailResult [] rsec = Messaging.sendEmail(emailList);
                           //Community Email to Printer
                           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           if ( owea.size() > 0 ) {
                               email.setOrgWideEmailAddressId(owea[0].Id);
                           }
                           email.setTreatTargetObjectAsRecipient(false);
                           email.saveAsActivity = false;
                           String bodyStrSalesforce='<html><body><table width="550" border="0">';
                           String [] strlistone=new string[] {useridemailPrinter.get(printRec.Id)};
                               
                               email.setToAddresses(strlistone);
                           email.setToAddresses(strlistone);
                           email.setSubject('India Reprint – Distributor Approved Packaging Detail');
                           bodyStrSalesforce+='<tr><td>Dear '+ useridnamePrinter.get(printRec.Id) +'<br><br>';
                           bodyStrSalesforce+=' Please note that the Print Order Packaging Detail <a href="'+ commurl.URL__c + '/IR/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                           bodyStrSalesforce+=' has Been Approved By Distributor.</td></tr>';
                           bodyStrSalesforce+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                           bodyStrSalesforce+='</table></body></html>';
                           email.setHtmlBody(bodyStrSalesforce);            
                           emailList.add(email);            
                           Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
                           
                       }else if(profileName=='India Reprint Production' && printRec.Prod_Approve_Packing_Details_del__c==true &&
                                (trig.oldmap.get(printRec.Id).Prod_Approve_Packing_Details_del__c!=trig.newmap.get(printRec.Id).Prod_Approve_Packing_Details_del__c)){
                                    //Send Email to Distributor   
                                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                    if ( owea.size() > 0 ) {
                                        email.setOrgWideEmailAddressId(owea[0].Id);
                                    }
                                    email.setTreatTargetObjectAsRecipient(false);
                                    email.saveAsActivity = false;
                                    String bodyStrSalesforce='<html><body><table width="550" border="0">';
                                    String [] strlistone=new string[] {useridemail.get(printRec.Id)};
                                        system.debug('$$$$$$$$$$$$$'+strlistone);
                                    email.setToAddresses(strlistone);
                                    email.setSubject('India Reprint – Production Approved Packaging Detail');
                                    bodyStrSalesforce+='<tr><td>Dear '+ useridname.get(printRec.Id) +'<br><br>';
                                    bodyStrSalesforce+=' Please note that the Print Order Packaging Detail <a href="'+ commurl.URL__c + '/IR/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                                    bodyStrSalesforce+=' has Been Approved By Production.</td></tr>';
                                    bodyStrSalesforce+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                                    bodyStrSalesforce+='</table></body></html>';
                                    email.setHtmlBody(bodyStrSalesforce);            
                                    emailList.add(email);            
                                    Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
                                                                    system.debug('commemail'+r);

                                }
                    else if(profileName=='India Reprint Production' && printRec.Document_Approved__c==true &&
                            (trig.oldmap.get(printRec.Id).Document_Approved__c!=trig.newmap.get(printRec.Id).Document_Approved__c)){
                                //Send Email To Printer   
                                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                if ( owea.size() > 0 ) {
                                    email.setOrgWideEmailAddressId(owea[0].Id);
                                }
                                email.setTreatTargetObjectAsRecipient(false);
                                email.saveAsActivity = false;
                                String bodyStrSalesforce='<html><body><table width="550" border="0">';
                                String [] strlistone=new string[] {useridemailPrinter.get(printRec.Id)};
                                    email.setToAddresses(strlistone);
                                email.setSubject('India Reprint – Production Document Approved');
                                bodyStrSalesforce+='<tr><td>Dear '+ useridnamePrinter.get(printRec.Id) +'<br><br>';
                                bodyStrSalesforce+=' Please note that  All the related  Documents of  <a href="'+ commurl.URL__c + '/IR/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                                bodyStrSalesforce+=' has Been Approved By Production .</td></tr>';
                                bodyStrSalesforce+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                                bodyStrSalesforce+='</table></body></html>';
                                email.setHtmlBody(bodyStrSalesforce);            
                                emailList.add(email);            
                                Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
                                system.debug('commemail'+r);
                            }
                    else if(printRec.Status__c=='Delivered' && (trig.oldmap.get(printRec.Id).Status__c!=trig.newmap.get(printRec.Id).Status__c)){
                        //Send Email To distributor and production   
                        Messaging.SingleEmailMessage secemail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            secemail.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        secemail.setTreatTargetObjectAsRecipient(false);
                        secemail.saveAsActivity = false;
                        String bodyStrcommunity='<html><body><table width="550" border="0">';
                        String [] strlist=new string[] {printRec.Owner.Email};
                            secemail.setToAddresses(strlist);
                        secemail.setSubject('India Reprint – Print Order is Been Delivered');
                        bodyStrcommunity+='<tr><td>Dear '+ printRec.Owner.Name +'<br><br>';
                        bodyStrcommunity+=' Please note that the Print Order  <a href="'+system.url.getSalesforceBaseUrl().toExternalForm() + '/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                        bodyStrcommunity+=' has Been Delivered .</td></tr>';
                        bodyStrcommunity+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                        bodyStrcommunity+='</table></body></html>';
                        secemail.setHtmlBody(bodyStrcommunity);            
                        emailList.add(secemail);            
                        Messaging.SendEmailResult [] rsec = Messaging.sendEmail(emailList);
                        //Community Email to Printer
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            email.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        email.setTreatTargetObjectAsRecipient(false);
                        email.saveAsActivity = false;
                        String bodyStrSalesforce='<html><body><table width="550" border="0">';
                        String [] strlistone=new string[] {useridemail.get(printRec.Id)};
                            email.setToAddresses(strlistone);
                        email.setSubject('India Reprint – Print Order is Been Delivered');
                        bodyStrSalesforce+='<tr><td>Dear '+ useridname.get(printRec.Id) +'<br><br>';
                        bodyStrSalesforce+=' Please note that the Print Order  <a href="'+ commurl.URL__c + '/IR/' + printRec.Id +'" target="_blank"><b>'+ printRec.Name +'</b></a>';            
                        bodyStrSalesforce+=' has Been Delivered .</td></tr>';
                        bodyStrSalesforce+='<tr><td><br>With regards,<br>'+ userName +'</td></tr>'; 
                        bodyStrSalesforce+='</table></body></html>';
                        email.setHtmlBody(bodyStrSalesforce);            
                        emailList.add(email);            
                        Messaging.SendEmailResult [] r = Messaging.sendEmail(emailList);
                        
                    }
                    
                }
            }
        }catch(Exception e){
            System.debug('Error'+e.getMessage());
        }   
    }
}