/*** Updated lines from 26-62 **
*** By Amanica for case : 00971139 *****/

public with sharing class BulkUpdateCase{

    public Case cas {get;set;}
    public Integer selectedCount {get;set;} 
    public boolean sendEmailNotification {get;set;}
    public boolean updated {get;set;}
    ApexPages.StandardSetController ctrl ;

  
    public BulkUpdateCase(ApexPages.StandardSetController controller) {
        cas = new Case();
        ctrl = controller ;
        updated = false;
        If(controller.getSelected() != null){
            selectedCount = controller.getSelected().size();
        }
    }
    public BulkUpdateCase(){
        cas = new Case();

    }

    public PageReference updateCurrentOwner(){

        List<Case> casList = new List<Case>();
        List<Case> casUpdList = new List<Case>();
        List<UserRecordAccess> uraList = new List<UserRecordAccess>();
        List<Id> updatableCasIdList = new List<Id>();
        List<Id> casIdList = new List<Id>();

        casList = ctrl.getSelected();
    
        for(Case cs : casList){
            casIdList.add(cs.id);
        }

        uraList = [SELECT RecordId FROM UserRecordAccess WHERE RecordId in : casIdList AND UserId = : userinfo.getuserid() AND HasTransferAccess = true] ;

        for(UserRecordAccess ura : uraList){
            updatableCasIdList.add(ura.RecordId);    
        }
        
        for(String casId : updatableCasIdList){
            Case cas = new Case();
            cas.Id = casId;
            cas.ownerId = UserInfo.getUserId();
            casUpdList.add(cas);
        }
        
        if(casUpdList.Size() > 0){
            Database.SaveResult[] srList = Database.update(casUpdList);    
            PageReference returnPage = ctrl.cancel();
            return returnPage ;
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary. Click Cancel to return to the previous page.'));
            return null;
        }

    }

    public PageReference updateOwner(){

        List<Case> casList = new List<Case>();
        List<Id> casUpdIdList = new List<Id>();
        List<Id> casIdList = new List<Id>();
        List<UserRecordAccess> uraList = new List<UserRecordAccess>();
        List<Id> updatableCasIdList = new List<Id>();
        List<Case> casesToUpdateLst = new List<Case>();
        Map<id,Id> casIdOwnIdMap = new  Map<id,Id>();
        casList = ctrl.getSelected();
        for(Case cs : casList){

            casIdList.add(cs.id);

        }

        uraList = [SELECT RecordId FROM UserRecordAccess WHERE RecordId in : casIdList AND UserId = : userinfo.getuserid() AND HasTransferAccess = true] ;
        for(UserRecordAccess ura : uraList){
            updatableCasIdList.add(ura.RecordId);    

        }

        if(updatableCasIdList.size() == 0){

           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary. Click Cancel to return to the previous page.'));
           
        }

        if(updatableCasIdList.size() > 0){
            Map<id,Case> casWithOwner = new Map<id,Case>([Select Id, OwnerId From Case where Id in : updatableCasIdList]);
            casesToUpdateLst = casWithOwner.values();
            for(Case c : casWithOwner.values()){
                casIdOwnIdMap.put(c.id, c.OwnerId);
                c.OwnerId = cas.ownerId;

            }

            Database.DMLOptions dlo = new Database.DMLOptions();

            dlo.EmailHeader.triggerUserEmail = sendEmailNotification;

            Database.SaveResult[] srList = Database.update(casesToUpdateLst, dlo); 

            updated = true;

        for (Database.SaveResult sr : srList) {

            if (sr.isSuccess()) {

                casUpdIdList.add(sr.getId());
            }

            else {

                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }      
        if(updatableCasIdList.size() < casList.size() ){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'Partially updated, you do not have the level of access necessary to perform the operation you requested on all records. Please contact the owner of the record or your administrator if access is necessary. Click Cancel to return to the previous page.'));
           updated = false;
        }  
            If(casUpdIdList.size() > 0){
                DateTime currentTime = System.now();
                String user_prefix = Schema.SObjectType.User.getKeyPrefix();
                if(((String)cas.ownerId).startsWith(user_prefix)){
                    List<Task> tskList = new List<Task>();
                    List<Event> evtList = new List<Event>();
                    List<Task> tskListToUpdt = new List<Task>();
                    List<Event> evtListToUpdt = new List<Event>();
                    tskList = [Select Id, ownerid, whatid from Task Where whatid in : casUpdIdList and IsClosed != true];
                    evtList = [Select Id, ownerid, whatid from Event Where whatid in : casUpdIdList and EndDateTime > : currentTime];
                    for(Task tsk : tskList){
                        if(tsk.ownerid == casIdOwnIdMap.get(tsk.whatid)){
                            tsk.ownerid = cas.ownerId;
                            tskListToUpdt.add(tsk);
                        }
                    }
                    for(Event evt : evtList){
                        if(evt.ownerid == casIdOwnIdMap.get(evt.whatid)){
                          evt.ownerid = cas.ownerId;
                          evtListToUpdt.add(evt);
                        }
                    }
                    if(tskListToUpdt.size() > 0){
                      update tskListToUpdt;
                    }
                    if(evtListToUpdt.size() > 0){
                       update evtListToUpdt;
                    }

                }

            }
    }
    if(updated){
    
        PageReference returnPage = ctrl.cancel();

        return returnPage ;

    }else{

        return null ;
    }
    }
       public PageReference updateStatus(){
        List<Case> casList = new List<Case>();
        List<Id> casUpdIdList = new List<Id>();
        List<Id> casIdList = new List<Id>();
        List<UserRecordAccess> uraList = new List<UserRecordAccess>();
        List<Id> updatableCasIdList = new List<Id>();
        List<Case> casesToUpdateLst = new List<Case>();
        casList = ctrl.getSelected();

        for(Case cs : casList){

            casIdList.add(cs.id);

        }
        uraList = [SELECT RecordId FROM UserRecordAccess WHERE RecordId in : casIdList AND UserId = : userinfo.getuserid() AND HasEditAccess = true] ;
        for(UserRecordAccess ura : uraList){
            updatableCasIdList.add(ura.RecordId);    
        }
        if(updatableCasIdList.size() == 0){
          Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary. Click Cancel to return to the previous page.'));
        }
        if(updatableCasIdList.size() > 0){
        Map<id,Case> casWithOwner = new Map<id,Case>([Select Id, OwnerId From Case where Id in : updatableCasIdList]);
           for(Case c : casWithOwner.values()){

                c.status = cas.status;

                casesToUpdateLst.add(c);
            }

            Database.DMLOptions dlo = new Database.DMLOptions();

            dlo.EmailHeader.triggerUserEmail = sendEmailNotification;

            Database.SaveResult[] srList = Database.update(casesToUpdateLst, dlo); 

            updated = true;

        for (Database.SaveResult sr : srList) {

            if (sr.isSuccess()) {

                casUpdIdList.add(sr.getId());

            }

            else {

                for(Database.Error err : sr.getErrors()) {

                    System.debug('The following error has occurred.');                    

                    System.debug(err.getStatusCode() + ': ' + err.getMessage());

                }

            }

        }      

        if(updatableCasIdList.size() < casList.size() ){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'Partially updated, you do not have the level of access necessary to perform the operation you requested on all records. Please contact the owner of the record or your administrator if access is necessary. Click Cancel to return to the previous page.'));
            updated = false;
        }  
    }
        if(updated){
            PageReference returnPage = ctrl.cancel();
            return returnPage ;
        }else{
            return null ;
        }
    }
}