@isTest
public class SAP_BP_utlDSTest {
    @isTest 
    public static void SAP_BP_utl()
    {
        Account ac=new Account();
        ac.Name='Test';
        insert ac;
        
        SAP_BP__c sap =new SAP_BP__c();
        sap.Name='sap Test';
        sap.Account_Id__c=ac.Id;
        sap.Country__c='India';
        sap.address_line1__c='banglore';
        sap.address_line2__c='';
        sap.address_line3__c='';
        sap.Address_Type__c= 'Account Billing';
        sap.Tax_Registration_Number__c='123';
        sap.Department__c='';
        sap.Street__c='B-67, Girikon';
        sap.Category__c='Organisation';
        sap.Source__c='Direct/Agent Opp Order';
        sap.Email__c='';
        sap.First_Name__c='';
        sap.Last_Name__c='';
        insert sap;                    
        
        SAP_BP_utlDS.addressWrapper addresswrap =new SAP_BP_utlDS.addressWrapper();
        addresswrap.PartyId='34424';
        addresswrap.accountId=sap.Id;
        addresswrap.houseNumber='20';
        addresswrap.addressLine1='bangloree';
        addresswrap.addressLine2='manglore';
        addresswrap.addressLine3='belgaavi';
        addresswrap.city='kadu';
        addresswrap.state='karnataka';
        addresswrap.country='india';
        addresswrap.countryCode='200098';
        addresswrap.postalCode='1267823';
        addresswrap.addressType='Account Billing';
        addresswrap.contactType='mobile';
        addresswrap.firstName='Test';
        addresswrap.lastName='Test';
        addresswrap.title='test';
        addresswrap.emailAddress='test123@gmail.Com';
        addresswrap.telephone='129238743';
        addresswrap.bpNumber='439439';
        addresswrap.bpPartnerFunction='sp';
        addresswrap.bpBusinessPartnerCategory='Organisation';
        addresswrap.taxRegistrationNumber='324';
        addresswrap.taxNumberCategory='12';
        addresswrap.source='Test';
        addresswrap.department='Test';
        addresswrap.careOf='Test';
        addresswrap.status=true;
        addresswrap.street='Test';
        addresswrap.addressUseType='asd';
        
        SAP_BP_utlDS.addressWrapper addresswrap2 =new SAP_BP_utlDS.addressWrapper();
        addresswrap2.PartyId='34424';
        addresswrap2.accountId=sap.Id;
        addresswrap2.houseNumber='20';
        addresswrap2.addressLine1='B-65';
        addresswrap2.addressLine2='Girikon';
        addresswrap2.addressLine3='Sctor-65';
        addresswrap2.city='Noida';
        addresswrap2.state='Uttar Pradesh';
        addresswrap2.country='india';
        addresswrap2.countryCode='IN';
        addresswrap2.postalCode='202001';
        addresswrap2.addressType='Account Billing';
        addresswrap2.contactType='mobile';
        addresswrap2.firstName='Test';
        addresswrap2.lastName='Test';
        addresswrap2.title='test';
        addresswrap2.emailAddress='test1234@gmail.com';
        addresswrap2.telephone='129238743';
        addresswrap2.bpNumber='439439';
        addresswrap2.bpPartnerFunction='sp';
        addresswrap2.bpBusinessPartnerCategory='Organisation';
        addresswrap2.taxRegistrationNumber='324';
        addresswrap2.taxNumberCategory='12';
        addresswrap2.source='Test';
        addresswrap2.department='Test';
        addresswrap2.careOf='Test';
        addresswrap2.status=true;
        addresswrap2.addressUseType='asd'; 
        addresswrap2.street='Test';
        
        SAP_BP_utlDS.BPResponseObject responsedata2 = new  SAP_BP_utlDS.BPResponseObject('1234','20','banglore','manglore','belagavi','','karnataka','india','2923','6372','post','mobile','Test','Test','test','Test@gmail.com','3736913980','324','4234','yy73','6876','43','source','auser');
        Test.startTest();
        SAP_BP_utlDS.validateRequest( addresswrap);
        SAP_BP_utlDS.addressMatcher(addresswrap,addresswrap2);
        SAP_BP_utlDS.mapAddressForSAP_BP(sap);
        SAP_BP_utlDS.noInsertCreateSAPBPRecord(addresswrap);
        Test.stopTest();
    }   
}