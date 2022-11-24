//This class is created for scheduling batch class : TF_LicenseStaticBatch
//Test class - zTEST_TF_LicenseStaticBatch_Schedule

global class TF_LicenseStaticBatch_Schedule implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
       TF_LicenseStaticBatch b = new TF_LicenseStaticBatch();
       Database.executebatch(b);
   }   
}