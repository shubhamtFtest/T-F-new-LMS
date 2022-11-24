@isTest
private class zTEST_CopyCountryFromPickList {

    static testmethod void testUserCountry() {
    
        User u = new User(
            Country='US',
            Country_List__c='United States',
            State = 'FL',
            State_List__c='Florida'
        );
        
        CopyCountryFromPickList.UserCountry(new User[]{u});
        
        // make sure the values where changed correctly
        System.assertEquals(u.Country,u.Country_List__c);
        System.assertEquals(u.State,u.State_List__c);   
        
    }        
    
    static testmethod void testLeadCountry() {
    
        Lead lead1 = new Lead(
            Country='US',
            Country_List__c='United States',
            State = 'FL',
            State_List__c='Florida'
        );
        
        CopyCountryFromPickList.LeadCountry(new Lead[]{lead1});
        
        User u = zTest_Shared.insertUser();
        
        Id leadRtId = MiscFunctions.getRecordtypeId('Lead', 'T&F - Leads'); //CHG0038379
        
        Lead lead2 = zTest_Shared.noinsertLead(u.Id);
        lead2.RecordTypeId = leadRtId;
        lead2.Country_List__c = 'United Kingdom';
        lead2.State_List__c = 'Middlesex';
        insert lead2;
        
        // make sure the values where changed correctly
        System.assertEquals(lead1.Country,lead1.Country_List__c);
        System.assertEquals(lead1.State,lead1.State_List__c); 
    }    
    
    static testmethod void testContactCountry() {
    
        Contact c1 = new Contact(
            firstname='Test',
            lastname='Conatct 1',
            email='no@email.com',
            MailingCountry = 'USA',
            Mailing_Country_List__c = 'United States',
            MailingState = 'FL',
            Mailing_State_List__c = 'Florida',
            OtherCountry = 'USA',
            Other_Country_List__c = 'United States',
            OtherState = 'FL',
            Other_State_List__c = 'Florida'
        );
        
        CopyCountryFromPickList.ContactCountry(new Contact[]{c1});
        
        User u = zTest_Shared.insertUser();
        
        Id accountRtId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        Id contactRtId = MiscFunctions.getRecordtypeId('Contact', 'T&F - Contacts'); //CHG0038379
        
        Account a = zTest_Shared.insertAccount(u.Id, accountRtId);
        
        Contact c2 = zTest_Shared.insertContact(u.Id, a.Id, contactRtId);
        c2.Mailing_Country_List__c = 'United Kingdom';
        c2.Mailing_State_List__c = 'Middlesex';
        update c2;
        
        // make sure the values where changed correctly
        System.assertEquals(c1.MailingCountry,c1.Mailing_Country_List__c);
        System.assertEquals(c1.MailingState,c1.Mailing_State_List__c);
        System.assertEquals(c1.OtherCountry,c1.Other_Country_List__c);
        System.assertEquals(c1.OtherState,c1.Other_State_List__c);  
    }
    
    static testmethod void testAccountCountry() {
        
        Account a1 = new Account(
            name='Test1',
            Billing_Country__c = 'United States',
            Billing_Country_List__c = 'United States',
            Billing_State__c = 'Florida',
            Billing_State_List__c = 'Florida',
            BillingCountry = 'United States',
            Mailing_Country_List__c = 'United States',
            BillingState = 'Florida',
            Mailing_State_List__c = 'Florida',
            ShippingCountry = 'United States',
            Shipping_Country_List__c = 'United States',
            ShippingState = 'Florida',
            Shipping_State_List__c = 'Florida'
        );
        
        // addresses don't match
        Account a2 = new Account(
            name='Test1',
            Billing_Country__c = 'US',
            Billing_Country_List__c = 'United States',
            Billing_State__c = 'FL',
            Billing_State_List__c = 'Florida',
            BillingCountry = 'US',
            Mailing_Country_List__c = 'United States',
            BillingState = 'FL',
            Mailing_State_List__c = 'Florida',
            ShippingCountry = 'US',
            Shipping_Country_List__c = 'United States',
            ShippingState = 'FL',
            Shipping_State_List__c = 'Florida'
        );
        
        CopyCountryFromPickList.AccountCountry(new Account[]{a1,a2});
        
        User u = zTest_Shared.insertUser();
        
        Id accountRtId = MiscFunctions.getRecordtypeId('Account', 'T&F - Accounts'); //CHG0038379
        
        Account a3 = zTest_Shared.insertAccount(u.Id, accountRtId);
        a3.Mailing_Country_List__c = 'United Kingdom';
        a3.Mailing_State_List__c = 'Middlesex';
        update a3;
                
        // make sure the values where changed correctly
        System.assertEquals(a2.Billing_Country__c,a2.Billing_Country_List__c);
        System.assertEquals(a2.Billing_State__c,a2.Billing_State_List__c);
        System.assertEquals(a2.BillingCountry,a2.Mailing_Country_List__c);
        System.assertEquals(a2.BillingState,a2.Mailing_State_List__c);
        System.assertEquals(a2.ShippingCountry,a2.Shipping_Country_List__c);
        System.assertEquals(a2.ShippingState,a2.Shipping_State_List__c);
    }
}