@isTest
public class Test_TF_upLoadEmailPrefrence {
    static String str1 = 'EMAIL\n test@test.com,test2@test.com';
    static String str = 'EMAIL,Status,Reason\n test@test1.com,Prospect,Test\n test3@test.com,10002,Prospect,Test,Banking';
    //static String str = 'Email\n test@test1.com\n test3@test.com';       
    
    public static String[] csvFileLines;
    public static Blob csvFileBody;
    
    @testsetup static void methodName() {
 
}
    @isTest
    public static void UploadGDPRTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
User u = new User(Alias = 'standt', Email='standarduser111@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser111@testorg.com');

        
       Email_preference__c empfr= new Email_preference__c();
        empfr.Email__c='test@test1.com';
        empfr.Status__c='Unsubscribed';
        empfr.Reason__c='Book Purchasing Page Opt Out';
        insert empfr;
        system.debug('empfr'+empfr);
        System.runAs(u) {
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        TF_upLoadEmailPrefrenceCtrl Ctrl = new TF_upLoadEmailPrefrenceCtrl();
        Ctrl.csvFileBody=csvFileBody;
       // Mehtod Calling
        Ctrl.importCSVFile();
        Test.stopTest();
        }
    }
    
    static testmethod void UploadGDPRTestNegative(){
        //  testsetup1();
        Test.startTest();
        csvFileBody = Blob.valueOf(str1);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        TF_upLoadEmailPrefrenceCtrl Ctrl = new TF_upLoadEmailPrefrenceCtrl();
        Ctrl.csvFileBody=csvFileBody;
        Ctrl.importCSVFile();
        Test.stopTest();
    }
}