/**************************************************
* Created by: Tom Reed: 2018-12-10
* Tested by: zTest_CSATSurveyAutomation @ 100%
**************************************************/
global class CSATSurveyAutomationScheduled implements schedulable{

    global void execute(SchedulableContext sc){
    CSATSurveyAutomationBatch b = new CSATSurveyAutomationBatch();
      database.executebatch(b, 50);
    }
}