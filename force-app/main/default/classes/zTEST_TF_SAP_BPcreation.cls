/*
 * Class: TF_SAP_BPcreation
 * Created by: Piyush Jain
 * */
@IsTest(SeeAllData=false)
public class zTEST_TF_SAP_BPcreation {
    
    @IsTest
    Public static void test_TF_SAP_BPcreation(){
        Map<String, Id> SapIdToLookupMap = new Map<String, Id>();
        Map<String, Id> SapIdToLookupMap_1 = new Map<String, Id>();
        //Test account
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        //Test sap bp record
        SAP_BP__c SAP_BP_Record = new SAP_BP__c();
        SAP_BP_Record.Name = 'PENDING';
        SAP_BP_Record.Address_Type__c = 'Account Mailing';
        SAP_BP_Record.Message__c = '';
        insert SAP_BP_Record;
        
        SAP_BP__c SAP_BP_Record_1 = new SAP_BP__c();
        SAP_BP_Record_1.Name = 'PENDING';
        SAP_BP_Record_1.Address_Type__c = 'Account Mailing';
        SAP_BP_Record_1.Message__c = 'Generation Failed';
        insert SAP_BP_Record_1;
		
        //Test opportunity record
        Id recId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F Automated eBooks Opportunity');
        //Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F Automated eBooks Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.stageName = 'Acceptance';
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        opp.Bill_to_BP__c = SAP_BP_Record_1.id;
        opp.Ship_to_BP__c = SAP_BP_Record_1.id;
        opp.RecordtypeId = recId;
        insert opp;
        
        //Test order record
        Order order_Record = new Order();
        order_Record.OpportunityId = opp.id;
        order_Record.Pricebook2Id = Test.getStandardPricebookId();
        order_Record.AccountId = acc.id;
        order_Record.EffectiveDate = Date.newInstance(2019, 12, 9);
        order_Record.Status = 'Draft';
        insert order_Record;
        SapIdToLookupMap.put('Bill to', SAP_BP_Record_1.id);
        SapIdToLookupMap.put('Ship to', SAP_BP_Record_1.id);
        SapIdToLookupMap_1.put('Bill to', SAP_BP_Record.id);
        SapIdToLookupMap_1.put('Ship to', SAP_BP_Record.id);
        
        List<Opportunity> oppList = new List<Opportunity>([Select id,Account.Name,Ship_to_BP__c, Bill_to_BP__c, Ship_to_BP__r.Name, Ship_to_BP__r.Message__c, Bill_to_BP__r.Name, Bill_to_BP__r.Message__c from Opportunity where id =: opp.id]);
        
        //Call methods
        TF_SAP_BPcreation.sap_BP_Details(oppList.get(0), order_Record.id);
        TF_SAP_BPcreation.updateSapMessage(SAP_BP_Record, 'test', SapIdToLookupMap_1);
    }
}