public with sharing class TF_SocietyQuote_UpdateDiscountAD_Trig implements TriggerInterface_SocietyQuote.Runnable {
	public void run(TriggerInterface_SocietyQuote.Trig trig) {
        if(trig.isDelete && trig.isAfter){
            TF_SocietyQuote_Utils.updateSocietyDiscountAmount(trig.oldList);
    	}
    }
}