global class ScheduleToArchiveBatch implements Schedulable {
  
    global void execute(SchedulableContext sc) {
        ToArchiveBatch b= new ToArchiveBatch(); 
        database.executebatch(b,10);
    }
}