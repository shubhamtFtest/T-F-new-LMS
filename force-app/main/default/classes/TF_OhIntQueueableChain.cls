/**
   Author : shashank
   Test class : zTestTF_ubxSelfServiceOrderSchduled
   Description : This class is scheduled to process opportunities & opportunity line items coming from order Hub for different channels.
   Changes :  self chaining new approch 

 */

public class TF_OhIntQueueableChain implements Queueable,Database.AllowsCallouts {
private String channel;
private String stProductId; 
Integer currentPageNo, totalPages ;
Boolean downTime;

public TF_OhIntQueueableChain(String channelPassed, String stProductIdPassed ,integer currentPageNo, integer totalPages ,Boolean downTime){
	System.debug('channelPassed-'+channelPassed);
	this.channel = channelPassed;
	this.stProductId = stProductIdPassed;
	this.currentPageNo = currentPageNo;
	this.totalPages = totalPages;
	this.downTime = downTime;

}
public void execute(QueueableContext context) {
	System.debug('channel- '+channel);
	System.debug('stProductId- '+stProductId);
	TF_OhIntclneChain obj = new TF_OhIntclneChain(channel, stProductId, currentPageNo,  totalPages , downTime);
	obj.execute();
}
}