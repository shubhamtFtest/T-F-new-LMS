/************************************************************************** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2013-03-26
** 
***************************************************************************/
global class CAS_DeadMesagesQueueSchedule implements Schedulable{
    global void execute(SchedulableContext SC)  
    {  
    	AsyncApexJobAlerts.CAS_DeadMesagesQueue();
         
    }
}