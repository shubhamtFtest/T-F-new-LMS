/**
   Author : shashank
   Test class : zTestTF_ubxSelfServiceOrderSchduled
   Description : This class is scheduled to process opportunities & opportunity line items coming from order Hub for different channels.
   Changes :  self chaining new approch 

 */
global class TF_OhOrderTypeSpecSchdlChain implements Schedulable  {
    private String channel;
    private String stProductId;

    global TF_OhOrderTypeSpecSchdlChain(String channelPassed, String stProductIdPassed){
        System.debug(' TF_OhOrderTypeSpecSchdlChain -channelPassed-'+channelPassed);
        this.channel = channelPassed.toUpperCase();
        this.stProductId = stProductIdPassed;
    }
 
    global void execute(SchedulableContext sc) {

        System.debug('TF_OhOrderTypeSpecSchdlChain execute ');
        System.debug('channel-'+channel );
        System.debug('stProductId-'+stProductId );
        if (Limits.getLimitQueueableJobs() >0 && !Test.isRunningTest()) {
            System.debug('specific sch - chanl-'+channel );
            // public TF_OhIntQueueableChain(String channelPassed, String stProductIdPassed ,integer currentPageNo, integer totalPages ,Boolean downTime){
            // downtime will be processed only after past days are processed    
            System.enqueueJob( new TF_OhIntQueueableChain(channel, stProductId, 0,NULL,False ) );
        }else {
            TF_OhIntclneChain TF_OhIntclneChainObj = new TF_OhIntclneChain();
            TF_OhIntclneChainObj.sendEmail( 'Queueable jobs limit exceeded', true,'No data' );
        }
    }

}