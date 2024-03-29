public without sharing class notificationInsertData {
    @AuraEnabled
    public static void create(Notification__c acc){
        try {
            System.debug('yasj '+ acc);
            // Notification__c acc = new Notification__c();
            // System.debug('toAddress :- '+a_toAddress);
            // System.debug('ccAddress:-'+a_ccAddress);
            // System.debug('Subject:- '+a_Subject);
            // System.debug('Message:- '+a_Message);
            // acc.To_Recipients__c  = a_toAddress;
            // acc.CC_Recipients__c = a_ccAddress;
            // acc.Subject__c = a_Subject;
            // acc.Email_Body__c = Message;
            System.debug(acc.To_Recipients__c);
            System.debug(acc.CC_Recipients__c);
            System.debug(acc.Subject__c);
            System.debug(acc.Email_Body__c);
           insert acc;

        } catch (Exception e) {
            error_handler.insert_errordata(e,'notificationInsertData','create');
            System.debug(e.getMessage());
            System.debug('error --> '+e);
        }
    }
    @AuraEnabled
    public static Notification__c  updated(Notification__c updatelist){
        System.debug('list :- ' + updatelist);
        try{
            System.debug('test :- '+updatelist.Id );
            // List<Notification__c> records = [SELECT Id FROM Notification__c WHERE Id =: updatelist.Id ];
            Notification__c record = [SELECT Id FROM Notification__c WHERE Id =: updatelist.Id ];

            // for (Notification__c record : records)
            // {
            record.To_Recipients__c = updatelist.To_Recipients__c;
            System.debug('To_Recipients__c :- '+updatelist.To_Recipients__c);
            record.CC_Recipients__c = updatelist.CC_Recipients__c;
            record.Subject__c = updatelist.Subject__c;
            record.Email_Body__c = updatelist.Email_Body__c;
            record.Attachment__c = updatelist.Attachment__c;
            record.BCC_Recipients__c = updatelist.BCC_Recipients__c;
            // }
            update record;
            return record;

        }
        catch (Exception e) {
            error_handler.insert_errordata(e,'notificationInsertData','updated');
            System.debug(e.getMessage());
            System.debug('error --> '+e);
            return null;
        }
        
        // try {
        //     System.debug('yasj '+ updatelist);
        //     System.debug(acc.To_Recipients__c);
        //     System.debug(acc.CC_Recipients__c);
        //     System.debug(acc.Subject__c);
        //     System.debug(acc.Email_Body__c);
        //     update updatelist;

        // } catch (Exception e) {
        //     System.debug('error --> '+e);
        // }
    }
    @AuraEnabled
    public static List<Notification__c> getContactList(String form_id){

        try{
        return[
            SELECT Attachment__c, CC_Recipients__c, Email_Body__c, To_Recipients__c,ID,Subject__c,BCC_Recipients__c,Status__c FROM Notification__c WHERE Form__c =: form_id
        ];
        }
        catch(Exception e){
            // error_handler.insert_errordata(e,'notificationInsertData','getContactList');
            // System.debug(e.getMessage());
            return null;
        }
    }
    
     // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Smit patel
    // # Create Date: 14/03/2023
    // # Description: Used to Send email for active Notification page
    // =================================== -->

    @AuraEnabled
    public static Notification__c getNotificationByStatus(Id form_id, Boolean Status){
        try{

            Notification__c Notification = [SELECT Id, Status__c, Form__c FROM Notification__c WHERE Form__c = :form_id];

            Notification.Status__c = Status;

            update Notification;

            return Notification;
        }
        catch (Exception e){
            error_handler.insert_errordata(e, 'notificationInsertData', 'getNotificationByStatus');
            System.debug(e.getMessage());
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }
}