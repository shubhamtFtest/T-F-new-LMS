@isTest(SeeAllData=false)
private class zTest_BulkUpdateCase{
  
     
    @istest 
    private static void testupdateOwner(){

        Case ca = new Case(status='New');
        insert ca;

        Task tsk = new Task();
        tsk.whatid = ca.id;
        tsk.Subject = 'test';
        tsk.ActivityDate = Date.Today()+3;
        tsk.Status = 'In Progress';
        tsk.Description = 'test desc';

        insert tsk;

        Event evt = new Event();

        evt.whatid = ca.id;
        evt.DurationInMinutes = 0 ;
        evt.ActivityDateTime = Datetime.Now().addMinutes(5);
        evt.EndDateTime = Datetime.Now().addMinutes(5);

        insert evt;

        List<Case> casLst = new List<Case>();
        casLst.add(ca);

        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(casLst);
        ssc.setSelected(casLst);
        BulkUpdateCase bcu = new  BulkUpdateCase(ssc);

        id currentUserId = userinfo.getuserid();
        id profId = userinfo.getProfileId();

        User usr = [Select id from User where id != : currentUserId and profileId = : profId and IsActive = true Limit 1] ;

        bcu.cas.ownerid = usr.id;

        Test.startTest();

            bcu.updateOwner();

        Test.stopTest();

        Case caseUpdn = [Select Id, Ownerid from case where id =: ca.id];

        System.assertEquals(caseUpdn.ownerid, usr.id);

    }


    @istest 
    private static void testupdateStatus(){

        Case ca = new Case(status='New');
        insert ca;

        List<Case> casLst = new List<Case>();
        casLst.add(ca);

        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(casLst);
        ssc.setSelected(casLst);
        BulkUpdateCase bcu = new  BulkUpdateCase(ssc);

        bcu.cas.ownerid = userinfo.getuserid();
        bcu.cas.Status = 'In Progress';


        Test.startTest();

            bcu.updateStatus();
            bcu.updateCurrentOwner();
        Test.stopTest();

        Case caseUpdn = [Select Id, status from case where id =: ca.id];

        System.assertEquals(caseUpdn.status, 'In Progress');

    }

}