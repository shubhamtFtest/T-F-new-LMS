/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)
* Modified by Jeff Douglas (jeff.douglas@informausa.com)
* Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)20090319
**************************************************************/

public class CopyCountryFromPickList 
{

    public static void AccountCountry(Account[] accs)
    {
        for (Account a:accs)
        {
            //BILLING  
            if (a.Billing_Country_List__c != null && (!a.Billing_Country_List__c.equals(a.Billing_Country__c)))
            {a.Billing_Country__c = a.Billing_Country_List__c;}
            if ((a.Billing_State_List__c == null) || (!a.Billing_State_List__c.equals(a.Billing_State__c)) )
            {a.Billing_State__c = a.Billing_State_List__c;}
            
            //MAILING 
            if (a.Mailing_Country_List__c != null && (!a.Mailing_Country_List__c.equals(a.BillingCountry)))
            {a.BillingCountry = a.Mailing_Country_List__c;}
            if ((a.Mailing_State_List__c == null) || (!a.Mailing_State_List__c.equals(a.BillingState)) )
            {a.BillingState = a.Mailing_State_List__c;}
            
            //SHIPPING
            if (a.Shipping_Country_List__c != null && (!a.Shipping_Country_List__c.equals(a.ShippingCountry)))
            {a.ShippingCountry = a.Shipping_Country_List__c;}
            if (a.Shipping_State_List__c == null || (!a.Shipping_State_List__c.equals(a.ShippingState)) )
            {a.ShippingState = a.Shipping_State_List__c;}

        }
    }
    
    public static void ContactCountry(Contact[] contact)
    {
        for (Contact c:contact)
        {
            //MAILING             
            if (c.Mailing_Country_List__c != null && (!c.Mailing_Country_List__c.equals(c.MailingCountry)))
            {c.MailingCountry = c.Mailing_Country_List__c;}
            
            if ((c.Mailing_Country_List__c != null && c.Mailing_State_List__c == null) || (c.Mailing_Country_List__c != null && !c.Mailing_State_List__c.equals(c.MailingState)))
            {c.MailingState = c.Mailing_State_List__c;}
            
            //OTHER
            if (c.Other_Country_List__c != null && (!c.Other_Country_List__c.equals(c.OtherCountry)))
            {c.OtherCountry = c.Other_Country_List__c;}
            
            if ((c.Other_Country_List__c != null && c.Other_State_List__c == null) || (c.Other_Country_List__c != null && !c.Other_State_List__c.equals(c.OtherState)))
            {c.OtherState = c.Other_State_List__c;}
                
        }
    }

    
    public static void LeadCountry(Lead[] lead)
    {
        for (Lead l:lead)
        {
    
        if (l.Country_List__c != null && (!l.Country_List__c.equals(l.Country)))
                {l.Country = l.Country_List__c;}      
        
        if ((l.Country_List__c != null && l.State_List__c == null) || (l.Country_List__c != null && !l.State_List__c.equals(l.State)))
                {l.State = l.State_List__c;}

        }
    }

    
    public static void UserCountry(User[] user)
    {
        for (User u:user)
        {
    
        if (u.Country_List__c != null && (!u.Country_List__c.equals(u.Country)))
                {u.Country = u.Country_List__c;}      
        if (u.State_List__c == null || (!u.State_List__c.equals(u.State)) )
                {u.State = u.State_List__c;}

        }
    }
}