public class TFRuleBasedSearchResponseDocument {

	public class Prices {
		public String price {get;set;} 
		public String X_currency {get;set;} 
		public String validFrom {get;set;} 
		public String priceType {get;set;} 
		public String priceTypeCode {get;set;} 
		
	}
	
	public class Counts {
		public String x_id {get;set;} // in json: _id
		public Integer count {get;set;} 
		public String type_Z {get;set;} // in json: type	
	
	}
	
	public Metadata metadata {get;set;} 
	public List<Data> data {get;set;} 

	
	
	public class Query {
		public Integer offset {get;set;} 
		public Integer limit_Z {get;set;} // in json: limit
		public String type_Z {get;set;} // in json: type		
	}
	
	public class Contributors_Z {
		public List<String> roles {get;set;} 
		public String givenName {get;set;} 
		public String familyName {get;set;} 
		public String email {get;set;} 
		public String bio {get;set;} 
		public String orcid {get;set;} 
		public List<Affiliation> affiliation {get;set;} 
		public String collab {get;set;} 
		public String fullName {get;set;} 
		public Integer position {get;set;} 		
	}
	
	public class Contributors {
		public List<String> roles {get;set;} 
		public String givenName {get;set;} 
		public String familyName {get;set;} 
		public String email {get;set;} 
		public String bio {get;set;} 
		public String orcid {get;set;} 
		public List<Affiliation> affiliation {get;set;} 
		public String collab {get;set;} 
		public String fullName {get;set;} 
		public Integer position {get;set;} 		
	}
	
	public class Metadata {
		public String application {get;set;} 
        public List<Counts> counts {get;set;} 
        public List<Prices> prices {get;set;} 
        public Boolean isFromCache {get;set;} 
        public Integer limit_Z {get;set;} // in json: limit
		public Integer offset {get;set;} 
		public Query query {get;set;} 
		public String type_Z {get;set;} // in json: type		
	}
	
	public class Data {
		public String id_Y {get;set;} // in json: @id
		public String type_W {get;set;} // in json: @type
		public String format {get;set;} 
		public List<Prices> prices {get;set;} 
		public String publicationDate {get;set;} 
		public String subtitle {get;set;} 
		public String title {get;set;} 
        public String doi {get;set;}
        public String isbn {get;set;}
        public String publisherImprint {get;set;}
		public List<Contributors> contributors {get;set;} 
		
	}
	
	public class Affiliation {

	
	}	
	
}