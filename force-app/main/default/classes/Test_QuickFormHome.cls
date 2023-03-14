@istest
public class Test_QuickFormHome {
    
    @TestSetup
    static void create_record(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        form.Mapped_Objects__c = '';
        form.Form_Styling__c = 'demo:0;test:1;check:3';
        form.FormBgID__c = 'test';
        form.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form;

        
        Form__c form1 = new Form__c();
        form1.Name = 'Test2';
        form1.Status__c = false;
        form1.Total_Submissions__c = 3;
        insert form1;
    }

    @istest
    Static void Test_getFormRecords(){ 
        Test.startTest();
        QuickFormHome q = new QuickFormHome();
        q.urlvalue = '';
        QuickFormHome.formid = '';
        QuickFormHome.getFormRecords();
        
        Test.stopTest();

    }

    @istest
    Static void Test_searchForms(){ 
        Test.startTest();
    
        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        
        QuickFormHome.searchForms(form_data.Name);
        
        Test.stopTest();

    }

    @istest
    Static void Test_getFormsByStatus(){ 
        Test.startTest();
    
        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c form_data1 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        
        QuickFormHome.getFormsByStatus(form_data.ID,'Test');
        QuickFormHome.getFormsByStatus(form_data1.ID,'Test');
        
        Test.stopTest();

    }

    @istest
    Static void Test_deleteFormRecord(){ 
        Test.startTest();
    
        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c form_data1 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        
        QuickFormHome.deleteFormRecord(form_data.ID,'Test');
        QuickFormHome.deleteFormRecord(form_data.ID,'Test');
        
        Test.stopTest();

    }

    @istest
    Static void Test_renameFormRecord(){ 
        Test.startTest();
    
        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test' LIMIT 1];
        Form__c form_data1 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__C WHERE Name = 'Test2' LIMIT 1];
        
        QuickFormHome.renameFormRecord(form_data1.ID,form_data.Name,'Test');
        QuickFormHome.renameFormRecord(form_data.ID,form_data.Name,'Test');

        Test.stopTest();

    }       

    @isTest
    static void Test_sendemail(){ 
        Test.startTest();

        QuickFormHome.sendemail('Test', 'test@gmail.com', 'subject', 'body');
        
        Test.stopTest();
    }

    @IsTest
    static void Test_f_Get_Types(){
    
        Test.startTest();

        QuickFormHome.f_Get_Types();
        
        Test.stopTest();
    
    }
    @IsTest 
    static void Test_Get_Captcha_Types(){
        Test.startTest();

        QuickFormHome.Get_Captcha_Types(); 
        
        Test.stopTest();
    }

    @IsTest 
    static void Test_siteUrl(){
        Test.startTest();
        
        Form__c form_data2 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test2' LIMIT 1];

        QuickFormHome.siteUrl(form_data2.id);
        
        Test.stopTest();
    }

    @IsTest 
    static void Test_getProgressindicator(){
        Test.startTest();

        QuickFormHome.getProgressindicator();
        
        Test.stopTest();
    }

    @IsTest 
    static void Test_getCaptchatype(){
        Test.startTest();

        QuickFormHome.getCaptchatype(); 
        
        Test.stopTest();
    }
    

}