@istest
public class zTestBatchAssignTerritoryToFetchedOppId {
    @isTest public static void batchTest(){
    Database.BatchableContext BC;
    List<Opportunity> listOpportunity;
    BatchAssignTerritoryToFetchedOppId bat = new BatchAssignTerritoryToFetchedOppId();
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    Id batchId=Database.executeBatch(bat);
    System.debug(batchId);
    List<Account> aList = new List<Account> {
       new Account (Name = 'My Test Account')
    };
    insert aList;
    System.debug(aList);
    
    List<Opportunity> oList = new List<Opportunity> {
    new Opportunity(Name ='New OPP Deal',AccountID =aList[0].Id,StageName = 'Close Won',Amount = 3000,CloseDate = System.today()+10)};
    insert oList;
    System.debug(oList);
    
    listOpportunity=[SELECT id,name,Amount,CloseDate,StageName,AccountID FROM opportunity Where id=:oList[0].id];
    System.debug(listOpportunity);
    List<Territory2Model> models = [Select Id from Territory2Model where State = 'Active'];
        Id activeModelId = null;
        if(models.size() == 1){
            activeModelId = models.get(0).Id;
        }
   ID terID;
   System.runAs(usr){
   for(List<Territory2> territories : [SELECT ID, DeveloperName, Name, Territory2TypeId FROM Territory2]){
        terID=territories[0].id;
    }
   }
   ObjectTerritory2Association objObjectTerritory2Association = new ObjectTerritory2Association(ObjectId = aList[0].Id, Territory2Id =terID, AssociationCause='Territory2Manual' );
   insert objObjectTerritory2Association;     
  
  //global void execute(Database.BatchableContext bc , List<Opportunity> listOpportunity);
        Test.startTest();
         bat.execute(BC, listOpportunity);
        Test.stopTest();
    }
}