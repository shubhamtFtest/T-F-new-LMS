/***************************************************************************
* Created by: Tom Reed, 2019.04.02
* Tested By: zTest_OmniChannel @100%
* Description: Class created to run the Omni Channel logic if a user is logging into Omni Channel.
* **************************************************************************/
public class OmniChannelUSPTrigClass implements TriggerInterface_UserServicePresence.Runnable{
    
    public void run(TriggerInterface_UserServicePresence.Trig trig) {
        for(UserServicePresence usp: Trig.NewList){  
            if(usp.IsAway==false){
        OmniChannelRouting.runOmniChannel();
            }
        }
    }
}