global class ScheduleToUnArchiveBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        ToUnArchiveBatch b= new ToUnArchiveBatch(); 
        database.executebatch(b,10);
    }
    }