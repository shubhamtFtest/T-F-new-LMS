/**************************************************
* Created by: Tom Reed: 2019-01-30
* Tested by: zTest_ProductAPI @100%
**************************************************/
global class SheduleProductAPIReRunErrorsBatch implements Schedulable {
  
    global void execute(SchedulableContext sc) {
        ProductAPIReRunErrorsBatch b = new ProductAPIReRunErrorsBatch(); 
        database.executebatch(b,1);
    }
}