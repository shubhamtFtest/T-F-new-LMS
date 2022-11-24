public class TFContentValidationResp {
    
	public String topic {get;set;}
	public String source {get;set;}
	public String application {get;set;}
	public String timestamp {get;set;}
	public List<Responses> responses {get;set;}

	public class Targets {
		public String value {get;set;}
		public String uuid {get;set;}
		public String result {get;set;}
		public String error {get;set;}
	}

	public class Responses {
		public String keyType {get;set;}
		public List<Targets> targets {get;set;}
	}
}