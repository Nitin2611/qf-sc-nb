@istest
public class Test_qfthankyou {
    @TestSetup
    static void create_record(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        insert form; 
        
        Thankyou_Page__c th = new Thankyou_Page__c();
        th.Name = 'Test';
        th.Form__c = form.Id;
        th.Thank_you_URL__c = '';
        th.ThankYou_Label__c = 'hi thsi data';
        th.Thankyou_Page_Type__c = 'Show Text';
        th.Thankyou_Text__c = 'data text';
        insert th;

    }
    @isTest
    static void Test_getthankyoupage(){
        Test.startTest();

        Form__c form_data = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c Thankyou_data = [SELECT ID,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: form_data.ID];
		
        string form_id = null;
        qfthankyou.getthankyoupage(form_data.ID);
        qfthankyou.getthankyoupage(form_id);
        qfthankyou.getthankyoupage(Thankyou_data.ID);
       
        Test.stopTest();
    }
        
    @istest 
    static void Test_insertrecord(){
        Test.StartTest();

        Form__c form_data = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c Thankyou_data = [SELECT ID,Name,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: form_data.ID];

        qfthankyou.insertrecord(Thankyou_data.Name,Thankyou_data.Thankyou_Page_Type__c,Thankyou_data.ThankYou_Label__c,Thankyou_data.Thankyou_Text__c,Thankyou_data.Form__c,Thankyou_data.Thank_you_URL__c,Thankyou_data.Id);
        
        qfthankyou.insertrecord('thank you','show Text','','vcrvvrvrv',Thankyou_data.ID,'',form_data.ID);
        
        Test.stopTest();
    }
     
    @istest 
    static void Test_getrecordslist(){
        Test.StartTest();
        
        Form__c form_data = [SELECT ID,Name,Status__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Thankyou_Page__c Thankyou_data = [SELECT ID,Thankyou_Page_Type__c,ThankYou_Label__c,Thankyou_Text__c,Thank_you_URL__c,Form__c FROM Thankyou_Page__C WHERE Form__C =: form_data.ID];
 		String id = null;
        
        qfthankyou.getrecordslist(form_data.Id);
        qfthankyou.getrecordslist(id);
        
        Test.stopTest();
    }
        

}