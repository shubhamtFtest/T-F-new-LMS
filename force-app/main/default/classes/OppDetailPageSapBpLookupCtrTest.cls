/** Author: Shalini Singh
	Class: OppDetailPageSapBpLookupCtr
**/
@isTest
public class OppDetailPageSapBpLookupCtrTest {
    
    @isTest
    public static void OppdetailSync()
    {
        Account acc =new Account();
        acc.Name='Test Account Long Name Testing Required';
        acc.Customer_Id__c='123';
        acc.Billing_City__c='india';
        acc.Mailing_Country_List__c='';
        acc.Mailing_State_List__c=''; 
        insert acc;
        
        SAP_BP__c sap =new SAP_BP__c();
        sap.Name='sap Test';
        sap.Country__c='India';
        sap.Account_Id__c=acc.Id;
        sap.address_line1__c='';
        sap.address_line2__c='';
        sap.address_line3__c='';
        sap.Address_Type__c= 'Account Billing';
        sap.Tax_Registration_Number__c='123';
        sap.Department__c='';
        sap.Street__c='B-67, Girikon';
        sap.Category__c='Organisation';
        insert sap;
        List<Id> saplist =new  List<Id>(); 
        saplist.add(sap.id);
        
        sap_BP__c sap1 =new sap_BP__c();
        sap1.Name='sap1 Test';
        sap1.Country__c='India';
        sap1.Account_Id__c=acc.Id;
        sap1.address_line1__c='';
        sap1.address_line2__c='';
        sap1.address_line3__c='';
        sap1.Address_Type__c= 'Account Billing';
        sap1.Tax_Registration_Number__c='123';
        sap1.Department__c='Long department name testing required';
        sap1.Street__c='B-78, Girikon, Long street is required for testing';
        sap1.Category__c='Organisation';
        insert sap1;
        List<Id> saplist1 =new  List<Id>(); 
        saplist1.add(sap1.id);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Acceptance';
        opp.AccountId = acc.id;
        opp.Bill_to_BP__c=sap.Id;
        opp.CloseDate = Date.newInstance(2019, 12, 9);
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test';
        opp1.StageName = 'Acceptance';
        opp1.AccountId = acc.id;
        opp1.Bill_to_BP__c=null;
        opp1.CloseDate = Date.newInstance(2019, 12, 9);
        insert opp1;
        
        Contact con=new Contact();
        con.LastName ='Test'; 
        con.AccountId=acc.Id;
        insert con;
        
        OppDetailPageSapBpLookupCtr.SapbpWrapper sapb=new OppDetailPageSapBpLookupCtr.SapbpWrapper(); 
        
        sapb.RecordId =acc.Id;
        sapb.Country ='India';
        sapb.AddressLine1=null;
        sapb.AddressLine2='';
        sapb.AddressLine3='';
        sapb.PostalCode='12345';
        sapb.Phone='84948318';
        sapb.State='Karnataka';
        sapb.City='Banglore';
        sapb.emailAddress='testclass@gmail.com';
        sapb.firstName='Jhone';
        sapb.lastName='jack';
        sapb.careOf='zxcv';
        sapb.department='technical';
        
        
        Country__c country =new country__c();
        country.Name='India';
        country.Country_2__c='IN';
        insert country;
        
        
        string jsonString='{ "customers": [ { "businessPartner": { "type": "ORGANIZATION" }, "contactDetail": { "addressLine1": "B- 24, 58/28, C Block,Vishwakarma", "addressLine2": "Rd, Rasoolpur Nawada, Phase 2,", "addressLine3": "Industrial Area, Near Fortis Hospital, Sector 62", "addressType": "Account Shipping", "city": "LONDON", "postalCode": "NW1 5LS", "country": "GB", "emailAddress": "gvjbb@gmail.com", "title": "", "firstName": "Test", "telephone": "", "lastName": "Contact 2", "location": "", "organizationName1": "Royal Australasian College of", "organizationName2": "Surgeons Phone", "organizationName3": "", "phoneNumber": "", "region": "" }, "externalCustomerAddressId": "161097", "sourceSystemId": "TF-EBOOK", "taxRegistrationNumber": "GB213431455", "taxType": "GB0" } ] }';
        Test.startTest();
        OppDetailPageSapBpLookupCtr.accountSearch('xyz',opp.Id,'abc');
        OppDetailPageSapBpLookupCtr.saveBPtoOpportunity(opp.Id,sap.Id,'BillTo');
        OppDetailPageSapBpLookupCtr.copyBillToSap(opp.id);
        OppDetailPageSapBpLookupCtr.copyBillToSap(opp1.id);
        OppDetailPageSapBpLookupCtr.getBPDetails(opp.Id);
        OppDetailPageSapBpLookupCtr.fetchLookUpValues('a','Account');
        OppDetailPageSapBpLookupCtr.fetchsapBpRecords(acc.Id);
        OppDetailPageSapBpLookupCtr.VerifyAddressController(sapb);
        OppDetailPageSapBpLookupCtr.shippingAddressVerify(sapb);
        OppDetailPageSapBpLookupCtr.getShippingBody(sapb);
        OppDetailPageSapBpLookupCtr.CreateSAPBP(sapb,'BillTo',opp.Id);
        OppDetailPageSapBpLookupCtr.CreateSAPBP(sapb,'ShipTo',opp.Id);
        OppDetailPageSapBpLookupCtr.getDependentMap(acc,'Mailing_Country_List__c','Mailing_State_List__c');
        OppDetailPageSapBpLookupCtr.decimalToBinary(20);
        OppDetailPageSapBpLookupCtr.base64ToBits('24');
        OppDetailPageSapBpLookupCtr.processRequest(jsonString,'/123/generateBP/','BillTo',opp.Id);
        OppDetailPageSapBpLookupCtr.splitStringBySpace('testString',10);
        OppDetailPageSapBpLookupCtr.updateSapMessageField('Generated Successfully',sap,'BillTo',opp.id);
        OppDetailPageSapBpLookupCtr.getSAPBPNumberCallout(saplist,jsonString,'BillTo',opp.id);
        OppDetailPageSapBpLookupCtr.getSAPBPNumberCallout(saplist1,jsonString,'ShipTo',opp.id);
        OppDetailPageSapBpLookupCtr.getRequestBody(sap);
        Test.stopTest();
    }
}