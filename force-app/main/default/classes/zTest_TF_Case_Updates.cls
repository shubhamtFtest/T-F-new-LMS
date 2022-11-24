/*
 * Created by : Tom Reed
 * Class	  : TF_Case_Updates
 * Ticket	  :	CHG0036476
 * Modified by: Rishabh Singh
*/
@istest
public class zTest_TF_Case_Updates {
    
	public static testmethod void Test_TF_Case_Updates(){
		
		Id caseRtId = MiscFunctions.getRecordtypeId('Case', 'T&F - CSD');
        
        //Insert Case
        Case NC = New Case();
        NC.Subject = 'Test';
        NC.RecordTypeID=caseRtId;
        insert NC;

        //Insert Setting 
        Setting__c st = new Setting__c(Name='TF_Case_Product_Platform_Emails');
        insert st;
        
        //Insert Setting Item
        Setting_Item__c SI = new Setting_Item__c (Text_1__c='Taylor & Francis eBooks',Text_2__c='test@test.com',Setting__c=st.id);
        insert SI;
        
        
        //Create test EmailMessage
        EmailMessage EM = New EmailMessage(Parentid = NC.ID, ToAddress = 'test@test.com');
        insert EM;

    }
    
}