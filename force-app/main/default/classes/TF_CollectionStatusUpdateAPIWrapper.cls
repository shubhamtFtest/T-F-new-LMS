//Test Class-Ztest_TF_ColStatusUpdateAPIWrapper
public class TF_CollectionStatusUpdateAPIWrapper {
public class Messages {
		public String code {get;set;} 
		public String description {get;set;} 
		public String dataPath {get;set;} 

			}
	
	public Metadata metadata {get;set;} 
	public Data data {get;set;} 

		
	public class Metadata {
		public String status {get;set;} 
		public String transactionId {get;set;} 
		public String id {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String transactionDate {get;set;} 
		public List<Messages> messages {get;set;} 
        public List<String> isPartOf{get;set;}

			}
	
	public class Collection {
		public String version {get;set;} 
		public String status {get;set;} 

			}
	
	public class Data {
		public String id {get;set;} 
		public String type_Z {get;set;} // in json: type
		public Identifiers identifiers {get;set;} 
		public Collection collection {get;set;} 

		
	}
	
	public class Identifiers {
		public String doi {get;set;} 
		public String sku {get;set;} 
		public String collectionId {get;set;} 

			}
}