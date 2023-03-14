@isTest
public class Test_notificationInsertData {

    @TestSetup
    static void create_record(){
        Test.startTest();

        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        insert form; 

        Notification__c n = new Notification__c();
        n.To_Recipients__c = 'dabhidhrupal29012003@gmail.com';
        n.CC_Recipients__c =  'dhrupal.d@gmail.com';
        n.Subject__c = 'Test';
        n.Email_Body__c = 'test the email body';
        n.Attachment__c = false;
        n.BCC_Recipients__c = '';
        n.Form__c = form.ID;
        insert n;
    
        Test.stopTest();
    }

    @IsTest
    static void Test_create(){
        Test.startTest();

        Form__c form_data = [SELECT id,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test'];
        Notification__c notification_data = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: form_data.ID];

        notificationInsertData.create(notification_data);
     
        Test.stopTest();   
    }
    @IsTest
    static void Test_update(){
        Test.startTest();
        
        Form__c form_data = [SELECT id,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test'];
        Notification__c notification_data = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: form_data.ID];

        Notification__c n1 = new Notification__c();
        n1.To_Recipients__c = 'dabhidhrupal29012003@gmail.com';
        n1.CC_Recipients__c =  'dabhidhrupal2003@gmail.com';
        n1.Subject__c = 'demo';
        n1.Email_Body__c = 'testdemo the email body';
        n1.Attachment__c = true;
        n1.BCC_Recipients__c = '';

        
        notificationInsertData.updated(notification_data);
        notificationInsertData.updated(n1);

        Test.stopTest();
    }
    @IsTest
    static void Test_getContactList(){
        Test.startTest();    
        Form__c form_data = [SELECT id,Name,Status__c,Total_Submissions__c FROM Form__c WHERE Name = 'Test'];
		Notification__c notification_data = [SELECT ID,To_Recipients__c,CC_Recipients__c,Subject__c,Email_Body__c,Attachment__c,BCC_Recipients__c,Form__c FROM Notification__c WHERE Form__c =: form_data.ID];
        
        String form_id = null;
        notificationInsertData.getContactList(form_data.id);
        notificationInsertData.getContactList(form_id);
        
        Test.stopTest();
    }    
}