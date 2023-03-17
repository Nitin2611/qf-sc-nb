@isTest
public class Test_PDFGeneratorController {
    @TestSetup
    static void Test_data(){
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Mapped_Objects__c = 'Account,Contact,Opportunity';
        insert form; 

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 1;
        pageno.Form__c = form.ID;
        insert pageno;
        
        Form_Page__c pageno1 = new Form_Page__c();
        pageno1.Name = 'Test';
        pageno1.Page_Number__c = 2;
        pageno1.Form__c = form.ID;
        insert pageno1;

        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'QFSIGNATURE';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 1;
        insert field;

        Form_Fields__c field1 = new Form_Fields__c();
        field1.Name = 'QFFILEUPLOAD';
        field1.Form__c = form.ID;
        field1.Form_Page__c = pageno.ID;
        field1.Field_Order__c = 2;
        insert field1;

        Form_Fields__c field2 = new Form_Fields__c();
        field2.Name = 'fefefewdff';
        field2.Form__c = form.ID;
        field2.Form_Page__c = pageno.ID;
        field2.Field_Order__c = 2;
        insert field2;

        Account a = new Account();
        a.Name = 'test';
        insert a;

        Contact c =  new Contact();
        c.LastName = 'Test';
        c.AccountId = a.Id;
        insert c;

        Case cs = new Case();
        cs.Status = 'New';
        cs.AccountId = a.Id;
        cs.ContactId = c.Id;

        Form_Submission__c sub = new Form_Submission__c();
        sub.Name = 'Test Sub';
        sub.Form__c = form.ID;
        sub.First_object_data__c  = '{"sobjectType":"Account","Name":"Testing"}';
        sub.Second_object_data__C  = '{"sobjectType":"Contact","LastName":"Test"}';
        sub.Third_object_data__C  = '{"sobjectType":"Case","Status":"New"}';
        sub.Other_fields_data__c = '{"sobjectType":"Form_c","'+field.Id+'":"'+field.Name+'","'+field1.ID+'":"'+field1.Name+'","'+field2.ID+'":"'+field2.Name+'"}';
        insert sub;

        
    }
    
    @isTest
    static void Test_getPagesOfForm(){
        
        Form_Submission__c sub = [SELECT id FROM Form_Submission__c WHERE Name = 'Test sub'];        

        Pagereference page = Page.PreViewForm;
        Test.setCurrentPage(page);
        page.getParameters().put('id',sub.id);

        PDFGeneratorController pdf = new PDFGeneratorController();
        pdf.getPagesOfForm();
        
    }
}