global with sharing class QuoteCalculateCallback implements SBQQ.CalculateCallback {
  global void callback(String quoteJSON){
    SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', quoteJSON);       
  }
}