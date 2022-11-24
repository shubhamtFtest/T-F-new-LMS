public Class TF_CheckRecursive{
    private static boolean run1 = true;
    private static boolean run2 = true;
    private static boolean run3 = true;
    private static boolean run4 = true;
    private static boolean run5 = true;
    
    public static boolean runOnce1(){
       if(run1){
          run1=false;
          return true;
       }
       else{
          return run1;
       }
    }
    
    public static boolean runOnce2(){
       if(run2){
          run2=false;
          return true;
       }
       else{
          return run2;
       }
    }
    
    public static boolean runOnce3(){
       if(run3){
          run3=false;
          return true;
       }
       else{
          return run3;
       }
    }
    
    public static boolean runOnce4(){
       if(run4){
          run4=false;
          return true;
       }
       else{
          return run4;
       }
    }
    
    public static boolean runOnce5(){
       if(run5){
          run5=false;
          return true;
       }
       else{
          return run5;
       }
    }
}