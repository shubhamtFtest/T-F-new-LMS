global class LeadConvert_TFBatch implements Database.Batchable<sObject>{

    List<String> leadEmails = new List<String>();
    List<Contact> contacts = new List<Contact>();
    List<String> idOfLeads = new List<String>();
    //Database.LeadConvert lc = new Database.LeadConvert();
    List<OpportunityLineItem> objLineItem = new List<OpportunityLineItem>();
    List<OpportunityLineItem> listOliWithPricbk = new List<OpportunityLineItem>();
    //List<Setting_Item__c> ldids = [select setting__c, Long_Text_1__c from Setting_Item__c where setting__r.Name = 'Lead Ids to convert'];
    //List<String> splitLeadIds = ldids[0].Long_Text_1__c.split(',');
    List<Setting_Item__c> ldids = new List<Setting_Item__c>();
    List<String> splitLeadIds = new List<String>();
    map<Id,OpportunityLineItem> mapleadIdWithOli = new map<Id,OpportunityLineItem>();
    List<Lead> listLeads = new List<Lead>();
    List<Opportunity> opp1 = new List<Opportunity>();
    map<Id,Lead> oppmapwithoutContact = new map<Id,Lead>();
    Id opprecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('T&F - CAS Opportunity').getRecordTypeId();
    Map<Id, Id> oppIdToContactIdMap = new Map<Id, Id>();
    List<opportunityContactRole> listOCRInsert=new List<opportunityContactRole>();
    //List<Id> oppExistingIdList = new List<Id>();
    Map<Id, Id> mapLeadIdToProductId = new Map<Id, Id>();
    map<id,PricebookEntry> mapProductIdWithPrcBk=new Map<id,PricebookEntry>();
    Map<Id,opportunityContactRole> mapLeadIdWithOCR=new Map<Id,opportunityContactRole>();
    
    global LeadConvert_TFBatch(){
        ldids = [select setting__c, Long_Text_1__c from Setting_Item__c where setting__r.Name = 'Lead Ids to convert'];
        if ( !ldids.isEmpty() ) {
            splitLeadIds = ldids[0].Long_Text_1__c.split(',');
        }
        
        System.debug('ldids ========>' + ldids);
        System.debug('splitLeadIds ========>' + splitLeadIds);
        if ( !splitLeadIds.isEmpty() ) {
        for(String leadid:splitLeadIds){
              idOfLeads.add(leadid);
          }
        }
    }
    


   global Database.QueryLocator start(Database.BatchableContext BC){

       String Qry = 'Select Id,Order_Type__c, Product_Name__c,Course_Start_Date__c,email,Lastname,Course_Name__c, isConverted, Book_Title_Requested__c, ISBN__c, Author__c, Publisher__c, Book_Requested_Type__c, Delivery_Instructions__c, Other_Considered_Texts__c, Other_Decision_Maker__c, Lead_Adoption_Level__c, Adoption_Probability__c, Current_Text__c, Website_Source__c, Promo_Code_C__c, Current_Text_Feedback__c, Last_Text_Change__c, New_Course__c, Table_of_Contents_Review__c, LeadSource, Lead_Source_Detail__c, Year_of_Study__c, Decision_Date__c, Anticipated_Enrollment__c from Lead Where Id IN:idOfLeads and isConverted=false';
       return Database.getQueryLocator(Qry);
   }

    global void execute(Database.BatchableContext BC, List<Lead> scope){
    system.debug('scope:----> '+scope);

    if ( !scope.isEmpty() ) {
        for(Lead lead : scope){
            leadEmails.add(lead.Email);
        }
    }
    system.debug('***** '+leadEmails);
    
    if ( !leadEmails.isEmpty() )
    contacts = [SELECT Id,AccountId, Email FROM Contact WHERE Email IN :leadEmails];
    Map<Id,Lead> mapContactLead=new Map<Id,Lead>();
    Map<Id,Lead> mapLeadIdWithLead=new Map<Id,Lead>();
    Set<String> setRemainingLead=new Set<String>();
    List<Lead> listRemainingLeads=new List<Lead>();
    system.debug('*****1 '+contacts);
    Map<Id,Contact> mapLeadContact=new Map<Id,Contact>();
    if(contacts.size()>0){
        /*for(Contact cont:contacts){
            listContEmails.add(cont.Email);
        }*/

        //List<Lead> listSelectedleads = [SELECT Id,Order_Type__c, Product_Name__c,Course_Name__c,Course_Start_Date__c, Email,Lastname, isConverted FROM Lead WHERE Email IN :listContEmails];
        
        for(Lead ld : scope){
            for(Contact con : contacts){
                if(con.Email == ld.Email){
                    system.debug('match='+ld);
                    //listMatchLeads.add(ld);
                    //mapContactLead.put(con.id,ld);
                    mapLeadContact.put(ld.Id,con);
                    mapLeadIdWithLead.put(ld.Id,ld);
                }
                /*else{
                    System.debug('Else='+ld);
                    listRemainingLeads.add(ld);
                }*/
            }
        }
        
        for (Lead ld : scope) {            
            if ( !mapLeadContact.containsKey(ld.id) ) {
                System.debug('Else='+ld);
                listRemainingLeads.add(ld);
            }                           
        }
        System.debug('mapContactLead ========>' + mapContactLead);
        System.debug('mapLeadContact ========>' + mapLeadContact);
        if(mapLeadContact!=null){
            List<Contact> mapValues=mapLeadContact.values();
            Set<Id> setLeadIds=mapLeadContact.keySet();
            for(Id leadId:setLeadIds){
                Opportunity p = new Opportunity(name = mapLeadIdWithLead.get(leadId).Course_Name__c+'~'+leadId, AccountId = mapLeadContact.get(leadId).AccountId, LeadSource = mapLeadIdWithLead.get(leadId).LeadSource ,RecordtypeId = opprecType, Volume_Year__c ='2019',CurrencyIsoCode = 'USD',CloseDate = date.today(),ownerid = '0050Y000002IvYy',StageName = 'Investigating',Order_Type__c=mapLeadIdWithLead.get(leadId).Order_Type__c,Course_Start_Date__c=mapLeadIdWithLead.get(leadId).Course_Start_Date__c, Book_Requested__c = mapLeadIdWithLead.get(leadId).Book_Title_Requested__c, ISBN__c = mapLeadIdWithLead.get(leadId).ISBN__c, Author__c = mapLeadIdWithLead.get(leadId).Author__c, Publisher__c = mapLeadIdWithLead.get(leadId).Publisher__c, Book_Requested_Type__c = mapLeadIdWithLead.get(leadId).Book_Requested_Type__c, Delivery_Instructions__c = mapLeadIdWithLead.get(leadId).Delivery_Instructions__c, Other_Considered_Texts__c = mapLeadIdWithLead.get(leadId).Other_Considered_Texts__c, Other_Decision_Maker__c = mapLeadIdWithLead.get(leadId).Other_Decision_Maker__c, Lead_Adoption_Level__c = mapLeadIdWithLead.get(leadId).Lead_Adoption_Level__c, Adoption_Probability__c = mapLeadIdWithLead.get(leadId).Adoption_Probability__c, Current_Text__c = mapLeadIdWithLead.get(leadId).Current_Text__c, Website_Source__c = mapLeadIdWithLead.get(leadId).Website_Source__c, Promo_Code__c = mapLeadIdWithLead.get(leadId).Promo_Code_C__c, Current_Text_Feedback__c = mapLeadIdWithLead.get(leadId).Current_Text_Feedback__c, Last_Text_Change__c = mapLeadIdWithLead.get(leadId).Last_Text_Change__c, New_Course__c = mapLeadIdWithLead.get(leadId).New_Course__c, Table_of_Contents_Review__c = mapLeadIdWithLead.get(leadId).Table_of_Contents_Review__c, Lead_Source_Detail__c = mapLeadIdWithLead.get(leadId).Lead_Source_Detail__c, Year_of_Study__c = mapLeadIdWithLead.get(leadId).Year_of_Study__c, Decision_Date__c = mapLeadIdWithLead.get(leadId).Decision_Date__c, Number_of_Students__c = mapLeadIdWithLead.get(leadId).Anticipated_Enrollment__c, Type = 'Course' );
                opp1.add(p);
                
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.ContactId = mapLeadContact.get(leadId).Id;
                //listOCRInsert.add(ocr);
                mapLeadIdWithOCR.put(leadId,ocr);
                if ( mapLeadIdWithLead.get(leadId).Product_Name__c != NULL ) {
                    OpportunityLineItem oliItem = new OpportunityLineItem();
                    oliItem.Description = mapLeadIdWithLead.get(leadId).Course_Name__c+'~'+leadId;
                    oliItem.Product2Id = mapLeadIdWithLead.get(leadId).Product_Name__c;
                    if ( String.isNotBlank(mapLeadIdWithLead.get(leadId).Book_Requested_Type__c) && mapLeadIdWithLead.get(leadId).Book_Requested_Type__c.equalsIgnoreCase('Print') ) {
                        oliItem.Order_Type__c = 'Complimentary Exam Copy';
                    } else if ( String.isNotBlank(mapLeadIdWithLead.get(leadId).Book_Requested_Type__c) && mapLeadIdWithLead.get(leadId).Book_Requested_Type__c.equalsIgnoreCase('eBook') ) {
                        if ( String.isNotBlank(mapLeadIdWithLead.get(leadId).Publisher__c) ) {
                            if ( mapLeadIdWithLead.get(leadId).Publisher__c.equalsIgnoreCase('CRC Press') ) {
                                oliItem.Order_Type__c = 'CRC Vitalsource e-Exam copy';
                            } else if ( mapLeadIdWithLead.get(leadId).Publisher__c.equalsIgnoreCase('Garland Science') ) {
                                oliItem.Order_Type__c = 'Garland Vitalsource e-Exam copy';                    
                            } else if ( mapLeadIdWithLead.get(leadId).Publisher__c.equalsIgnoreCase('Routledge HSS') ) {
                                oliItem.Order_Type__c = 'HSS Vitalsource e-Exam copy';
                            }
                        }   
                    }
                
                    mapleadIdWithOli.put(leadId,oliItem);
                    mapLeadIdToProductId.put(leadId, mapLeadIdWithLead.get(leadId).Product_Name__c);
                    objLineItem.add(oliItem);
                }
                
            }
            
            //List<Contact> listContactWithAccount=[Select Id,AccountId from Contact Where Id IN:setContactIds];
            //System.debug('listContactWithAccount =======>' + listContactWithAccount);
            for(Id key:setLeadIds){
                
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setContactId(mapLeadContact.get(key).Id);
                lc.setAccountId(mapLeadContact.get(key).AccountId);
                lc.setDoNotCreateOpportunity(TRUE);
                lc.setOwnerId('0050Y000002IvYy');
                //System.debug('Lead Id='+mapContactLead.get(contact.id).Id);
                lc.setLeadId(key);
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                try{
                    System.debug('Lead convert Record ========>' + lc);
                    //System.debug('Lead isConverted ========>' + mapContactLead.get(contact.id).isConverted);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                }
                catch(Exception e){
                    System.debug('*****Message:='+e.getMessage()+'*****'+e.getLineNumber());
                }
                
            }
            
        }
        System.debug('opp1========>' + opp1);
        // get all OCr from map
        if ( !opp1.isEmpty() ) {
            insert opp1;
            System.debug('opp1========>' + opp1);
            for(Opportunity oppForOCR : opp1){
                String oppNameWithLeadId = oppForOCR.Name;
                Integer index = oppNameWithLeadId.indexOf('~');
                String leadId=oppNameWithLeadId.substring(index+1,oppNameWithLeadId.length());
                if(mapLeadIdWithOCR.containsKey(leadId)){
                    OpportunityContactRole  ocr=mapLeadIdWithOCR.get(leadId);
                    ocr.OpportunityId=oppForOCR.Id;
                    ocr.isPrimary = True;
                    listOCRInsert.add(ocr);
                }
                
            }
            for(Opportunity oppor : opp1){
                //oppExistingIdList.add( oppor.id );
                for(OpportunityLineItem oli : objLineItem){
                    if(oli.Description == oppor.Name){
                        oli.OpportunityId = oppor.Id;
                        String stroppName = oppor.Name;
                        Integer index = stroppName.indexOf('~');
                        system.debug('******'+stroppName.substring(0, index));
                        oppor.Name = stroppName.substring(0, index);
                        system.debug('******'+stroppName);
                        
                    }
                }
                
            }
                
            update opp1;
        }
        System.debug('listOCRInsertbefore =====***'+listOCRInsert);
        if(!listOCRInsert.isEmpty()){
            insert listOCRInsert;
        }
        System.debug('listOCRInsert  after =====***'+listOCRInsert);
        /*Set<Id> productIdSet = mapOliwithProd.keyset();
        List<PricebookEntry> lstPBECurISOCode = [SELECT Id,Unitprice, Pricebook2.Name,Product2Id,product2.List_Price__c, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id IN :productIdSet AND CurrencyIsoCode='USD' AND PriceBook2.Name = 'Standard Price Book'];
        system.debug('******lstPBECurISOCode'+lstPBECurISOCode);
        system.debug('******productIdSet'+productIdSet);
        for(PricebookEntry pbEntry : lstPBECurISOCode){
            OpportunityLineItem oliItem = mapOliwithProd.get(pbEntry.Product2Id);
            oliItem.PricebookEntryId  = pbEntry.Id;
            oliItem.Description = '';
            oliItem.Adoption_Stage__c = 'In-Process';
            //oliItem.OwnerId = '0050Y000002IvYy';
            oliItem.UnitPrice = pbEntry.UnitPrice;
            oliItem.VitalSource_Bookshelf_Code__c = 'Already Sent';
            oliItem.VitalSource_Access_Period__c = 'Perpetual Access';
            listOliWithPricbk.add(oliItem);
        }*/
        Set<Id> leadIdSet = mapleadIdWithOli.keyset();
        List<Id> listproductIds = mapLeadIdToProductId.values();
        List<PricebookEntry> lstPBECurISOCode = [SELECT Id,Unitprice, Pricebook2.Name,Product2Id,product2.List_Price__c, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id IN :listproductIds  AND CurrencyIsoCode='USD' AND PriceBook2.Name = 'Standard Price Book'];
        system.debug('******lstPBECurISOCode'+lstPBECurISOCode);
        //system.debug('******productIdSet'+productIdSet);
        for(PricebookEntry pbEntry : lstPBECurISOCode){
            mapProductIdWithPrcBk.put(pbEntry.Product2Id,pbEntry);
        }
        System.debug('mapProductIdWithPrcBk ========>' + mapProductIdWithPrcBk);
        for(Id leadId : leadIdSet){
            OpportunityLineItem oliItem = mapleadIdWithOli.get(leadId);
            Id productId=mapLeadIdToProductId.get(leadId);
            Id priceBookId;
            System.debug('productId ========>' + productId);
            System.debug('priceBookId ========>' + priceBookId);
            if ( String.isNotBlank(productId) ) {
                priceBookId=mapProductIdWithPrcBk.get(productId).Id;
            }
            oliItem.PricebookEntryId  = priceBookId;
            oliItem.Description = '';
            oliItem.Adoption_Stage__c = 'In-Process';
            //oliItem.OwnerId = '0050Y000002IvYy';
            if ( String.isNotBlank(productId) ) {
                oliItem.UnitPrice = mapProductIdWithPrcBk.get(productId).UnitPrice;
            }
            oliItem.VitalSource_Bookshelf_Code__c = 'Already Sent';
            oliItem.VitalSource_Access_Period__c = 'Perpetual Access';
            oliItem.Recipient__c = mapLeadContact.get(leadId).id;
            listOliWithPricbk.add(oliItem);
        }
        
    }
    else{
        for (Lead ld : scope) {            
            listRemainingLeads.add(ld);                          
        }
    }
    system.debug('******listRemainingLeads****'+listRemainingLeads);
    system.debug('******listOliWithPricbk'+listOliWithPricbk);
    if(listOliWithPricbk.size()>0){
        insert listOliWithPricbk;
    }
    
    
    
    /* Part with no contact mapped*/
    
    /*for(String leadEail:leadEmails){
        Set<Id> setOfContactIds=mapContactLead.keySet();
        System.debug('setOfContactIds:='+setOfContactIds);
        
        if(setOfContactIds!=null && setOfContactIds.size()>0){
            for(Id conId:setOfContactIds){
                if(mapContactLead.get(conId).Email!=leadEail){
                    System.debug('leadEail:='+leadEail);
                    setRemainingLead.add(leadEail);
                }
            }
        }
        else{
            System.debug('leadEail eslse:='+leadEail);
            setRemainingLead.add(leadEail);
        }
    }
    
    system.debug('setRemainingLead:='+setRemainingLead);
    List<Lead> RemainingLeads = [SELECT Id,Email, LastName,Order_Type__c, Course_Name__c, Product_Name__c ,Course_Start_Date__c FROM Lead WHERE Email IN : setRemainingLead];
    List<Lead> RemainingLeads = new List<Lead>();
    if ( !listRemainingLeads.isEmpty() ) {
        RemainingLeads.addAll(listRemainingLeads);
    }
    system.debug('RemainingLeads***'+RemainingLeads);
    */
    
    if ( !listRemainingLeads.isEmpty() ) {
        for(Lead ldss : listRemainingLeads){
            Database.LeadConvert lc1 = new Database.LeadConvert();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc1.setConvertedStatus(convertStatus.MasterLabel);
            lc1.setLeadId(ldss.Id);
            lc1.setOwnerId('0050Y000002IvYy');
            Database.LeadConvertResult lcr = Database.convertLead(lc1);
            system.debug('**oppids---> '+lcr.getOpportunityId());
            oppmapwithoutContact.put(lcr.getOpportunityId(),ldss);
            oppIdToContactIdMap.put( lcr.getOpportunityId(), lcr.getContactId() );
        }
    }
    
    Set<Id> oppkeysets = oppmapwithoutContact.keyset();
    List<Opportunity> listopp=[Select Id,name from Opportunity Where Id IN:oppkeysets];
    List<Opportunity> listoppUpdateName = new List<Opportunity>();
    List<OpportunityLineItem> listOlis=new List<OpportunityLineItem>();
    List<OpportunityLineItem> listOlisToInsert=new List<OpportunityLineItem>();
    Map<Id,OpportunityLineItem> mapProductWithOLI=new Map<Id,OpportunityLineItem>();
    System.debug('listopp =========>' + listopp);
    for(Opportunity opp:listopp){
        Lead lead=oppmapwithoutContact.get(opp.Id);
        if ( String.isNotBlank(lead.Course_Name__c) ) {
            opp.Name = lead.Course_Name__c;
        }
        opp.Volume_Year__c ='2019';
        opp.CurrencyIsoCode = 'USD';
        opp.ownerid = '0050Y000002IvYy';
        opp.StageName = 'Investigating';
        opp.RecordtypeId = opprecType;
        opp.Order_Type__c=lead.Order_Type__c;
        opp.Course_Start_Date__c=lead.Course_Start_Date__c;
        opp.LeadSource = lead.LeadSource;
        opp.Lead_Source_Detail__c = lead.Lead_Source_Detail__c;
        opp.Year_of_Study__c = lead.Year_of_Study__c;
        opp.Decision_Date__c = lead.Decision_Date__c;
        opp.Number_of_Students__c = lead.Anticipated_Enrollment__c;
        opp.Type = 'Course';
        //opp.Primary_Contact__c = oppIdToContactIdMap.containsKey(opp.id) ? oppIdToContactIdMap.get(opp.id) : '';
        listoppUpdateName.add(opp);
        // Create OLIs
        if(lead.Product_Name__c!=null){
            OpportunityLineItem oliItemNew = new OpportunityLineItem();
            //oliItem.Description = mapContactLead.get(key).Lastname+'~'+key;
            oliItemNew.Product2Id = lead.Product_Name__c;
            oliItemNew.OpportunityId = opp.Id;
            oliItemNew.Adoption_Stage__c = 'In-Process';
            oliItemNew.VitalSource_Bookshelf_Code__c = 'Already Sent';
            oliItemNew.VitalSource_Access_Period__c = 'Perpetual Access';
            if ( String.isNotBlank(lead.Book_Requested_Type__c) && lead.Book_Requested_Type__c.equalsIgnoreCase('Print') ) {
                oliItemNew.Order_Type__c = 'Complimentary Exam Copy';
            } else if ( String.isNotBlank(lead.Book_Requested_Type__c) && lead.Book_Requested_Type__c.equalsIgnoreCase('eBook') ) {
                if ( String.isNotBlank(lead.Publisher__c) ) {
                    if ( lead.Publisher__c.equalsIgnoreCase('CRC Press') ) {
                        oliItemNew.Order_Type__c = 'CRC Vitalsource e-Exam copy';
                    } else if ( lead.Publisher__c.equalsIgnoreCase('Garland Science') ) {
                        oliItemNew.Order_Type__c = 'Garland Vitalsource e-Exam copy';                    
                    } else if ( lead.Publisher__c.equalsIgnoreCase('Routledge HSS') ) {
                        oliItemNew.Order_Type__c = 'HSS Vitalsource e-Exam copy';
                    }
                }
            }
            oliItemNew.Recipient__c = oppIdToContactIdMap.get(opp.id);
            listOlis.add(oliItemNew);
            mapProductWithOLI.put(lead.Product_Name__c,oliItemNew);
        }
        
    }
    System.debug('listoppUpdateName Size =======>' + listoppUpdateName.size());
    if ( !listoppUpdateName.isEmpty() ) {
        update listoppUpdateName;
    }
    
    if(listOlis.size()>0){
        Set<Id> productIds=mapProductWithOLI.keySet();
            List<PricebookEntry> listPriceBkEntry=[SELECT Id,Unitprice, Pricebook2.Name,Product2Id,product2.List_Price__c, CurrencyIsoCode FROM PricebookEntry  WHERE Product2Id IN :productIds AND CurrencyIsoCode='USD' AND PriceBook2.Name = 'Standard Price Book'];
        for(PricebookEntry prcBkEntry:listPriceBkEntry){
            OpportunityLineItem oli=mapProductWithOLI.get(prcBkEntry.Product2Id);
            oli.UnitPrice=prcBkEntry.Unitprice;
            oli.PricebookEntryId=prcBkEntry.Id;
            listOlisToInsert.add(oli);
        }
    }
    system.debug('=====>'+listOlisToInsert);
    if(listOlisToInsert.size()>0){
        insert listOlisToInsert;
    }        
    
    /*
    if ( !oppIdToContactIdMap.isEmpty() ) { //oppExistingIdList
        oppExistingIdList.addAll( oppIdToContactIdMap.keySet() );
    }
    
    if ( !oppExistingIdList.isEmpty() ) {
        List<OpportunityContactRole> ocrDeleteList = new List<OpportunityContactRole>();
        ocrDeleteList = [ SELECT id, opportunityId FROM OpportunityContactRole WHERE opportunityId IN:oppExistingIdList ];
        
        if ( !ocrDeleteList.isEmpty() ) {
            DELETE ocrDeleteList;
        }
    }*/
    
    }

   global void finish(Database.BatchableContext BC){
   }
}