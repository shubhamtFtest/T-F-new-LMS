global class CASBulkSCAssignment {
    
    private static Map<Integer,List<CAS_Subject_Code_Lead__c>> leadsMap = new Map<Integer,List<CAS_Subject_Code_Lead__c>>{1 => new List<CAS_Subject_Code_Lead__c>()};
    private static Map<Integer,List<CAS_Subject_Code_Contact__c>> contactsMap = new Map<Integer,List<CAS_Subject_Code_Contact__c>>{1 => new List<CAS_Subject_Code_Contact__c>()};
    // the max number of items a list can hold
    private static final Integer MAX_LIST_LIMIT = 1000;

    webService static String assignSubjectCodes(List<ID> subjectCodeIds, String campaignId) {
        
        // count the number of leads/contacts that where processed
        Integer nbrAssigned = 0;
        // get a list of all of the subject codes to add
        List<CAS_Subject_Code__c> subjectCodes = [Select Id, Name from CAS_Subject_Code__c Where Id IN :subjectCodeIds];
        // lists to hold the records to insert
        List<CAS_Subject_Code_Contact__c> contactCodesToInsert = new List<CAS_Subject_Code_Contact__c>();
        List<CAS_Subject_Code_Lead__c> leadCodesToInsert = new List<CAS_Subject_Code_Lead__c>();

        for (CampaignMember member : [Select Id, LeadId, ContactId, Status from CampaignMember Where Status = 'Sent' And CampaignId = :campaignId]) {
            
            nbrAssigned++;
            
            // if the member is a lead
            if (member.LeadId != null) {
                
                // add all of the subject codes for the lead
                for (CAS_Subject_Code__c sc : subjectCodes) {
                
                    CAS_Subject_Code_Lead__c lsc = new CAS_Subject_Code_Lead__c(
                        name = sc.Name,
                        lead__c = member.LeadId,
                        subject_code__c = sc.Id
                    );
                    addLeadSubjectcode(lsc);
                }

            // member is a contact
            } else {
                
                // add all of the subject codes for the contact
                for (CAS_Subject_Code__c sc : subjectCodes) {
                
                    CAS_Subject_Code_Contact__c csc = new CAS_Subject_Code_Contact__c(
                        name = sc.Name,
                        contact__c = member.ContactId,
                        subject_code__c = sc.Id
                    );
                    addContactSubjectCode(csc);
                }
                
            }
            
        }
        
        // insert the records
        try {
        
            for (Integer i=1;i<=leadsMap.size();i++)
                insert leadsMap.get(i);
            for (Integer j=1;j<=contactsMap.size();j++) 
                insert contactsMap.get(j);
            
        } catch (DMLException e) {
            return 'Error! '+e.getDmlMessage(0);
        }
        
        return 'Assigned '+subjectCodes.size()+' subject codes to '+nbrAssigned+' campaign members.';
    }
    
    // add a subject code to the leads list/map
    private static void addLeadSubjectcode(CAS_Subject_Code_Lead__c sc) {
        // if the list is equal to the max number of list items, then add a new list to the map
        if (leadsMap.get(leadsMap.size()).size() == MAX_LIST_LIMIT)
            leadsMap.put(leadsMap.size()+1, new List<CAS_Subject_Code_Lead__c>());
    
        // get the current list
        List<CAS_Subject_Code_Lead__c> leads = leadsMap.get(leadsMap.size());
        // add the subject code to the list
        leads.add(sc);
        // put the list back into the map
        leadsMap.put(leadsMap.size(), leads);
    }

    // add a subject code to the contacts list/map
    private static void addContactSubjectCode(CAS_Subject_Code_Contact__c sc) {
        // if the list is equal to the max number of list items, then add a new list to the map
        if (contactsMap.get(contactsMap.size()).size() == MAX_LIST_LIMIT)
            contactsMap.put(contactsMap.size()+1, new List<CAS_Subject_Code_Contact__c>());
    
        // get the current list
        List<CAS_Subject_Code_Contact__c> contacts = contactsMap.get(contactsMap.size());
        // add the subject code to the list
        contacts.add(sc);
        // put the list back into the map
        contactsMap.put(contactsMap.size(), contacts);
    }
    


}