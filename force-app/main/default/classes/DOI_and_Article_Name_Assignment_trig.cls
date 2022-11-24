/* Tested by: zTest_DOI_and_Article_Name_Assignment  at 100% ********************
* 
*   Created by Tom Reed - 2018-03-11 - Replacement of Process Builder 'T&F Latest DOI and Article Name Assignment for Author'
*
********************************************************************************/

public class DOI_and_Article_Name_Assignment_trig implements TriggerInterface_ProductInterest.Runnable {
    
    public void run(TriggerInterface_ProductInterest.Trig trig) {
        if ((trig.isafter && trig.isInsert) || (trig.isafter && trig.isUpdate)) {
            
            //Contact List ids To Update
            LIST<id> contactListIds = New LIST<id>();
            //MAP Of ProductInterest__c Records
            MAP<id,ProductInterest__c> productInterestRecords = NEW MAP<id,ProductInterest__c>();
            //List Of Contacts To Update
            LIST<Contact> contactsToUpdate = New LIST<Contact>();
            
            //Initialize the setting item records
            LIST<Setting_Item__c> settingItemList = new LIST<Setting_Item__c>();
            SET<String> settingItemSet = new SET<String>();
            settingItemList = [SELECT Text_1__c FROM Setting_Item__c WHERE Setting__r.name = 'DOI_and_Article_Name_Assignment_trig_List'];
            for(Setting_Item__c si: SettingItemList){       
                if(SettingItemList.size()>0){
                    SettingItemSet.add(string.valueof(si.Text_1__c));
                }               
           }
            
            For(ProductInterest__c pi: [SELECT ContactID__r.name, ProductID__r.name
                                        , DOI__c
                                        , product_interest_role__c
                                        , Article_Type__c
                                        , ProductID__c
                                        , ContactID__c
                                        , Article_Name__c
                                        , ContactID__r.Published_Articles__c
                                        FROM ProductInterest__c
                                        WHERE id in: trig.newList]){ 
                                            
                                            //Set the Parent Records
                                            contactListIds.add(pi.ContactID__c);
                                            //Set the ProductInterest__c Records
                                            productInterestRecords.put(pi.contactID__c,pi);                                    
                                        }
            
            for(Contact contactRecord: [SELECT id, Published_Articles__c  FROM Contact WHERE id in: contactListIds]){
                
                if(settingItemSet.contains(productInterestRecords.get(contactRecord.id).product_interest_role__c) && productInterestRecords.get(contactRecord.id).DOI__c != '' && productInterestRecords.get(contactRecord.id).Article_Type__c == 'Article'){

                    //Length of String
                    Integer lengthOfString = productInterestRecords.get(contactRecord.id).DOI__c.length();
                    
                    //Assign values to the Contact relating to the ProductInterest__c record
                    if(productInterestRecords.get(contactRecord.id).ProductID__c != null){
                        contactRecord.Latest_Article_Journal__c = productInterestRecords.get(contactRecord.id).ProductID__r.name; 
                    } else {contactRecord.Latest_Article_Journal__c = '';}
                    contactRecord.Latest_Article_Title__c = productInterestRecords.get(contactRecord.id).Article_Name__c;
                    contactRecord.Latest_DOI_1__c = productInterestRecords.get(contactRecord.id).DOI__c.substring(0,string.valueof(productInterestRecords.get(contactRecord.id).DOI__c).indexOf('/',0));
                    contactRecord.Latest_DOI_2__c = productInterestRecords.get(contactRecord.id).DOI__c.substring(string.valueof(productInterestRecords.get(contactRecord.id).DOI__c).indexOf('/',0)+1,lengthOfString);
                    
                    if(contactRecord.Published_Articles__c == 0){
                        contactRecord.Published_Articles__c = 1;
                    } else {contactRecord.Published_Articles__c = productInterestRecords.get(contactRecord.id).ContactID__r.Published_Articles__c+1;}
                    
                    //Add The Contact To Update
                    contactsToUpdate.add(contactRecord);           
                } 
                
            }
            if(contactsToUpdate.size() > 0){ 
                Update contactsToUpdate; 
            }
        }
    }
}