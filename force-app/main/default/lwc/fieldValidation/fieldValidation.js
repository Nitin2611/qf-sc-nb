import { api, LightningElement, track } from 'lwc';
import fieldcancel from '@salesforce/resourceUrl/fieldcancel';
import fielddelete from '@salesforce/resourceUrl/fielddelete';
import fieldsave from '@salesforce/resourceUrl/fieldsave';
import fieldduplicate from '@salesforce/resourceUrl/fieldduplicate';
import deletefield from '@salesforce/apex/fieldvalidation.deletefield';
import savevalidation from '@salesforce/apex/fieldvalidation.savevalidation';
import getfieldvalidation from '@salesforce/apex/fieldvalidation.getfieldvalidation';
import copyfield from '@salesforce/apex/fieldvalidation.copyfield';


export default class FieldValidation extends LightningElement {
    mainbody = true;
    shorttextoptions = false;
    shorttextprefix = false;
    longtextoptions = false;
    dropdownchoices = false;
    numberoptions = false;
    numberprefix= false;
    emailoptions= true;
    priceoption = false;
    nameoptions = false;
    
    scaleratinghelptext= false;
    scaleratingoptions = false;
    termsofservice = false;
    editterms= false;
    linkoptions = false;

    formedit= false;
    pageedit= false;
    @api tab;
    @api fieldId;
    @track fieldName = '';
    d = true;
    @api labelvalue;
    @track helptext = '';
    @track placeholdervalue = '';
    @track prefixvalue ='';
    @track decimal;
    @track helptextcheck = false;
    @track labelcheck = true;
    @track isRequiredcheck = false;
    @track isdisabledcheck = false;
    @track placeholdercheck = false;
    @track readonlycheck = false
    @track prefixcheck = false;
    @track richtextinput = false;
    @track FieldValidation = [];
    @track Richtextvalue;
    @track minimumvalue = 0;
    @track maximumvalue = 128;
    @track salutation = [];
    @track salutationindex = 0;
    @track salutationvalue = [];
    @track validation = [];
    @track fieldtype;
    @track maximumdate;
    @track minimumdate;
    spinnerDataTable;

    fieldcancel = fieldcancel;
    fieldduplicate = fieldduplicate;
    fieldsave = fieldsave;
    fielddelete = fielddelete;

    @api
    get field(){
        if(this.fieldtype == 'Extra'){
        let mydata1 = {data:[{Name:this.fieldName}]};
        mydata1.data.forEach(element => {
            if (element.Name == 'QFPHONE') {element.QFPHONE = true} 
            else if(element.Name == 'QFFULLNAME') {element.QFFULLNAME = true}
            else if(element.Name == 'QFADDRESS') {element.QFADDRESS = true}
            else if(element.Name == 'QFNAME') {element.QFNAME = true}
            else if(element.Name == 'QFEMAILID') {element.QFEMAILID = true}
            else if(element.Name == 'QFNUMBER') {element.QFNUMBER = true}
            else if(element.Name == 'QFPRICE') {element.QFPRICE = true}
            else if(element.Name == 'QFRADIOBUTTON') {element.QFRADIOBUTTON = true}
            else if(element.Name == 'QFCHECKBOX') {element.QFCHECKBOX = true}
            else if(element.Name == 'QFRICHTEXT') {element.QFRICHTEXT = true}
            else if(element.Name == 'QFLONGTEXT') {element.QFLONGTEXT = true}
            else if(element.Name == 'QFSHORTTEXT') {element.QFSHORTTEXT = true}
            else if(element.Name == 'QFFILEUPLOAD') {element.QFFILEUPLOAD = true}
            else if(element.Name == 'QFTERMSOFSERVICE') {element.QFTERMSOFSERVICE = true}
            else if(element.Name == 'QFSIGNATURE') {element.QFSIGNATURE = true}
            else if(element.Name == 'QFLINK') {element.QFLINK = true}
            else if(element.Name == 'QFDATE') {element.QFDATE = true}
            else if(element.Name == 'QFTIME') {element.QFTIME = true}
            else if(element.Name == 'QFDATETIME') {element.QFDATETIME = true}
            else if(element.Name == 'QFRATING') {element.QFRATING = true}
            else if(element.Name == 'QFEMOJIRATING') {element.QFEMOJIRATING = true}
            else if(element.Name == 'QFSCALERATING') {element.QFSCALERATING = true}
        });
        return mydata1;
    }
    else{
        let mydata1 = {data:[{Name:this.fieldtype}]};
        mydata1.data.forEach(element => {
            if (element.Name == 'PHONE') {element.QFPHONE = true} 
            else if(element.Name == 'STRING' || element.Name == 'TEXTAREA' || element.Name == 'EMAIL' || element.Name == 'ENCRYPTEDSTRING') {element.QFEMAILID = true}
            else if(element.Name == 'DOUBLE' || element.Name == 'CURRENCY' || element.Name == 'PERCENT') {element.QFNUMBER = true}
            else if(element.Name == 'DATE') {element.QFDATE = true}
            else if(element.Name == 'TIME') {element.QFTIME = true}
            else if(element.Name == 'DATETIME') {element.QFDATETIME = true}
        });
        return mydata1; 
    }
    }
    @api
    openvalidation(tab, fieldId, fieldName){
        this.fieldtype = fieldName.split(',')[1];
        this.tab = tab;
        this.fieldId = fieldId;
        this.fieldName = fieldName.slice(0, fieldName.indexOf(','));
        this.isRequiredcheck = false;
        this.isdisabledcheck = false;
        this.helptextcheck = false;
        this.placeholdercheck = false;
        this.readonlycheck= false;
        this.labelcheck = false;
        this.labelvalue = '';
        this.helptext = '';
        this.placeholdervalue = '';
        this.fieldValidation = [];
        this.salutationvalue = [];
        this.salutation = [];
        this.salutationindex = 0;
        this.maximumdate ='';
        this.minimumdate ='';
        // this.spinnerDataTable = true;
        getfieldvalidation({fieldId:this.fieldId}).then(result =>{ 
                       
            let str = result.split('?$`~');
            for(let i = 0; i<str.length; i++){
               let Arr = str[i].split(':');
               let labels = Arr[0];
               let value = Arr[1];
               if(labels == 'isRequired'){
                this.isRequiredcheck = JSON.parse(value);
               }
               else if(labels == 'isDisabled'){
                this.isdisabledcheck = JSON.parse(value);
               }
               else if(labels == 'isLabel'){
                this.labelcheck = JSON.parse(value);
               }
               else if(labels == 'isHelpText'){
                this.helptextcheck = JSON.parse(value);
               }
               else if(labels == 'isPlaceholder'){
                this.placeholdercheck = JSON.parse(value);
               }
               else if(labels == 'isReadonly'){
                this.readonlycheck = JSON.parse(value);
               }
               else if(labels == 'isReadonly'){
                this.readonlycheck = JSON.parse(value);
               }
               else if(labels == 'isPrefix'){
                this.prefixcheck = JSON.parse(value);
               }
               else if(labels == 'Prefix'){
                this.prefixvalue = value;
               }
               else if(labels == 'Label'){
                this.labelvalue = value;
               }
               else if(labels == 'HelpText'){
                this.helptext = value;
               }
               else if(labels == 'Placeholder'){
                this.placeholdervalue = value;
               }
               else if(labels == 'Salutation'){
                this.salutationvalue.push(value);
               }
               else if(labels == 'MinimumDateTime'){
              this.minimumdate = value;
               }
               else if(labels == 'MaximumDateTime'){
                this.maximumdate = value;
               }
               else if(labels == 'MinimumDate'){
                this.minimumdate = value;
               }
               else if(labels == 'MaximumDate'){
                this.maximumdate = value;
               }
               else if(labels == 'MinimumTime'){
                this.minimumdate = value;
               }
               else if(labels == 'MaximumTime'){
                this.maximumdate = value;
               }
            }
            this.opensalutation();
            this.spinnerDataTable = false;
           })
    }

    validatingbtnhandle(event){

        if(event.currentTarget.dataset.title == 'Close'){
            event.preventDefault();
            const selectEvent = new CustomEvent('closevalidation', {
                detail: this.tab
            });
            this.dispatchEvent(selectEvent);
        }
        else if(event.currentTarget.dataset.title == 'Delete'){
            deletefield({fieldId:this.fieldId})
            .then(result => {
                event.preventDefault();
                const deleteEvent = new CustomEvent('updatefields', {
                    detail: this.fieldName
                });
                this.dispatchEvent(deleteEvent);

                const selectEvent = new CustomEvent('closevalidation', {
                    detail: this.tab
                });
                this.dispatchEvent(selectEvent);
            })
            .catch(error => {
                console.log(error);
            });
        }
        else if(event.currentTarget.dataset.title == 'Save'){
            this.fieldValidation = 'isRequired:'+this.isRequiredcheck+
                '?$`~isDisabled:'+ this.isdisabledcheck +
                '?$`~isLabel:'+this.labelcheck+
                '?$`~isHelpText:' +this.helptextcheck+
                '?$`~Label:'+ this.labelvalue+
                '?$`~HelpText:'+ this.helptext
            if(this.fieldtype == 'Extra'){
            if(event.currentTarget.dataset.name == "QFPHONE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue)
            }
            else if(event.currentTarget.dataset.name == "QFADDRESS"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isReadonly:'+ this.readonlycheck)
            }
            else if( event.currentTarget.dataset.name == "QFNAME"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+this.placeholdercheck + '?$`~Placeholder:'+ this.placeholdervalue)
            }
            else if(event.currentTarget.dataset.name == "QFEMAILID"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue +
                 '?$`~Minimum:' +this.minimumvalue + '?$`~Maximum:' + this.maximumvalue )                       
            }
            else if(event.currentTarget.dataset.name == "QFNUMBER"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue +
                '?$`~isPrefix:' +this.prefixcheck + '?$`~Prefix:' + this.prefixvalue )
            }
            else if(event.currentTarget.dataset.name == "QFFULLNAME"){
                for(let i = 0; i< this.salutationvalue.length; i++){
                this.fieldValidation = this.fieldValidation.concat('?$`~Salutation:'+ this.salutationvalue[i])
                }
            }
            else if(event.currentTarget.dataset.name == "QFPRICE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue+ '?$`~Decimal:'+ this.decimal)
            }
            else if(event.currentTarget.dataset.name == "QFLONGTEXT"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue)
            }
            else if(event.currentTarget.dataset.name == "QFRICHTEXT"){
                this.fieldValidation = this.fieldValidation.concat('?$`~Richtext:'+ this.Richtextvalue)
            }
            else if(event.currentTarget.dataset.name == "QFSHORTTEXT"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue +
                '?$`~isPrefix:' +this.prefixcheck + '?$`~Prefix:' + this.prefixvalue )
            }
            else if(event.currentTarget.dataset.name == "QFLINK"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue)
            }
            else if(event.currentTarget.dataset.name == "QFTERMSOFSERVICE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~Agreement:'+ this.Richtextvalue)
            }
            else if(event.currentTarget.dataset.name == "QFTIME"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumTime:'+ this.minimumdate + '?$`~MaximumTime:' + this.maximumdate)
            }
            else if(event.currentTarget.dataset.name == "QFDATETIME"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumDateTime:'+ this.minimumdate + '?$`~MaximumDateTime:' + this.maximumdate)
            }
            else if(event.currentTarget.dataset.name == "QFDATE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumDate:'+ this.minimumdate + '?$`~MaximumDate:' + this.maximumdate)
            }
            else if(event.currentTarget.dataset.name == "QFRADIOBUTTON"){
                for(let i = 0; i< this.salutationvalue.length; i++){
                    this.fieldValidation = this.fieldValidation.concat('?$`~Salutation:'+ this.salutationvalue[i])
                    }
            }
            else if(event.currentTarget.dataset.name == "QFCHECKBOX"){
                for(let i = 0; i< this.salutationvalue.length; i++){
                    this.fieldValidation = this.fieldValidation.concat('?$`~Salutation:'+ this.salutationvalue[i])
                    }
            }
            else if(event.currentTarget.dataset.name == "QFSCALERATING"){
                for(let i = 0; i< this.salutationvalue.length; i++){
                    this.fieldValidation = this.fieldValidation.concat('?$`~Salutation:'+ this.salutationvalue[i])
                    }
            }
        }
        else{
            if(this.fieldtype == "PHONE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue)
            }
            else if(this.fieldtype == "STRING" || this.fieldtype == "TEXTAREA" || this.fieldtype == "ENCRYPTEDSTRING" || this.fieldtype == "EMAIL" ){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue +
                 '?$`~Minimum:' +this.minimumvalue + '?$`~Maximum:' + this.maximumvalue )                       
            }
            else if(this.fieldtype == "NUMBER" || this.fieldtype == "CURRENCY" || this.fieldtype == "PERCENT"){
                this.fieldValidation = this.fieldValidation.concat('?$`~isPlaceholder:'+ this.placeholdercheck+'?$`~Placeholder:'+ this.placeholdervalue +
                '?$`~Minimum:' +this.minimumvalue + '?$`~Maximum:' + this.maximumvalue )
            }
            else if(this.fieldtype == "TIME"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumTime:'+ this.minimumdate + '?$`~MaximumTime:' + this.maximumdate)
            }
            else if(this.fieldtype == "DATETIME"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumDateTime:'+ this.minimumdate + '?$`~MaximumDateTime:' + this.maximumdate)
            }
            else if(this.fieldtype == "DATE"){
                this.fieldValidation = this.fieldValidation.concat('?$`~MinimumDate:'+ this.minimumdate + '?$`~MaximumDate:' + this.maximumdate)
            }
        }
            savevalidation({fieldId:this.fieldId, fieldValidation:JSON.stringify(this.fieldValidation)})
            .then(result => {
                event.preventDefault();
                const selectEvent = new CustomEvent('closevalidation', {
                    detail: this.tab
                });
                this.dispatchEvent(selectEvent);
            })
            .catch(error => {
                console.log(error);
            });
           
        }
        else if(event.currentTarget.dataset.title == 'Copy'){
            copyfield({fieldId:this.fieldId})
            .then(result => {
                event.preventDefault();
                const selectEvent = new CustomEvent('closevalidation', {
                    detail: this.tab
                });
                this.dispatchEvent(selectEvent);
            })
            .catch(error => {
                console.log(error);
            });
        }
    }

    get showlabel() {
        return [
            { label: 'Show', value: 'Show' },
            { label: 'Hide', value: 'Hide' },
        
        ];
    }
    get showdecimal(){
        return [
            { label: '0', value: '0' },
            { label: '0.00', value: '0.00' },
            { label: '0.000', value: '0.000' },
            { label: '0.0000', value: '0.0000' },
        ];
    }

    validatingvalue(event){
        if(event.currentTarget.dataset.title == 'Label'){
        this.labelvalue = event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'HelpText'){
            this.helptext = event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'PlaceHolder'){
            this.placeholdervalue = event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'Prefix'){
            this.prefixvalue = event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'Maximum'){
            this.maximumvalue =  event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'Minimum'){
            this.minimumvalue =  event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'MinimumDate'){
            this.minimumdate =  event.detail.value;
        }
        else if(event.currentTarget.dataset.title == 'MaximumDate'){
            this.maximumdate =  event.detail.value;
        }
    }

    handlevalidation(event){
        if(event.currentTarget.dataset.title == 'Label'){
                this.labelcheck = event.target.checked;;       
        }
        else if(event.currentTarget.dataset.title == 'HelpText'){
                this.helptextcheck = event.target.checked;;       
        }
        else if(event.currentTarget.dataset.title == 'PlaceHolder'){
                this.placeholdercheck = event.target.checked;
        }
        else if(event.currentTarget.dataset.title == 'Prefix'){
            this.prefixcheck = event.detail.checked;
        }
        else if(event.currentTarget.dataset.title == 'Decimal'){
            this.decimal = event.detail.value;
        }
        else if (event.currentTarget.dataset.title == 'RichText'){
            this.richtextinput = true;
        }
    }

    isRequired(event){
        this.isRequiredcheck = event.target.checked;
        if(this.isRequiredcheck == true){
            this.isdisabledcheck = false;
        }
    }

    isdisabled(event){
        this.isdisabledcheck = event.target.checked;
        if(this.isdisabledcheck == true){
            this.isRequiredcheck = false;
        }
    }
    RichTextData(event){
        this.Richtextvalue =  event.detail.value;
    }
    closerichtext(){
        this.richtextinput = false;
    }

    slider(event){
        if(event.currentTarget.dataset.title == 'Minimum'){
            if(event.detail.value < this.maximumvalue){
                this.minimumvalue =  event.detail.value;
            }
        }
        else if(event.currentTarget.dataset.title == 'Maximum'){
            if(event.detail.value > this.minimumvalue){
                this.maximumvalue =  event.detail.value;
            }
        }
        else if(event.currentTarget.dataset.title == 'Reset'){
            this.minimumvalue = 0;
            this.maximumvalue = 128;
        }
    }
    @api
    get salutations(){
       return this.salutation;
    }
    addsalutation(event){
        this.salutation.push({id : this.salutationindex , salutation: ''})
        this.salutationindex ++; 
    }
    opensalutation(){
        for(let i = 0; i < this.salutationvalue.length; i++){
        this.salutation.push({id : this.salutationindex , salutation: this.salutationvalue[i]})
        this.salutationindex ++; 
        }
    }
    deletesalutation(event){
        this.salutation.splice(event.currentTarget.dataset.id, 1);
        this.salutationvalue.splice(event.currentTarget.dataset.id, 1);
        this.salutationindex --;
        this.salutation = [];
        for (let index = 0; index < this.salutationindex; index++) {
            this.salutation.push({id : index , salutation: this.salutationvalue[index]});
        }
    }

    salutationvalues(event){
        this.salutationvalue[event.currentTarget.dataset.id] = event.detail.value;
        this.salutation[event.currentTarget.dataset.id] = ({id : event.currentTarget.dataset.id, salutation: this.salutationvalue[event.currentTarget.dataset.id]});
    }
    @api 
    get validations(){
        return this.validation;
    }
}