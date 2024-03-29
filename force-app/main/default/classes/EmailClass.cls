public without sharing class EmailClass {

    @AuraEnabled
    public static List<SObject> search(String searchString) {
        List<SObject> searchList = new List<SObject>();
        try {
            String searchStr = '*' + searchString + '*';
            String searchquery =
                'FIND\'' +
                searchStr +
                '\'IN ALL FIELDS RETURNING Contact(id, name, email where email != null), User(id, name, email where email != null AND isActive = true) LIMIT 10';
            List<List<SObject>> searchResult = search.query(searchquery);
            for (List<SObject> curList : searchResult) {
                searchList.addAll(curList);
            }
            system.debug('searchList:::' + searchList.size());
        } catch (Exception e) {
            error_handler.insert_errordata(e,'EmailClass','search');
            System.debug(e.getMessage());
            // throw new AuraHandledException(e.getMessage());
        }
        return searchList;
    }


    @AuraEnabled
    public static void sendEmailController(String emailDetailStr) {
        EmailWrapper emailDetails = (EmailWrapper) JSON.deserialize(emailDetailStr, EmailWrapper.class);
        Messaging.reserveSingleEmailCapacity(1);
        try {
            messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
            mail.setToAddresses(emailDetails.toAddress);
            mail.setCcAddresses(emailDetails.ccAddress);
            mail.setReplyTo('test.k@xyz.com');
            mail.setSenderDisplayName('Test');
            mail.setSubject(emailDetails.subject);
            mail.setHtmlBody(emailDetails.body);
            mail.setEntityAttachments(emailDetails.files);
            Messaging.sendEmail(new List<messaging.SingleEmailMessage>{ mail });
        } catch (exception e) {
            error_handler.insert_errordata(e,'EmailClass','sendEmailController');
            System.debug(e.getMessage());
            // throw new AuraHandledException(e.getMessage());
        }
    }

    Class EmailWrapper {
        public List<String> toAddress;
        public List<String> ccAddress;
        public String subject;
        public String body;
        public List<String> files;
    }
}