@istest 
public class Test_qfhome {
    @TestSetup 
    static void create_data(){
        Test.startTest();
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        insert form; 
        
        Form__c form1 = new Form__c();
        form1.Name = 'Testdemo';
        form1.Status__c = false;
        form1.Total_Submissions__c = 2;
        insert form1; 
        
        Form__c form2 = new Form__c();
        form2.Name = 'Test2';
        form2.Status__c = true;
        form2.Total_Submissions__c = 2;
        insert form2;
        Test.stopTest();
    }
    @isTest
    static void Test_records(){ 

        Test.startTest();
        
        qfhome.records();

        Test.stopTest();
    }

    @isTest
    static void Test_status(){ 
        Test.startTest();

        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test' LIMIT 1];
        Form__c form_data1 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Testdemo' LIMIT 1];

        qfhome.status(form_data1.Id,'test');
        qfhome.status(form_data1.Id,'');
        
        Test.stopTest();
    }

    @isTest
    static void Test_deleteform(){ 
        Test.startTest();

        Form__c form_data = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test' LIMIT 1];
        Form__c form_data1 = [SELECT ID,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Testdemo' LIMIT 1];

        qfhome.deleteform(form_data1.Id,'testefew');
        qfhome.deleteform(form_data.Id,'');

        Test.stopTest();        
    }
            
}