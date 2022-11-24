/***************************************************************************
* Created by: Piyush Jain, 2019.10.14
* Tested By:
* Description: Schedule and execute a Batch class to Retry Order creation.
* NOTE: Although bulkified in most places this class is designed as per Order hub and Order Item is created with ISBN for product
* Extensive testing is needed if the code is to be completely bulkified in future.
* **************************************************************************/

global class OrderApiRetryBatch_Schedule implements Schedulable{
    
    // ----- execute method to call and Schedule Batch class  ------
    global void execute(SchedulableContext sc) {
        OrderApiRetryBatch b = new OrderApiRetryBatch(); 
        database.executebatch(b,1);
    }
    
}