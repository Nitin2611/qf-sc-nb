/***************************************************************
** Author             : Nitin
** Created Date       : 04/03/2023
** Last Modified Date : 06/03/2023
** Description        : Used for genrating pdf of submission record
***************************************************************/
public without sharing class PDFGeneratorController {
    
    public Form_Submission__c fromSubmisionData {get; set;}
    public formDataWrapper formData {get; set;}
    public boolean isFirstObject {get; set;}
    public boolean isSecondObject {get; set;}
    public boolean isThirdObject {get; set;}
    public boolean isOtherObject {get; set;}
    public boolean isSignature {get; set;}
    public boolean isFileupload {get; set;}

    public void getPagesOfForm() {
        fromSubmisionData = new Form_Submission__c();
        formData = new formDataWrapper();
        Map<String, Object> mapofFirstObject = new Map<String, Object>();
        Map<String, String> mapofFirstObjectData = new Map<String, String>();

        Map<String, Object> mapofSecondObject = new Map<String, Object>();
        Map<String, String> mapofSecondObjectData = new Map<String, String>();

        Map<String, Object> mapofThirdObject = new Map<String, Object>();
        Map<String, String> mapofThirdObjectData = new Map<String, String>();

        Map<String, Object> mapofOtherObject = new Map<String, Object>();
        Map<String, String> mapofOtherObjectData = new Map<String, String>();
        Map<String, String> mapofExtraFieldsData = new Map<String, String>();

        Map<String, String> mapofSignatureData = new Map<String, String>();
        Map<String, String> mapofFileUploadData = new Map<String, String>();
        Map<String, String> mapofOtherFieldsLabelData = new Map<String, String>();

        try {
            // Getting Form_Submission__c record id using page referenc
            String submissionId = ApexPages.currentPage().getParameters().get('Id');
            System.debug('Id from PageReference ==>' + submissionId);

            // Submitted record 
            Form_Submission__c formSubmissionRecord = [SELECT Id, Name, Form__c, Form__r.Name, First_object_data__c, Second_object_data__c, Third_object_data__c, Other_fields_data__c FROM Form_Submission__c WHERE Id =: submissionId];
            fromSubmisionData = formSubmissionRecord;

            // Stroring First object fields submitted data into Map<String, String>
            mapofFirstObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.First_object_data__c);
            for (String key : mapofFirstObject.keySet()) {
                Object value = mapofFirstObject.get(key);
                if (value != null) {
                    mapofFirstObjectData.put(key, String.valueOf(value));
                }
                isFirstObject = true;
            }
            System.debug('*** mapofFirstObjectData ==>' + mapofFirstObjectData);

            // Stroring Second object fields submitted data into Map<String, String>
            mapofSecondObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Second_object_data__c);
            for (String key : mapofSecondObject.keySet()) {
                Object value = mapofSecondObject.get(key);
                if (value != null) {
                    mapofSecondObjectData.put(key, String.valueOf(value));
                }
                isSecondObject = true;
            }
            System.debug('*** mapofSecondObjectData ==>' + mapofSecondObjectData);

            // Stroring Third object fields submitted data into Map<String, String>
            mapofThirdObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Third_object_data__c);
            for (String key : mapofThirdObject.keySet()) {
                Object value = mapofThirdObject.get(key);
                if (value != null) {
                    mapofThirdObjectData.put(key, String.valueOf(value));
                }
                isThirdObject = true;
            }
            System.debug('*** mapofThirdObjectData ==>' + mapofThirdObjectData);

            // Storing Other fields submitted data into Map<String, String>
            mapofOtherObject = (Map<String, Object>)JSON.deserializeUntyped(formSubmissionRecord.Other_fields_data__c);
            System.debug('other object map : '+mapofOtherObject);
            for (String key : mapofOtherObject.keySet()) {
                Object value = mapofOtherObject.get(key);
                if (value != null) {
                    mapofOtherObjectData.put(key, String.valueOf(value));
                }
                isOtherObject = true;
            }
            System.debug('*** mapofOtherObjectData ==>' + mapofOtherObjectData);

            
            List<Form_Fields__c> formFildsList = new List<Form_Fields__c>();
            formFildsList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Label__c FROM Form_Fields__c WHERE Form__c =: formSubmissionRecord.Form__c];
            System.debug('*** formFildsList Size ==>' + formFildsList.size() + ' -- formFildsList ==>' + formFildsList);

            for (String key : mapofOtherObjectData.keySet()) {
                if (key == 'sobjectType') {
                    mapofExtraFieldsData.put(key, mapofOtherObjectData.get(key));
                } else {
                    for (Form_Fields__c ff : formFildsList) {
                        if (ff.Id == key && ff.Name.Contains('QFSIGNATURE')) {
                            System.debug('in the QFSIGNATURE part ==>' + ff.Name);
                            mapofSignatureData.put(key, mapofOtherObjectData.get(key));
                            isSignature = true;
                        } else if (ff.Id == key && ff.Name.Contains('QFFILEUPLOAD')) {
                            System.debug('in the QFFILEUPLOAD part ==>' + ff.Name);
                            mapofFileUploadData.put(key, mapofOtherObjectData.get(key));
                            isFileupload = true;
                        } else if (ff.Id == key){
                            System.debug('in the else part ==>' + ff.Name);
                            mapofExtraFieldsData.put(key, mapofOtherObjectData.get(key));
                        }
                        
                        // Storing Fields label in map to display in vf page
                        if (ff.Id == key) {
                            if (String.isNotBlank(ff.Field_Label__c)) {
                                mapofOtherFieldsLabelData.put(key, ff.Field_Label__c);
                            } else {
                                mapofOtherFieldsLabelData.put(key, key);
                            }
                        }
                    }
                }
            }

            System.debug('*** mapofSignatureData ==>' + mapofSignatureData);
            System.debug('*** mapofFileUploadData ==>' + mapofFileUploadData);
            System.debug('*** mapofExtraFieldsData ==>' + mapofExtraFieldsData);
            System.debug('*** mapofOtherFieldsLabelData ==>' + mapofOtherFieldsLabelData);


            // getting list of pages of the submited form
            List<Form_Page__c> formpageList = new List<Form_Page__c>();
            formpageList = [SELECT Id, Name, Page_Number__c FROM Form_Page__c WHERE Form__c =: formSubmissionRecord.Form__c ORDER BY Page_Number__c ASC];

            // Assigning values to wrraper class
            formData.formName = formSubmissionRecord.Form__r.Name;
            formData.formPages = formpageList;
            formData.firstObjectFieldMap = mapofFirstObjectData;
            formData.secondObjectFieldMap = mapofSecondObjectData;
            formData.thirdObjectFieldMap = mapofThirdObjectData;
            formData.otherObjectFieldMap = mapofExtraFieldsData;
            formData.signatureFieldMap = mapofSignatureData;
            formData.fileUploadFieldMap = mapofFileUploadData;
            formData.otherObjectFieldLabelsMap = mapofOtherFieldsLabelData;
            
        } catch (Exception e) {
            System.debug('In the catch block of getPagesOfForm ==>');
            System.debug('--Line number ==>' + e.getLineNumber() + '-- Message ==>' + e.getMessage());
            System.debug(e);
        }
    }

    // This wrapper used to show all datat in pdf 
    public class formDataWrapper {
        public String formName {get; set;} // form name of submmited data
        public List<Form_Page__c> formPages {get; set;} //List of pages of form
        public Map<String, String> firstObjectFieldMap {get; set;} // Map of submitted data of first object
        public Map<String, String> secondObjectFieldMap {get; set;} // Map of submitted data of second object
        public Map<String, String> thirdObjectFieldMap {get; set;} // Map of submitted data of third object
        public Map<String, String> otherObjectFieldMap {get; set;} // Map of submitted data of other object
        public Map<String, String> signatureFieldMap {get; set;} // Map of submitted data of other object
        public Map<String, String> fileUploadFieldMap {get; set;} // Map of submitted data of other object
        public Map<String, String> otherObjectFieldLabelsMap {get; set;} // Map of submitted data's Labes of other object
    }

}