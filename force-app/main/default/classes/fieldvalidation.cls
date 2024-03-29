public without sharing class fieldvalidation {
    public fieldvalidation() {

    }
    @AuraEnabled
    public static String getfieldvalidation(Id fieldId){
        try {
            Form_Fields__c fieldvalidation = [SELECT Id,Field_Validations__c FROM Form_Fields__c WHERE Id =: fieldId ];
            System.debug(fieldvalidation);
            return fieldvalidation.Field_Validations__c;

        } catch (Exception e) {
         // error_handler.insert_errordata(e,'fieldvalidation','getfieldvalidation');
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static void deletefield(Id fieldId){
        try {

            delete [SELECT Id FROM Form_Fields__c WHERE Id =: fieldId];
            
        } catch (Exception e) {
         error_handler.insert_errordata(e,'fieldvalidation','deletefield');
            // throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void savevalidation(Id fieldId, String fieldValidation,String Label){
        try {
            System.debug(fieldValidation);
            fieldValidation = fieldValidation;
            Form_Fields__c field = [SELECT Id,Field_Validations__c	FROM Form_Fields__c WHERE Id =: fieldId];
            field.Field_Validations__c = fieldValidation;
            field.Field_Label__c = Label;
            update field;
        } catch (Exception e) {
            error_handler.insert_errordata(e,'fieldvalidation','savevalidation');
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void copyfield(Id fieldId){
        try {
            Form_Fields__c field = [SELECT Id,Field_Validations__c,Field_Mapping__c,Field_Order__c,Form__c,Form_Page__c,Name,Mapped_Obj__c FROM Form_Fields__c WHERE Id =: fieldId];
            Form_Fields__c clonefield = field.clone(false,false,false,false);
            insert clonefield;
             // insert(new Form_Fields__c(Field_Validations__c = field.Field_Validations__c ,Field_Mapping__c = field.Field_Mapping__c ,Field_Order__c =field.Field_Order__c,
            // Form__c = field.Form__c ,Form_Page__c = field.Form_Page__c,Name = field.Name,Mapped_Obj__c =field.Mapped_Obj__c));
        } catch (Exception e) {
            error_handler.insert_errordata(e,'fieldvalidation','copyfield');
            // throw new AuraHandledException(e.getMessage());
        }
    }
}