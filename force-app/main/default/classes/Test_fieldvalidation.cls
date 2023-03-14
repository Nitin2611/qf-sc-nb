@istest
public class Test_fieldvalidation {
    @TestSetup
    static void Test_classData_add(){
         Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        form.Mapped_Objects__c = 'text,data,demo';
        form.Form_Styling__c = 'demo:0;test:1;check:3';
        form.FormBgID__c = 'test';
        form.Page_CSS__C = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-image:"test.png";background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        insert form;

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 4;
        pageno.Form__c = form.ID;
        insert pageno;
        
        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'Test,dferf,feerf';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 10;
        field.Field_Validations__c = 'isRequired<!@!>false?$`~isDisabled<!@!>false?$`~isLabel<!@!>true?$`~isHelpText<!@!>false?$`~Label<!@!>ShippingAddress?$`~HelpText<!@!>?$`~isPlaceholder<!@!>false?$`~Placeholder<!@!>?$`~Minimum<!@!>0?$`~Maximum<!@!>128?$`~isPrefix<!@!>false?$`~Prefix<!@!>?$`~Decimal<!@!>?$`~Richtext<!@!>?$`~MinimumTime<!@!>?$`~MaximumTime<!@!>?$`~MinimumDateTime<!@!>?$`~MaximumDateTime<!@!>?$`~MinimumDate<!@!>?$`~MaximumDate<!@!>?$`~Salutation<!@!>'; 
        insert field;
    }

    @isTest
    static void getfieldvalidation_method(){
        
        Test.startTest();
        
        Form__C form_data = [SELECT ID,Name,Status__c,Total_Submissions__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfield_data = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: form_data.Id ];
        
        fieldvalidation fi = new fieldvalidation();
        
        fieldvalidation.getfieldvalidation(formfield_data.ID);
        fieldvalidation.getfieldvalidation(form_data.ID);

        Test.stopTest();
    }

    @IsTest
    static void deletefield_method(){
        Test.startTest();
        
        Form__C form_data = [SELECT ID,Name,Status__c,Total_Submissions__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Page__c formpage_data = [SELECT ID,Name,Page_Number__c, Form__c FROM Form_Page__c WHERE Form__c =: form_data.Id];
        Form_Fields__c formfield_data = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: form_data.Id ];
        
        fieldvalidation.deletefield(formfield_data.ID);
        fieldvalidation.deletefield(formpage_data.ID);

        Test.stopTest();
    }

    @IsTest
    static void savevalidation_method(){
        Test.startTest();
        
        Form__C form_data = [SELECT ID,Name,Status__c,Total_Submissions__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfield_data = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: form_data.Id ];
        
        fieldvalidation.savevalidation(formfield_data.ID,formfield_data.Field_Validations__c,'test');
        fieldvalidation.savevalidation(form_data.ID,form_data.Form_Styling__c,'test');

        Test.stopTest();
    }

    @IsTest
    static void copyfield_method(){
        Test.startTest();
        
        Form__C form_data = [SELECT ID,Name,Status__c,Total_Submissions__c, Mapped_Objects__c , Form_Styling__c, FormBgID__c,Page_CSS__C FROM Form__c WHERE Name = 'Test' Limit 1];
        Form_Fields__c formfield_data = [SELECT ID,Name,Form__c, Form_Page__C, Field_Order__c,Field_Validations__c FROM Form_Fields__c WHERE Form__c =: form_data.Id ];
        
        fieldvalidation.copyfield(formfield_data.ID);
        fieldvalidation.copyfield(form_data.ID);

        Test.stopTest();
    }
}