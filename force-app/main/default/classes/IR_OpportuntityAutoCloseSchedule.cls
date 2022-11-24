/**************************************************
* Created by Amit Kumar 
* Tested By zTest_IR_OpportuntityAutoCloseSchedule
**************************************************/
global class IR_OpportuntityAutoCloseSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new IR_OpportuntityAutoCloseBatch());
    }
}