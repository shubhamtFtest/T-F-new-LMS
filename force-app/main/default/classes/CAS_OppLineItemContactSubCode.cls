/************************************************************************** 
** Tested by: zTEST_CAS.
** Automate adding SubjectCodes to CAS contacts when Opportunity Product is added or created
** Modified by Shay Spoonmore - 2010.07.13
** Modified by Jeff Lup - 2011.09.30 - CHG0037851
** Modified by Shay Spoonmore (shay.spoonmore@informausa.com) 2015-05-21 CHG0066391
** Modified by Ashish Purwar - Update to use Product2.Subject_Classifications__c 
***************************************************************************/


public without sharing class CAS_OppLineItemContactSubCode {
    
    @future
public static void AddContactSubjectCodes(Set<Id> oliIds)
{
        if (oliIds != null &&  oliIds.size() != 0)
        {
            List<OpportunityLineItem> updateEventdetail = new OpportunityLineItem[]{};

            OpportunityLineItem[] oliContactSubjectCodesRaw = [Select o.Id, 
                                                            o.OpportunityRecordtypeId__c, 
                                                            o.PricebookEntryId, 
                                                            o.PricebookEntry.Product2Id, 
                                                            o.Recipient__c, 
                                                            o.PricebookEntry.Product2.Subject_Classifications__c 
                                                    from OpportunityLineItem o
                                                    where o.PricebookEntry.Product2.Subject_Classifications__c != null and o.Recipient__c != NULL and o.Id IN:oliIds LIMIT 200];
            if(oliContactSubjectCodesRaw != null &&  oliContactSubjectCodesRaw.size() != 0)
            {
                                                    
                Set<Id> oliRecepients = new Set<Id>();
                Set<String> oliProductSubjectCodes = new Set<String>();
                Map<Id, String> contactSubjectCodes = new Map<Id, String>();
                //Get contacts and subject codes                                        
                for (OpportunityLineItem oppProduct : oliContactSubjectCodesRaw) 
                {
                    Product2 subProduct =  oppProduct.PricebookEntry.Product2;
                    System.debug('##### OpportunityRecordtypeId: ' + oppProduct.OpportunityRecordtypeId__c + 
                                ' ##### Product SubjectCode: ' + subProduct.Subject_Classifications__c + 
                                ' ##### OpportunityLineItemId: ' + oppProduct.Id + 
                                ' ##### OpportunityLineItemRecipient: ' + oppProduct.Recipient__c);
                    
                    
                    //Get all contact Ids
                    oliRecepients.add(oppProduct.Recipient__c);
                    contactSubjectCodes.put(oppProduct.Recipient__c, subProduct.Subject_Classifications__c);
    
                    List<String> splitSubjectCodes = subProduct.Subject_Classifications__c.split(';');
                    for(Integer i = 0; i < splitSubjectCodes.size(); i++)
                    { 
                        List<String> splitCode = splitSubjectCodes[i].split(' - ');
                        if (splitCode.size() != 0 && splitCode[0].trim() != '-')
                        {
                            System.debug('##### Contact SubjectCode: ' + splitCode[0].trim());
                            oliProductSubjectCodes.add(splitCode[0].trim());
                        }
                    }
                    
                }
            
                
                //Get subject code parents to only return relevant mappings to each contact, return list is smaller
                Set<String> parentSubjectCodes = new Set<String>();
                for(String code: oliProductSubjectCodes)
                {
                    parentSubjectCodes.Add(code);
                    System.debug('##### ProductSubjectCode = ' + code);
                    if(code.length() > 4)
                    {
                        do
                        {
                            code= code.left(code.length()-2);
                            System.debug('##### ProductSubjectCode Children = ' + code);
                            parentSubjectCodes.Add(code);
                        } while (code.length() > 4);
                    
                    }
                }
                System.debug('##### parentSubjectCodes.size() = ' + parentSubjectCodes.size());
                
                
                System.debug('##### oliRecepients.size() = ' + oliRecepients.size());

                //Get existing Contact Subject Codes to compare against
                Map<String,String> mapContactSubjectCodes = new Map<String,String>();
                CAS_Subject_Code_Contact__c[] contactsSubjectCodes = [Select c.Contact__c, c.Id, c.Name, c.Subject_Code__c, c.SystemModstamp, c.Subject_Code__r.GT_Cat_Code__c 
                                                                        from CAS_Subject_Code_Contact__c c where c.Subject_Code__r.GT_Cat_Code__c IN:parentSubjectCodes and c.Contact__c IN:oliRecepients];// this will not work because it check for parents c.Subject_Code__r.GT_Cat_Code__c IN: oliProductSubjectCodes AND
                for (CAS_Subject_Code_Contact__c contactsSubjectCode: contactsSubjectCodes) 
                {
                    System.debug('##### CAS_Subject_Code_Contact__c.Contact__c: ' + contactsSubjectCode.Contact__c + 
                                ' ##### CAS_Subject_Code_Contact__c.Subject_Code__c: ' + contactsSubjectCode.Subject_Code__c);
                    mapContactSubjectCodes.put(contactsSubjectCode.Contact__c + '-' + contactsSubjectCode.Subject_Code__c,contactsSubjectCode.Subject_Code__c);
                }
                System.debug('##### Check mapContactSubjectCodes.size(): ' + mapContactSubjectCodes.size());
    
                //Loop Subject Codes and add them if missing
                List<CAS_Subject_Code_Contact__c> createContactSubjectCodes = new CAS_Subject_Code_Contact__c[]{};
                CAS_Subject_Code__c[] subjectCodes = [Select c.GT_Cat_Code__c, c.Id, c.Name, c.Parent__c, c.Parent__r.GT_Cat_Code__c, c.Parent__r.Name, 
                                                            c.Parent__r.Parent__c,
                                                            c.Parent__r.Parent__r.GT_Cat_Code__c, c.Parent__r.Parent__r.Name, c.Parent__r.Parent__r.Parent__c,
                                                            c.Parent__r.Parent__r.Parent__r.GT_Cat_Code__c, c.Parent__r.Parent__r.Parent__r.Name, c.Parent__r.Parent__r.Parent__r.Parent__c 
                                                            from CAS_Subject_Code__c c where c.GT_Cat_Code__c IN: oliProductSubjectCodes order by c.GT_Cat_Code__c asc];
            
                for(String oliRecepient : oliRecepients)
                {   
                
                    Map<Id,String> dedupeSubjectCodes = new Map<Id,String>();
                    List<String> splitSubjectCodes = contactSubjectCodes.get(oliRecepient).split(';');
                    
                    for (CAS_Subject_Code__c subjectCode : subjectCodes) 
                    {
                        
                            System.debug('##### Cat_Code__c: ('+ subjectCode.Id +'): ' + subjectCode.GT_Cat_Code__c);
                        
                            CAS_Subject_Code__c subCodeChild1 =  subjectCode.Parent__r;
                            CAS_Subject_Code__c subCodeChild2 =  subjectCode.Parent__r.Parent__r;
                            CAS_Subject_Code__c subCodeChild3 =  subjectCode.Parent__r.Parent__r.Parent__r;

                            for(Integer j = 0; j < splitSubjectCodes.size(); j++)
                            { 
                                List<String> splitCode = splitSubjectCodes[j].split(' - ');
                                if (splitCode.size() != 0)
                                {
                                    if (splitCode[0].trim() == subjectCode.GT_Cat_Code__c && mapContactSubjectCodes.containsKey(oliRecepient + '-' + subjectCode.Id) == false)
                                    {
                                        dedupeSubjectCodes.put(subjectCode.Id,subjectCode.Name);

                                        // Add Child Codes
                                        if (subCodeChild1 != null)
                                        {
                                            if(mapContactSubjectCodes.containsKey(oliRecepient + '-' + subCodeChild1.Id) == false)
                                                dedupeSubjectCodes.put(subCodeChild1.Id,subCodeChild1.Name);
                                        }
                                        if (subCodeChild2 != null)
                                        {
                                            if(mapContactSubjectCodes.containsKey(oliRecepient + '-' + subCodeChild2.Id) == false)
                                            {
                                                System.debug('##### ADD Child Contact SubjectCode 2: ' + subCodeChild2.GT_Cat_Code__c + ':' + oliRecepient + '-' + subCodeChild2.Id);
                                                dedupeSubjectCodes.put(subCodeChild2.Id,subCodeChild2.Name);
                                            }
                                        }

                                        if (subCodeChild3 != null)
                                        {
                                            if(mapContactSubjectCodes.containsKey(oliRecepient + '-' + subCodeChild3.Id) == false)
                                            {
                                                System.debug('##### ADD Child Contact SubjectCode 3: ' + subCodeChild3.GT_Cat_Code__c + ':' + oliRecepient + '-' + subCodeChild3.Id);
                                                dedupeSubjectCodes.put(subCodeChild3.Id,subCodeChild3.Name);
                                            }
                                        }
                                    }
                                }
                            }
                        
                }
                
                
                //Add the deduped Subject codes
                    if (dedupeSubjectCodes != null && dedupeSubjectCodes.size() != 0)
                    {
                        Set <Id> scIds = new Set<Id>();
                        scIds = dedupeSubjectCodes.keySet();

                        for (Id subjectCodeId : scIds) 
                        {
                            System.debug('##### dedupeSubjectCodes.get(' + subjectCodeId + '): ' + dedupeSubjectCodes.get(subjectCodeId));
                            CAS_Subject_Code_Contact__c createContactSubjectCode = new CAS_Subject_Code_Contact__c (Contact__c = oliRecepient, Name = dedupeSubjectCodes.get(subjectCodeId), Subject_Code__c = subjectCodeId);
                            createContactSubjectCodes.add(createContactSubjectCode);
                        }
                    }
    
                
            }
            
            
                //Add SubjectCodes to Contact
                System.debug('##### createContactSubjectCodes.size(): ' + createContactSubjectCodes.size());    
                if  (createContactSubjectCodes != null && createContactSubjectCodes.size() != 0)
                {
                    
                    insert(createContactSubjectCodes);
                }
            
        }
    }
}
}