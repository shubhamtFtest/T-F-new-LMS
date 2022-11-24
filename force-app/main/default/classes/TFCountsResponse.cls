public class TFCountsResponse {

	public class Counts {
		public String type_Z {get;set;} // in json: type
		public Integer count {get;set;} 
		
	}
    
    public class Prices {
		public String priceType {get;set;} 
		public String price {get;set;} 
        public String X_currency {get;set;} //in json:currency
        public String priceTypeCode {get;set;} 
		
	}
	
	public Metadata metadata {get;set;}	
	
	public class Metadata {
		public List<Counts> counts {get;set;}
        public List<Prices> prices {get;set;}		
		
	}
    
    
	
}