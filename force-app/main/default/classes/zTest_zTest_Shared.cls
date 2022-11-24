/**************************************************
* Created by Ashish Purwar, 2018.05.11
* Test class to test zTest_Shared
**************************************************/
@Istest
private class zTest_zTest_Shared {
    static testmethod  void InsertRecords(){
        User u1 = zTEST_Shared.insertUser();
        User u2 = zTEST_Shared.insertUser('System Administrator','Taylor And francis');
        User u3 = zTEST_Shared.insertUser('System Administrator','Taylor And francis','APAC','');
        User u4 = zTEST_Shared.noinsertUser();
        
        //Pricebook2 p1=ztest_Shared.insertPricebook2();
        Id p1 = ztest_Shared.insertPricebook2().id;
        Pricebook2 p2=ztest_Shared.insertPricebook2_2();
        product2 Prod1=ztest_Shared.insertProduct2();
        product2 Prod2=ztest_Shared.insertProduct2('0120Y000000WnAY');
        product2 Prod3=ztest_Shared.noinsertProduct2();
        product2 Prod4=ztest_Shared.noinsertProduct2('0120Y000000WnAY');
        PricebookEntry pbe = ztest_Shared.insertPricebookEntry(Test.getStandardPricebookId(), ztest_Shared.insertProduct2().id);
        
        Id productRTId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Product2' LIMIT 1 ].id;
        Id opportunityRTId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Opportunity' LIMIT 1 ].id;
        Id accountRTId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Account' LIMIT 1 ].id;
        Id contactRTId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Contact' LIMIT 1 ].id;
        Id leadRTId = [ SELECT id, name FROM RecordType WHERE sObjectType = 'Lead' LIMIT 1 ].id;
        
        PricebookEntry pbe2 = ztest_Shared.insertPricebookEntry(productRTId);
        PricebookEntry pbe3 = ztest_Shared.insertPricebookEntry();
        PricebookEntry pbe4 = ztest_Shared.insertPricebookEntryWithCurrency('USD');
        Opportunity opp = ztest_Shared.insertOpportunity( opportunityRTId, u1.id, ztest_Shared.insertAccount( u1.id ).id );
        Opportunity opp2 = ztest_Shared.insertOpportunity( opportunityRTId, u1.id );
        Opportunity opp3 = ztest_Shared.noinsertOpportunity( opportunityRTId, u1.id, ztest_Shared.insertAccount( u1.id ).id );
        Opportunity opp4 = ztest_Shared.noinsertOpportunity2( opportunityRTId, u1.id );
        
        OpportunityLineItem oli = ztest_Shared.insertOpportunityLineItem( opp.id );
        OpportunityLineItem oli2 = ztest_Shared.noinsertOpportunityLineItem( opp.id );
        OpportunityLineItem oli3 = ztest_Shared.insertOpportunityLineItem( pbe.id, opp.id );
        OpportunityLineItem oli4 = ztest_Shared.insertOpportunityLineItem( pbe.id, opp.id, NULL );
        OpportunityLineItem oli5 = ztest_Shared.noinsertOpportunityLineItem( pbe.id, opp.id );
        
        Account acc = ztest_Shared.insertAccount( u1.id );
        Account acc2 = ztest_Shared.insertAccount( u1.id, accountRTId );
        
        Contact con = ztest_Shared.insertContact( u1.id, acc.id );
   //     Contact con2 = ztest_Shared.insertContact( u1.id, acc2.id, contactRTId );
        
        OpportunityContactRole ocr = ztest_Shared.insertOpportunityContactRole( opp.id, con.id );
        OpportunityContactRole ocr2 = ztest_Shared.insertOpportunityContactRole( opp2.id, con.id, 'Decision Maker' );
        
        Lead lead1 = ztest_Shared.noinsertLead( u1.id );
        Lead lead2 = ztest_Shared.insertLead( u1.id );
        Lead lead3 = ztest_Shared.insertLead( u1.id, leadRTId );
        
        CAS_Subject_Code__c subj1 = ztest_Shared.insertCASSubjectCode( u1.id );
        CAS_Subject_Code_Contact__c subj2 = ztest_Shared.insertCASSubjectCodeContact( subj1.id,con.id,u1.id );
        CAS_Inspection_Copy__c ins1 = ztest_Shared.insertCASInspectionCopy(opp.id,Prod1.id);
        
        Id RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAS - Campaigns').getRecordTypeId();
        // Created a Campaign to refer prevCampaignId,campaignId
        Campaign camp = new Campaign();
        camp.Name = 'test';
        insert camp;
        
        Case c = new Case();
        c.Status = 'In Progress';
        insert c;
        
        
    	ztest_Shared.insertCampaign(u1.id,RecordTypeId,System.today(),camp.Id);
        ztest_Shared.insertCampaign(u1.id,RecordTypeId,System.today());
        ztest_Shared.insertCampaign(u1.id);
        ztest_Shared.insertCampaignMember(camp.id,lead2.id,con.id);
        ztest_Shared.noinsertCase(acc.id,'Account');
//       ztest_Shared.noinsertCase(con.id,' ');
        ztest_Shared.insertCase(acc.id,'Account');
        ztest_Shared.noinsertCSAT('test1',c.id,System.today(),'Yes',10,11,'USD');
        ztest_Shared.insertCSAT('test2',c.id,System.today(),'No',15,12,'USD');
        ztest_Shared.insertCampus();
  
    }
}