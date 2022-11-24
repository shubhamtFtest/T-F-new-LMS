/************************************************************************** 
** Create schedule Apex - Job Name: IR_OpportuntityAutoCloseSchedule -Test class - zTEST_IR_OpportuntityAutoCloseBatch
** Created/Modified by Amit Kumar - 2021-02-11
***************************************************************************/
global class IR_OpportuntityAutoCloseBatch implements Database.Batchable<Sobject>{
    public Boolean isTesting; //used for test methods
    Public Integer queryLimit;
    Private String query;
    
    global database.querylocator start(Database.BatchableContext BC) {
        Id oppRecordtypeId = MiscFunctions.getRecordtypeId('Opportunity', 'T&F - India Reprint');
        String dt = DateTime.now().format('yyyy-MM-dd');         
        query = 'SELECT Id, Name, CloseDate, IsClosed, StageName FROM Opportunity where RecordTypeId =  \'' + oppRecordtypeId + 
            + '\' AND IsClosed = false AND StageName NOT IN (\'Closed Won\') AND CloseDate < ' + dt +
            + ' ORDER BY Id ASC limit 500';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        List<Opportunity> opptoupdate = new List<Opportunity>();
        for(Opportunity opp : scope) {
            Opportunity oppobj =new Opportunity();  
            oppobj.Id = opp.Id;
            oppobj.StageName = 'Closed Lost';
            opptoupdate.add(oppobj);
        }
        update opptoupdate;
    } 
    
    global void finish(Database.BatchableContext bc) {
        
    }
}