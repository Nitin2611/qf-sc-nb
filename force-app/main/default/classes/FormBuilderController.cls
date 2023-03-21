public without sharing class FormBuilderController{
    @AuraEnabled
    public static List<BaseField_mdt__mdt> GetFieldsMetaData(){
        try{
            List<BaseField_mdt__mdt> basefield = BaseField_mdt__mdt.getAll().values();
            return basefield;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','GetFieldsMetaData');
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static StylesWrapper GetStyles(){
        try{
            StylesWrapper sw = new StylesWrapper();
            sw.AlignmentProp = Alignment__mdt.getAll().values();
            sw.Btn_AlignmentProp = Btn_Alignment__mdt.getAll().values();
            sw.BgPositionProp = Background_position__mdt.getAll().values();
            sw.BgRepeatProp = Background_repeat__mdt.getAll().values();
            sw.BgsizeProp = Background_size__mdt.getAll().values();
            sw.BorderStylesProp = Border_styles__mdt.getAll().values();
            sw.FixPosProp = Fix_position__mdt.getAll().values();
            sw.FontProp = Font__mdt.getAll().values();
            sw.FontLineHeightProp = Font_Line_Height__mdt.getAll().values();
            sw.FontStyleProp = Font_Style__mdt.getAll().values();
            sw.FontWeightProp = Font_Weight__mdt.getAll().values();
            sw.FormDirectionProp = Form_Direction__mdt.getAll().values();
            return sw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','GetStyles');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    //Method to get Field's Data
    @Auraenabled
    public static List<List<String>> getFields(String id){
        try{
            List<String> types = new List<String>();
            Form__c FormDetail = [SELECT Id, Mapped_Objects__c
                                  FROM Form__c
                                  WHERE Id = :id
                                  LIMIT 1];
            //List<Form_Page__c> pageList = [SELECT Id, Name, Page_Number__c FROM Form_Page__c WHERE Form__c=:Form_Id ORDER BY Page_Number__c ASC];
            types = (FormDetail.Mapped_Objects__c).split(',');
            System.debug(types);
            List<List<String>> allFields = new List<List<String>>();
            List<List<String>> allReqiredFields = new List<List<String>>();
            List<Form_Fields__c> FieldList = new List<Form_Fields__c>();

            for (String type : types){
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get(type) ;
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                List<String> Fields = new List<String>();
                Set<String> compoundFields = new Set<String>();
                Integer Position = 0;
                for (String fieldName : fieldMap.keySet()){
                    System.debug(fieldName);
                    if ((fieldMap.get(fieldName).getDescribe().getRelationshipName() != null && fieldMap.get(fieldName).getDescribe().isUpdateable()) || ((fieldMap.get(fieldName).getDescribe().isUpdateable() && fieldMap.get(fieldName).getDescribe().isNillable() == true) && fieldMap.get(fieldName).getDescribe().getCalculatedFormula() == null)){
                        // if (((fieldMap.get(fieldName).getDescribe().isUpdateable() && fieldMap.get(fieldName).getDescribe().isNillable() == true) && fieldMap.get(fieldName).getDescribe().getCalculatedFormula() == null)){
                        // list of all field API name
                        System.debug(fieldMap.get(fieldName).getDescribe().getCompoundFieldName() + '===> getfields');
                        if (fieldMap.get(fieldName).getDescribe().getCompoundFieldName() == null){
                            Fields.add(fieldMap.get(fieldName).getDescribe().getLabel() + './.' + fieldMap.get(fieldName).getDescribe().getType());
                        } else{
                            String temp = fieldMap.get(fieldName).getDescribe().getCompoundFieldName();
                            String type1 = '';
                            boolean hasAddress = temp.Contains('Address');
                            if (hasAddress){
                                type1 = 'QFADDRESS';
                            }
                            // Here not adding contact objects Name field
                            if (type != 'Contact' && temp != 'Name') {
                            compoundFields.add(temp + './.' + type1);
                        }
                    }
                }
                }
                Fields.addAll(compoundFields);
                allFields.add(Fields);
            }
            // if(!FieldList.isEmpty()){
            //     insert FieldList;
            // }
            System.debug(allFields);

            return allFields;

        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','getfields');
            return null;
        }
    }

    @AuraEnabled
    public static string UploadFormImage(String id, String body, String FName, String Type){
        try{
            Attachment a = new Attachment();
            Blob b = EncodingUtil.base64Decode(body);
            System.debug('body??' + body);

            ContentVersion cv = new ContentVersion();
            cv.Title = FName;
            cv.PathOnClient = FName;
            System.debug('FName:- ' + FName);
            System.debug(Type) ;
            cv.VersionData = b;
            cv.IsMajorVersion = true;
            Insert cv;

            Form__c nform = [SELECT id, Form_Styling__c, FormBgID__c
                             FROM Form__c
                             where Id = :id];

            System.debug(nform.Form_Styling__c);
            String fullFileURL;
            String URL = '/sfc/servlet.shepherd/version/download/' + cv.id;
            if (nform.Form_Styling__c == null){
                nform.Form_Styling__c = 'background-image:' + 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
            } else{
                List<String> lst = nform.Form_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == 'background-image'){
                        fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                        lst2[1] = fullFileURL;
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                    nform.Form_Styling__c += 'background-image:' + fullFileURL;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Form_Styling__c = fvalue;
                }
            }
            if ((nform.Form_Styling__c).substring(nform.Form_Styling__c.length() - 1, nform.Form_Styling__c.length()) != ';'){
                nform.Form_Styling__c += ';';
            }
            nform.FormBgID__c = cv.id;
            update nform;
            return nform.Form_Styling__c + ',' + URL;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','UploadFormImage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string UploadPageImage(String id, String body, String FName, String Type){
        try{
            Attachment a = new Attachment();
            Blob b = EncodingUtil.base64Decode(body);
            System.debug('body??' + body);

            ContentVersion cv = new ContentVersion();
            cv.Title = FName;
            cv.PathOnClient = FName;
            System.debug('FName:- ' + FName);
            System.debug(Type) ;
            cv.VersionData = b;
            cv.IsMajorVersion = true;
            Insert cv;

            Form__c nform = [SELECT id, Page_CSS__c, PageBgID__c
                             FROM Form__c
                             where Id = :id];
            System.debug(nform.Page_CSS__c);
            String fullFileURL;
            String URL = '/sfc/servlet.shepherd/version/download/' + cv.id;
            if (nform.Page_CSS__c == null){
                nform.Page_CSS__c = 'background-image:' + 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
            } else{
                List<String> lst = nform.Page_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == 'background-image'){
                        fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                        lst2[1] = fullFileURL;
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    fullFileURL = 'url("/sfc/servlet.shepherd/version/download/' + cv.id + '")';
                    nform.Page_CSS__c += 'background-image:' + fullFileURL;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Page_CSS__c = fvalue;
                }
            }
            if ((nform.Page_CSS__c).substring(nform.Page_CSS__c.length() - 1, nform.Page_CSS__c.length()) != ';'){
                nform.Page_CSS__c += ';';
            }
            nform.PageBgID__c = cv.id;
            update nform;
            return nform.Page_CSS__c + ',' + URL;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','UploadPageImage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string RemoveFormImage(String id){
        try{
            Form__c nform = [SELECT id, Form_Styling__c, FormBgID__c
                             FROM Form__c
                             where Id = :id];
            ContentVersion cv = [SELECT Id, ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :nform.FormBgID__c];
            ContentDocument cd = [SELECT Id
                                  FROM ContentDocument
                                  WHERE Id = :cv.ContentDocumentId];
            delete cd;
            nform.FormBgID__c = null;
            String str = nform.Form_Styling__c;
            List<String> Arr = str.split(';background-image:');
            List<string> Arr2 = Arr[1].split(';');
            Arr2.remove(0);
            Arr[1] = String.join(Arr2, ';');

            str = String.join(Arr, ';');
            nform.Form_Styling__c = str;
            nform.FormBgID__c = null;
            update nform;
            return nform.Form_Styling__c;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','RemoveFormImage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string RemovePageImage(String id){
        try{
            Form__c nform = [SELECT id, Page_CSS__c, PageBgID__c
                             FROM Form__c
                             where Id = :id];
            ContentVersion cv = [SELECT Id, ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :nform.PageBgID__c];
            ContentDocument cd = [SELECT Id
                                  FROM ContentDocument
                                  WHERE Id = :cv.ContentDocumentId];
            delete cd;
            nform.FormBgID__c = null;
            String str = nform.Page_CSS__c;
            List<String> Arr = str.split(';background-image:');
            List<string> Arr2 = Arr[1].split(';');
            Arr2.remove(0);
            Arr[1] = String.join(Arr2, ';');

            str = String.join(Arr, ';');
            nform.Page_CSS__c = str;
            nform.PageBgID__c = null;
            update nform;
            return nform.Page_CSS__c;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','RemovePageImage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string StoreBtnStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, Button_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Button_CSS__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Button_CSS__c == null){
                nform.Button_CSS__c = Value;
            } else{
                List<String> lst = nform.Button_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Button_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Button_CSS__c = fvalue;
                }
            }
            if ((nform.Button_CSS__c).substring(nform.Button_CSS__c.length() - 1, nform.Button_CSS__c.length()) != ';'){
                nform.Button_CSS__c += ';';
            }
            update nform;
            result = nform.Button_CSS__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreBtnStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static string StoreBtnposition(String Value, String id){
        try{
            Form__c nform = [SELECT Id, Button_Position__c
                             FROM Form__c
                             WHERE Id = :id];
            nform.Button_Position__c = Value;
            update nform;
            return nform.Button_Position__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreBtnposition');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string StoreLabelStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, Label_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            System.debug(nform.Label_CSS__c);
            System.debug('value>>' + Value);
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Label_CSS__c == null){
                nform.Label_CSS__c = Value;
            } else{
                List<String> lst = nform.Label_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Label_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Label_CSS__c = fvalue;
                }
            }
            if ((nform.Label_CSS__c).substring(nform.Label_CSS__c.length() - 1, nform.Label_CSS__c.length()) != ';'){
                nform.Label_CSS__c += ';';
            }
            update nform;
            // nform.All_Field_Styling__c = Value;
            result = nform.Label_CSS__c;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','StoreLabelStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static string StoreFormStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, Form_Styling__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Form_Styling__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Form_Styling__c == null){
                nform.Form_Styling__c = Value;
            } else{
                List<String> lst = nform.Form_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Form_Styling__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Form_Styling__c = fvalue;
                }
            }
            if ((nform.Form_Styling__c).substring(nform.Form_Styling__c.length() - 1, nform.Form_Styling__c.length()) != ';'){
                nform.Form_Styling__c += ';';
            }
            update nform;
            result = nform.Form_Styling__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreFormStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static string StorePageStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, Page_CSS__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.Page_CSS__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.Page_CSS__c == null){
                nform.Page_CSS__c = Value;
            } else{
                List<String> lst = nform.Page_CSS__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.Page_CSS__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.Page_CSS__c = fvalue;
                }
            }
            if ((nform.Page_CSS__c).substring(nform.Page_CSS__c.length() - 1, nform.Page_CSS__c.length()) != ';'){
                nform.Page_CSS__c += ';';
            }
            update nform;
            // nform.Page_CSS__c = Value;
            result = nform.Page_CSS__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StorePageStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static String StoreStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Styling__c
                             FROM Form__c
                             WHERE Id = :id];
            String st = nform.All_Field_Styling__c;
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Styling__c == null){
                nform.All_Field_Styling__c = Value;
            } else{
                List<String> lst = nform.All_Field_Styling__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Styling__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Styling__c = fvalue;
                }
            }
            if ((nform.All_Field_Styling__c).substring(nform.All_Field_Styling__c.length() - 1, nform.All_Field_Styling__c.length()) != ';'){
                nform.All_Field_Styling__c += ';';
            }
            update nform;
            result = nform.All_Field_Styling__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static string getBGImages(String id){
        try{
            Form__c nform = [SELECT Id, FormBgID__c, PageBgID__c
                             FROM Form__c
                             WHERE Id = :id];
            String str = '/sfc/servlet.shepherd/version/download/' + nform.FormBgID__c + ',' + '/sfc/servlet.shepherd/version/download/' + nform.PageBgID__c;
            return str;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','getBGImages');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String StoreHoverStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Hover__c
                             FROM Form__c
                             WHERE Id = :id];
            System.debug(nform.All_Field_Hover__c);
            System.debug('value>>' + Value);
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Hover__c == null){
                nform.All_Field_Hover__c = Value;
            } else{
                List<String> lst = nform.All_Field_Hover__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Hover__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Hover__c = fvalue;
                }
            }
            if ((nform.All_Field_Hover__c).substring(nform.All_Field_Hover__c.length() - 1, nform.All_Field_Hover__c.length()) != ';'){
                nform.All_Field_Hover__c += ';';
            }
            update nform;
            // nform.All_Field_Styling__c = Value;
            result = nform.All_Field_Hover__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreHoverStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static String StoreFocusStyles(String Value, String id){
        String result = '';
        try{
            Form__c nform = [SELECT Id, All_Field_Focus__c
                             FROM Form__c
                             WHERE Id = :id];
            System.debug(nform.All_Field_Focus__c);
            System.debug('value>>' + Value);
            List<String> test = Value.split(';');
            List<String> prop = test[0].split(':');
            if (nform.All_Field_Focus__c == null){
                nform.All_Field_Focus__c = Value;
            } else{
                List<String> lst = nform.All_Field_Focus__c.split(';');
                Integer count = 0;
                for (Integer i = 0; i < lst.size(); i++){
                    List<String> lst2 = lst[i].split(':');
                    if (lst2[0] == prop[0]){
                        lst2[1] = prop[1];
                        System.debug(lst[i]);
                        lst[i] = String.join(lst2, ':');
                        System.debug(lst[i]);
                        count++;
                        break;
                    }
                }
                if (count == 0){
                    nform.All_Field_Focus__c += Value;
                } else{
                    String fvalue = String.join(lst, ';');
                    nform.All_Field_Focus__c = fvalue;
                }
            }
            if ((nform.All_Field_Focus__c).substring(nform.All_Field_Focus__c.length() - 1, nform.All_Field_Focus__c.length()) != ';'){
                nform.All_Field_Focus__c += ';';
            }
            update nform;
            // nform.All_Field_Styling__c = Value;
            result = nform.All_Field_Focus__c;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'StoreFocusStyles');
            result = e.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static Form__c formdetails(Id id){
        try{
            Form__c nform = [SELECT Id, Name, Progress_Indicator__c, Captcha_Type__c, Button_CSS__c, Button_Position__c, Page_CSS__c, Form_Styling__c, All_Field_Hover__c, All_Field_Focus__c, All_Field_Styling__c, Label_CSS__c, FormBgID__c, PageBgID__c
                             FROM Form__c
                             WHERE Id = :id];
            System.debug('all styles :---> ' + nform);
            return nform;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','formdetails');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getcaptcha(String id){
        try{
            Form__c nform = [SELECT Id, Captcha_Type__c
                             FROM Form__c
                             WHERE Id = :id];
            return nform.Captcha_Type__c;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','getcaptcha');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Form_Page__c> GetFormPage(String Form_Id){
        try{
            List<Form_Page__c> pageList = [SELECT Id, Name, Page_Number__c
                                           FROM Form_Page__c
                                           WHERE Form__c = :Form_Id
                                           ORDER BY Page_Number__c ASC];
            return pageList;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','GetFormPage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    public class StylesWrapper{
        @AuraEnabled
        public list<Alignment__mdt> AlignmentProp{ get; set; }

        @AuraEnabled
        public list<Btn_Alignment__mdt> Btn_AlignmentProp{ get; set; }

        @AuraEnabled
        public list<Background_position__mdt> BgPositionProp{ get; set; }

        @AuraEnabled
        public list<Background_repeat__mdt> BgRepeatProp{ get; set; }

        @AuraEnabled
        public list<Background_size__mdt> BgsizeProp{ get; set; }

        @AuraEnabled
        public list<Border_styles__mdt> BorderStylesProp{ get; set; }

        @AuraEnabled
        public list<Fix_position__mdt> FixPosProp{ get; set; }

        @AuraEnabled
        public list<Font__mdt> FontProp{ get; set; }

        @AuraEnabled
        public list<Font_Line_Height__mdt> FontLineHeightProp{ get; set; }

        @AuraEnabled
        public list<Font_Style__mdt> FontStyleProp{ get; set; }

        @AuraEnabled
        public list<Font_Weight__mdt> FontWeightProp{ get; set; }

        @AuraEnabled
        public list<Form_Direction__mdt> FormDirectionProp{ get; set; }

    }

    @AuraEnabled
    public static List<Scale_Rating__mdt> getScaleRating(){
        try{
            return Scale_Rating__mdt.getAll().values();
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','getScaleRating');
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Form_Fields__c> CreateFieldRecord(String Form_Id, String Name, String Form_Page_Id, Decimal Position, boolean isold, String Field_Page_Id){
        try{
            System.debug('Form_Id-->' + Form_Id);
            System.debug('Name-->' + Name);
            System.debug('Form_Page_Id-->' + Form_Page_Id);
            System.debug('Position-->' + Position);
            System.debug('isold-->' + isold);
            System.debug('Field_Page_Id-->' + Field_Page_Id);

            Form_Fields__c field = new Form_Fields__c();
            List<Form_Fields__c> updateList = new List<Form_Fields__c>();

            List<Form_Fields__c> fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                                              FROM Form_Fields__c
                                              WHERE Form_Page__c = :Form_Page_Id
                                              ORDER BY Field_Order__c ASC];
            if (Field_Page_Id != ''){
                Form_Fields__c field_which_page_changed = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                                                           FROM Form_Fields__c
                                                           WHERE Id = :Name
                                                           ORDER BY Field_Order__c ASC];
                field_which_page_changed.Form_Page__c = Form_Page_Id;
                update field_which_page_changed;
            }
            for (Form_Fields__c it : fieldList){
                if (it.Field_Order__c > Position){
                    if (isold){
                        System.debug(it.Id);
                        System.debug(Name);
                        if (it.Id == Name){
                            it.Field_Order__c = Position + 1;
                        } else{
                            it.Field_Order__c = it.Field_Order__c + 1;
                        }
                    } else{
                        it.Field_Order__c = it.Field_Order__c + 1;
                    }
                    updateList.add(it);
                }
            }
            if (!updateList.isEmpty()){
                update updateList;
            }
            if (!isold){
                string form = [SELECT Mapped_Objects__c
                               from Form__c
                               WHERE Id = :Form_Id].Mapped_Objects__c;
                List<String> Objects = form.split(',');
                List<String> label = Name.split(',');
                String firstLabel = label[0];
                String secondlabel = label[1];
                System.debug(firstLabel);
                for (String type : Objects){
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType leadSchema = schemaMap.get(type) ;
                    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                    List<String> Fields = new List<String>();
                    for (String fieldName : fieldMap.keySet()){
                        if (fieldMap.get(fieldName).getDescribe().isUpdateable()){
                            if (fieldMap.get(fieldName).getDescribe().getLabel() == firstLabel){
                                System.debug('##Field API Name=' + fieldName);// list of all field API na
                                System.debug('type:=>' + type);
                                field.Mapped_Obj__c = type;
                                field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                            }
                        }
                    }
                }
                if (Position == 0){
                    Form_Fields__c maxPostion = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                                                 FROM Form_Fields__c
                                                 ORDER BY Field_Order__c DESC
                                                 LIMIT 1];
                    if (maxPostion != null){
                        Position = maxPostion.Field_Order__c;
                    }
                }
                field.Name = Name;
                field.Form__c = Form_Id;
                field.Form_Page__c = Form_Page_Id;
                field.Field_Order__c = Position + 1;
                field.Field_Label__c = Name.split(',')[0].replace('QF', '').toUpperCase();
                if (Name.split(',')[0].replace('QF', '') == 'RADIOBUTTON' || Name.split(',')[0].replace('QF', '') == 'CHECKBOX'){
                    field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>128' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>1';
                } else if (Name.split(',')[0].replace('QF', '') == 'SCALERATING'){
                    field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>128' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>Very Poor?$`~Salutation<!@!>Poor?$`~Salutation<!@!>Good?$`~Salutation<!@!>Very Good?$`~Salutation<!@!>Excellent';
                } else{
                    field.Field_Validations__c = 'isRequired<!@!>false' + 
                             '?$`~isDisabled<!@!>false' + 
                             '?$`~isLabel<!@!>true' + 
                             '?$`~isHelpText<!@!>false' + 
                             '?$`~Label<!@!>' + Name.split(',')[0].replace('QF', '').toUpperCase() + 
                             '?$`~HelpText<!@!>' + 
                             '?$`~isPlaceholder<!@!>false' + 
                             '?$`~Placeholder<!@!>' + 
                             '?$`~Minimum<!@!>0' + 
                             '?$`~Maximum<!@!>128' + 
                             '?$`~isPrefix<!@!>false' + 
                             '?$`~Prefix<!@!>' + 
                             '?$`~Decimal<!@!>' + 
                             '?$`~Richtext<!@!>' + 
                             '?$`~MinimumTime<!@!>' + 
                             '?$`~MaximumTime<!@!>' + 
                             '?$`~MinimumDateTime<!@!>' + 
                             '?$`~MaximumDateTime<!@!>' + 
                             '?$`~MinimumDate<!@!>' + 
                             '?$`~MaximumDate<!@!>' + 
                             '?$`~Salutation<!@!>';
                }

                insert field;

                if (Name.split(',')[1] == 'Extra'){
                    field.Mapped_Obj__c = 'Extra';
                    field.Field_Mapping__c = field.Id + '<!@!>' + 'Extra';
                } else if (Name.split(',')[1] == 'QFADDRESS'){
                    for (String type : Objects){
                        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                        Schema.SObjectType leadSchema = schemaMap.get(type) ;
                        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                        if (Name.split(',')[1] == 'QFADDRESS'){
                            field.Mapped_Obj__c = type;
                            field.Field_Mapping__c = fieldMap.get(Name.split(',')[0]) + '<!@!>' + type;
                        }
                    }

                }
                update field;
            }
            fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                         FROM Form_Fields__c
                         WHERE Form__c = :Form_Id
                         ORDER BY Field_Order__c ASC];
            return fieldList;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'CreateFieldRecord');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static pageWrapper addPageBreak(Id FormId, String Name, String Form_Page_Id, Integer Position, String dropFieldId){
        try{
            System.debug('FormId= =>>' + FormId + '-- Name ==>>' + Name + '-- Form_Page_Id ==>>' + Form_Page_Id + 'Position ==>>' + Position + 'dropFieldId ==>>' + dropFieldId);

            List<Form_Fields__c> cuurentPageFields = new List<Form_Fields__c>();

            Form_Page__c currentFormPage = new Form_Page__c();
            cuurentPageFields = [SELECT Id, Name, Field_Order__c, Form_Page__c, Field_Mapping__c
                                 FROM Form_Fields__c
                                 WHERE Form_Page__c = :Form_Page_Id
                                 ORDER BY Field_Order__c ASC];

            List<Form_Page__c> allPages = [SELECT id, Name, Page_Number__c
                                           FROM Form_Page__c
                                           WHERE Form__c = :FormId
                                           ORDER BY Page_Number__c ASC];
            System.debug('*** allPages size ==>' + allPages.size() + '*** allPages ==>' + allPages);
            // Integer total_pages = allPages.size();

            List<Form_Page__c> pagesToUpdateList = new List<Form_Page__c>();
            boolean isPageFind = false;

            for (Form_Page__c fp : allPages){
                if (isPageFind){
                    pagesToUpdateList.add(fp);
                }
                if (fp.Id == Form_Page_Id && isPageFind == false){
                    isPageFind = true;
                    currentFormPage = fp;
                }

            }

            Form_Page__c newFormPage = new Form_Page__c();
            newFormPage.Form__c = FormId;
            newFormPage.Name = 'New Page';
            newFormPage.Page_Number__c = currentFormPage.Page_Number__c + 1;
            insert newFormPage;

            for (Form_Page__c fp : pagesToUpdateList){
                fp.Page_Number__c = fp.Page_Number__c + 1;
            }
            update pagesToUpdateList;


            // checking current page has any field or not
            if (String.isNotBlank(dropFieldId) && cuurentPageFields.size() > 0){
                List<Form_Fields__c> newPageFields = new List<Form_Fields__c>();
                boolean isFieldFind = false;
                for (Form_Fields__c ff : cuurentPageFields){
                    if (isFieldFind){
                        newPageFields.add(ff);
                    }
                    if (ff.Id == dropFieldId && isFieldFind == false){
                        isFieldFind = true;
                    }
                }

                for (Form_Fields__c ff : newPageFields){
                    ff.Form_Page__c = newFormPage.Id;
                }
                update newPageFields;
            }

            pageWrapper pw = new pageWrapper();
            pw.fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                            FROM Form_Fields__c
                            WHERE Form__c = :FormId
                            ORDER BY Field_Order__c ASC];
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           ORDER BY Page_Number__c ASC];
            return pw;

        } catch (Exception e){
            System.debug('Exception-->>' + e.getMessage() + '-->Line--' + e.getLineNumber() + '-->Stack-->' + e.getStackTraceString());
            error_handler.insert_errordata(e, 'FormBuilderController', 'addPageBreak');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    public class pageWrapper{
        @AuraEnabled
        public list<Form_Fields__c> fieldList{ get; set; }

        @AuraEnabled
        public list<Form_Page__c> pageList{ get; set; }

    }

    @AuraEnabled
    public static String ObjName(String id){
        try{
            Form__c nform = [SELECT Id, Mapped_Objects__c
                             FROM Form__c
                             WHERE Id = :id];
            // Set<String> objectset = new Set<String>{ 'Account', 'Address', 'AlternativePaymentMethod', 'Announcement', 'AppAnalyticsQueryRequest', 'AppointmentTopicTimeSlot', 'ApptBundleAggrDurDnscale', 'ApptBundleAggrPolicy', 'ApptBundleConfig', 'ApptBundlePolicy', 'ApptBundlePolicySvcTerr', 'ApptBundlePropagatePolicy', 'ApptBundleRestrictPolicy', 'ApptBundleSortPolicy', 'Asset', 'AssetDowntimePeriod', 'AssetRelationship', 'AssetWarranty', 'AssociatedLocation', 'AttributeDefinition', 'AuthorizationForm', 'AuthorizationFormConsent', 'AuthorizationFormDataUse', 'AuthorizationFormText', 'BusinessBrand', 'CalendarView', 'Campaign', 'CampaignMember', 'CardPaymentMethod', 'Case', 'CollaborationGroup', 'CollaborationGroupRecord', 'CommSubscription', 'CommSubscriptionChannelType', 'CommSubscriptionConsent', 'CommSubscriptionTiming', 'ConsumptionRate', 'ConsumptionSchedule', 'Contact', 'ContactPointAddress', 'ContactPointConsent', 'ContactPointEmail', 'ContactPointPhone', 'ContactPointTypeConsent', 'ContactRequest', 'ContentVersion', 'Contract', 'ContractGroupPlan', 'ContractGroupPlanGroupClass', 'ContractLineItem', 'Customer', 'DataUseLegalBasis', 'DataUsePurpose', 'DigitalWallet', 'DuplicateRecordItem', 'DuplicateRecordSet', 'EngagementChannelType', 'Entitlement', 'EntitlementContact', 'Error_Handler__c', 'Event', 'Expense', 'ExpenseReport', 'ExpenseReportEntry', 'ExpressionFilter', 'ExpressionFilterCriteria', 'FinanceTransaction', 'FlowRecordRelation', 'GroupCensus', 'GroupCensusMember', 'GroupCensusMemberPlan', 'GroupClass', 'GroupClassContribution', 'Idea', 'Image', 'Individual', 'InsuranceContract', 'JobProfile', 'Lead', 'LegalEntity', 'ListEmail', 'ListEmailIndividualRecipient', 'ListEmailRecipientSource', 'Location', 'LocationGroup', 'LocationGroupAssignment', 'Macro', 'MacroInstruction', 'MaintenanceAsset', 'MaintenancePlan', 'MaintenanceWorkRule', 'Opportunity', 'Order', 'OrgMetric', 'OrgMetricScanResult', 'OrgMetricScanSummary', 'PartyConsent', 'Payment', 'PaymentAuthAdjustment', 'PaymentAuthorization', 'PaymentGateway', 'PaymentGatewayLog', 'PaymentGroup', 'PaymentLineInvoice', 'Pricebook2', 'ProcessException', 'Product2', 'ProductConsumed', 'ProductConsumptionSchedule', 'ProductItem', 'ProductRequest', 'ProductRequestLineItem', 'ProductRequired', 'ProductServiceCampaign', 'ProductServiceCampaignItem', 'ProductTransfer', 'ProductWarrantyTerm', 'ProfileSkill', 'ProfileSkillEndorsement', 'ProfileSkillUser', 'PromptAction', 'PromptError', 'QuickText', 'Recommendation', 'RecommendationResponse', 'RecordAction', 'Refund', 'RefundLinePayment', 'ResourceAbsence', 'ReturnOrder', 'ReturnOrderLineItem', 'SchedulingConstraint', 'Scorecard', 'ScorecardAssociation', 'ScorecardMetric', 'SearchPromotionRule', 'Seller', 'SerializedProduct', 'ServiceAppointment', 'ServiceContract', 'ServiceCrew', 'ServiceCrewMember', 'ServiceResource', 'ServiceResourcePreference', 'ServiceTerritory', 'ServiceTerritoryLocation', 'SetupAssistantStep', 'Shift', 'ShiftTemplate', 'Shipment', 'ShipmentItem', 'Solution', 'Task', 'TimeSheet', 'TimeSheetEntry', 'TravelMode', 'UnitOfMeasure', 'UserEmailPreferredPerson', 'WarrantyTerm', 'WorkAccess', 'WorkBadge', 'WorkBadgeDefinition', 'WorkOrder', 'WorkOrderLineItem', 'WorkPlan', 'WorkPlanSelectionRule', 'WorkPlanTemplate', 'WorkPlanTemplateEntry', 'WorkStep', 'WorkStepTemplate', 'WorkThanks', 'WorkType', 'WorkTypeGroup', 'WorkTypeGroupMember' };

            List<String> obj1 = nform.Mapped_Objects__c.split(',');
            String result = nform.Mapped_Objects__c;
            Map<String, String> objectIconMap = new Map<String, String>{ 'Account' => 'standard:account', 'Address' => 'standard:address', 'AlternativePaymentMethod' => 'standard:payment_gateway', 'Announcement' => 'standard:announcement', 'AppAnalyticsQueryRequest' => 'standard:care_request_reviewer', 'AppointmentTopicTimeSlot' => 'standard:timeslot', 'ApptBundleAggrDurDnscale' => 'standard:event', 'ApptBundleAggrPolicy' => 'standard:aggregation_policy', 'ApptBundleConfig' => 'standard:bundle_config', 'ApptBundlePolicy' => 'standard:bundle_policy', 'ApptBundlePolicySvcTerr' => 'standard:service_territory_policy', 'ApptBundlePropagatePolicy' => 'standard:propagation_policy', 'ApptBundleRestrictPolicy' => 'standard:restriction_policy', 'ApptBundleSortPolicy' => 'standard:sort_policy', 'Asset' => 'standard:asset_object', 'AssetDowntimePeriod' => 'standard:asset_downtime_period', 'AssetRelationship' => 'standard:asset_relationship', 'AssetWarranty' => 'standard:asset_warranty', 'AssociatedLocation' => 'standard:location', 'AttributeDefinition' => 'standard:variation_attribute_setup', 'AuthorizationForm' => 'standard:form', 'AuthorizationFormConsent' => 'standard:form', 'AuthorizationFormDataUse' => 'standard:form', 'AuthorizationFormText' => 'standard:form', 'BusinessBrand' => 'standard:store', 'CalendarView' => 'standard:date_input', 'Campaign' => 'standard:campaign', 'CampaignMember' => 'standard:campaign_members', 'CardPaymentMethod' => 'standard:contract_payment', 'Case' => 'standard:case', 'CollaborationGroup' => 'standard:live_chat', 'CollaborationGroupRecord' => 'standard:live_chat', 'CommSubscription' => 'standard:product_consumed', 'CommSubscriptionChannelType' => 'standard:channel_program_levels', 'CommSubscriptionConsent' => 'standard:product_consumed', 'CommSubscriptionTiming' => 'standard:channel_program_history', 'ConsumptionRate' => 'standard:product_consumed_state', 'ConsumptionSchedule' => 'standard:product_consumed_state', 'Contact' => 'standard:contact', 'ContactPointAddress' => 'standard:address', 'ContactPointConsent' => 'standard:address', 'ContactPointEmail' => 'standard:email', 'ContactPointPhone' => 'standard:call', 'ContactPointTypeConsent' => 'standard:contact', 'ContactRequest' => 'standard:contact_request', 'ContentVersion' => 'standard:file', 'Contract' => 'standard:contract', 'ContractGroupPlan' => 'standard:contract', 'ContractGroupPlanGroupClass' => 'standard:contract', 'ContractLineItem' => 'standard:contract_line_item', 'Customer' => 'standard:customer', 'DataUseLegalBasis' => 'standard:product_consumed', 'DataUsePurpose' => 'standard:product_consumed', 'DigitalWallet' => 'standard:connect_wallet', 'DuplicateRecordItem' => 'custom:custom49', 'DuplicateRecordSet' => 'standard:record', 'EngagementChannelType' => 'standard:channel_programs', 'Entitlement' => 'standard:entitlement', 'EntitlementContact' => 'standard:people', 'Event' => 'standard:event', 'Expense' => 'standard:expense', 'ExpenseReport' => 'standard:expense_report', 'ExpenseReportEntry' => 'standard:expense_report_entry', 'ExpressionFilter' => 'standard:filter', 'ExpressionFilterCriteria' => 'standard:filter_criteria', 'FinanceTransaction' => 'standard:crypto_transaction', 'FlowRecordRelation' => 'standard:flow', 'GroupCensus' => 'standard:groups', 'GroupCensusMember' => 'standard:groups', 'GroupCensusMemberPlan' => 'standard:groups', 'GroupClass' => 'standard:groups', 'GroupClassContribution' => 'standard:groups', 'Idea' => 'standard:solution', 'Image' => 'custom:custom38', 'Individual' => 'standard:individual', 'InsuranceContract' => 'standard:entitlement_policy', 'JobProfile' => 'standard:job_profile', 'Lead' => 'standard:lead', 'LegalEntity' => 'standard:entity', 'ListEmail' => 'standard:list_email', 'ListEmailIndividualRecipient' => 'standard:email', 'ListEmailRecipientSource' => 'standard:email', 'Location' => 'standard:location', 'LocationGroup' => 'standard:location', 'LocationGroupAssignment' => 'standard:location', 'Macro' => 'standard:macros', 'MacroInstruction' => 'standard:macros', 'MaintenanceAsset' => 'standard:maintenance_asset', 'MaintenancePlan' => 'standard:maintenance_plan', 'MaintenanceWorkRule' => 'standard:maintenance_work_rule', 'Opportunity' => 'standard:opportunity', 'Order' => 'standard:orders', 'OrgMetric' => 'standard:dashboard', 'OrgMetricScanResult' => 'standard:dashboard_ea', 'OrgMetricScanSummary' => 'standard:dashboard_component', 'PartyConsent' => 'custom:custom69', 'Payment' => 'standard:contract_payment', 'PaymentAuthAdjustment' => 'standard:contract_payment', 'PaymentAuthorization' => 'standard:contract_payment', 'PaymentGateway' => 'standard:payment_gateway', 'PaymentGatewayLog' => 'standard:payment_gateway', 'PaymentGroup' => 'standard:partner_fund_request', 'PaymentLineInvoice' => 'standard:payment_gateway', 'Pricebook2' => 'standard:pricebook', 'ProcessException' => 'standard:process_exception', 'Product2' => 'standard:product', 'ProductConsumed' => 'standard:product_consumed', 'ProductConsumptionSchedule' => 'standard:product_consumed', 'ProductItem' => 'standard:product_item', 'ProductRequest' => 'standard:product_request', 'ProductRequestLineItem' => 'standard:product_request_line_item', 'ProductRequired' => 'standard:product_required', 'ProductServiceCampaign' => 'standard:product_service_campaign', 'ProductServiceCampaignItem' => 'standard:product_service_campaign_item', 'ProductTransfer' => 'standard:product_transfer', 'ProductWarrantyTerm' => 'standard:product_warranty_term', 'ProfileSkill' => 'standard:skill', 'ProfileSkillEndorsement' => 'standard:skill_entity', 'ProfileSkillUser' => 'standard:skill_entity', 'PromptAction' => 'standard:prompt', 'PromptError' => 'standard:prompt', 'QuickText' => 'standard:quick_text', 'Recommendation' => 'standard:feedback', 'RecommendationResponse' => 'standard:feedback', 'RecordAction' => 'standard:record', 'Refund' => 'standard:contract_payment', 'RefundLinePayment' => 'standard:contract_payment', 'ResourceAbsence' => 'standard:resource_absence', 'ReturnOrder' => 'standard:return_order', 'ReturnOrderLineItem' => 'standard:return_order_line_item', 'SchedulingConstraint' => 'standard:scheduling_constraint', 'Scorecard' => 'standard:scan_card', 'ScorecardAssociation' => 'standard:scan_card', 'ScorecardMetric' => 'standard:scan_card', 'SearchPromotionRule' => 'standard:search', 'Seller' => 'standard:partner_fund_allocation', 'SerializedProduct' => 'standard:serialized_product', 'ServiceAppointment' => 'standard:service_appointment', 'ServiceContract' => 'standard:service_contract', 'ServiceCrew' => 'standard:service_crew', 'ServiceCrewMember' => 'standard:service_crew_member', 'ServiceResource' => 'standard:service_resource', 'ServiceResourcePreference' => 'standard:service_territory', 'ServiceTerritory' => 'standard:service_territory', 'ServiceTerritoryLocation' => 'standard:location', 'SetupAssistantStep' => 'standard:setup_modal', 'Shift' => 'standard:shift', 'ShiftTemplate' => 'standard:shift_template', 'Shipment' => 'standard:shipment', 'ShipmentItem' => 'standard:shipment', 'Solution' => 'standard:solution', 'Task' => 'standard:task', 'TimeSheet' => 'standard:timesheet', 'TimeSheetEntry' => 'standard:timesheet_entry', 'TravelMode' => 'standard:location', 'UnitOfMeasure' => 'custom:custom79', 'UserEmailPreferredPerson' => 'standard:people', 'WarrantyTerm' => 'standard:warranty_term', 'WorkAccess' => 'standard:work_queue', 'WorkBadge' => 'standard:skill_requirement', 'WorkBadgeDefinition' => 'standard:skill_requirement', 'WorkOrder' => 'standard:work_order', 'WorkOrderLineItem' => 'standard:work_order_item', 'WorkPlan' => 'standard:work_plan', 'WorkPlanSelectionRule' => 'standard:work_plan_rule', 'WorkPlanTemplate' => 'standard:work_plan_template', 'WorkPlanTemplateEntry' => 'standard:work_plan_template_entry', 'WorkStep' => 'standard:work_step', 'WorkStepTemplate' => 'standard:work_step_template', 'WorkThanks' => 'standard:thanks', 'WorkType' => 'standard:work_type', 'WorkTypeGroup' => 'standard:work_type_group', 'WorkTypeGroupMember' => 'standard:team_member' };
            Integer n = 0;
            for (String a : obj1){
                String str = '';
                if (objectIconMap.containsKey(a)){
                    str = objectIconMap.get(a);
                } else{
                    if (n == 0){
                        str = 'custom:custom3';
                        n++;
                    } else if (n == 1){
                        str = 'custom:custom10';
                        n++;
                    } else{
                        str = 'custom:custom11';
                        n++;
                    }
                }
                result = result + ',' + str;
            }
            return result;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','ObjName');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Form_Fields__c> getFieldsRecords(Id id){
        try{
            //string form = [SELECT Mapped_Objects__c from Form__c WHERE Id=:id].Mapped_Objects__c;
            // List<String> Objects = form.split(',');

            Form__c FormDetail = [SELECT Id, Mapped_Objects__c
                                  FROM Form__c
                                  WHERE Id = :id
                                  LIMIT 1];
            //List<Form_Page__c> pageList = [SELECT Id, Name, Page_Number__c FROM Form_Page__c WHERE Form__c=:Form_Id ORDER BY Page_Number__c ASC];
            List<String> types = (FormDetail.Mapped_Objects__c).split(',');
            Decimal Position = 0;
            List<Form_Page__c> AllFormPages = [SELECT ID
                                               From Form_Page__c
                                               where Form__c = :FormDetail.Id
                                               ORDER BY Page_Number__c];
            boolean hasRequiredField = false;
            List<Form_Fields__c> fieldContainsRequireCheck = [SELECT Name
                                                              From Form_Fields__c
                                                              where Form_Page__c = :AllFormPages.get(0).Id];
            List<Form_Fields__c> allFieldsOfForm = [SELECT Name, Form__c, Form_Page__c
                                                    FROM Form_Fields__c
                                                    WHERE Form__c = :FormDetail.Id];

            for (Form_Fields__c it : fieldContainsRequireCheck){
                List<String> temp = it.Name.split(',');
                if (temp.size() == 3){
                    if (temp.get(2) == 'isrequired'){
                        hasRequiredField = true;
                    }
                }
            }

            if (hasRequiredField == false){
                if (allFieldsOfForm.size() == 0){
                    Integer iteration = 0;
                    List<Form_Fields__c> Fields = new List<Form_Fields__c>();
                    for (String type : types){
                        Position = 0;
                        Form_Page__c page_Id = AllFormPages.get(iteration);
                        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                        Schema.SObjectType leadSchema = schemaMap.get(type) ;
                        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                        for (String fieldName : fieldMap.keySet()){

                            // if (fieldName == 'Name' || (!fieldMap.get(fieldName).getDescribe().isNillable() && !fieldMap.get(fieldName).getDescribe().isDefaultedOnCreate() && fieldMap.get(fieldName).getDescribe().isCreateable())){
                            if (fieldName != 'OwnerId' && (!fieldMap.get(fieldName).getDescribe().isNillable() && fieldMap.get(fieldName).getDescribe().isUpdateable())){
                            // if (String.valueOf(fieldMap.get(fieldName).getDescribe().getType()) != 'BOOLEAN' && fieldName != 'OwnerId' && (!fieldMap.get(fieldName).getDescribe().isNillable() && fieldMap.get(fieldName).getDescribe().isUpdateable())){
                                Position = Position + 1;
                                System.debug('##Field API Name=' + fieldName);
                                Form_Fields__c field = new Form_Fields__c();
                                //requiredFieldList.add(fieldMap.get(fieldName).getDescribe().getLabel()+'./.'+ fieldMap.get(fieldName).getDescribe().getType());
                                field.Mapped_Obj__c = type;
                                field.Field_Mapping__c = fieldMap.get(fieldName) + '<!@!>' + type;
                                field.Name = fieldMap.get(fieldName).getDescribe().getLabel() + ',' + fieldMap.get(fieldName).getDescribe().getType() + ',isrequired';
                                field.Form__c = FormDetail.Id;
                                field.Form_Page__c = page_Id.Id;
                                field.Field_Order__c = Position + 1;
                                field.Field_Label__c = fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase();
                                field.Field_Validations__c = 'isRequired<!@!>true' + 
                                                         '?$`~isDisabled<!@!>false' + 
                                                         '?$`~isLabel<!@!>true' + 
                                                         '?$`~isHelpText<!@!>false' + 
                                                         '?$`~Label<!@!>' + fieldMap.get(fieldName).getDescribe().getLabel().toUpperCase() + 
                                                         '?$`~HelpText<!@!>' + 
                                                         '?$`~isPlaceholder<!@!>false' + 
                                                         '?$`~Placeholder<!@!>' + 
                                                         '?$`~Minimum<!@!>0' + 
                                                         '?$`~Maximum<!@!>128' + 
                                                         '?$`~isPrefix<!@!>false' + 
                                                         '?$`~Prefix<!@!>' + 
                                                         '?$`~Decimal<!@!>' + 
                                                         '?$`~Richtext<!@!>' + 
                                                         '?$`~MinimumTime<!@!>' + 
                                                         '?$`~MaximumTime<!@!>' + 
                                                         '?$`~MinimumDateTime<!@!>' + 
                                                         '?$`~MaximumDateTime<!@!>' + 
                                                         '?$`~MinimumDate<!@!>' + 
                                                         '?$`~MaximumDate<!@!>' + 
                                                         '?$`~Salutation<!@!>';
                                Fields.add(field);
                            }

                        }
                        iteration = iteration + 1;
                    }
                    insert Fields;
                }
            }
            // List<Form_Fields__c> fieldList=[SELECT Id,Name,Form__c,Form_Page__c,Field_Order__c, Field_Validations__c FROM Form_Fields__c];
            // return fieldList;
            List<Form_Fields__c> fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                              FROM Form_Fields__c
                                              WHERE Form__c = :id
                                              ORDER BY Field_Order__c ASC];
            return fieldList;

        } catch (Exception e){
            System.debug('Error Line Number ==>' + e.getLineNumber() + ' Error Message ==>' + e.getMessage());
            System.debug('Error ==>' + e);
            // error_handler.insert_errordata(e,'FormBuilderController','getFieldsRecords');
            return null;
        }
    }

    /***************************************************************
     ** Author             : Nitin
     ** Created Date       : 23/02/2023
     ** Last Modified Date : 23/02/2023
     ** Description        : Used for Reordering fields in form builder
     ***************************************************************/
    @AuraEnabled
    public static List<Form_Fields__c> reOrderField(String dropFieldId, String currentFieldId, String dropPageId){
        List<Form_Fields__c> fieldList = new List<Form_Fields__c>();
        List<Form_Fields__c> fieldListToUpdate = new List<Form_Fields__c>();

        Form_Fields__c cuurentField = new Form_Fields__c();
        Form_Fields__c dropField = new Form_Fields__c();
        try{
            if (String.isNotBlank(dropFieldId) && String.isNotBlank(currentFieldId)){
                cuurentField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c, Field_Mapping__c
                                FROM Form_Fields__c
                                WHERE Id = :currentFieldId];
                dropField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c, Field_Mapping__c
                             FROM Form_Fields__c
                             WHERE Id = :dropFieldId];
                fieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Mapping__c
                             FROM Form_Fields__c
                             WHERE Form__c = :cuurentField.Form__c
                             ORDER BY Field_Order__c ASC];

                system.debug('fieldList size ==>' + fieldList.size() + '== fieldList ==>' + fieldList);

                if (cuurentField.Field_Order__c < dropField.Field_Order__c){
                    for (Form_Fields__c ff : fieldList){
                        if (ff.Field_Order__c > cuurentField.Field_Order__c && ff.Field_Order__c < dropField.Field_Order__c){
                            ff.Field_Order__c = ff.Field_Order__c - 1;
                            fieldListToUpdate.add(ff);
                        }
                    }
                    cuurentField.Field_Order__c = dropField.Field_Order__c - 1;
                    cuurentField.Form_Page__c = dropField.Form_Page__c;
                    fieldListToUpdate.add(cuurentField);
                } else if (cuurentField.Field_Order__c > dropField.Field_Order__c){
                    for (Form_Fields__c ff : fieldList){
                        if (ff.Field_Order__c >= dropField.Field_Order__c && ff.Field_Order__c < cuurentField.Field_Order__c){
                            ff.Field_Order__c = ff.Field_Order__c + 1;
                            fieldListToUpdate.add(ff);
                        }
                    }
                    cuurentField.Field_Order__c = dropField.Field_Order__c;
                    cuurentField.Form_Page__c = dropField.Form_Page__c;
                    fieldListToUpdate.add(cuurentField);
                }

                if (fieldListToUpdate.size() > 0){
                    update fieldListToUpdate;
                }

            } else if (String.isNotBlank(currentFieldId)){
                System.debug('In the else part of notblank check ==>');
                cuurentField = [SELECT Id, Name, Form_Page__c, Field_Order__c, Form__c
                                FROM Form_Fields__c
                                WHERE Id = :currentFieldId];
                cuurentField.Field_Order__c = 2;
                cuurentField.Form_Page__c = dropPageId;
                update cuurentField;
            }
            List<Form_Fields__c> latestFieldList = new List<Form_Fields__c>();
            latestFieldList = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                               FROM Form_Fields__c
                               WHERE Form__c = :cuurentField.Form__c
                               ORDER BY Field_Order__c ASC];
            return latestFieldList;
        } catch (Exception e){
            System.debug('Error Line Number ==>' + e.getLineNumber() + ' Error Message ==>' + e.getMessage());
            System.debug('Error ==>' + e);
            // error_handler.insert_errordata(e,'FormBuilderController','reOrderField');
            return null;
        }
    }

    @AuraEnabled
    public static pageWrapper createPage(Integer totalPages, Id formId, String pagename, Integer pageNumber){
        try{
            Form_Page__c newFormPage = new Form_Page__c();
            newFormPage.Form__c = formId;
            newFormPage.Name = pagename;
            if (pageNumber != null && pageNumber <= totalPages){
                // shift the existing pages forward by one page number
                List<Form_Page__c> existingPages = [SELECT Id, Page_Number__c
                                                    FROM Form_Page__c
                                                    WHERE Form__c = :formId AND Page_Number__c >= :pageNumber
                                                    ORDER BY Page_Number__c DESC];
                for (Form_Page__c page : existingPages){
                    page.Page_Number__c += 1;
                }
                update existingPages;
                newFormPage.Page_Number__c = pageNumber;
            } else{
                newFormPage.Page_Number__c = totalPages + 1;
            }
            insert newFormPage;
            List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               ORDER BY Field_Order__c ASC];
            pageWrapper pw = new pageWrapper();
            pw.fieldList = formFields;
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           ORDER BY Page_Number__c ASC];
            return pw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','createPage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static pageWrapper updatePage(Id formId, Id pageId, String pageTitle, Integer pageNumber){
        try{
            Form_Page__c formPage = new Form_Page__c(Id = pageId, Name = pageTitle, Page_Number__c = pageNumber);
            update formPage;

            // Get the page that was updated
            Form_Page__c updatedPage = [SELECT Id, Name, Page_Number__c
                                        FROM Form_Page__c
                                        WHERE Id = :pageId];

            // Get the pages with a number less than or equal to the updated page number
            List<Form_Page__c> pagesBefore = [SELECT Id, Name, Page_Number__c
                                              FROM Form_Page__c
                                              WHERE Form__c = :formId AND Page_Number__c <= :pageNumber AND Id != :pageId
                                              ORDER BY Page_Number__c ASC];

            // Get the pages with a number greater than the updated page number
            List<Form_Page__c> pagesAfter = [SELECT Id, Name, Page_Number__c
                                             FROM Form_Page__c
                                             WHERE Form__c = :formId AND Page_Number__c > :pageNumber
                                             ORDER BY Page_Number__c ASC];

            // Update the page numbers for the pages before the updated page
            Integer newPageNumber = 1;
            for (Form_Page__c page : pagesBefore){
                page.Page_Number__c = newPageNumber;
                newPageNumber++;
            }

            // Set the updated page number to the updated page
            updatedPage.Page_Number__c = newPageNumber;
            newPageNumber++;

            // Update the page numbers for the pages after the updated page
            for (Form_Page__c page : pagesAfter){
                page.Page_Number__c = newPageNumber;
                newPageNumber++;
            }

            // Update the pages in the database
            List<Form_Page__c> pagesToUpdate = new List<Form_Page__c>();
            pagesToUpdate.addAll(pagesBefore);
            pagesToUpdate.add(updatedPage);
            pagesToUpdate.addAll(pagesAfter);
            update pagesToUpdate;
            List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Validations__c, Field_Order__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               ORDER BY Field_Order__c ASC];
            pageWrapper pw = new pageWrapper();
            pw.fieldList = formFields;
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :formId
                           ORDER BY Page_Number__c ASC];
            return pw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','updatePage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static pageWrapper renameform(Id id, String rename, Id FormId){
        try{
            Form_Page__c form = [SELECT Name
                                 FROM Form_Page__c
                                 WHERE Id = :id];
            form.Name = rename;
            update form;
            List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               ORDER BY Field_Order__c ASC];
            pageWrapper pw = new pageWrapper();
            pw.fieldList = formFields;
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           ORDER BY Page_Number__c ASC];
            return pw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','renameform');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string renameMainform(String rename, Id FormId){
        try{
            Form__c renameform = [SELECT Name
                                  from Form__c
                                  WHERE Id = :FormId];
            renameform.Name = rename;
            update renameform;
            return rename;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','renameMainform');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static pageWrapper deletePage(Id FormId, Id PageId){
        try{
            Form_Page__c deletePage = [SELECT Id, Page_Number__c
                                       from Form_Page__c
                                       where Id = :PageId];
            boolean hasRequiredField = false;
            List<Form_Fields__c> fieldContainsRequireCheck = [SELECT Name
                                                              From Form_Fields__c
                                                              where Form_Page__c = :PageId];
            for (Form_Fields__c it : fieldContainsRequireCheck){
                List<String> temp = it.Name.split(',');
                if (temp.size() == 3){
                    if (temp.get(2) == 'isrequired'){
                        hasRequiredField = true;
                    }
                }
            }
            if (!hasRequiredField){
                delete deletePage;
                // Subtract 1 from Page_Number__c of all pages that have a higher page number than the deleted page
                List<Form_Page__c> pagesToUpdate = [SELECT Id, Page_Number__c
                                                    FROM Form_Page__c
                                                    WHERE Form__c = :FormId AND Page_Number__c > :deletePage.Page_Number__c];
                for (Form_Page__c p : pagesToUpdate){
                    p.Page_Number__c -= 1;
                }
                update pagesToUpdate;
            }
            List<Form_Fields__c> formFields = [SELECT Id, Name, Form__c, Form_Page__c, Field_Order__c, Field_Validations__c, Field_Mapping__c
                                               FROM Form_Fields__c
                                               ORDER BY Field_Order__c ASC];
            pageWrapper pw = new pageWrapper();
            pw.fieldList = formFields;
            pw.pageList = [SELECT Id, Name, Page_Number__c
                           FROM Form_Page__c
                           WHERE Form__c = :FormId
                           ORDER BY Page_Number__c ASC];
            return pw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','deletePage');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled
    // public static Form__c formDetails(Id id){
    //     try{
    //         return [SELECT Id, Captcha_Type__c, Progress_Indicator__c, Name
    //                 FROM Form__c
    //                 where Id = :id];
    //     } catch (Exception e){
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    @AuraEnabled
    public static Form_Page__c pageDetails(Id FormId, Id PageId){
        try{
            return [SELECT Id, Name, Page_Number__c
                    from Form_Page__c
                    where Id = :PageId];
        } catch (Exception e){
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    // add by yash
    @AuraEnabled
    public static string editFormSubmit(String id, String name, String progressIn, String captcha){
        try{
            Form__c editForm = [SELECT Id, Captcha_Type__c, Progress_Indicator__c, Name
                                FROM Form__c
                                where Id = :id];
            if (captcha == 'None'){
                editForm.Captcha_Type__c = '';
            } else{
                editForm.Captcha_Type__c = captcha;
            }

            if (progressIn == 'None'){
                editForm.Progress_Indicator__c = '';
            } else{
                editForm.Progress_Indicator__c = progressIn;
            }
            editForm.Name = name;
            update editForm;
            return 'saved successfully';
        } catch (Exception e){
            error_handler.insert_errordata(e, 'FormBuilderController', 'editFormSubmit');
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static referencewrapper getreferencevalue(Id id, String searchkey){
        try{
            String searchkeyword = '%' + searchkey + '%';
            String Query;
            Form_Fields__c MappedObject = [SELECT Id, Mapped_Obj__c, Field_Mapping__c
                                           FROM Form_Fields__c
                                           WHERE Id = :id];
            String mappedfield = MappedObject.Field_Mapping__c.split('<!@!>')[0];
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(MappedObject.Mapped_Obj__c).getDescribe().fields.getMap().get(mappedfield).getDescribe();
            String Objects;
            for (Schema.SObjectType reference : f.getReferenceTo()){
                Objects = reference.getDescribe().getName();
            }
            if (searchkey == null || searchkey == 'undefined' || searchkey == ''){
                Query = 'SELECT Id, Name FROM ' + Objects + ' Limit 1000';
            } else{
                Query = 'SELECT Id, Name FROM ' + Objects + ' WHERE Name LIKE :searchkeyword';
            }
            List<sObject> ObjectRecords = Database.query(Query);

            referencewrapper rw = new referencewrapper();
            rw.referenceval = ObjectRecords;

            // Set<String> objectset = new Set<String>{ 'Account', 'Address', 'AlternativePaymentMethod', 'Announcement', 'AppAnalyticsQueryRequest', 'AppointmentTopicTimeSlot', 'ApptBundleAggrDurDnscale', 'ApptBundleAggrPolicy', 'ApptBundleConfig', 'ApptBundlePolicy', 'ApptBundlePolicySvcTerr', 'ApptBundlePropagatePolicy', 'ApptBundleRestrictPolicy', 'ApptBundleSortPolicy', 'Asset', 'AssetDowntimePeriod', 'AssetRelationship', 'AssetWarranty', 'AssociatedLocation', 'AttributeDefinition', 'AuthorizationForm', 'AuthorizationFormConsent', 'AuthorizationFormDataUse', 'AuthorizationFormText', 'BusinessBrand', 'CalendarView', 'Campaign', 'CampaignMember', 'CardPaymentMethod', 'Case', 'CollaborationGroup', 'CollaborationGroupRecord', 'CommSubscription', 'CommSubscriptionChannelType', 'CommSubscriptionConsent', 'CommSubscriptionTiming', 'ConsumptionRate', 'ConsumptionSchedule', 'Contact', 'ContactPointAddress', 'ContactPointConsent', 'ContactPointEmail', 'ContactPointPhone', 'ContactPointTypeConsent', 'ContactRequest', 'ContentVersion', 'Contract', 'ContractGroupPlan', 'ContractGroupPlanGroupClass', 'ContractLineItem', 'Customer', 'DataUseLegalBasis', 'DataUsePurpose', 'DigitalWallet', 'DuplicateRecordItem', 'DuplicateRecordSet', 'EngagementChannelType', 'Entitlement', 'EntitlementContact', 'Error_Handler__c', 'Event', 'Expense', 'ExpenseReport', 'ExpenseReportEntry', 'ExpressionFilter', 'ExpressionFilterCriteria', 'FinanceTransaction', 'FlowRecordRelation', 'GroupCensus', 'GroupCensusMember', 'GroupCensusMemberPlan', 'GroupClass', 'GroupClassContribution', 'Idea', 'Image', 'Individual', 'InsuranceContract', 'JobProfile', 'Lead', 'LegalEntity', 'ListEmail', 'ListEmailIndividualRecipient', 'ListEmailRecipientSource', 'Location', 'LocationGroup', 'LocationGroupAssignment', 'Macro', 'MacroInstruction', 'MaintenanceAsset', 'MaintenancePlan', 'MaintenanceWorkRule', 'Opportunity', 'Order', 'OrgMetric', 'OrgMetricScanResult', 'OrgMetricScanSummary', 'PartyConsent', 'Payment', 'PaymentAuthAdjustment', 'PaymentAuthorization', 'PaymentGateway', 'PaymentGatewayLog', 'PaymentGroup', 'PaymentLineInvoice', 'Pricebook2', 'ProcessException', 'Product2', 'ProductConsumed', 'ProductConsumptionSchedule', 'ProductItem', 'ProductRequest', 'ProductRequestLineItem', 'ProductRequired', 'ProductServiceCampaign', 'ProductServiceCampaignItem', 'ProductTransfer', 'ProductWarrantyTerm', 'ProfileSkill', 'ProfileSkillEndorsement', 'ProfileSkillUser', 'PromptAction', 'PromptError', 'QuickText', 'Recommendation', 'RecommendationResponse', 'RecordAction', 'Refund', 'RefundLinePayment', 'ResourceAbsence', 'ReturnOrder', 'ReturnOrderLineItem', 'SchedulingConstraint', 'Scorecard', 'ScorecardAssociation', 'ScorecardMetric', 'SearchPromotionRule', 'Seller', 'SerializedProduct', 'ServiceAppointment', 'ServiceContract', 'ServiceCrew', 'ServiceCrewMember', 'ServiceResource', 'ServiceResourcePreference', 'ServiceTerritory', 'ServiceTerritoryLocation', 'SetupAssistantStep', 'Shift', 'ShiftTemplate', 'Shipment', 'ShipmentItem', 'Solution', 'Task', 'TimeSheet', 'TimeSheetEntry', 'TravelMode', 'UnitOfMeasure', 'UserEmailPreferredPerson', 'WarrantyTerm', 'WorkAccess', 'WorkBadge', 'WorkBadgeDefinition', 'WorkOrder', 'WorkOrderLineItem', 'WorkPlan', 'WorkPlanSelectionRule', 'WorkPlanTemplate', 'WorkPlanTemplateEntry', 'WorkStep', 'WorkStepTemplate', 'WorkThanks', 'WorkType', 'WorkTypeGroup', 'WorkTypeGroupMember' };
            Map<String, String> objectIconMap = new Map<String, String>{ 'Account' => 'standard:account', 'Address' => 'standard:address', 'AlternativePaymentMethod' => 'standard:payment_gateway', 'Announcement' => 'standard:announcement', 'AppAnalyticsQueryRequest' => 'standard:care_request_reviewer', 'AppointmentTopicTimeSlot' => 'standard:timeslot', 'ApptBundleAggrDurDnscale' => 'standard:event', 'ApptBundleAggrPolicy' => 'standard:aggregation_policy', 'ApptBundleConfig' => 'standard:bundle_config', 'ApptBundlePolicy' => 'standard:bundle_policy', 'ApptBundlePolicySvcTerr' => 'standard:service_territory_policy', 'ApptBundlePropagatePolicy' => 'standard:propagation_policy', 'ApptBundleRestrictPolicy' => 'standard:restriction_policy', 'ApptBundleSortPolicy' => 'standard:sort_policy', 'Asset' => 'standard:asset_object', 'AssetDowntimePeriod' => 'standard:asset_downtime_period', 'AssetRelationship' => 'standard:asset_relationship', 'AssetWarranty' => 'standard:asset_warranty', 'AssociatedLocation' => 'standard:location', 'AttributeDefinition' => 'standard:variation_attribute_setup', 'AuthorizationForm' => 'standard:form', 'AuthorizationFormConsent' => 'standard:form', 'AuthorizationFormDataUse' => 'standard:form', 'AuthorizationFormText' => 'standard:form', 'BusinessBrand' => 'standard:store', 'CalendarView' => 'standard:date_input', 'Campaign' => 'standard:campaign', 'CampaignMember' => 'standard:campaign_members', 'CardPaymentMethod' => 'standard:contract_payment', 'Case' => 'standard:case', 'CollaborationGroup' => 'standard:live_chat', 'CollaborationGroupRecord' => 'standard:live_chat', 'CommSubscription' => 'standard:product_consumed', 'CommSubscriptionChannelType' => 'standard:channel_program_levels', 'CommSubscriptionConsent' => 'standard:product_consumed', 'CommSubscriptionTiming' => 'standard:channel_program_history', 'ConsumptionRate' => 'standard:product_consumed_state', 'ConsumptionSchedule' => 'standard:product_consumed_state', 'Contact' => 'standard:contact', 'ContactPointAddress' => 'standard:address', 'ContactPointConsent' => 'standard:address', 'ContactPointEmail' => 'standard:email', 'ContactPointPhone' => 'standard:call', 'ContactPointTypeConsent' => 'standard:contact', 'ContactRequest' => 'standard:contact_request', 'ContentVersion' => 'standard:file', 'Contract' => 'standard:contract', 'ContractGroupPlan' => 'standard:contract', 'ContractGroupPlanGroupClass' => 'standard:contract', 'ContractLineItem' => 'standard:contract_line_item', 'Customer' => 'standard:customer', 'DataUseLegalBasis' => 'standard:product_consumed', 'DataUsePurpose' => 'standard:product_consumed', 'DigitalWallet' => 'standard:connect_wallet', 'DuplicateRecordItem' => 'custom:custom49', 'DuplicateRecordSet' => 'standard:record', 'EngagementChannelType' => 'standard:channel_programs', 'Entitlement' => 'standard:entitlement', 'EntitlementContact' => 'standard:people', 'Event' => 'standard:event', 'Expense' => 'standard:expense', 'ExpenseReport' => 'standard:expense_report', 'ExpenseReportEntry' => 'standard:expense_report_entry', 'ExpressionFilter' => 'standard:filter', 'ExpressionFilterCriteria' => 'standard:filter_criteria', 'FinanceTransaction' => 'standard:crypto_transaction', 'FlowRecordRelation' => 'standard:flow', 'GroupCensus' => 'standard:groups', 'GroupCensusMember' => 'standard:groups', 'GroupCensusMemberPlan' => 'standard:groups', 'GroupClass' => 'standard:groups', 'GroupClassContribution' => 'standard:groups', 'Idea' => 'standard:solution', 'Image' => 'custom:custom38', 'Individual' => 'standard:individual', 'InsuranceContract' => 'standard:entitlement_policy', 'JobProfile' => 'standard:job_profile', 'Lead' => 'standard:lead', 'LegalEntity' => 'standard:entity', 'ListEmail' => 'standard:list_email', 'ListEmailIndividualRecipient' => 'standard:email', 'ListEmailRecipientSource' => 'standard:email', 'Location' => 'standard:location', 'LocationGroup' => 'standard:location', 'LocationGroupAssignment' => 'standard:location', 'Macro' => 'standard:macros', 'MacroInstruction' => 'standard:macros', 'MaintenanceAsset' => 'standard:maintenance_asset', 'MaintenancePlan' => 'standard:maintenance_plan', 'MaintenanceWorkRule' => 'standard:maintenance_work_rule', 'Opportunity' => 'standard:opportunity', 'Order' => 'standard:orders', 'OrgMetric' => 'standard:dashboard', 'OrgMetricScanResult' => 'standard:dashboard_ea', 'OrgMetricScanSummary' => 'standard:dashboard_component', 'PartyConsent' => 'custom:custom69', 'Payment' => 'standard:contract_payment', 'PaymentAuthAdjustment' => 'standard:contract_payment', 'PaymentAuthorization' => 'standard:contract_payment', 'PaymentGateway' => 'standard:payment_gateway', 'PaymentGatewayLog' => 'standard:payment_gateway', 'PaymentGroup' => 'standard:partner_fund_request', 'PaymentLineInvoice' => 'standard:payment_gateway', 'Pricebook2' => 'standard:pricebook', 'ProcessException' => 'standard:process_exception', 'Product2' => 'standard:product', 'ProductConsumed' => 'standard:product_consumed', 'ProductConsumptionSchedule' => 'standard:product_consumed', 'ProductItem' => 'standard:product_item', 'ProductRequest' => 'standard:product_request', 'ProductRequestLineItem' => 'standard:product_request_line_item', 'ProductRequired' => 'standard:product_required', 'ProductServiceCampaign' => 'standard:product_service_campaign', 'ProductServiceCampaignItem' => 'standard:product_service_campaign_item', 'ProductTransfer' => 'standard:product_transfer', 'ProductWarrantyTerm' => 'standard:product_warranty_term', 'ProfileSkill' => 'standard:skill', 'ProfileSkillEndorsement' => 'standard:skill_entity', 'ProfileSkillUser' => 'standard:skill_entity', 'PromptAction' => 'standard:prompt', 'PromptError' => 'standard:prompt', 'QuickText' => 'standard:quick_text', 'Recommendation' => 'standard:feedback', 'RecommendationResponse' => 'standard:feedback', 'RecordAction' => 'standard:record', 'Refund' => 'standard:contract_payment', 'RefundLinePayment' => 'standard:contract_payment', 'ResourceAbsence' => 'standard:resource_absence', 'ReturnOrder' => 'standard:return_order', 'ReturnOrderLineItem' => 'standard:return_order_line_item', 'SchedulingConstraint' => 'standard:scheduling_constraint', 'Scorecard' => 'standard:scan_card', 'ScorecardAssociation' => 'standard:scan_card', 'ScorecardMetric' => 'standard:scan_card', 'SearchPromotionRule' => 'standard:search', 'Seller' => 'standard:partner_fund_allocation', 'SerializedProduct' => 'standard:serialized_product', 'ServiceAppointment' => 'standard:service_appointment', 'ServiceContract' => 'standard:service_contract', 'ServiceCrew' => 'standard:service_crew', 'ServiceCrewMember' => 'standard:service_crew_member', 'ServiceResource' => 'standard:service_resource', 'ServiceResourcePreference' => 'standard:service_territory', 'ServiceTerritory' => 'standard:service_territory', 'ServiceTerritoryLocation' => 'standard:location', 'SetupAssistantStep' => 'standard:setup_modal', 'Shift' => 'standard:shift', 'ShiftTemplate' => 'standard:shift_template', 'Shipment' => 'standard:shipment', 'ShipmentItem' => 'standard:shipment', 'Solution' => 'standard:solution', 'Task' => 'standard:task', 'TimeSheet' => 'standard:timesheet', 'TimeSheetEntry' => 'standard:timesheet_entry', 'TravelMode' => 'standard:location', 'UnitOfMeasure' => 'custom:custom79', 'UserEmailPreferredPerson' => 'standard:people', 'WarrantyTerm' => 'standard:warranty_term', 'WorkAccess' => 'standard:work_queue', 'WorkBadge' => 'standard:skill_requirement', 'WorkBadgeDefinition' => 'standard:skill_requirement', 'WorkOrder' => 'standard:work_order', 'WorkOrderLineItem' => 'standard:work_order_item', 'WorkPlan' => 'standard:work_plan', 'WorkPlanSelectionRule' => 'standard:work_plan_rule', 'WorkPlanTemplate' => 'standard:work_plan_template', 'WorkPlanTemplateEntry' => 'standard:work_plan_template_entry', 'WorkStep' => 'standard:work_step', 'WorkStepTemplate' => 'standard:work_step_template', 'WorkThanks' => 'standard:thanks', 'WorkType' => 'standard:work_type', 'WorkTypeGroup' => 'standard:work_type_group', 'WorkTypeGroupMember' => 'standard:team_member' };

            if (objectIconMap.containsKey(Objects)){
                rw.objicon = objectIconMap.get(Objects);
            } else{
                rw.objicon = 'custom:custom3';
            }

            return rw;
        } catch (Exception e){
            // error_handler.insert_errordata(e,'FormBuilderController','getreferencevalue');
            return null;
            // throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, String> getpicklistvalue(Id id){
        try{

            Form_Fields__c MappedObject = [SELECT Id, Mapped_Obj__c, Field_Mapping__c
                                           FROM Form_Fields__c
                                           WHERE Id = :id];
            String mappedfield = MappedObject.Field_Mapping__c.split('<!@!>')[0];
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Set<String> objectKeys = gd.keySet();
            Map<String, String> picklistvalue = new Map<String, String>();

            //Iterate through all objects to locate ACCOUNT Object

            Schema.SObjectType systemObjectType = gd.get(MappedObject.Mapped_Obj__c);
            Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
            Map<String, Schema.SObjectField> M = r.fields.getMap();
            Set<String> fieldNames = M.keySet();
            Schema.SObjectField field = M.get(mappedfield);
            Schema.DescribeFieldResult fieldDesc = field.getDescribe();


            //extract the picklist values
            // System.debug(fieldDesc.getPicklistValues() + ' ::::::::::::::::::::::::::::::::::: ') ;
            for (Integer i = 0; i < fieldDesc.getPicklistValues().size(); i++){
                picklistvalue.put(fieldDesc.getPicklistValues()[i].getLabel(), fieldDesc.getPicklistValues()[i].getValue());
            }


            return picklistvalue;
        } catch (Exception e){
            // throw new AuraHandledException(e.getMessage());
            // error_handler.insert_errordata(e,'FormBuilderController','getpicklistvalue');
            return null;
        }
    }

    @AuraEnabled
    public static String signatureSave(String fieldId, String fieldData){
        try{
            // Form_Fields__c formField = [SELECT Id, Form__c
            //                             FROM Form_Fields__c
            //                             WHERE Id = :fieldId];
            String s = fieldData.replaceFirst('data:image/png;base64,', '');
            ContentVersion conVer = new ContentVersion();
            conVer.title = 'signature1456';
            conVer.versionData = EncodingUtil.base64decode(s);
            conVer.PathOnClient = 'signature16.png';
            insert conVer;
            System.debug('yash shsh');

            String contentId = [select id, ContentDocumentId
                                from ContentVersion
                                WHERE Id = :conVer.Id].ContentDocumentId;
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = contentId;
            cl.LinkedEntityId = fieldId;
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            insert cl;
            System.debug('yash shsh tests' + contentId);

            // return contentId;
            return conVer.Id;
        } catch (Exception e){
            // GenericException Exp = ExceptionHandler.logException(e, 'QFFormFieldComponentController', 'signatureSave');
            System.debug('error :-' + e);
            return null;
        }
    }

    @AuraEnabled
    public static String SaveFile(String fieldId, String fileName, String base64Data, String contentType){
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.IsMajorVersion = true;
            Insert cv;

            // Form_Fields__c formField = [SELECT Id, Form__c
            //                             FROM Form_Fields__c
            //                             WHERE Id = :fieldId];
            String conDocId = [SELECT ContentDocumentId
                               FROM ContentVersion
                               WHERE Id = :cv.Id].ContentDocumentId;
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = conDocId;
            // cl.LinkedEntityId = formField.Form__c;
            cl.LinkedEntityId = fieldId;
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            insert cl;

            return cv.Id;
        } catch (Exception e){
            // GenericException Exp = ExceptionHandler.logException(e, 'QFFormFieldComponentController', 'SaveFile');
            // error_handler.insert_errordata(e,'FormBuilderController','SaveFile');
            return null;
        }
    }

    public class referencewrapper{
        @AuraEnabled
        public list<SObject> referenceval{ get; set; }

        @AuraEnabled
        public String objicon{ get; set; }

    }

    @AuraEnabled
    public static List<Form_Fields__c> getFieldsRecords_page(Id id){
        try{
            List<Form_Fields__c> page_fild_list = [SELECT Name, Field_Mapping__c, Field_Validations__c
                                                   From Form_Fields__c
                                                   where Form_Page__c = :ID];

            return page_fild_list;

        } catch (Exception e){
            // throw new AuraHandledException(e.getMessage());
            // error_handler.insert_errordata(e,'FormBuilderController','getreferencevalue');
            return null;
        }
    }

    @AuraEnabled
    public static List<Form__c> GetFormObject(String id){
        try{
            List<Form__c> form_obj = [SELECT Mapped_Objects__c
                                      From Form__c
                                      where ID = :Id];

            return form_obj;

        } catch (Exception e){
            // throw new AuraHandledException(e.getMessage());
            // error_handler.insert_errordata(e,'FormBuilderController','getreferencevalue');
            return null;
        }
    }

    @AuraEnabled
    public static SubId createrecord(Form_Submission__c acc, SObject first_obj_list, String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list){
        // public static void createrecord(Account acc){
        try{
            // System.debug('yasj ' + acc);
            // System.debug('yasj first_obj_list' + first_obj_list);
            // System.debug(acc.name);
            // System.debug('sigdid list:- '+sig_upload_fid_list);
            // System.debug('fildid list:- '+file_upload_fid_list);
            // System.debug(acc.name);
            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sig_upload_map = new Map<String, Object>();
            // System.debug('test sing json '+file_upload_jsone);
            // System.debug('test file json '+file_upload_jsone);
            Map<String, Object> sig_map = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            // System.debug(sig_upload_jsone);
            // System.debug(sig_upload_jsone);
            insert acc;
            insert first_obj_list;
            String sub_id = acc.Id;

            // if (sin_id != 'undefined' || sin_id != '' || sin_id != null){
            //     signatureid = signatureSave(sub_id, sin_id);
            //     System.debug('test nimit :- ' + signatureid);
            // }
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0) {
                for (String sig_type : sig_upload_fid_list) {
                    String sig_baseid = (String)sig_map.get(sig_type);
                    // fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    signatureid = signatureSave(sub_id, sig_baseid);
                    System.debug('aftre :- '+signatureid);
                    sig_upload_map.put(sig_type,signatureid);
            }
                System.debug('finel id :- '+sig_upload_map);
            }

            Integer list_len = file_upload_fid_list.size();
            if (list_len > 0) {
                for (String type : file_upload_fid_list) {
                    String[] address = type.split('<!QF!>');
                    String f_name = address[1];
                    String f_type = address[2];
                    String baseid = (String)m.get(type);
                    fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    System.debug('aftre :- '+fildid);
                    file_upload_map.put(address[0],fildid);
                }
                System.debug('finel id :- '+file_upload_map);
            }
            SubId ids = new SubId();
            ids.SubmissionId = acc.Id;
            ids.SignatureId = signatureid;
                ids.Sig_upload_map = sig_upload_map;
                ids.File_upload_map = file_upload_map;
            // System.debug('idsss :-'+ids);
            // insert ids;
            return ids;
        } catch (Exception e){
            System.debug('error --> ' + e);
            // error_handler.insert_errordata(e,'FormBuilderController','createrecord');
            return null;
        }
    }

    @AuraEnabled
    public static SubId createrecord_for_secod_object(Form_Submission__c acc, SObject first_obj_list, SObject list_second_obj,String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list){
        try{
            System.debug('yasj ' + acc);
            System.debug(acc.name);
            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sig_upload_map = new Map<String, Object>();
            Map<String, Object> sig_map = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            insert acc;
            // System.debug('yasj first_obj_list' + first_obj_list);
            insert first_obj_list;
            // System.debug('yasj first_obj_list' + list_second_obj);
            // Contact acctest = new Contact();
            // acctest.AccountId =first_obj_list.id;
            // list_second_obj.add(acctest);
            // List<sobject> tasks = new List<sobject>();
            // tasks.AccountId=first_obj_list.id;
            // // list_second_obj.'AccountId' =first_obj_list.id;
            insert list_second_obj;
            String sub_id = acc.Id;
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0) {
                for (String sig_type : sig_upload_fid_list) {
                    String sig_baseid = (String)sig_map.get(sig_type);
                    // fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    signatureid = signatureSave(sub_id, sig_baseid);
                    System.debug('aftre :- '+signatureid);
                    sig_upload_map.put(sig_type,signatureid);
                }
                System.debug('finel id :- '+sig_upload_map);
            }

            Integer list_len = file_upload_fid_list.size();
            if (list_len > 0) {
                for (String type : file_upload_fid_list) {
                    String[] address = type.split('<!QF!>');
                    String f_name = address[1];
                    String f_type = address[2];
                    String baseid = (String)m.get(type);
                    fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    System.debug('aftre :- '+fildid);
                    file_upload_map.put(address[0],fildid);
                }
                System.debug('finel id :- '+file_upload_map);
            }
            SubId ids = new SubId();
            ids.SubmissionId = acc.Id;
            ids.SignatureId = signatureid;
            ids.Sig_upload_map = sig_upload_map;
            ids.File_upload_map = file_upload_map;
            return ids;
        } catch (Exception e){
            System.debug('error --> ' + e);
            // error_handler.insert_errordata(e,'FormBuilderController','createrecord_for_secod_object');
            return null;
        }
    }

    @AuraEnabled
    public static SubId createrecord_for_third_object(Form_Submission__c acc, SObject first_obj_list, SObject list_second_obj, SObject list_third_obj,String sig_upload_jsone, List<String> sig_upload_fid_list, String file_upload_jsone, List<String> file_upload_fid_list){
        try{
            System.debug('yasj ' + acc);
            System.debug('yasj first_obj_list' + first_obj_list);
            System.debug(acc.name);
            String signatureid;
            String fildid;
            Map<String, Object> file_upload_map = new Map<String, Object>();
            Map<String, Object> sig_upload_map = new Map<String, Object>();
            Map<String, Object> sig_map = (Map<String, Object>)JSON.deserializeUntyped(sig_upload_jsone);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(file_upload_jsone);
            insert acc;
            insert first_obj_list;
            insert list_second_obj;
            insert list_third_obj;
            String sub_id = acc.Id;
            Integer sig_list_len = sig_upload_fid_list.size();
            if (sig_list_len > 0) {
                for (String sig_type : sig_upload_fid_list) {
                    String sig_baseid = (String)sig_map.get(sig_type);
                    // fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    signatureid = signatureSave(sub_id, sig_baseid);
                    System.debug('aftre :- '+signatureid);
                    sig_upload_map.put(sig_type,signatureid);
                }
                System.debug('finel id :- '+sig_upload_map);
            }

            Integer list_len = file_upload_fid_list.size();
            if (list_len > 0) {
                for (String type : file_upload_fid_list) {
                    String[] address = type.split('<!QF!>');
                    String f_name = address[1];
                    String f_type = address[2];
                    String baseid = (String)m.get(type);
                    fildid = SaveFile(sub_id, f_name, baseid, f_type);
                    System.debug('aftre :- '+fildid);
                    file_upload_map.put(address[0],fildid);
                }
                System.debug('finel id :- '+file_upload_map);
            }
            
            SubId ids = new SubId();
            ids.SubmissionId = acc.Id;
            ids.SignatureId = signatureid;
            ids.Sig_upload_map = sig_upload_map;
            ids.File_upload_map = file_upload_map;
            return ids;
        } catch (Exception e){
            System.debug('error --> ' + e);
            // error_handler.insert_errordata(e,'FormBuilderController','createrecord_for_third_object');
            return null;
        }
    }

    @AuraEnabled
    public static List<Form_Fields__c> GetFormValidation(String form_id){
        try{
            List<Form_Fields__c> form_val_list = [SELECT Field_Mapping__c, Field_Validations__c
                                                  FROM Form_Fields__c
                                                  WHERE Form__c = :form_id];

            return form_val_list;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String update_ext_list(String acc2, String submit_id){
        // public static void createrecord(Account acc){
        try{
            System.debug('firsttttt');
            System.debug('firsttttt' + submit_id);
            Form_Submission__c form_sub = [SELECT Other_fields_data__c
                                           FROM Form_Submission__c
                                           WHERE Id = :submit_id];
            System.debug('firsttttt' + acc2);
            System.debug('firsttttt sql list' + form_sub);
            // form_sub.Other_fields_data__c = string.valueOf(acc2);
            form_sub.Other_fields_data__c = acc2;

            update form_sub;
            System.debug('adddd');
            return null;

        } catch (Exception e){
            System.debug('error --> ' + e);
            return null;
        }
    }

    public class SubId{
        @AuraEnabled
        public String SubmissionId{ get; set; }

        @AuraEnabled
        public String SignatureId{ get; set; }

        @AuraEnabled
        public Map<String,Object> Sig_upload_map { get; set; }

        @AuraEnabled
        public Map<String,Object> File_upload_map { get; set; }

        

    }

}