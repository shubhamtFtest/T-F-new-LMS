global class ScheduleOppRenewalReminder implements Schedulable {
    global void execute(SchedulableContext SC) {
        BatchOppRenewalReminder batch = new BatchOppRenewalReminder();
        if(!Test.isRunningTest()){
            database.executeBatch(batch);    
        }
    }
}