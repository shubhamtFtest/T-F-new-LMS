public without sharing class Case_AutoResponseRules_trig implements TriggerInterface_Case.Runnable {
   
    public void run(TriggerInterface_Case.Trig trig) {
        if (trigger.isAfter && trigger.isInsert) {
           
            //Logic to handle any cases coming through the UBX community contact form.
            List<Id> communityUserId = new List<Id>();
            for(User u: [SELECT Id, Name
                         FROM User
                         WHERE Name = 'Help Center - Librarian/Institution Site Guest User'
                         OR Name = 'Help Center - Student/Researcher Site Guest User']){
                             communityUserId.add(u.Id);   
                         }
            system.debug('communityUserId ' + communityUserId);
            List<Case> casesToAutoRespond = new List<Case>();
            for(Case c: [SELECT Id, SuppliedEmail, Origin, CreatedById FROM Case WHERE Id in: trig.newlist]){
                if(c.SuppliedEmail != '' && c.Origin == 'UBX Community Help Portal' && communityUserId.contains(c.CreatedById)){ 
                    system.debug('If statement Passed');
                    casesToAutoRespond.add(c);
                }
            }
            Database.DMLOptions autoResponseOptions = new Database.DMLOptions();
            autoResponseOptions.EmailHeader.triggerAutoResponseEmail = true;
            
            Database.update(casesToAutoRespond, autoResponseOptions);
        }
        
    }        
}