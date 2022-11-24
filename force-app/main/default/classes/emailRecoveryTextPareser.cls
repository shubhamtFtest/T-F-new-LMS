public class emailRecoveryTextPareser {
    public string BccAddress='',CcAddress='',FromAddress='',FromName='',Headers='',TextBody='',Status='',ToAddress='',Subject='' ,HtmlBody = '';
    public boolean Incoming;
    public datetime MessageDate;
    public list<id> attachment_ids;
    public String ParentId , RelatedToId ;
    
    public emailRecoveryTextPareser(string mail_text){
        list<string>str =   mail_text.split('#%#'); 
        
        BccAddress= str[1]; 
        BccAddress=BccAddress.remove('BccAddress=');
        BccAddress= (BccAddress=='null'? '' : BccAddress);
        
        CcAddress= str[2];
        CcAddress=CcAddress.remove('CcAddress=');
        CcAddress=(CcAddress=='null'? '' : CcAddress);
        
        FromAddress = str[3];
        FromAddress=FromAddress.remove('FromAddress=');
        FromAddress=(FromAddress=='null'? '' : FromAddress);
        
        FromName=str[4];
        FromName=FromName.remove('FromName=');
        FromName=(FromName=='null'? '' : FromName);
        
        Headers=str[5];
        Headers=Headers.remove('Headers=');
        
        string tst = str[6];
        Incoming = boolean.valueOf(tst.remove('Incoming='));
        
        
        string dt = str[7];
        MessageDate= datetime.valueOf(dt.remove('MessageDate='));
        
        
        TextBody = str[8];
        TextBody=TextBody.remove('TextBody=');
        TextBody=(TextBody=='null'? '' : TextBody);

        HtmlBody = str[9];
        HtmlBody=HtmlBody.remove('HtmlBody=');
        HtmlBody=(HtmlBody=='null'? '' : HtmlBody);
        
        string Parti = str[10];
        ParentId=Parti.remove('ParentId=');
        
        string Rarti = str[11];
        RelatedToId=Rarti.remove('RelatedToId=');
        RelatedToId=(RelatedToId=='null'? '' : RelatedToId);
        
        Status = str[12];
        Status=Status.remove('Status=');
        
        ToAddress = str[13];
        ToAddress=ToAddress.remove('ToAddress=');
        ToAddress=(ToAddress=='null'? '' : ToAddress);
        
        Subject = str[14];
        Subject = Subject.remove('Subject=');
        Subject=(Subject=='null'? '' : Subject);
        
        string attid = str[15];
        attid = attid.remove('Attachment=');
        
        attachment_ids = attid.split('#;#');
        attachment_ids.remove(0);
        
          
        
        // system.debug('################'+str);
        
    }
}