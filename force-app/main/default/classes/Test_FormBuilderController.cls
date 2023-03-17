@istest 
public class Test_FormBuilderController {
    @TestSetup 
    static void create_data(){
            
        Test.startTest();
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;

        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;        
        form.Mapped_Objects__c = 'text,data,demo';
        form.Form_Styling__c = 'color:red;background-image:test.pdf';
        form.Page_CSS__C = 'color:red;background-image:"test.png";padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form.PageBgID__c = cv.Id;
        form.FormBgID__c = cv.Id;
        insert form;

        Form__c form1 = new Form__c();
        form1.Name = 'Test2';
        form1.Status__c = true;        
        form1.Mapped_Objects__c = 'Account,Contact,Case';
        form1.FormBgID__c = 'test';
        form.Form_Styling__c = 'color:red;background-image:test.pdf';
        form1.Button_CSS__c = 'color';
        form1.Label_CSS__c = 'color:red';
        form1.All_Field_Styling__c = 'color:red';
        form1.All_Field_Hover__c = 'color:red';
        form1.All_Field_Focus__c = 'size:13px';
        form1.Page_CSS__C = 'background-image:"test.png";padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:solid;border-width:1px;border-radius:0px;';
        form1.PageBgID__c = cv.Id;
        insert form1;

        Form__c form2 = new Form__c();
        form2.Name = 'Test3';
        form2.Status__c = true;        
        form2.Mapped_Objects__c = 'Account,Contact,Case';
        form2.FormBgID__c = 'test';
        form2.Form_Styling__c = 'background-image:test.pdf';
        form2.Button_CSS__c = 'color:red';
        form2.Label_CSS__c = 'color:red';
        form2.All_Field_Styling__c = 'color:red';
        form2.All_Field_Hover__c = 'color:red';
        form2.All_Field_Focus__c = 'size:13px';
        form2.PageBgID__c = cv.Id;
        insert form2;

        Form_Page__c pageno = new Form_Page__c();
        pageno.Name = 'Test';
        pageno.Page_Number__c = 4;
        pageno.Form__c = form.ID;
        insert pageno;
        
        Form_Fields__c field = new Form_Fields__c();
        field.Name = 'Test,dferf,feerf';
        field.Form__c = form.ID;
        field.Form_Page__c = pageno.ID;
        field.Field_Order__c = 3;
        insert field;

        Form_Fields__c field1 = new Form_Fields__c();
        field1.Name = 'Test2,dferf,feerf';
        field1.Form__c = form.ID;
        field1.Form_Page__c = pageno.ID;
        field1.Field_Order__c = 1;
        insert field1;
        
        Form_Fields__c field2 = new Form_Fields__c();
        field2.Name = 'Test3,dferf,feerf';
        field2.Form__c = form.ID;
        field2.Form_Page__c = pageno.ID;
        field2.Field_Order__c = 2;
        insert field2;

        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;
        insert sub;

        Test.stopTest();

    }

    @isTest
    static void Test_GetFieldsMetaData(){ 

        Test.startTest();

        FormBuilderController.GetFieldsMetaData();
        
        Test.stopTest();
    }
    @isTest
    static void Test_GetStyles(){ 

        Test.startTest();

        FormBuilderController.GetStyles();
        
        Test.stopTest();
    }
    @isTest
    static void Test_getFields(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.getFields(form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.getFields(form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.getFields(form2.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_UploadFormImage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];

        FormBuilderController.UploadFormImage(form.ID,'testData','Test','Test_Type');
        FormBuilderController.UploadFormImage(form1.ID,'testData','Test','Test_Type');
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.UploadPageImage(form2.ID,'testData','Test','Test_Type');

        Test.stopTest();
    }
    @isTest
    static void Test_UploadPageImage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];

        FormBuilderController.UploadPageImage(form.ID,'testData','Test','Test_Type');
        FormBuilderController.UploadPageImage(form1.ID,'testData','Test','Test_Type');

        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.UploadPageImage(form2.ID,'testData','Test','Test_Type');
        Test.stopTest();
    }
    @isTest
    static void Test_RemoveFormImage(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,PageBgID__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
 
        FormBuilderController.RemoveFormImage(form.ID);
        
        Test.stopTest();
    }
    
    @isTest
    static void Test_RemovePageImage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,PageBgID__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.RemovePageImage(form.ID);
        
        Test.stopTest();
    }
    
    @isTest
    static void Test_StoreBtnStyles(){ 
        
        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreBtnStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreBtnStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreBtnStyles('color:red;',form2.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_StoreBtnposition(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreBtnposition('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreBtnposition('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreBtnposition('color:red;',form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_StoreLabelStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreLabelStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreLabelStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreLabelStyles('color:red;',form2.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_StoreFormStyles(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreFormStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreFormStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreFormStyles('color:red;',form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_StorePageStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StorePageStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StorePageStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StorePageStyles('color:red;',form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_StoreStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreStyles('color:red;',form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_getBGImages(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.getBGImages(form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.getBGImages(form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.getBGImages(form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_StoreHoverStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreHoverStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreHoverStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreHoverStyles('color:red;',form2.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_StoreFocusStyles(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.StoreFocusStyles('color:red;',form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.StoreFocusStyles('color:red;',form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.StoreFocusStyles('color:red;',form2.ID);

        Test.stopTest();
    }
    @isTest
    static void Test_formdetails(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.formdetails(form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.formdetails(form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.formdetails(form2.ID);        
        Test.stopTest();
    }
    @isTest
    static void Test_getcaptcha(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.getcaptcha(form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.getcaptcha(form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.getcaptcha(form2.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_GetFormPage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        FormBuilderController.GetFormPage(form.ID);
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        FormBuilderController.GetFormPage(form1.ID);
        Form__c form2 = [SELECT ID,Name,Status__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test3'];
        FormBuilderController.GetFormPage(form2.ID);
        
        
        Test.stopTest();
    }
    @isTest
    static void Test_getScaleRating(){ 

        Test.startTest();
        
        FormBuilderController.getScaleRating();
        
        Test.stopTest();
    }
    @isTest
    static void Test_CreateFieldRecord(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.CreateFieldRecord(form.ID,field.ID,pageno.ID,2,true,field.ID);
        FormBuilderController.CreateFieldRecord(form.ID,pageno.ID,field.ID,2,false,field.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_addPageBreak(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.addPageBreak(form.ID,'test_name',pageno.ID,3,field.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_ObjName(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        FormBuilderController.ObjName(form.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_getFieldsRecords(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        FormBuilderController.getFieldsRecords(form.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_reOrderField(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field1 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Fields__c field2 = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.reOrderField(field.ID,field2.ID,pageno.ID);
        FormBuilderController.reOrderField(field.ID,field1.ID,pageno.ID);
        FormBuilderController.reOrderField(field2.ID,field1.ID,pageno.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_createPage(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        FormBuilderController.createPage(20,form.Id,'test_pagename',2);
        FormBuilderController.createPage(5,form.Id,'test_pagename',10);
        
        Test.stopTest();
    }
    @isTest
    static void Test_updatePage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.updatePage(form.ID,pageno.ID,'test',5);
        
        Test.stopTest();
    }
    @isTest
    static void Test_renameform(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.renameform(pageno.id,'test_renameform',form.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_renameMainform(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];

        FormBuilderController.renameMainform('Testmain',form.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_deletePage(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form__c form1 = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test2'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.deletePage(form.id,pageno.id);
        FormBuilderController.deletePage(form1.id,pageno.id);
        
        Test.stopTest();
    }
    @isTest
    static void Test_pageDetails(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
        
        FormBuilderController.pageDetails(form.ID,pageno.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_editFormSubmit(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];

        FormBuilderController.editFormSubmit(form.id,'testdemo','Page Count','Normal Captcha');
        FormBuilderController.editFormSubmit(form.id,'testdemo','None','None');

        Test.stopTest();
    }
    @isTest
    static void Test_getreferencevalue(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE Form__c =: form.Id LIMIT 1];
        FormBuilderController.getreferencevalue(field.id,'testdemo');
        FormBuilderController.getreferencevalue(form.id,'testdemo');
    
        Test.stopTest();
    }
    @isTest
    static void Test_getpicklistvalue(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        
        FormBuilderController.getpicklistvalue(field.id);
    
        Test.stopTest();
    }
    @isTest
    static void Test_signatureSave(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];

        FormBuilderController.signatureSave(field.id,'testdemo');
    
        Test.stopTest();
    }
    @isTest
    static void Test_SaveFile(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];

        FormBuilderController.SaveFile(field.id,'testdemo','None','None');
        FormBuilderController.SaveFile(form.id,'testdemo','None','None');
    
        Test.stopTest();
    }
    @isTest
    static void Test_getFieldsRecords_page(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        Form_Page__c pageno = [SELECT Id,Name,Page_Number__c,Form__c FROM Form_Page__c WHERE Form__c =: form.ID];
       
        FormBuilderController.getFieldsRecords_page(pageno.ID);
        
        Test.stopTest();
    }
    @isTest
    static void Test_GetFormObject(){ 

        Test.startTest();

        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        
        FormBuilderController.GetFormObject(form.id);

        Test.stopTest();
    }
    @isTest
    static void Test_createrecord(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c FROM Form_Submission__c WHERE Form__c =: form.ID];
        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;

        Sobject acc = new Account( Name = 'Testing');
        
        // FormBuilderController.createrecord(sub,acc,'');
        // FormBuilderController.createrecord(sub1,acc,'');

        Test.stopTest();
    }
    @isTest
    static void Test_createrecord_for_secod_object(){ 

        Test.startTest();
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c FROM Form_Submission__c WHERE Form__c =: form.ID];
        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;
        Sobject acc = new Account( Name = 'Testing');
        Sobject con = new Contact( LastName = 'Testing',Email='testing@test.com' );
        
        // FormBuilderController.createrecord_for_secod_object(sub,acc,con,'');
        // FormBuilderController.createrecord_for_secod_object(sub1,acc,con,'');

        Test.stopTest();
    }
    @isTest
    static void Test_createrecord_for_third_object(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Submission__c sub1 = [SELECT ID, Form__c FROM Form_Submission__c WHERE Form__c =: form.ID];
        Form_Submission__c sub = new Form_Submission__c();
        sub.Form__c = form.ID;
        
        Sobject acc = new Account( Name = 'Testing');
        Sobject con = new Contact( LastName = 'Testing',Email='testing@test.com' );
        Sobject ca = new Case(ContactId = con.ID,Status = 'New',Origin = 'Email');
       
        // FormBuilderController.createrecord_for_third_object(sub,acc,con,ca,'');
        // FormBuilderController.createrecord_for_third_object(sub1,acc,con,ca,'');

        Test.stopTest();
    }
    @isTest
    static void Test_GetFormValidation(){ 

        Test.startTest();
        
        Form__c form = [SELECT ID,Name,Status__c,All_Field_Focus__c,All_Field_Hover__c,All_Field_Styling__c,Mapped_Objects__c,Form_Styling__c,FormBgID__c,Page_CSS__c,Button_CSS__c,Label_CSS__c FROM form__c WHERE Name = 'Test'];
        Form_Fields__c field = [SELECT ID,Name,Form__c,Form_Page__c,Field_Order__c FROM Form_Fields__c WHERE form__c =: form.ID LIMIT 1];
        
        FormBuilderController.GetFormValidation(form.id);
        FormBuilderController.GetFormValidation(field.id);

        Test.stopTest();
    }
}