@istest
public class Test_qf_guide2_Controller {

    @istest
    static void Test_getSites(){
        qf_guide2_Controller.getSites();
    }
    
    @istest(SeeAllData=true) 
    static void Test_saveSecureUrl(){
        
        Site s = [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status FROM Site Limit 1] ;
            SiteDetail sd = [SELECT ID,DurableId FROM SiteDetail WHERE DurableId =:  s.ID];
            qf_guide2_Controller.saveSecureUrl(s.ID);
            qf_guide2_Controller.saveSecureUrl(sd.ID);
    }
    
    @istest 
    static void Test_getSettingData(){
        qf_guide2_Controller.getSettingData();
   
    }
    
    @istest 
    static void Test_getSitePrefixes(){
        qf_guide2_Controller.getSitePrefixes();

    }
}