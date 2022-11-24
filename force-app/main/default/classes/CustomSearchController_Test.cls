@isTest
private class CustomSearchController_Test {
    static testMethod void Ir_Controller () {
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        contact cc=new contact ();
        cc.lastname='test';
        cc.AccountId=acc.id;
        insert cc;
        Account acc1=zTEST_Shared.insertAccount(u.id);
        contact cc1=new contact ();
        cc1.lastname='test';
        cc1.AccountId=acc1.id;
        insert cc1;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'India Reprint Printer' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jadfsdfson.liveston@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US',
                            contactid=cc.id
                            
                           );
        
        System.runas(usr) 
        {
            Print_Order__c  printorderobj=new Print_Order__c();
            printorderobj.Status__c='Print Order Created';
            printorderobj.Invoice_Number__c='1234';
            printorderobj.Reference_Number__c='1234';
            printorderobj.Payment_Terms__c='69days';
            printorderobj.Delivery_Date__c=system.today();
            printorderobj.Special_Instructions__c='test';
            printorderobj.Packing_Instructions__c='test';
            printorderobj.Customer__c=acc.id;
            printorderobj.Printer__c=acc.id;
            printorderobj.isPoUploaded__c=true;
            
            insert printorderobj;
            printorderobj = [select Id, Name from Print_Order__c where id = : printorderobj.id];
            
            system.debug('!!!!!!!!!'+printorderobj);
            List<Print_Order__c> lla = CustomSearchController.searchForIds(printorderobj.name);
        }
    }   
    @isTest static void testMethod1() {
        
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        contact cc=new contact ();
        cc.lastname='test';
        cc.AccountId=acc.id;
        insert cc;
        Account acc1=zTEST_Shared.insertAccount(u.id);
        contact cc1=new contact ();
        cc1.lastname='test';
        cc1.AccountId=acc1.id;
        insert cc1;
        
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'India Reprint Distributor' LIMIT 1];
        
        User usr1 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.liveston@asdf.com',
                             Username = 'jadfsdfasson.liveston@asdf.com',
                             ProfileId = profileId1.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US',
                             contactid=cc1.id
                             
                            );
        System.runas(usr1) 
        {
            Print_Order__c  printorderobj=new Print_Order__c();
            printorderobj.Status__c='Print Order Created';
            printorderobj.Invoice_Number__c='1234';
            printorderobj.Reference_Number__c='1234';
            printorderobj.Payment_Terms__c='69days';
            printorderobj.Delivery_Date__c=system.today();
            printorderobj.Special_Instructions__c='test';
            printorderobj.Packing_Instructions__c='test';
            printorderobj.Customer__c=acc1.id;
            printorderobj.Printer__c=acc1.id;
            printorderobj.isPoUploaded__c=true;
            insert printorderobj;
            printorderobj = [select Id, Name from Print_Order__c where id = : printorderobj.id];
            
            List<Print_Order__c> lla = CustomSearchController.searchForIds(printorderobj.name);        }
        
    }
    @isTest static void testMethod2() {
        
        User u = zTEST_Shared.insertUser();
        Account acc=zTEST_Shared.insertAccount(u.id);
        contact cc=new contact ();
        cc.lastname='test';
        cc.AccountId=acc.id;
        insert cc;
        Account acc1=zTEST_Shared.insertAccount(u.id);
        contact cc1=new contact ();
        cc1.lastname='test';
        cc1.AccountId=acc1.id;
        insert cc1;
        
        Profile profileId1 = [SELECT Id FROM Profile WHERE Name = 'India Reprint Credit Control' LIMIT 1];
        
        User usr1 = new User(LastName = 'LIVESTON',
                             FirstName='JASON',
                             Alias = 'jliv',
                             Email = 'jason.liveston@asdf.com',
                             Username = 'jadfsdfasson.liveston@asdf.com',
                             ProfileId = profileId1.id,
                             TimeZoneSidKey = 'GMT',
                             LanguageLocaleKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LocaleSidKey = 'en_US',
                             contactid=cc1.id
                             
                            );
        System.runas(usr1) 
        {
            Print_Order__c  printorderobj=new Print_Order__c();
            printorderobj.Status__c='Print Order Created';
            printorderobj.Invoice_Number__c='1234';
            printorderobj.Reference_Number__c='1234';
            printorderobj.Payment_Terms__c='69days';
            printorderobj.Delivery_Date__c=system.today();
            printorderobj.Special_Instructions__c='test';
            printorderobj.Packing_Instructions__c='test';
            printorderobj.Customer__c=acc1.id;
            printorderobj.Printer__c=acc1.id;
            printorderobj.isPoUploaded__c=true;
            insert printorderobj;
            printorderobj = [select Id, Name from Print_Order__c where id = : printorderobj.id];
            
            List<Print_Order__c> lla = CustomSearchController.searchForIds(printorderobj.name);        }
        
    }
}