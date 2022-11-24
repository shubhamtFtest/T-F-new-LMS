public with sharing class TF_SocietyQuote_UpdateDiscountAIUU_Trig implements TriggerInterface_SocietyQuote.Runnable {
	public void run(TriggerInterface_SocietyQuote.Trig trig) {
        if((trig.isInsert && trig.isAfter) || (trig.isUpdate && trig.isAfter) || (trig.isUndelete && trig.isAfter)){
            TF_SocietyQuote_Utils.updateSocietyDiscountAmount(trig.newList);
    	}
    }
}