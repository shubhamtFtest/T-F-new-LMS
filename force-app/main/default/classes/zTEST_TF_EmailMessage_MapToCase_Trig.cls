//Tests: TF_EmailMessage_MapToCase_Trig

@istest
public class zTEST_TF_EmailMessage_MapToCase_Trig {
    
    static testmethod void test_TF_EmailMessage_MapToCase_Trig(){
        
        TriggerInterfaceHelper.runTrigger('TF_EmailMessage_MapToCase_Trig', 'EmailMessage', 1, 'bi,ai', null, null);
        
        //Create New Case
        Case cse = new Case(Subject = 'Test', Origin = 'Email', Legacy_ID__c = '5000z00001AlLdjAAF');  
        insert cse;
        
        //Create the Email Message to set off the trigger        
        EmailMessage em = NEW EmailMessage();
        em.ToAddress = 'test@example.com';
        em.Subject = '[ ref:_00D301NXO._5000z1AlLdj:ref ]';
        insert em;
    }
    
}