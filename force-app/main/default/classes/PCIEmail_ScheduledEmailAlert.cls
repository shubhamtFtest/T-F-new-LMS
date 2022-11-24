/************************************************************************** 
** 
** Last Modified by Shay Spoonmore (shay.spoonmore@informausa.com)2012-02-14
**   
***************************************************************************/ 

global class PCIEmail_ScheduledEmailAlert implements Schedulable{
    global void execute(SchedulableContext SC)  
    {  
        //Setup to Schedule
        PCIEmail pciEmail = new PCIEmail();
		pciEmail.GetPCIPending(); 
        
    }
}