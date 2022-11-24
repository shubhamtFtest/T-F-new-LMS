/************************************************************************************
 This handler class is used for TF_UpdateCountryApplicableListFieldTrigger trigger.
*************************************************************************************/
public class TF_UpdCountryAppliListFieldTrigHandler {
    
/************************************************************************************
  This method is used to update Country Applicable List field on Quote record.
*************************************************************************************/
public static void updateCountryApplicableListField(List<SBQQ__Quote__c> newQuotes){
    //Set<Id> accountIdset = new Set<Id>();
    //Set<Id> contactIdset = new Set<Id>();
    Set<Id> payerAccIdset = new Set<Id>();
    Set<Id> payerConIdset = new Set<Id>();
    //List<Account> accountList = new List<Account>();
    //List<Contact> contactList = new List<Contact>();
    List<Account> payerAccList = new List<Account>();
    List<Contact> payerConList = new List<Contact>();
    List<Country__c> countryList = new List<Country__c>();
    //integer flag1 = 0;
    integer flag2 = 0;
    
    for(SBQQ__Quote__c quoteObj : newQuotes){
        /*if(quoteObj.SBQQ__Account__c != NULL){
                accountIdset.add(quoteObj.SBQQ__Account__c);
        }
        
        if(quoteObj.SBQQ__PrimaryContact__c != NULL){
                contactIdset.add(quoteObj.SBQQ__PrimaryContact__c);
        }*/
        
        if(quoteObj.Payer_Account__c != NULL){
                payerAccIdset.add(quoteObj.Payer_Account__c);
        }
        
        if(quoteObj.Payer_Contact__c != NULL){
                payerConIdset.add(quoteObj.Payer_Contact__c);
        }
    }
    
    //Fetch Account records.
    /*if(!accountIdset.isEmpty()){
        accountList = [select id,Mailing_Country_List__c,Billing_Country_List__c from Account where ID IN :accountIdset AND Billing_Country_List__c != NULL];
    }*/
    
    //Fetch Contact records.
    /*if(!contactIdset.isEmpty()){
        contactList = [select id,Mailing_Country_List__c from Contact where ID IN :contactIdset AND Mailing_Country_List__c != NULL];
    }*/
    
    //Fetch Payer Account records.
    if(!payerAccIdset.isEmpty()){
        payerAccList = [SELECT Id,Name,Billing_Street__c,Billing_City__c,Billing_Country_List__c,Billing_State_List__c,Billing_ZIP__c FROM Account WHERE Id in :payerAccIdset];
    }
    
    //Fetch Payer Contact records.
    if(!payerConIdset.isEmpty()){
        payerConList = [SELECT Id,Name,Mailing_Street__c,Mailing_City__c,Mailing_Country_List__c,Mailing_State_List__c,Mailing_Zip_Postal_Code__c FROM Contact WHERE Id in :payerConIdset];
    }
      
    //Fetch Country records.
    countryList = [select id,Name,Discount_amount__c,Applicable_List__c,EIFL__c,Preferred_currency__c from Country__c];
    
    for(SBQQ__Quote__c quote :newQuotes){
        quote.Country_Applicable_List__c = null;
        //quote.CurrencyIsoCode = null;
        quote.SBQQ__BillingName__c = null;
        quote.SBQQ__BillingStreet__c = null;
        quote.SBQQ__BillingCity__c = null;
        quote.SBQQ__BillingState__c = null;
        quote.SBQQ__BillingPostalCode__c = null;
        quote.SBQQ__BillingCountry__c = null;
        /*quote.SBQQ__ShippingName__c = null;
        quote.SBQQ__ShippingStreet__c = null;
        quote.SBQQ__ShippingCity__c = null;
        quote.SBQQ__ShippingState__c = null;
        quote.SBQQ__ShippingPostalCode__c = null;
        quote.SBQQ__ShippingCountry__c = null;*/
        //flag1 = 0;
        flag2 = 0;
        
        //Fetch Country Applicable List field value based on value of Mailing Country List field on Account.
        /*if(!accountList.isEmpty()){
            for(Account accountObj :accountList){
                if(quote.SBQQ__Account__c == accountObj.id){
                    for(Country__c countryObj :countryList){
                        if(accountObj.Billing_Country_List__c == countryObj.Name){
                            quote.Country_Applicable_List__c = getCountryApplicableListValue(countryObj.Applicable_List__c, countryObj.EIFL__c);
                            //quote.CurrencyIsoCode = countryObj.Preferred_currency__c;
                            flag1 = 1;
                            break;   
                        }
                    }
                }
            }
        }*/
        
        //Fetch Country Applicable List field value based on value of Mailing Country List field on Contact.
        /*if(!contactList.isEmpty() && flag1 == 0){
            for(Contact contactObj :contactList){
                if(quote.SBQQ__PrimaryContact__c == contactObj.id){
                    for(Country__c countryObj :countryList){
                        if(contactObj.Mailing_Country_List__c == countryObj.Name){
                            quote.Country_Applicable_List__c = getCountryApplicableListValue(countryObj.Applicable_List__c, countryObj.EIFL__c);
                            //quote.CurrencyIsoCode = countryObj.Preferred_currency__c;
                            flag1 = 1;
                            break;
                        }
                    }
                }
            }
        }*/
        
        if(!payerAccList.isEmpty()){
            for(Account payerAccObj :payerAccList){
                if(quote.Payer_Account__c == payerAccObj.id){
                   for(Country__c countryObj :countryList){
                        if(payerAccObj.Billing_Country_List__c == countryObj.Name){
                            quote.CurrencyIsoCode = countryObj.Preferred_currency__c;
							quote.Country_Applicable_List__c = getCountryApplicableListValue(countryObj.Applicable_List__c, countryObj.EIFL__c);
                            break;   
                        }
                    }
                   quote.SBQQ__BillingName__c = payerAccObj.Name;
                   quote.SBQQ__BillingStreet__c = payerAccObj.Billing_Street__c;
                   quote.SBQQ__BillingCity__c = payerAccObj.Billing_City__c;
                   quote.SBQQ__BillingState__c = payerAccObj.Billing_State_List__c;
                   quote.SBQQ__BillingPostalCode__c = payerAccObj.Billing_ZIP__c;
                   quote.SBQQ__BillingCountry__c = payerAccObj.Billing_Country_List__c;
                   if(quote.Same_as_Billing__c == true){
                       quote.SBQQ__ShippingName__c = payerAccObj.Name;
                       quote.SBQQ__ShippingStreet__c = payerAccObj.Billing_Street__c;
                       quote.SBQQ__ShippingCity__c = payerAccObj.Billing_City__c;
                       quote.SBQQ__ShippingState__c = payerAccObj.Billing_State_List__c;
                       quote.SBQQ__ShippingPostalCode__c = payerAccObj.Billing_ZIP__c;
                       quote.SBQQ__ShippingCountry__c = payerAccObj.Billing_Country_List__c;
                   }
                   else{
                       if((quote.SBQQ__BillingName__c == quote.SBQQ__ShippingName__c) && (quote.SBQQ__BillingStreet__c == quote.SBQQ__ShippingStreet__c) && (quote.SBQQ__BillingCity__c == quote.SBQQ__ShippingCity__c) && (quote.SBQQ__BillingState__c == quote.SBQQ__ShippingState__c) && (quote.SBQQ__BillingPostalCode__c == quote.SBQQ__ShippingPostalCode__c) && (quote.SBQQ__BillingCountry__c == quote.SBQQ__ShippingCountry__c)){
                           quote.SBQQ__ShippingName__c = null;
                           quote.SBQQ__ShippingStreet__c = null;
                           quote.SBQQ__ShippingCity__c = null;
                           quote.SBQQ__ShippingState__c = null;
                           quote.SBQQ__ShippingPostalCode__c = null;
                           quote.SBQQ__ShippingCountry__c = null;
                       }
                   }
                   flag2 = 1;
                }
            }
        }
        
        if(!payerConList.isEmpty() && flag2 == 0){
            for(Contact payerConObj :payerConList){
                if(quote.Payer_Contact__c == payerConObj.id){
                   for(Country__c countryObj :countryList){
                        if(payerConObj.Mailing_Country_List__c == countryObj.Name){
                            quote.CurrencyIsoCode = countryObj.Preferred_currency__c;
							quote.Country_Applicable_List__c = getCountryApplicableListValue(countryObj.Applicable_List__c, countryObj.EIFL__c);
                            break;   
                        }
                    }
                   quote.SBQQ__BillingName__c = payerConObj.Name;
                   quote.SBQQ__BillingStreet__c = payerConObj.Mailing_Street__c;
                   quote.SBQQ__BillingCity__c = payerConObj.Mailing_City__c;
                   quote.SBQQ__BillingState__c = payerConObj.Mailing_State_List__c;
                   quote.SBQQ__BillingPostalCode__c = payerConObj.Mailing_Zip_Postal_Code__c;
                   quote.SBQQ__BillingCountry__c = payerConObj.Mailing_Country_List__c;
                   if(quote.Same_as_Billing__c == true){
                       quote.SBQQ__ShippingName__c = payerConObj.Name;
                       quote.SBQQ__ShippingStreet__c = payerConObj.Mailing_Street__c;
                       quote.SBQQ__ShippingCity__c = payerConObj.Mailing_City__c;
                       quote.SBQQ__ShippingState__c = payerConObj.Mailing_State_List__c;
                       quote.SBQQ__ShippingPostalCode__c = payerConObj.Mailing_Zip_Postal_Code__c;
                       quote.SBQQ__ShippingCountry__c = payerConObj.Mailing_Country_List__c;
                   }
                   else{
                       if((quote.SBQQ__BillingName__c == quote.SBQQ__ShippingName__c) && (quote.SBQQ__BillingStreet__c == quote.SBQQ__ShippingStreet__c) && (quote.SBQQ__BillingCity__c == quote.SBQQ__ShippingCity__c) && (quote.SBQQ__BillingState__c == quote.SBQQ__ShippingState__c) && (quote.SBQQ__BillingPostalCode__c == quote.SBQQ__ShippingPostalCode__c) && (quote.SBQQ__BillingCountry__c == quote.SBQQ__ShippingCountry__c)){
                           quote.SBQQ__ShippingName__c = null;
                           quote.SBQQ__ShippingStreet__c = null;
                           quote.SBQQ__ShippingCity__c = null;
                           quote.SBQQ__ShippingState__c = null;
                           quote.SBQQ__ShippingPostalCode__c = null;
                           quote.SBQQ__ShippingCountry__c = null;
                       }
                   }
                }
            }
        }
    }   
}
    
    /************************************************************************************************************************
      This method is used to get Country Applicable List field value based on Applicable List & EIFL fields on Country record.
    *************************************************************************************************************************/
    public static String getCountryApplicableListValue(String applicableListValue, Boolean eIFLValue){
        String countryApplicableListValue = '';
        //Check whether Applicable List on Country record is NULL.
        if(applicableListValue != Null){
              countryApplicableListValue = applicableListValue;
              if(eIFLValue != False){
                    countryApplicableListValue = countryApplicableListValue + ', EIFL';
              }
        }
        
        //Check whether Applicable List is NULL & EIFL is checked.
        if(applicableListValue == Null && eIFLValue == True){
              countryApplicableListValue = 'EIFL';
        }
        
        //Check whether Applicable List is NULL & EIFL is unchecked.
        if(applicableListValue == Null && eIFLValue == False){
              countryApplicableListValue = '';
        }
        
        return countryApplicableListValue;
    }  
}