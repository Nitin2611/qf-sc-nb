//  ===================================
// # MV Clouds Private Limited
// # Author: Nimit Shah
// # Create Date: 09/01/2023
// # Description: Used for Edit, Delete, Read or Create New Form
// # Change Version History
// # Version No.     Author          Date            Change Description            Jira Ticket
// #    1.           Nimit         09/01/2023           Home Page UI              QUIC-37, QUIC-36
// ===================================
//   Edited as per sheet(qf_home.cls - 1)
public without sharing class QuickFormHome{
    // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Nimit Shah
    // # Create Date: 09/01/2023
    // # Description: Used to Read All Forms record
    // =================================== -->
    @AuraEnabled
    // public static Map<Integer,List<Form__c>> getFormRecords(){
    //     try {
    //         List<Form__c> forms = [SELECT Id,Name,Total_Submissions__c, Status__c FROM Form__c];
    //         Integer count = [SELECT Count() FROM Form__c];
    //         Map<Integer,List<Form__c>> data = new Map<Integer,List<Form__c>>();
    //         data.put(count,forms);
    //         return data;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    //   Edited as per sheet(qf_home.cls - 2 & 3)
    public static List<Form__c> getFormRecords(){
        try{
            List<Form__c> forms = [SELECT Id, Name, Total_Submissions__c, Status__c
                                   FROM Form__c
                                   ORDER BY LastModifiedDate DESC];
            return forms;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'QuickFormHome','getFormRecords');
            System.debug(e.getMessage());
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Nimit Shah
    // # Create Date: 09/01/2023
    // # Description: Used to Search Form
    // =================================== -->
    @AuraEnabled
    // public static Map<Integer,List<Form__c>> searchForms(String searchkey){
    //     try {
    //         List<Form__c> forms = [SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c WHERE Name LIKE:'%'+searchkey+'%'];
    //         Integer count = [SELECT Count() FROM Form__c WHERE Name LIKE:'%'+searchkey+'%'];
    //         Map<Integer,List<Form__c>> data = new Map<Integer,List<Form__c>>();
    //         data.put(count,forms);
    //         return data;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    //   Edited as per sheet(qf_home.cls - 2 & 3 & 4)
    public static List<Form__c> searchForms(String searchkey){
        try{
            return [SELECT Id, Name, Status__c, Total_Submissions__c
                    FROM Form__c
                    WHERE Name LIKE:'%' + searchkey + '%'
                    order by LastModifiedDate DESC
                    NULLS LAST];
        } catch (Exception e){
            // error_handler.insert_errordata(e,'QuickFormHome','searchForms');
            System.debug(e.getMessage());
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Nimit Shah
    // # Create Date: 09/01/2023
    // # Description: Used to Change Status of form
    // =================================== -->
    //   Edited as per sheet(qf_home.cls - 2 & 3 & 5)
    @AuraEnabled
    public static List<Form__c> getFormsByStatus(Id id, String searchkey){
        try{

            Form__c form = [SELECT Id, Name, Status__c, Total_Submissions__c
                            FROM Form__c
                            WHERE Id = :id
                            order by LastModifiedDate DESC
                            NULLS LAST];

            if (form.Status__c == true){
                form.Status__c = false;
            } else{
                form.Status__c = true;
            }
            update form;

            // if(searchkey == null || searchkey == '' || searchkey == 'undefined'){
            // List<Form__c> forms = [SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c];
            // return forms;
            // }
            // else{
            // List<Form__c> forms = [SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c WHERE Name LIKE:'%'+searchkey+'%'];
            // return forms;
            // }
            String searchkeyword = '%' + searchkey + '%';
            String query = 'SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c';
            if (searchkey != null && searchkey != '' && searchkey != 'undefined'){
                query += ' WHERE Name LIKE :searchkeyword order by LastModifiedDate  DESC NULLS LAST';
            } else{
                query += ' order by LastModifiedDate  DESC NULLS LAST ';
            }
            List<Form__c> forms = Database.query(query);
            return forms;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'getFormsByStatus');
            System.debug(e.getMessage());
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Nimit Shah
    // # Create Date: 09/01/2023
    // # Description: Used to delete form
    // =================================== -->
    //   Edited as per sheet(qf_home.cls - 2 & 3 & 5)
    @AuraEnabled
    public static List<Form__c> deleteFormRecord(Id id, String searchkey){
        try{
            Form__c form = [SELECT Id, Name, Status__c, Total_Submissions__c
                            FROM Form__c
                            WHERE Id = :id
                            order by LastModifiedDate DESC
                            NULLS LAST];
            delete form;

            // if(searchkey == null || searchkey == '' || searchkey == 'undefined'){
            //     List<Form__c> forms = [SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c];
            //     return forms;
            //     }
            //     else{
            //     List<Form__c> forms = [SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c WHERE Name LIKE:'%'+searchkey+'%'];
            //     return forms;
            //     }
            String searchkeyword = '%' + searchkey + '%';
            String query = 'SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c';
            if (searchkey != null && searchkey != '' && searchkey != 'undefined'){
                query += ' WHERE Name LIKE :searchkeyword order by LastModifiedDate  DESC NULLS LAST';
            } else{
                query += ' order by LastModifiedDate  DESC NULLS LAST ';
            }
            List<Form__c> forms = Database.query(query);
            return forms;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'deleteFormRecord');
            System.debug(e.getMessage());
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // <!-- ===================================
    // # MV Clouds Private Limited
    // # Author: Nimit Shah
    // # Create Date: 09/01/2023
    // # Description: Used to Rename form
    // =================================== -->
    //   Edited as per sheet(qf_home.cls - 2)
    @AuraEnabled
    public static List<Form__c> renameFormRecord(Id id, String rename, String searchkey){
        try{
            Form__c form = [SELECT Name
                            FROM Form__c
                            WHERE Id = :id
                            order by LastModifiedDate DESC
                            NULLS LAST];
            form.Name = rename;
            update form;
            String searchkeyword = '%' + searchkey + '%';
            String query = 'SELECT Id, Name, Status__c, Total_Submissions__c FROM Form__c';
            if (searchkey != null && searchkey != '' && searchkey != 'undefined'){
                query += ' WHERE Name LIKE :searchkeyword order by LastModifiedDate  DESC NULLS LAST';
            } else{
                query += ' order by LastModifiedDate  DESC NULLS LAST ';
            }
            List<Form__c> forms = Database.query(query);
            return forms;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'renameFormRecord');
            System.debug(e.getMessage());
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Void sendemail(String name, String email, String subject, String body){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<String> address = new List<String>{ 'smit11685@gmail.com' };

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.setplaintextbody(body + '\n\n\nFrom ' + name + '\nEmail ' + email);
            mail.setToAddresses(address) ;
            emailList.add(mail);
            Messaging.sendEmail(emailList);
        } catch (Exception e){
            error_handler.insert_errordata(e, 'QuickFormHome', 'sendemail');
            System.debug(e.getMessage());
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // custom meta data
    Public static String formid{ get; set; }

    Public static String test_form_id;

    public string urlvalue{ get; set; }

    public QuickFormHome(){
        urlvalue = Apexpages.currentPage().getParameters().get('formid');
    }

    @AuraEnabled(cacheable = true)
    public static List<Progress_Indicator__mdt> getProgressindicator(){
        return Progress_Indicator__mdt.getAll().values();
    }

    @AuraEnabled(cacheable = true)
    public static List<Captcha_Type__mdt> getCaptchatype(){
        return Captcha_Type__mdt.getAll().values();
    }

    @AuraEnabled(cacheable = true)
    public static List<Progress_Indicator__mdt> f_Get_Types(){
        try{
            List<Progress_Indicator__mdt> l_Types = new List<Progress_Indicator__mdt>();

            l_Types = [SELECT DeveloperName, Label, sr__c
                       FROM Progress_Indicator__mdt
                       ORDER BY sr__c ASC]; // Can include multiple fields,
            System.debug(l_Types);

            // You can also use any standard or custom object
            // You can get values from custom setting also.

            return l_Types;
        } catch (Exception e){
            // error_handler.insert_errordata(e ,'QuickFormHome','f_get_Type');
            // System.debug(e.getMessage());
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Captcha_Type__mdt> Get_Captcha_Types(){
        try{
            List<Captcha_Type__mdt> Captcha_Types = new List<Captcha_Type__mdt>();

            Captcha_Types = [SELECT DeveloperName, Label, sr__c
                             FROM Captcha_Type__mdt
                             ORDER BY sr__c ASC]; // Can include multiple fields,
            System.debug(Captcha_Types);

            // You can also use any standard or custom object
            // You can get values from custom setting also.

            return Captcha_Types;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'QuickFormHome','Get_Captcha_Types');
            // System.debug(e.getMessage());
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }

    // @AuraEnabled
    // public static void getformid(String currentformid){
    //     System.debug('u r in get form id');
    //     System.debug('Exception form url in get form id: '+ currentformid);
    //     formid = currentformid;
    // }
    @AuraEnabled
    public static String siteUrl(String Formid){
        try{
            System.debug('Exception form url: ' + Formid);
            String formid_test = Formid;
            System.debug('String form id: ' + formid_test);
            System.debug('u r in siteList ');
            Site siteList = [SELECT GuestUserId, Name, MasterLabel, Subdomain, UrlPathPrefix
                             FROM Site
                             WHERE Status = 'Active'];
            List<String> siteFullUrlList = new List<String>();
            System.debug('list of siteList :-' + siteList.Name);
            String name = siteList.Name;
            Site mySite = [select Id
                           from Site
                           where Name = :name];
            SiteDetail mySiteDetail = [select SecureURL
                                       from SiteDetail
                                       where DurableId = :mySite.Id];
            System.debug(mySiteDetail.SecureURL + siteList.Name);
            String modifiedSecureURL = mySiteDetail.SecureURL;
            if (modifiedSecureURL.endsWith('/')){
                modifiedSecureURL = modifiedSecureURL.substring(0, modifiedSecureURL.length() - 1);
            }
            String testtest = modifiedSecureURL + '?formid=' + formid_test;
            System.debug(testtest);
            siteFullUrlList.add(mySiteDetail.SecureURL + siteList.Name);
            return testtest;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'QuickFormHome','siteUrl');
            // System.debug(e.getMessage());
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }
    }

}