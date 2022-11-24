/**************************************************************************
  //This is the handler class for the trigger "TF_Contact_On_Lead" (Case no: 01291886)
  //Created By : Shefali Arora on date 28.08.2019
  //Modified By : Shefali Arora on date 01.10.2019
  //Modified By : Shefali Arora on date 31.10.2019 (Case no :01359747)
  //Modified By : Faiz Ali 19.10.2019 (Lead web form order execution issue)
  //Modified By : Matt Smith 27.10.2020 (updating the lead on before insert so it populates product name and price for gbp and usd)
**************************************************************************/
public with sharing class TF_Contact_On_Lead implements TriggerInterface_Lead.Runnable {
    public void run(TriggerInterface_Lead.Trig trig) {
        if(trig.isBefore && trig.isInsert) {
            //List to fetch out the Emails of Lead
            List<String> leadEmail = new List<String>();
            /*for(Lead l : trig.NewList) {
                if(l.Country_List__c == 'United States') {
                    leadEmail.add(l.Email);
                }
            }*/
            for(Lead l : trig.NewList) {
                leadEmail.add(l.Email);
            }
            //List to fetch out the Contact Emails
            List<String> contactEmails = new List<String>();
            List<Contact> listOfContacts = [SELECT id, name, Email FROM Contact WHERE Email IN :leadEmail];
            for(Contact con :listOfContacts) {
                contactEmails.add(con.Email);
            }
            for(Lead l: trig.NewList) {
                //Checking if the Lead Email matches with the Contact's Email
                if(contactEmails.contains(l.Email)) {
                    l.Status = 'Existing Contact';
                    
                }
                system.debug('DEBUG --- What is the status? ' + l.Status);
            }
            
            //Product Update in Before Insert for Lead execution order issue
            List<string> isbns = new List<string>();
            for (Integer i = 0; i < trig.triggerSize; i++) {
                system.debug('DEBUG --- Running Product Update to add Product Code and Price');
                if (trig.newList[i].ISBN__c != null && trig.newList[i].ISBN__c != ''){
                  //  if (trig.isInsert || trig.newList[i].ISBN__c != trig.oldList[i].ISBN__c)
                    {
                        String isbn = trig.newList[i].ISBN__c.replaceAll(' ','').replaceAll('-','');
                        isbns.add(isbn);
                    }
                }
            }    
            if (isbns.size() > 0){
                Map<string, string> mapIsbnToProduct = new Map<string, string>();
                
                List<Product2> products = [SELECT Id, ProductCode, Edition_Number__c //CHG0067110
                                           FROM Product2
                                           WHERE IsActive = true 


                                               AND RecordTypeId = '0120Y000000WnAaQAK' //T&F - Products
                                               AND ProductCode IN :isbns];
                                               
                for (Product2 p : products){
                    mapIsbnToProduct.put(p.ProductCode, p.Id);
                    
                }
                
                Map<string, decimal> mapIsbnToGbp = new Map<string, decimal>();
                Map<string, decimal> mapIsbnToUsd = new Map<string, decimal>();
                List<PricebookEntry> pbes = [SELECT Id, ProductCode, Product2Id, CurrencyIsoCode, UnitPrice 
                                             FROM PriceBookEntry 
                                             WHERE IsActive = true 


                                               AND Pricebook2Id = '01s0Y00000832dDQAQ' //T&F Pricebook
                                               AND CurrencyIsoCode IN ('GBP','USD')
                                               AND Product2Id IN :products];
                                               
                for (PricebookEntry pbe : pbes){
                    if (pbe.CurrencyIsoCode == 'GBP') 
                        mapIsbnToGbp.put(pbe.ProductCode, pbe.UnitPrice);
                    else if (pbe.CurrencyIsoCode == 'USD')
                        mapIsbnToUsd.put(pbe.ProductCode, pbe.UnitPrice );
                }
                
                for (Integer i = 0; i < trig.triggerSize; i++) {
                   if (trig.newList[i].ISBN__c != null && trig.newList[i].ISBN__c != '')
                   {
                        String isbn = trig.newList[i].ISBN__c.replaceAll(' ','').replaceAll('-','');
                        trig.newList[i].Product_Name__c = mapIsbnToProduct.get(isbn);
                        system.debug('@trig.newList[i].Product_Name__c@'+trig.newList[i].Product_Name__c);
                        trig.newList[i].Price_GBP__c = mapIsbnToGbp.get(isbn);
                        trig.newList[i].Price_USD__c = mapIsbnToUsd.get(isbn);
                    }
                }
            }
        }
    }
}