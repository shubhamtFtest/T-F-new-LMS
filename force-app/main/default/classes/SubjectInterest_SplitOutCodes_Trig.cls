/*
* Created by Jeff Lup - 2019.10.11 - SAL-1027
* 
* Test: zTEST_SubjectInterest_SplitOutCodes_Trig      94%
*/

public without sharing class SubjectInterest_SplitOutCodes_Trig implements TriggerInterface_SubjectInterest.Runnable {
    public void run(TriggerInterface_SubjectInterest.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            
            //get list of SI Ids processed by FormStack
            Set<Id> siIds = new Set<Id>();  
            for (SubjectInterest__c si : trig.newList) {
                if (si.System_ID__c == 'Formstack')
                	siIds.add(si.Id);
            }
            
            system.debug('siIds = ' + siIds);
            
            if (siIds.size() > 0) {
                Set<String> siCodes = new Set<String>();
                
                //get existing data
                Map<String, SubjectInterest__c> mapExistingSIs = new Map<String, SubjectInterest__c>();
                List<SubjectInterest__c> existingSIs = [SELECT Id, ContactID__c,
                                                        	Subject_Code_Level_1__c, Subject_Code_Level_2__c, Subject_Code_Level_3__c,
                                                        	System_ID__c
                                                        FROM SubjectInterest__c
                                                        WHERE System_ID__c IN :trig.newMap.keySet()
                                                       		OR Id IN :trig.newMap.keySet()];
                for (SubjectInterest__c si : existingSIs) {
                    if (si.System_ID__c == 'Formstack')
	                    mapExistingSIs.put(si.id, si);
                    else
	                    mapExistingSIs.put(si.System_ID__c + si.Subject_Code_Level_1__c + (si.Subject_Code_Level_2__c == null ? '' : si.Subject_Code_Level_2__c) + (si.Subject_Code_Level_3__c == null ? '' : si.Subject_Code_Level_3__c), si);
                }
                
                system.debug('mapExistingSIs = ' + mapExistingSIs);
                
                //loop through trig data
                List<SubjectInterest__c> sisToInsert = new List<SubjectInterest__c>();
                List<SubjectInterest__c> sisToUpdate = new List<SubjectInterest__c>();
                
                for (SubjectInterest__c si : trig.newList) {
                    if (si.System_ID__c == 'Formstack') {
                        
                        //put codes into sets
                        List<string> level1s = new List<string>();
                        List<string> level2or3s = new List<string>();                               
                        if (si.Subject_Code_Level_1__c != null)
                            level1s = si.Subject_Code_Level_1__c.remove(' ').split(',');
                        if (si.Subject_Code_Level_3__c != null)
                            level2or3s = si.Subject_Code_Level_3__c.remove(' ').split(',');
                                   
                        //loop through Level 1 codes per trig record
                        List<SubjectInterest__c> sisToInsertTemp = new List<SubjectInterest__c>();
                        
                        system.debug('level1s = ' + level1s);
                        system.debug('level2or3s = ' + level2or3s);
                        
						for (string level1 : level1s) {
                            siCodes.add(level1);
                            boolean bLevel3Found = false;
                            boolean bLevel1Found = false;    
                            for (string level2or3 : level2or3s) {
                                //siCodes.add(level2or3);
                                if (level2or3.left(2) == level1) {
                                    bLevel3Found = true;
                                    
                                    string level2 = level2or3.left(4);
                                    siCodes.add(level2);
                                    
                                    string level3 = '';
                                    if (level2or3.length() == 6) {
	                                    level3 = level2or3;   
                                    	siCodes.add(level3);
                                    }
                                    
                                    system.debug('level1 = ' + level1);
                                    system.debug('level2 = ' + level2);
                                    system.debug('level3 = ' + level3);
                                    
                                    //check if existing matches
                                    if (mapExistingSIs.containsKey(si.Id + level1 + level2 + level3)) {
                                        system.debug('Exact match found, so do nothing');
                                    } else {
                                        //add possible SI to insert/update
                                        SubjectInterest__c siToAdd = new SubjectInterest__c();
                                        siToAdd.ContactID__c = si.ContactID__c;
                                        siToAdd.Subject_Code_Level_1__c = level1;
                                        siToAdd.Subject_Code_Level_2__c = level2;
                                        siToAdd.Subject_Code_Level_3__c = level3;
                                        siToAdd.Subject_Level_1_Name__c = '';
                                        siToAdd.Subject_Interest_Role__c = si.Subject_Interest_Role__c;
                                        siToAdd.Date_Added_To_Role__c = si.Date_Added_To_Role__c;
                                        siToAdd.Number_of_Interactions__c = si.Number_of_Interactions__c;
                                        siToAdd.System_ID__c = si.Id; //so it can be reference next time
                                        
                                        if (mapExistingSIs.containsKey(si.Id + level1) && !bLevel1Found) {
                                            system.debug('Found a level1 match to enrich');
                                            bLevel1Found = true;
                                            siToAdd.Id = mapExistingSIs.get(si.Id + level1).Id;
                                            sisToUpdate.add(siToAdd);
                                        } else {
                                            system.debug('No match found, so need to insert');
                                        	sisToInsertTemp.add(siToAdd);
                                        }
                                    }
                                }
                            }
                            if (!bLevel3Found) {
                                //check if existing matches
                                if (mapExistingSIs.containsKey(si.Id + level1)) {
                                    system.debug('Exact match found, so do nothing');
                                } else {
                                    //add possible SI to insert
                                    system.debug('No match found, so might need to insert');
                                    SubjectInterest__c siToAdd = new SubjectInterest__c();
                                    siToAdd.Active__c = true;
                                    siToAdd.ContactID__c = si.ContactID__c;
                                    siToAdd.Subject_Code_Level_1__c = level1;
                                    siToAdd.Subject_Code_Level_2__c = '';
                                    siToAdd.Subject_Code_Level_3__c = '';
                                    siToAdd.Subject_Level_1_Name__c = '';
                                    siToAdd.Subject_Interest_Role__c = si.Subject_Interest_Role__c;
                                    siToAdd.Date_Added_To_Role__c = si.Date_Added_To_Role__c;
                                    siToAdd.Number_of_Interactions__c = si.Number_of_Interactions__c;
                                    siToAdd.System_ID__c = si.Id; //so it can be reference next time
                                    sisToInsertTemp.add(siToAdd);
                                }
                            } 
                        }
                        //remove one of the Inserts, and update the Trigger record instead
                        integer i = sisToInsertTemp.size() - 1;
                        SubjectInterest__c siToRemove = sisToInsertTemp[i];
                        SubjectInterest__c siToUpdate = mapExistingSIs.get(si.id);
                        siToUpdate.Subject_Code_Level_1__c = siToRemove.Subject_Code_Level_1__c;
                        siToUpdate.Subject_Code_Level_2__c = siToRemove.Subject_Code_Level_2__c;
                        siToUpdate.Subject_Code_Level_3__c = siToRemove.Subject_Code_Level_3__c;
                        siToUpdate.System_ID__c = 'Trigger Enriched';
                        sisToUpdate.add(siToUpdate);
                        sisToInsertTemp.remove(i);
                        sisToInsert.addAll(sisToInsertTemp);
                    }
                }
                
                //get Subject Names
                Map<String, String> mapCodeToName = new Map<String, String>();
                List<Subject_Taxonomy__c> subjectTaxonomyList = [SELECT Subject_Code__c, Subject_Name__c
                                                                 FROM Subject_Taxonomy__c
                                                                 WHERE Subject_Code__c IN :siCodes];
                for (Subject_Taxonomy__c subjectTaxonomy : subjectTaxonomyList) {
                    mapCodeToName.put(subjectTaxonomy.Subject_Code__c, subjectTaxonomy.Subject_Name__c);
                }
                
                //update sets with the names
                for (SubjectInterest__c si : sisToInsert) {
                    si.Active__c = true;
                    if (mapCodeToName.containsKey(si.Subject_Code_Level_1__c)) {
	                    si.Subject_Level_1_Name__c = mapCodeToName.get(si.Subject_Code_Level_1__c);
                        si.Subject__c = si.Subject_Level_1_Name__c;
                    }
                    if (si.Subject_Code_Level_2__c != null && mapCodeToName.containsKey(si.Subject_Code_Level_2__c)) {
	                    si.Subject_Level_2_Name__c = mapCodeToName.get(si.Subject_Code_Level_2__c);
                        si.Subject__c = si.Subject_Level_2_Name__c;
                    }
                    if (si.Subject_Code_Level_3__c != null && mapCodeToName.containsKey(si.Subject_Code_Level_3__c)) {
	                    si.Subject_Level_3_Name__c = mapCodeToName.get(si.Subject_Code_Level_3__c);
                        si.Subject__c = si.Subject_Level_3_Name__c;
                    }
                }
                
                if (sisToInsert.size() > 0)
                    insert sisToInsert;       
          
                for (SubjectInterest__c si : sisToUpdate) {
                    si.Active__c = true;
                    if (mapCodeToName.containsKey(si.Subject_Code_Level_1__c)) {
	                    si.Subject_Level_1_Name__c = mapCodeToName.get(si.Subject_Code_Level_1__c);
                        si.Subject__c = si.Subject_Level_1_Name__c;
                    }
                    if (si.Subject_Code_Level_2__c != null && mapCodeToName.containsKey(si.Subject_Code_Level_2__c)) {
	                    si.Subject_Level_2_Name__c = mapCodeToName.get(si.Subject_Code_Level_2__c);
                        si.Subject__c = si.Subject_Level_2_Name__c;
                    }
                    if (si.Subject_Code_Level_3__c != null && mapCodeToName.containsKey(si.Subject_Code_Level_3__c)) {
	                    si.Subject_Level_3_Name__c = mapCodeToName.get(si.Subject_Code_Level_3__c);
                        si.Subject__c = si.Subject_Level_3_Name__c;
                    }
                }
                
                if (sisToUpdate.size() > 0)
                    update sisToUpdate;
            }       
        }
    }
}


/*
public without sharing class SubjectInterest_SplitOutCodes_Trig implements TriggerInterface_SubjectInterest.Runnable {
    public void run(TriggerInterface_SubjectInterest.Trig trig) {
        if (trig.isAfter && (trig.isInsert || trig.isUpdate)) {
            Set<Id> contactIds = new Set<Id>();
            //Possible SIs to create
            List<SubjectInterest__c> sisToPossiblyInsert = new List<SubjectInterest__c>();
            for (SubjectInterest__c si : trig.newList) {
                if (si.System_ID__c == 'Formstack') {
                    List<string> level1s = new List<string>();
                    List<string> level2or3s = new List<string>();                               
                    if (si.Subject_Code_Level_1__c != null)
                        level1s = si.Subject_Code_Level_1__c.remove(' ').split(',');
                    if (si.Subject_Code_Level_3__c != null)
                        level2or3s = si.Subject_Code_Level_3__c.remove(' ').split(',');
                  
                    for (string level1 : level1s) {
                        boolean bFound = false;
                        for (string level2or3 : level2or3s) {
                            if (level2or3.left(2) == level1) {
                                bFound = true;
                                //add possible SI to insert
                                SubjectInterest__c siToInsert = new SubjectInterest__c();
                                siToInsert.ContactID__c = si.ContactID__c;
                                siToInsert.Subject_Code_Level_1__c = level1;
                                siToInsert.Subject_Code_Level_2__c = level2or3.left(4);
                                siToInsert.Subject_Code_Level_3__c = (level2or3.length() == 6 ? level2or3 : '');
                                siToInsert.Subject_Interest_Role__c = si.Subject_Interest_Role__c;
                                siToInsert.Date_Added_To_Role__c = si.Date_Added_To_Role__c;
                                siToInsert.Number_of_Interactions__c = si.Number_of_Interactions__c;
                                sisToPossiblyInsert.add(siToInsert);
                            }
                        }
                        if (!bFound) {
                            //add possible SI to insert
                            SubjectInterest__c siToInsert = new SubjectInterest__c();
                            siToInsert.ContactID__c = si.ContactID__c;
                            siToInsert.Subject_Code_Level_1__c = level1;
                            siToInsert.Subject_Code_Level_2__c = '';
                            siToInsert.Subject_Code_Level_3__c = '';
                            siToInsert.Subject_Interest_Role__c = si.Subject_Interest_Role__c;
                            siToInsert.Date_Added_To_Role__c = si.Date_Added_To_Role__c;
                            siToInsert.Number_of_Interactions__c = si.Number_of_Interactions__c;
                            sisToPossiblyInsert.add(siToInsert);
                        }
                    }
                }
            }
            
            //now need to determine which of the above possibles already exist, and should be updated instead
            //also need to keep one back, and update this record instead
            
            List<SubjectInterest__c> existingSIs = [SELECT Id, ContactID__c, Subject_Code_Level_1__c,
                                                    	Subject_Code_Level_2__c, Subject_Code_Level_3__c
                                                    FROM SubjectInterest__c
                                                    WHERE ContactID__c IN :contactIds
                                                    	AND System_ID__c = 'Formstack'];
            
            Map<String, SubjectInterest__c> mapExistingSIs = new Map<String, SubjectInterest__c>();
            for (SubjectInterest__c si : existingSIs) {
                string key = si.ContactID__c + si.Subject_Code_Level_1__c;
                mapExistingSIs.put(key, si);
            }
            
            Set<Id> existingUsedIds = new Set<Id>();
            for (SubjectInterest__c si : sisToPossiblyInsert) {
                string key = si.ContactID__c + si.Subject_Code_Level_1__c;
                if (!existingUsedIds.contains(si.Id) && mapExistingSIs.containsKey(key)) {
                    existingUsedIds.add(si.Id);
                    SubjectInterest__c existingSI = mapExistingSIs.get(key);
                }
            }  
            
            
        }
    }
}
*/


/*
public without sharing class SubjectInterest_SplitOutCodes_Trig implements TriggerInterface_SubjectInterest.Runnable {
    public void run(TriggerInterface_SubjectInterest.Trig trig) {
        if (trig.isBefore && (trig.isInsert || trig.isUpdate)) {
            
            //get list of contact ids
            Set<Id> contactIds = new Set<Id>();  
            for (SubjectInterest__c si : trig.newList) {
                if (si.System_ID__c == 'Formstack')
                	contactIds.add(si.ContactID__c);
            }
            
            if (contactIds.size() > 0) {
                //organize existing data into smaller lists per Contact (so less looping later)
                Map<Id, List<SubjectInterest__c>> mapExistingSIs = new Map<Id, List<SubjectInterest__c>>();
                List<SubjectInterest__c> allExistingSIs = [SELECT Id, ContactID__c, Subject_Code_Level_1__c,
                                                                Subject_Code_Level_2__c, Subject_Code_Level_3__c
                                                            FROM SubjectInterest__c
                                                            WHERE ContactID__c IN :contactIds
                                                                AND System_ID__c = 'Formstack'];
                for (SubjectInterest__c si : allExistingSIs) {
                    List<SubjectInterest__c> existingSIs = new List<SubjectInterest__c>();
                    if (mapExistingSIs.containsKey(si.ContactID__c))
                        existingSIs = mapExistingSIs.get(si.ContactID__c);
                    existingSIs.add(si);
                    mapExistingSIs.put(si.ContactID__c, existingSIs);
                }         
                //
                for (SubjectInterest__c si : trig.newList) {
                    if (si.System_ID__c == 'Formstack') {
                        List<string> level1s = new List<string>();
                        List<string> level2or3s = new List<string>();                               
                        if (si.Subject_Code_Level_1__c != null)
                            level1s = si.Subject_Code_Level_1__c.remove(' ').split(',');
                        if (si.Subject_Code_Level_3__c != null)
                            level2or3s = si.Subject_Code_Level_3__c.remove(' ').split(',');
                        
                        
                        for (string level1 : level1s) {
                            if (level2or3s.size() == 0) {
                                //only level 1 was entered
                                boolean bFound = false;
                                for (SubjectInterest__c existingSI : mapExistingSIs.get(si.ContactID__c)) {
                                    if (existingSI.Subject_Code_Level_1__c == level1) {
                                        bFound = true;
                                        break;
                                    }
                                    if (!bFound) {
                                        //create new SI record, else do nothing
                                        SubjectInterest__c siToInsert = new SubjectInterest__c();
                                        siToInsert.ContactID__c = si.ContactID__c;
                                        siToInsert.Subject_Code_Level_1__c = 
                                    }
                                }
                            } else {
                                //level 1 and 3 was entered
                            	string level2 = '';
                            	string level3 = '';
                            
                                for (string level2or3 : level2or3s) {
                                    level2 = level2or3.left(4);
                                    if (level2or3.length() = 6)
                                        level3 = level2or3;
                                	//
                                	for (SubjectInterest__c existingSI : mapExistingSIs.get(si.ContactID__c)) {
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                //do insert/update here
                
                
            }
        }
    }
}
 */