@isTest
private class TF_BatchCaseUpdate_Test{
  static testmethod void Test1(){
   
  case c = new case ();
   c.Status = 'New';
   c.origin = 'Web';
   c.Subject = 'Test';
  insert c;

  
    list<EmailMessage> ec = New list<EmailMessage>();
      for(integer i=0;i<=10;i++)
      {
          
   ec.add(new EmailMessage(Incoming = True, Status = '0',parentid=c.id));
   ec.add(new EmailMessage(Incoming = false, Status = '3',parentid=c.id));
  
      }  
   Insert ec;
   
       test.startTest();

       TF_BatchCaseUpdate obj01 = new TF_BatchCaseUpdate();
  Database.executeBatch(obj01, 20);
  test.stopTest();



  }
    

   

}