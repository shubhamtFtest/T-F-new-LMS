@isTest
public class zTEST_TF_IR_PrintOrderTrigger {
    static testMethod void testCloseWonValidation() {   
        Profile profileIdpri = [SELECT Id FROM Profile WHERE Name = 'India Reprint Printer' LIMIT 1];
        User usrprinter = new User(LastName = 'LIVESTON',
                                   FirstName='JASON',
                                   Alias = 'jliv',
                                   Email = 'jason.liveston@asdf.com',
                                   Username = 'jadfsdfsson.liveston@asdf.com',
                                   ProfileId = profileIdpri.id,
                                   TimeZoneSidKey = 'GMT',
                                   LanguageLocaleKey = 'en_US',
                                   EmailEncodingKey = 'UTF-8',
                                   LocaleSidKey = 'en_US'
                                  );
        insert usrprinter;
        Profile profileIddist = [SELECT Id FROM Profile WHERE Name = 'India Reprint Distributor' LIMIT 1];
        User usrdistributor = new User(LastName = 'LIVESTON',
                                       FirstName='JASON',
                                       Alias = 'jliv',
                                       Email = 'jason.liveston@asdf.com',
                                       Username = 'jadfsdfssosn.liveston@asdf.com',
                                       ProfileId = profileIddist.id,
                                       TimeZoneSidKey = 'GMT',
                                       LanguageLocaleKey = 'en_US',
                                       EmailEncodingKey = 'UTF-8',
                                       LocaleSidKey = 'en_US'
                                      );
        insert usrdistributor;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'India Reprint Production' LIMIT 1];
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jadfsdfson.liveston@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert usr;
        Profile profileId2 = [SELECT Id FROM Profile WHERE Name = 'India Reprint Distributor' LIMIT 1];
        User usr2 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.liveston@asdf.com',
                             Username = 'jadfsdfdsn.liveston@asdf.com',
                             ProfileId = profileId2.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US'
                            );
        insert usr2;
        User u = zTEST_Shared.insertUser();
        Account ap = zTEST_Shared.noinsertAccount(u.Id);
        ap.RelatedUserId__c=usrprinter.Id;
        insert ap;
        Account ad = zTEST_Shared.noinsertAccount(u.Id);
        ad.RelatedUserId__c=usrdistributor.Id;
        insert ad;
        Print_Order__c pobjp=new Print_Order__c();
        pobjp.Delivery_Date__c=System.today();
        pobjp.Document_Approved__c=false;
        pobjp.OwnerId=u.id;
        pobjp.Printer__c=ap.id;
        pobjp.Customer__c=ad.id;
        pobjp.Status__c='Print Order Created';
        pobjp.Prod_Approve_Packing_Details_del__c=false;
        pobjp.Document_Approved__c=false;
        pobjp.Distr_Approve_Packing_Details__c=false;
        insert pobjp;
        Print_Order__c pobj=[select Customer__r.RelatedUserId__c,Prod_Approve_Packing_Details_del__c,Status__c,Customer__c,Printer__c,OwnerId,Document_Approved__c,Delivery_Date__c,printer__r.RelatedUserId__c,Distr_Approve_Packing_Details__c from Print_Order__c where id=:pobjp.Id];
        system.debug('pobj'+pobj);
        IR_CommunityURL__c setting = new IR_CommunityURL__c();
        setting.URL__c = 'https://devir-tandf.cs101.force.com/IR';
        insert setting;
        TriggerInterfaceHelper.runTrigger('TF_IR_PrintOrderTrigger','Print_Order__c',1,'au',null,null);
        pobj.Status__c='Delivered';
        update pobj;
        System.runas(usr) 
        {
            pobj.Prod_Approve_Packing_Details_del__c=true;
            update pobj;
            pobj.Document_Approved__c=true;
            update pobj;
        }
        System.runas(usr2) 
        {     
            pobj.Distr_Approve_Packing_Details__c=true;
            update pobj;  
        }
    }
    
}