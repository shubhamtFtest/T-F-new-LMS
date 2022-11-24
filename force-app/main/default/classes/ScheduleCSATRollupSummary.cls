//Creted by Ashish Purwar on 05-03-2018
//This class is scheduler class for BatchCSATRollupSummary
global class ScheduleCSATRollupSummary implements Schedulable{
    global void execute(SchedulableContext SC) {             
        database.executeBatch(new BatchCSATRollupSummary(),200);           
    }
}