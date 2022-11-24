/*
Author : shashank kulshreshtha 
Description : This batch is used for assigning all required opp to territories according to the account territory. prioritized territory is fetched according to the function defined . only active territories are used in this batch class. 
Date created :
Test class :
Test coverage :
*/
global  class BatchAssignTerritoryToFetchedOppId implements Database.Batchable<sobject> , Database.Stateful {
    Set<Id> setRecTypeIds = new Set<Id>();
    Map<id,RecordType> mapIdRecType ;
    Id activeModelId;
    integer recordsProcessed= 0;
	
	global Database.QueryLocator start( Database.BatchableContext bc ){
        activeModelId = getActiveModelId();
        mapIdRecType = new Map<id,RecordType>([SELECT id,Name FROM RecordType WHERE DeveloperName  IN ('T_F_Journals_Customer_Opportunity_Direct','T_F_Journals_Consortium_Opportunity_Direct','T_F_Journals_Consortium_Opportunity_Price_Agreement','T_F_One_Off_Opportunity')  and isActive=true]);
		setRecTypeIds = mapIdRecType.keySet();
		System.debug('setRecTypeIds-'+setRecTypeIds);
		System.debug('activeModelId-'+activeModelId);
		String query = 'SELECT id,accountId,Territory2Id FROM opportunity WHERE IsExcludedFromTerritory2Filter=false AND RecordTypeId IN :setRecTypeIds' ; 
		return database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext bc , List<Opportunity> listOpportunity){
        List<opportunity> listOppToUpdate = new List<opportunity>();
		Map<Id, Id> OppIdTerritoryIdResult = new Map<Id, Id>();
        // Get the active territory model Id
        if(activeModelId != null){
            Set<Id> accountIds = new Set<Id>();
            // Create set of parent accountIds
            for(Opportunity opp : listOpportunity){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId); 
                }
            }

            Map<Id,Territory2Priority> accountMaxPriorityTerritory = getAccountMaxPriorityTerritory(activeModelId, accountIds);
			// For each opportunity, assign the highest priority territory if there is no conflict, else assign null.
            for(Opportunity opp: listOpportunity){
               Territory2Priority tp = accountMaxPriorityTerritory.get(opp.AccountId);
               // Assign highest priority territory if there is only 1.
              if((tp != null) && (tp.moreTerritoriesAtPriority == false)  ){
                   OppIdTerritoryIdResult.put(opp.Id, tp.territory2Id);
                   opp.Territory2Id = tp.territory2Id;
                   listOppToUpdate.add(opp);
               }else{
                   OppIdTerritoryIdResult.put(opp.Id, null);
                   opp.Territory2Id = null;
                   listOppToUpdate.add(opp);
               }
            }
        }
		System.debug('OppIdTerritoryIdResult-'+OppIdTerritoryIdResult);
		System.debug('listOppToUpdate size-'+listOppToUpdate.size());
        if(listOppToUpdate!= null && listOppToUpdate.size()>0 ){
            update listOppToUpdate;
            recordsProcessed =recordsProcessed + listOppToUpdate.size();
        }
        // return OppIdTerritoryIdResult;
	}
	global void finish(Database.BatchableContext bc){
        System.debug('finished recordsProcessed-'+recordsProcessed); 
	}

    /**
      * Query assigned territoryIds in active model for given accountIds.
      * Create a map of accountId to max priority territory.
      */
     private Map<Id,Territory2Priority> getAccountMaxPriorityTerritory(Id activeModelId, Set<Id> accountIds){
        Map<Id,Territory2Priority> accountMaxPriorityTerritory = new Map<Id,Territory2Priority>();
        for(ObjectTerritory2Association ota:[Select ObjectId, Territory2Id, Territory2.Territory2Type.Priority from ObjectTerritory2Association where objectId IN :accountIds and Territory2.Territory2ModelId = :activeModelId]){
            Territory2Priority tp = accountMaxPriorityTerritory.get(ota.ObjectId);

            if((tp == null) || (ota.Territory2.Territory2Type.Priority > tp.priority)){
                // If this is the first territory examined for account or it has greater priority than current highest priority territory, then set this as new highest priority territory.
                tp = new Territory2Priority(ota.Territory2Id,ota.Territory2.Territory2Type.priority,false);
            }else if(ota.Territory2.Territory2Type.priority == tp.priority){
                // The priority of current highest territory is same as this, so set moreTerritoriesAtPriority to indicate multiple highest priority territories seen so far.
                tp.moreTerritoriesAtPriority = true;
            }
            //  opportunities that dont have territorites are assigned new territories . but if the territories o f account is change dwe are changing the territories of opportunity. 
            accountMaxPriorityTerritory.put(ota.ObjectId, tp);
        }
        return accountMaxPriorityTerritory;
    }


    /**
     * Get the Id of the Active Territory Model.
     * If none exists, return null.
     */
    private Id getActiveModelId() {
        List<Territory2Model> models = [Select Id from Territory2Model where State = 'Active'];
        Id activeModelId = null;
        if(models.size() == 1){
            activeModelId = models.get(0).Id;
        }

        return activeModelId;
    }

    /**
    * Helper class to help capture territory2Id, its priority, and whether there are more territories with same priority assigned to the account.
    */
    private class Territory2Priority {
        public Id territory2Id { get; set; }
        public Integer priority { get; set; }
        public Boolean moreTerritoriesAtPriority { get; set; }

        Territory2Priority(Id territory2Id, Integer priority, Boolean moreTerritoriesAtPriority){
            this.territory2Id = territory2Id;
            this.priority = priority;
            this.moreTerritoriesAtPriority = moreTerritoriesAtPriority;
        }
    }
}