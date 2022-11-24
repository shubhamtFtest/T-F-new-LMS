@isTest
global class zTestEmailArchiveAndUnArchive {
 
    static testMethod void test1() {
        
   
        case cse = new case();
        cse.Origin = 'web';
        cse.Status = 'New';
        insert cse;
        
        cse.Status = 'Closed';
        cse.Reason = 'Access Issue';
        cse.CurrencyIsoCode = 'USD';
        update cse;
        
        Case cc = [select ClosedDate,CreatedDate from case where id=: cse.Id];
        
        system.debug('*******'+cse);
        system.debug('*******'+cc.closedDate + '*******'+cc.CreatedDate);
        
        
        EmailMessage em = new EmailMessage();
        em.Subject = 'test';
        em.ParentId = cc.id;
        insert em;
        
        attachment at = new attachment();
        at.ParentId = em.id;
        at.Name = 'test';
        at.Body = blob.toPdf('testing Only');
        insert at;
        
        Datetime yesterday = Datetime.now().addDays(-100);
        Test.setCreatedDate(cc.Id, yesterday); 
       
        Archive_UnArchive_Emails__c custom1 = new Archive_UnArchive_Emails__c();
        custom1.name = 'Archive';
        custom1.Case_Closed_older_Then__c = '0';
        custom1.Batch_Limit__c = '50000';
        insert custom1;
        test.startTest();
        ScheduleToArchiveBatch c = new ScheduleToArchiveBatch();
        String sch = '0 28 5 * * ?';
        System.schedule('Schedule Job65', sch, c);
        ScheduleToUnArchiveBatch b = new ScheduleToUnArchiveBatch();
        String sch1 = '0 28 5 * * ?';
        System.schedule('Schedule Job85', sch1, b);
        ToArchiveBatch baR= new ToArchiveBatch(); 
        database.executebatch(baR,10);
        ToUnArchiveBatch buAr= new ToUnArchiveBatch(); 
        database.executebatch(buAr,10);
        test.stopTest();
    }
    static testMethod void test2(){
        case cc = new case();
        cc.Origin = 'web';
        insert cc;
        EmailMessage em = new EmailMessage();
        em.Subject = 'test';
        em.ParentId = cc.id;
        insert em;
        attachment at = new attachment();
        at.ParentId = em.id;
        at.Name = 'test';
        at.Body = blob.toPdf('testing Only');
        insert at;
        PageReference pageRef = Page.ArchiveEmailVf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(cc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(cc);
        emailArchive  eA = new emailArchive (sc);
        ea.Archive();
        ea.exitpg();
        test.startTest();
         FutureArchiveUnArchive.FutureArchive(cc.id);
        test.stopTest();
        PageReference pageRefUnArc = Page.UnArchiveEmailVf;
        Test.setCurrentPage(pageRefUnArc);
        pageRefUnArc.getParameters().put('Id', String.valueOf(cc.Id));
        ApexPages.StandardController scUnArc = new ApexPages.StandardController(cc);
        emailUnArchive  EUnArc = new emailUnArchive(scUnArc);
        EUnArc.Recover();
        EUnArc.exitpg();
    }
    
    
    
}