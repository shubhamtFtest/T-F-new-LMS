@isTest
public class ztest_TFCountsResponse {
    TFCountsResponse.Metadata mt =new TFCountsResponse.Metadata();
    
    private static testmethod void testCounts(){        
        TFCountsResponse.Counts cont = new TFCountsResponse.Counts();
        cont.type_Z='TestName@gmail.com';
        cont.count=6;        
    }
    
    private static testmethod void testPrices(){        
        TFCountsResponse.Prices cont = new TFCountsResponse.Prices();
        cont.priceType='TestName@gmail.com';
        cont.price='44.00';
        cont.X_currency='GBP';
        cont.priceTypeCode='BYO';        
    }
    
    private static testmethod void testMetadata(){        
        TFCountsResponse.Metadata met = new TFCountsResponse.Metadata();
        
        List<TFCountsResponse.Prices> pcs = new List<TFCountsResponse.Prices>();
        List<TFCountsResponse.Counts> cont = new List<TFCountsResponse.Counts>();
        
        TFCountsResponse.Counts ct = new TFCountsResponse.Counts();
        ct.type_Z='TestName@gmail.com';
        ct.count=6;         
        cont.add(ct);
        
        TFCountsResponse.Prices pc = new TFCountsResponse.Prices();
        pc.priceType='TestName@gmail.com';
        pc.price='44.00';
        pc.X_currency='GBP';
        pc.priceTypeCode='BYO';
        pcs.add(pc);
        
        met.Counts=cont;
        met.Prices=pcs;
        
        
        
        
    }

}