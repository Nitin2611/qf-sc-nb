@isTest
public class Test_EncryptDecryptController {
    @isTest
    Static void EncryptDecryptController_method(){

        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Status__c = true;
        form.Total_Submissions__c = 2;
        insert form; 

        EncryptDecryptController e = new EncryptDecryptController();
        // e.cryptoKey;

        EncryptDecryptController.processEncryption(form.ID);
        EncryptDecryptController.processDecryption('thisisdatacheck');

    }
}