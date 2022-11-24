/**************************************************
* Created by Jeff Lup for case 14417
* jeff.lup@informausa.com / 941-554-3475
* This is a wrapper class and is called by
*  CASContactSearchExportController
* Modified by Jeff Lup - Case#21910 - 2010.05.11
**************************************************/

public class CASContactSearchExportWrapper {
	//Wrapper class for Contact so I can add extra columns

    public Contact contact { get; set;}
    public String MailingStreetFull { get; set; }    
    public String MailingStreet1 { get; set; }    
    public String MailingStreet2 { get; set; }    
    public String MailingStreet3 { get; set; }    
    public String OtherStreetFull { get; set; }    
    public String OtherStreet1 { get; set; }    
    public String OtherStreet2 { get; set; }    
    public String OtherStreet3 { get; set; }
    public String CleanedAccountName { get; set; }    

    public CASContactSearchExportWrapper(Contact c){
        contact = c;
        CleanedAccountName = c.Account.Name.replaceAll('–','-'); //replace long dash with short dash - Case#21910 - 2010.05.11
        CleanedAccountName = c.Account.Name.replaceAll('ó','o'); //remove accents - Case#21910 - 2010.05.11
        CleanedAccountName = c.Account.Name.replaceAll('á','a'); //remove accents - Case#21910 - 2010.05.11
		if (c.MailingStreet != null) {
	    	MailingStreetFull = c.MailingStreet.replace('\n',', ').replace(',,',',').replace(', ,',',').replace(' ,',','); //remove line feed, replace with a comma, but user may have added their own comma
			List<String> MailingStreetList = c.MailingStreet.replace('\n','|').replace(',|','|').split('\\|',3);
			MailingStreet1 = MailingStreetList[0];
			if (MailingStreetList.size() > 1)
				MailingStreet2 = MailingStreetList[1];
			if (MailingStreetList.size() > 2)
				MailingStreet3 = MailingStreetList[2].replace('|',', ');
    	}
		if (c.OtherStreet != null) {
	    	OtherStreetFull = c.OtherStreet.replace('\n',', ').replace(',,',',').replace(', ,',',').replace(' ,',','); //remove line feed, replace with a comma, but user may have added their own comma
			List<String> OtherStreetList = c.OtherStreet.replace('\n','|').replace(',|','|').split('|',3);
			OtherStreet1 = OtherStreetList[0];
			if (OtherStreetList.size() > 1)
				OtherStreet2 = OtherStreetList[1];
			if (OtherStreetList.size() > 2)
				OtherStreet3 = OtherStreetList[2].replace('|',', ');
    	}
    }
}