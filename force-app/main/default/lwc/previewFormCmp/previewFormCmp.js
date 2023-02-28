import { LightningElement,track,api } from 'lwc';

import GetFormPage from '@salesforce/apex/FormBuilderController.GetFormPage';
import getFieldsRecords from '@salesforce/apex/FormBuilderController.getFieldsRecords';
import getFormCSS from '@salesforce/apex/FormBuilderController.getFormCSS';
import getPageCSS from '@salesforce/apex/FormBuilderController.getPageCSS';
import getButtonCSS from '@salesforce/apex/FormBuilderController.getButtonCSS';
import getprogressbar from '@salesforce/apex/FormBuilderController.getprogressbar';
import getcaptcha from '@salesforce/apex/FormBuilderController.getcaptcha';
import BackButton from '@salesforce/resourceUrl/BackButton';

import { NavigationMixin } from "lightning/navigation";

export default class PreviewFormCmp  extends NavigationMixin(LightningElement) {

    @api formid;
    @track getFieldCSS;
    removeObjFields = [];
    @track page = [];
    @track PageList = [];
    @track FieldList = [];
    @track Mainlist = [];
    @track pageindex = 1;
    @api activepreview = false;
    @track spinnerDataTable = false;
    @track isIndexZero = true;
    @track isIndexLast = false;
    @track Progressbarvalue;
    @track captchavalue;
    BackButton = BackButton;
    @track verify;

    renderedCallback(){
        getFormCSS({id:this.formid})
        .then(result=>{
            console.log(result);
            this.getFieldCSS = result;
            console.log('FormCSS->> '+this.getFieldCSS);
            let array = this.template.querySelector('.myform');
            let str = this.getFieldCSS;
            array.style=str;
        }).catch(error=>{
            console.log({error});
        })

        getButtonCSS({id:this.formid})
        .then(result=>{
            console.log(result + 'button css');
            let str = result;
            let value;
            let arr = this.template.querySelectorAll('.btn1');
            for (let i = 0; i < arr.length; i++){
                const element = arr[i];
                element.style = str; 
            }
            let buttoncss = result.split(';');
          for(let i = 0; i < buttoncss.length; i++){
            buttoncss[i] = buttoncss[i].split(':');
            let label = buttoncss[i][0];
         
            if(label == 'justify-content'){
                value = 'justify-content:'+buttoncss[i][1];
                console.log(value);
            }
          }

            let Arr = this.template.querySelectorAll(".footer");
            for (let i = 0; i < Arr.length; i++) {
                const element = Arr[i];
                console.log(i+'--'+{element});
                element.style = value;
            }
        })

        getPageCSS({id:this.formid})
        .then(result=>{
            console.log(result);
            this.getFieldCSS = result;
            console.log('PageCSS->> '+this.getFieldCSS);
            let array = this.template.querySelectorAll('.page');
            let str = this.getFieldCSS;
            for (let i = 0; i < array.length; i++) {
                const element = array[i];
                console.log(i+'--'+element);
                element.style = str;
            }
            this.spinnerDataTable = false;
        }).catch(error=>{
            console.log({error});
            this.spinnerDataTable = false;
        })
    }
    
    connectedCallback() {
        this.spinnerDataTable = true;
        getprogressbar({id:this.formid})
        .then(result =>{
            this.Progressbarvalue = result;
            });

        getcaptcha({id:this.formid})
        .then(result =>{
            this.captchavalue = result;
            });

        GetFormPage({ Form_Id: this.formid})
        .then(result => {
            this.PageList = result;
            this.secondmethod();
        }).catch(error => {
            console.log(error);
        });
    }
    secondmethod(){
        getFieldsRecords({id:this.formid})
            .then(result => {
                this.FieldList = result;
                this.setPageField(this.FieldList);
            })
            .catch(error => {
                console.log(error);
            });
    }



    setPageField(fieldList) {
        let outerlist = [];
        for (let i = 0; i < this.PageList.length; i++) {
            let innerlist = [];
            for (let j = 0; j < fieldList.length; j++) {
                if (this.PageList[i].Id == fieldList[j].Form_Page__c) {
                   let fieldofObj =  fieldList[j].Name.split(',');
                   let fieldtype = fieldofObj[1];
                   if(fieldofObj.length==2){
                     if(fieldofObj[1]!='Extra' && fieldofObj[1]!=undefined && fieldofObj[1]!='undefined'){
                        this.removeObjFields.push(fieldofObj[0]);
                     }
                 }
                 
                 let isdisabledcheck;
                 let isRequiredcheck; 
                 let labelcheck; 
                 let helptextcheck;
                 let placeholdercheck;
                 let readonlycheck;
                 let prefixcheck;
                 let prefixvalue;
                 let labelvalue;
                 let helptext;
                 let placeholdervalue;
                 let salutationvalue = []; 

                if(fieldList[j].Field_Validations__c){
                    fieldList[j].Field_Validations__c = fieldList[j].Field_Validations__c.split('?$`~');
                    for(let i =0; i< fieldList[j].Field_Validations__c.length; i++){
                        fieldList[j].Field_Validations__c[i] =  fieldList[j].Field_Validations__c[i].split(':');
                        console.log( fieldList[j].Field_Validations__c[i][0] + 'Nimit');
                        let labels = fieldList[j].Field_Validations__c[i][0];
                        let value = fieldList[j].Field_Validations__c[i][1];

                        if(labels == 'isRequired'){
                            isRequiredcheck = JSON.parse(value);
                           }
                           else if(labels == 'isDisabled'){
                            isdisabledcheck = JSON.parse(value);
                           }
                           else if(labels == 'isLabel'){
                            labelcheck = JSON.parse(value);
                           }
                           else if(labels == 'isHelpText'){
                            helptextcheck = JSON.parse(value);
                           }
                           else if(labels == 'isPlaceholder'){
                            placeholdercheck = JSON.parse(value);
                           }
                           else if(labels == 'isReadonly'){
                            readonlycheck = JSON.parse(value);
                           }
                           else if(labels == 'isPrefix'){
                            prefixcheck = JSON.parse(value);
                           }
                           else if(labels == 'Prefix'){
                            prefixvalue = value;
                           }
                           else if(labels == 'Label'){
                            labelvalue = value;
                           }
                           else if(labels == 'HelpText'){
                            helptext = value;
                           }
                           else if(labels == 'Placeholder'){
                            placeholdervalue = value;
                           }
                           else if(labels == 'Salutation'){
                            salutationvalue.push(value);
                           }
                           
                    }
                    fieldList[j].Field_Validations__c = ({isRequired: isRequiredcheck, isDisabled : isdisabledcheck, isLabel : labelcheck, isHelptext :helptextcheck, isPlaceholder : placeholdercheck, 
                        isReadonly : readonlycheck, isPrefix : prefixcheck,  Prefix : prefixvalue, Label: labelvalue, HelpText : helptext, Placeholder : placeholdervalue , Salutation : salutationvalue, fieldtype : fieldtype});
                }
                    innerlist.push(fieldList[j]);
                }
            }

            let temp = { pageName: this.PageList[i].Name, pageId: this.PageList[i].Id, FieldData: innerlist };

            outerlist.push(temp);
        }
        this.Mainlist = outerlist;
        this.page = outerlist[0];

        getFormCSS({id:this.formid})
        .then(result=>{
            this.getFieldCSS = result;
            let array = this.template.querySelector('.myform');
            let str = this.getFieldCSS;
            array.style=str;
        }).catch(error=>{
            console.log({error});
        })

        getPageCSS({id:this.formid})
        .then(result=>{
            this.getFieldCSS = result;
            let array = this.template.querySelectorAll('.page');
            let str = this.getFieldCSS;
            for (let i = 0; i < array.length; i++) {
                const element = array[i];
                element.style = str;
            }
        }).catch(error=>{
            console.log({error});
        })

         getButtonCSS({id:this.formid})
        .then(result=>{
            console.log(result);
            let str = result;
            let arr = this.template.querySelectorAll('.btn1');
            for (let i = 0; i < arr.length; i++){
                const element = arr[i];
                element.style = str; 
            }
        })

        if(this.pageindex == this.PageList.length){
            this.isIndexZero = true;
            this.isIndexLast = true;
        }
        this.spinnerDataTable = false;
        this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue,this.pageindex, this.PageList.length);
       
    }

    backhome(event){
        let cmpDef = {
            componentDef: "c:qf_home"
        };
        let encodedDef = btoa(JSON.stringify(cmpDef));
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: "/one/one.app#" + encodedDef
            }
        });
    }

    onaddpage1(event){
        if(event.currentTarget.dataset.name == 'previous'){
            
            if(this.pageindex == 1){ 
                this.isIndexZero = true;              
            }
            else if(this.PageList.length  > this.pageindex){
                this.pageindex--;  
                if(this.pageindex == 1){
                    this.isIndexLast = false;
                    this.isIndexZero = true;
                }
            }
            else if(this.PageList.length  == this.pageindex){
                this.pageindex--;               
                this.isIndexLast = false;
                if(this.pageindex == 1){
                    this.isIndexLast = false;
                    this.isIndexZero = true;
                }
            }
            this.page = this.Mainlist[this.pageindex - 1]; 
            this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue,this.pageindex, this.PageList.length);
            
        }

        else if(event.currentTarget.dataset.name == 'next'){
            if(this.pageindex == 1){ 

                if(this.pageindex == this.PageList.length){
                    this.isIndexZero = false;
                    this.isIndexLast = true;
                }
                else{
                    this.pageindex++;
                    this.isIndexZero = false;
                    this.isIndexLast = false;
                    if(this.pageindex == this.PageList.length){
                        this.isIndexLast = true;
                    }
                }              
            }
            else if(this.PageList.length  > this.pageindex){
                this.pageindex++;               
                if(this.pageindex == this.PageList.length ){
                    this.isIndexLast = true;
                }
                else{
                    this.isIndexLast = false;
                }
            }
            else if(this.PageList.length == this.pageindex){
            }
            this.page = this.Mainlist[this.pageindex - 1]; 
            this.template.querySelector('c-progress-indicator').calculation(this.Progressbarvalue,this.pageindex, this.PageList.length);
        }

        else if(event.currentTarget.dataset.name == 'submit'){
            
            if(this.verify == true){
            }
            else if(this.verify == false){
                let toast_error_msg = 'Invalid Captcha';
                this.template.querySelector('c-toast-component').showToast('error',toast_error_msg,3000);
            }
            else {
                let toast_error_msg = 'Please Verify Captcha';
                this.template.querySelector('c-toast-component').showToast('error',toast_error_msg,3000);
            }
        }
    }

    verifycaptcha(event){
        this.verify = event.detail;
    }
}