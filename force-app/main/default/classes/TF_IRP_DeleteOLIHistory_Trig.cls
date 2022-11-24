public with sharing class TF_IRP_DeleteOLIHistory_Trig implements TriggerInterface_OLI.Runnable {
	public void run(TriggerInterface_OLI.Trig trig) {
        if(trig.isDelete && trig.isAfter){
            TF_IRPOLIHistory_Utils.deleteOLIHistoryRecords(trig.oldList); //trig.oldList
    	}
    }
}