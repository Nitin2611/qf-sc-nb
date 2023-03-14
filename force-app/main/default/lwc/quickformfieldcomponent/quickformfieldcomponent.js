import {
    LightningElement,
    api,
    track
} from 'lwc';
import EmojiRating1 from '@salesforce/resourceUrl/EmojiRating1';
import EmojiRating5 from '@salesforce/resourceUrl/EmojiRating5';
import EmojiRating2 from '@salesforce/resourceUrl/EmojiRating2';
import EmojiRating3 from '@salesforce/resourceUrl/EmojiRating3';
import EmojiRating4 from '@salesforce/resourceUrl/EmojiRating4';
import multiright from '@salesforce/resourceUrl/multiright';
import multileft from '@salesforce/resourceUrl/multileft';
import multitick from '@salesforce/resourceUrl/multitick';
import getScaleRating from '@salesforce/apex/FormBuilderController.getScaleRating';
import getreferencevalue from '@salesforce/apex/FormBuilderController.getreferencevalue';
import getpicklistvalue from '@salesforce/apex/FormBuilderController.getpicklistvalue';
import signatureSave from '@salesforce/apex/FormBuilderController.signatureSave';
import saveFile from '@salesforce/apex/FormBuilderController.SaveFile';
import blackcross from '@salesforce/resourceUrl/blackcross';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

let isDownFlag,
    isDotFlag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0;

let x = "#0000A0"; //blue color
let y = 1.5; //weight of line width and dot.       

let canvasElement, ctx; //storing canvas context
// let dataURL, convertedDataURI; //holds image data


export default class Quickformfieldcomponent extends LightningElement {

    @api isFieldView;
    @api isPreviewView;

    // icons'
    multiright = multiright;
    multileft = multileft;
    multitick = multitick;
    emojiRating1 = EmojiRating1;
    emojiRating2 = EmojiRating2;
    emojiRating3 = EmojiRating3;
    emojiRating4 = EmojiRating4;
    emojiRating5 = EmojiRating5;
    blackcross = blackcross;

    @api compview = '';
    @api tView = '';
    @api disableField = '';
    @api fieldAttribute = '';
    @api fieldAttributeValue = '';
    @api fieldId = '';
    @api formid = '';
    @track scaleRating = [];
    @track isFieldDesabled = false;

    @track FieldShown = true;
    @track LabelShown = true;
    // @api isReqired;
    @api isReqired = '';
    @track fieldHelpText = 'please fill the help text';
    @track fieldValidations = '';
    FieldLabel = '';
    FieldType = '';
    count = '';
    @track Address = 'Address';
    @track onfocus = false;
    @api getLabelCSS1 = '';
    @api hovercssproperty = '';
    @api focuscssproperty = '';
    @api labelvalue = '';
    @api labelcheck = '';
    @api salutationvalue = '';
    @api helptextcheck = '';
    @api helptextvalue = '';
    @api isdisabled = '';
    @api placeholder = '';
    @api fieldtype = '';
    @api termsAndConditionValue = '';
    @api fieldName;
    @track fieldcount = true;
    d = false;
    @track picklistvalue = [];
    usrViewBool = false;
    referencevalue = [];
    outsideClick;
    selectedmultipicklistvalues = [];
    @track searchkey = '';
    selmultipicklistvalues = [];
    @track focused = '';
    @api fieldcss = '';
    @api labelcss = '';
    @track updatedfieldcss = this.fieldcss;
    @track updatedlabelcss = this.labelcss;
    usricon = true;
    reficon;
    @api minimum;
    @api maximum;
    @api minimumtime;
    @api maximumtime;
    @api minimumdatetime;
    @api maximumdatetime;
    @api minimumdate;
    @api maximumdate;
    @track FieldListname = [];
    @api fieldmapping;
    @api firstobjvallist = {};
    @api secondobjvallist = {};
    @api thirdobjvallist = {};
    @api extobjvallist = {};
    @track all_filde_value = {};
    @track fullName = {
        'salutation': '',
        'f_name': '',
        's_name': ''
    };
    @track Address = {
        'street': '',
        'city': '',
        'state': '',
        'zipcode': '',
        'country': ''
    };
    @api formobject;
    @track fildval = '';
    @api validation;
    @track check_vali_next = true;
    @track chexk_val_list = [];
    // @track FullName;
    // @track error_validation_json = {};
    // error_josn_key_list = new Set();
    // @track error_josn_key_list=[];
    @track sec_val = '';
    @track thi_val = '';
    @track for_val = '';
    @track fiv_val = '';
    @track dataURL;
    @track convertedDataURI;
    @track sig_filde_id;

    connectedCallback() {
        this.fieldstype = this.tView.split(',')[1];
        if (this.fieldstype == 'REFERENCE') {
            // this.referencevalues();
        } else if (this.fieldstype == 'PICKLIST') {
            this.picklistvalues();
        } else if (this.fieldstype == 'MULTIPICKLIST') {
            this.picklistvalues();
        }
        getScaleRating()
            .then(result => {
                if (result != undefined) {
                    this.scaleRating = result;
                }
            }).catch(err => {
                console.log(err);
            })

        this.onfocus = false;
        console.log('fieldmapping --> ' + this.fieldmapping);
        console.log('validation :- ', JSON.stringify(this.validation));

    }

    renderedCallback() {
        console.log('quickformfield rendered callback!');
        if (this.formid != undefined) {
            console.log('formid --> ' + this.formid);
        }


        try {
            if (this.fieldcss != undefined) {
                let array = this.template.querySelectorAll('.slds-input');
                let array2 = this.template.querySelectorAll('.dropuser');
                let str = this.fieldcss;
                this.updatedfieldcss = str;
                if (str != undefined) {
                    let Arr = str.split(';color:');
                    let Arr2 = Arr[1].split(';');
                    let pcolor = Arr2[0];
                    for (let i = 0; i < array.length; i++) {
                        const element = array[i];
                        element.style = str;
                        element.style.setProperty("--c", pcolor);
                    }
                    for (let i = 0; i < array2.length; i++) {
                        const element = array2[i];
                        element.style = str;
                        element.style.setProperty("--c", pcolor);
                    }
                }

                array = this.template.querySelectorAll('.flabel');
                Arr = this.template.querySelectorAll('.labeldiv');
                if (this.labelcss != undefined) {
                    str = this.labelcss;
                    for (let i = 0; i < array.length; i++) {
                        const element = array[i];
                        element.style = 'display:flex;' + str;
                    }
                    let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                    for (let i = 0; i < Arr.length; i++) {
                        const element = Arr[i];
                        element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                    }
                    let array2 = this.template.querySelectorAll('.slds-popover--tooltip ');
                    let str2 = ((this.labelcss.split('margin-top:'))[1].split(';'))[0];
                    for (let j = 0; j < array2.length; j++) {
                        const element = array2[j];
                        element.style = 'margin:top:' + str2;
                    }
                }
            }
        } catch (error) {
            console.log('fielderror' + error);
        }

        //Label css using style property
        try {
            console.log('rendered callback label css -->> ' + this.labelcss);
            if (this.labelcss != undefined) {
                this.updatedlabelcss = this.labelcss;
                let array = this.template.querySelectorAll('.flabel');
                let Arr = this.template.querySelectorAll('.labeldiv');
                let str = this.labelcss;
                for (let i = 0; i < array.length; i++) {
                    const element = array[i];
                    element.style = 'display:flex;' + str;
                }
                let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                for (let i = 0; i < Arr.length; i++) {
                    const element = Arr[i];
                    element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                }
                let array2 = this.template.querySelectorAll('.slds-popover--tooltip ');
                let str2 = ((this.labelcss.split('margin-top:'))[1].split(';'))[0];
                let str3 = ((this.labelcss.split('margin-bottom:'))[1].split(';'))[0];
                for (let j = 0; j < array2.length; j++) {
                    const element = array2[j];
                    element.style = 'margin:top:' + str2 + ';margin:bottom:' + str3;
                }
                const event1 = CustomEvent('startsppiner');
                this.dispatchEvent(event1);
            }
        } catch (error) {
            console.log({
                error
            });
            const event1 = CustomEvent('startsppiner');
            this.dispatchEvent(event1);
        }

        this.apply_val(); //add by yash

    }

    // add by yash
    apply_val() {
        try {
            var tempararyList = this.fieldmapping.split('<!@!>');
            let fildname = tempararyList[0];
            let fildobject = tempararyList[1];
            console.log('fildobject :----', fildobject);
            console.log('testtetet :- ', fildname);
            let frst_map_obj = this.firstobjvallist.sobjectType;
            let second_map_obj = this.secondobjvallist.sobjectType;
            let third_map_obj = this.thirdobjvallist.sobjectType;
            let forth_map_obj = this.extobjvallist.sobjectType;
            console.log('forth_map_obj :- ', forth_map_obj);
            if (fildobject == frst_map_obj) {
                var obj_one_lst = [];
                obj_one_lst = Object.keys(this.firstobjvallist);
                for (let i = 0; i < obj_one_lst.length; i++) {
                    console.log('obj_one_lst[i] :- ', obj_one_lst[i]);
                    console.log('fildname :- ', fildname);
                    if (obj_one_lst[i] == fildname) {
                        // this.fildval = this.firstobjvallist[obj_one_lst[i]];
                        let vel_of_filde = this.firstobjvallist[obj_one_lst[i]];
                        var nameArr = vel_of_filde.split('<QF>');
                        console.log('data key OUTPUT : ', nameArr[0]);
                        this.fildval = nameArr[0];
                        console.log('this.fildval ', this.fildval);
                        this.sec_val = nameArr[1];
                        console.log('this.fildval ', this.sec_val);
                        this.thi_val = nameArr[2];
                        console.log('this.fildval ', this.thi_val);
                        this.for_val = nameArr[3];
                        console.log('this.fildval ', this.for_val);
                        this.fiv_val = nameArr[4];
                        this.searchkey = nameArr[1];
                        if (this.fildval == 'select-one') {
                            console.log('u r in pic lit');
                            var pic_val = nameArr[1];
                            console.log('pic_val :- ', pic_val);
                            var p_list = this.template.querySelector(`[data-id="${pic_val}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.selected = true;
                        } else if (nameArr[0] == 'm_pick') {
                            console.log('u r in m_pick');
                            // alert('yash');
                            for (let t = 1; t < nameArr.length; t++) {
                                var pic_lit = nameArr[t];
                                var m_listArr = pic_lit.split('<?QF>');
                                console.log('m_list :- ', m_listArr[0]);
                                console.log('m_list :- ', m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_list[1]);
                            }

                        } else if (this.fildval == 'textarea') {
                            console.log('u r in textarea');
                            // console.log(this);
                            var text_a = nameArr[1];
                            // let select_name = event.currentTarget.dataset.id;
                            console.log('nameArr[1]', nameArr[1]);
                            // console.log('nameArr[2]',nameArr[2]);
                            // console.log('select_name',select_name);
                            var field_mapping = this.fieldmapping;
                            var p_list = this.template.querySelector(`[data-name="${field_mapping}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.innerHTML = nameArr[1];

                        }

                        console.log('data object OUTPUT : ', nameArr[1]);
                        console.log('data value OUTPUT : ', nameArr[2]);
                        console.log('fild val -----', this.fildval);
                    }
                }
            } else if (fildobject == second_map_obj) {
                var obj_two_lst = [];
                obj_two_lst = Object.keys(this.secondobjvallist);
                for (let i = 0; i < obj_two_lst.length; i++) {
                    if (obj_two_lst[i] == fildname) {
                        // this.fildval = this.secondobjvallist[obj_two_lst[i]];
                        let vel_of_filde = this.secondobjvallist[obj_two_lst[i]];
                        var nameArr = vel_of_filde.split('<QF>');
                        console.log('data key OUTPUT : ', nameArr[0]);
                        this.fildval = nameArr[0];
                        this.sec_val = nameArr[1];
                        this.thi_val = nameArr[2];
                        this.for_val = nameArr[3];
                        this.fiv_val = nameArr[4];
                        this.searchkey = nameArr[1];
                        if (this.fildval == 'select-one') {
                            console.log('u r in pic lit');
                            var pic_val = nameArr[1];
                            console.log('pic_val :- ', pic_val);
                            var p_list = this.template.querySelector(`[data-id="${pic_val}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.selected = true;
                        } else if (nameArr[0] == 'm_pick') {
                            console.log('u r in m_pick');
                            // alert('yash');
                            for (let t = 1; t < nameArr.length; t++) {
                                var pic_lit = nameArr[t];
                                var m_listArr = pic_lit.split('<?QF>');
                                console.log('m_list :- ', m_listArr[0]);
                                console.log('m_list :- ', m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_list[1]);
                            }

                        } else if (this.fildval == 'textarea') {
                            console.log('u r in textarea');
                            // console.log(this);
                            var text_a = nameArr[1];
                            // let select_name = event.currentTarget.dataset.id;
                            console.log('nameArr[1]', nameArr[1]);
                            // console.log('nameArr[2]',nameArr[2]);
                            // console.log('select_name',select_name);
                            var field_mapping = this.fieldmapping;
                            var p_list = this.template.querySelector(`[data-name="${field_mapping}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.innerHTML = nameArr[1];

                        }
                        console.log('data object OUTPUT : ', nameArr[1]);
                        console.log('data value OUTPUT : ', nameArr[2]);

                        console.log('fild val -----', this.fildval);

                    }
                }
            } else if (fildobject == third_map_obj) {
                var obj_three_lst = [];
                obj_three_lst = Object.keys(this.thirdobjvallist);
                for (let i = 0; i < obj_three_lst.length; i++) {
                    if (obj_three_lst[i] == fildname) {
                        // this.fildval = this.thirdobjvallist[obj_three_lst[i]];
                        let vel_of_filde = this.thirdobjvallist[obj_three_lst[i]];
                        var nameArr = vel_of_filde.split('<QF>');
                        console.log('data key OUTPUT : ', nameArr[0]);
                        this.fildval = nameArr[0];
                        this.sec_val = nameArr[1];
                        this.thi_val = nameArr[2];
                        this.for_val = nameArr[3];
                        this.fiv_val = nameArr[4];
                        this.searchkey = nameArr[1];
                        var strString = nameArr[2];
                        if (this.fildval == 'select-one') {
                            console.log('u r in pic lit');
                            var pic_val = nameArr[1];
                            console.log('pic_val :- ', pic_val);
                            var p_list = this.template.querySelector(`[data-id="${pic_val}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.selected = true;
                        } else if (nameArr[0] == 'm_pick') {
                            console.log('u r in m_pick');
                            // alert('yash');
                            for (let t = 1; t < nameArr.length; t++) {
                                var pic_lit = nameArr[t];
                                var m_listArr = pic_lit.split('<?QF>');
                                console.log('m_list :- ', m_listArr[0]);
                                console.log('m_list :- ', m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_listArr[1]);
                                // this.selectedmultipicklistvalues.push(m_list[1]);
                            }

                        } else if (this.fildval == 'textarea') {
                            console.log('u r in textarea');
                            // console.log(this);
                            var text_a = nameArr[1];
                            // let select_name = event.currentTarget.dataset.id;
                            console.log('nameArr[1]', nameArr[1]);
                            // console.log('nameArr[2]',nameArr[2]);
                            // console.log('select_name',select_name);
                            var field_mapping = this.fieldmapping;
                            var p_list = this.template.querySelector(`[data-name="${field_mapping}"]`);
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.innerHTML = nameArr[1];

                        }
                        console.log('data object OUTPUT : ', nameArr[1]);
                        console.log('data value OUTPUT : ', nameArr[2]);

                        console.log('fild val -----', this.fildval);
                    }
                }
            } else {
                var ex_obj_lst = [];
                ex_obj_lst = Object.keys(this.extobjvallist);
                console.log('test 4 a :- ', JSON.stringify(ex_obj_lst));
                for (let i = 0; i < ex_obj_lst.length; i++) {
                    console.log('u r in loop');
                    console.log('ex_obj_lst[i] :- ', ex_obj_lst[i]);
                    console.log('fildname :- ', fildname);
                    if (ex_obj_lst[i] == fildname) {
                        console.log('u r fild is valid');
                        console.log('ex_obj_lst[i]', ex_obj_lst[i]);
                        // this.fildval = this.extobjvallist[ex_obj_lst[i]];
                        let vel_of_filde = this.extobjvallist[ex_obj_lst[i]];
                        var nameArr = vel_of_filde.split('<QF>');
                        console.log('data key OUTPUT : ', nameArr[0]);
                        this.fildval = nameArr[0];
                        this.sec_val = nameArr[1];
                        this.thi_val = nameArr[2];
                        this.for_val = nameArr[3];
                        this.fiv_val = nameArr[4];
                        this.searchkey = nameArr[0];
                        var strString = nameArr[1];
                        if (this.fildval == 'redio') {
                            console.log('u r in redio log', this.fildval);
                            console.log('strString', strString);
                            var radiobtn = this.template.querySelector(`[data-id="${strString}"]`)
                            console.log('** error variable ===>' + JSON.stringify(radiobtn));
                            console.log('** error variable 1 ===>' + radiobtn.textContent);
                            radiobtn.checked = true;
                        } else if (this.fildval == 'chk_box') {
                            for (let k = 2; k < nameArr.length; k++) {
                                var chk_val = nameArr[k];
                                console.log('u r in chk_val log', this.fildval);
                                console.log('chk_val', chk_val);
                                var CheckBox = this.template.querySelector(`[data-id="${chk_val}"]`)
                                console.log('** error variable ===>' + JSON.stringify(CheckBox));
                                console.log('** error variable 1 ===>' + CheckBox.textContent);
                                CheckBox.checked = true;
                            }

                        } else if (this.fildval == 'select-one') {
                            var pic_val = nameArr[1];
                            var p_list = this.template.querySelector(`[data-id="${pic_val}"]`)
                            console.log('** error variable ===>' + JSON.stringify(p_list));
                            console.log('** error variable 1 ===>' + p_list.textContent);
                            p_list.checked = true;


                        } else if (this.fildval == 'emoji') {
                            var emojiSelectedEle = this.template.querySelectorAll('.emoji-ratingfield-Selected');
                            emojiSelectedEle.forEach(element => {
                                element.classList.remove('emoji-ratingfield-Selected');
                            });
                            var emojiEle = this.template.querySelector('label[title="' + nameArr[1] + '"]');
                            emojiEle.classList.add('emoji-ratingfield-Selected');

                        }
                        console.log('data object OUTPUT : ', nameArr[1]);
                        console.log('data value OUTPUT : ', nameArr[2]);
                        console.log('fild val -----', this.fildval);
                    }
                }

            }
        } catch (error) {
            console.log("In the catch block ==> Method :** apply_val ** || LWC:** quickformfieldcomponent ** ==>", {
                error
            });
            console.log('above error ==>' + error);
        }
    }
    // clos add by yash


    @api FieldCSSUpdate(CSSString) {
        if (CSSString != undefined) {
            try {
                this.updatedfieldcss = CSSString;
                let array = this.template.querySelectorAll('.slds-input');
                let array2 = this.template.querySelectorAll('.dropuser');
                let str = '';
                if (CSSString == undefined || CSSString == null || CSSString == '') {
                    if (this.fieldcss != undefined) {
                        str = this.fieldcss;
                    }
                } else {
                    str = CSSString;
                }
                if (str != undefined) {
                    let Arr = str.split(';color:');
                    let Arr2 = Arr[1].split(';');
                    let pcolor = Arr2[0];
                    if (pcolor != undefined || pcolor != null) {
                        for (let i = 0; i < array.length; i++) {
                            const element = array[i];
                            element.style = str;
                            element.style.setProperty("--c", pcolor);
                        }
                        for (let i = 0; i < array2.length; i++) {
                            const element = array2[i];
                            element.style = str;
                            element.style.setProperty("--c", pcolor);
                        }
                    }
                }
                // this.template.querySelector('select').style = str;
            } catch (error) {
                console.log("In the catch block ==> Method :** FieldCSSUpdate ** || LWC:** quickformfieldcomponent ** ==>", {
                    error
                });
                console.log('above error ==>' + error);
            }
        }
    }

    @api LabelCSSUpdate(CSSString) {
        try {
            if (CSSString != undefined) {
                this.updatedlabelcss = CSSString;
                let array = this.template.querySelectorAll('.flabel');
                let Arr = this.template.querySelectorAll('.labeldiv');
                let str = this.updatedlabelcss;
                for (let i = 0; i < array.length; i++) {
                    const element = array[i];
                    element.style = 'display:flex;' + str;
                }
                let str23 = str.split('margin-bottom:')[0] + str.split('margin-bottom:')[1].slice(3);
                for (let i = 0; i < Arr.length; i++) {
                    const element = Arr[i];
                    element.style = 'display:flex;' + str23 + ';margin-top:0px;';
                }
                let array2 = this.template.querySelectorAll('.slds-popover--tooltip');
                let str2 = ((this.getLabelCSS1.split('margin-top:'))[1].split(';'))[0];
                let str3 = ((this.getLabelCSS1.split('margin-bottom:'))[1].split(';'))[0];
                if (str2 != undefined) {
                    for (let j = 0; j < array2.length; j++) {
                        const element = array2[j];
                        element.style = 'margin:top:' + str2 + ';margin-bottom:' + str3;
                    }
                }
            }
        } catch (error) {
            console.log("In the catch block ==> Method :** LableCSSUpdate ** || LWC:** quickformfieldcomponent ** ==>", {
                error
            });
            console.log('above error ==>' + error);
        }
    }

    @api handleeffect(type, property) {
        if (type != null && type != undefined && property != null && property != undefined) {
            if (type == 'hover') {
                this.hovercssproperty = property;
            } else if (type == 'focus') {
                this.focuscssproperty = property;
            }
        }
    }

    handlehover(event) {
        if (this.hovercssproperty != undefined) {
            let str = this.hovercssproperty;
            if (this.onfocus) {
                if (event.target.dataset.id == undefined || event.target.dataset.id == null) {
                    this.handlefocus(event)
                } else {
                    if (event.target.dataset.id == this.focused) {
                        this.handlefocus(event)
                    } else {
                        event.target.style = str;
                        array = this.template.querySelector('.listbox-item');
                        for (let i = 0; i < array.length; i++) {
                            const element = array[i];
                            element.style = str;
                        }
                    }
                }
            } else {
                event.target.style = str;
            }
        }
    }

    handlefocus(event) {
        if (this.focuscssproperty != undefined) {
            if (event.target.dataset.id != undefined && event.target.dataset.id != null) {
                this.focused = event.target.dataset.id;
            }
            let str = this.focuscssproperty;
            event.target.style = str;
            this.onfocus = true;
        }
    }

    handleblur(event) {
        if (this.onfocus != undefined) {
            if (this.onfocus) {
                if (event.target.dataset.id == undefined || event.target.dataset.id == null) {
                    this.handlefocus(event)
                } else {
                    if (event.target.dataset.id == this.focused) {
                        this.handlefocus(event)
                    } else {
                        event.target.style = this.fieldcss;
                    }
                }
            } else {
                event.target.style = this.fieldcss;
            }
        }
    }

    handleblur1(event) {
        this.onfocus = false;
        if (this.fieldcss != undefined) {
            event.target.style = this.fieldcss
        }
        if (this.updatedfieldcss != undefined) {
            this.FieldCSSUpdate(this.updatedfieldcss)
        }
    }

    get CheckBoxOp() {
        return [{
                label: 'first',
                value: 'option1'
            },
            {
                label: 'second',
                value: 'option2'
            },
        ];
    }


    @track placeHolder = 'New Field';
    get isFieldCompView() {
        return this.compview == 'Field';
    }
    get isFullView() {
        return this.compview == 'Full';
    }
    get isTrueEmail() {
        this.tView = this.tView.split(',')[0];
        return this.tView == 'QFEMAILID' || this.FieldLabel == 'QFEMAILID';
    }

    get isTrueFullName() {

        return this.tView == 'QFFULLNAME' || this.FieldLabel == 'QFFULLNAME';
    }
    get isTrueName() {
        return this.tView == 'QFNAME' || this.FieldLabel == 'QFNAME';
    }
    get isTrueAddress() {
        return this.tView == 'QFADDRESS' || this.FieldLabel == 'QFADDRESS';
    }
    get isTruePhone() {
        return this.tView == 'QFPHONE';
    }
    get isTrueCheckBox() {
        return this.tView == 'QFCHECKBOX';
    }
    get isTruePageBreak() {
        return this.tView == 'QFPAGEBREAK';
    }
    get isTrueShortText() {
        return this.tView == 'QFSHORTTEXT';
    }
    get isTrueLongText() {
        return this.tView == 'QFLONGTEXT';
    }
    get isTrueFileUpload() {
        return this.tView == 'QFFILEUPLOAD';
    }
    get isTrueRadioButton() {
        return this.tView == 'QFRADIOBUTTON';
    }
    get isTrueDropDown() {
        return this.tView == 'QFDROPDOWN';
    }
    get isTrueNumber() {
        return this.tView == 'QFNUMBER';
    }
    get isTruePrice() {
        return this.tView == 'QFPRICE';
    }


    get isTrueDate() {
        return this.tView == 'QFDATE';
    }

    get isTrueTime() {
        return this.tView == 'QFTIME';
    }
    get isTrueDateTime() {
        return this.tView == 'QFDATETIME';
    }
    get isTrueRating() {
        return this.tView == 'QFRATING';
    }
    get isTrueEmojiRating() {
        return this.tView == 'QFEMOJIRATING';
    }
    get isTrueScaleRating() {
        return this.tView == 'QFSCALERATING';
    }
    get isTrueTerms() {
        return this.tView == 'QFTERMSOFSERVICE';
    }
    get isTrueLink() {
        return this.tView == 'QFLINK';
    }
    get isTrueSign() {
        return this.tView == 'QFSIGNATURE';
    }
    get isTrueRichText() {
        return this.tView == 'QFRICHTEXT';
    }

    get isTruePageBreak() {
        return this.tView == 'QFPAGEBREAK';
    }




    get sTrueEmail() {
        if (this.fieldstype == 'EMAIL') {
            return true;
        }
    }

    get sTrueName() {
        if (this.fieldstype == 'STRING') {

            return true;
        }
    }
    get sTrueAddress() {
        if (this.fieldstype == 'QFADDRESS') {

            return true;
        }
    }
    get sTruePhone() {
        if (this.fieldstype == 'PHONE') {

            return true;
        }
    }
    get sTrueCheckBox() {
        if (this.fieldstype == 'BOOLEAN') {

            return true;
        }
    }
    get sTrueLongText() {
        if (this.fieldstype == 'TEXTAREA') {

            return true;
        }
    }

    get sTrueNumber() {
        if (this.fieldstype == 'DOUBLE') {

            return true;
        }
    }

    get sTrueDate() {
        if (this.fieldstype == 'DATE') {

            return true;
        }
    }

    get sTrueTime() {
        if (this.fieldstype == 'TIME') {

            return true;
        }
    }
    get sTrueDateTime() {
        if (this.fieldstype == 'DATETIME') {

            return true;
        }
    }

    get sTrueLink() {
        if (this.fieldstype == 'URL') {

            return true;
        }
    }

    get sTruePassword() {
        if (this.fieldstype == 'ENCRYPTEDSTRING') {

            return true;
        }
    }

    get sTruePercent() {
        if (this.fieldstype == 'PERCENT') {

            return true;
        }
    }
    get sTrueCurrency() {
        if (this.fieldstype == 'CURRENCY') {

            return true;
        }
    }
    get sTruePicklist() {
        if (this.fieldstype == 'PICKLIST') {

            return true;
        }
    }
    get sTrueMultiPicklist() {
        if (this.fieldstype == 'MULTIPICKLIST') {

            return true;
        }
    }
    get sTrueRefernce() {
        if (this.fieldstype == 'REFERENCE') {

            return true;
        }
    }
    @track referencevaling = false;
    @track referencevalings = false;
    getreferncevalue(event) {
        try {
            if (this.referencevalue.length == 0) {
                document.addEventListener('click', this.outsideClick = this.closereference.bind(this));
                event.stopPropagation();

                getreferencevalue({
                        id: this.fieldId,
                        searchkey: this.searchkey
                    })
                    .then(result => {
                        if (result.referenceval.length > 0) {
                            this.referencevaling = true;
                            this.referencevalings = false;
                            this.referencevalue = result.referenceval;
                            this.reficon = result.objicon;
                            this.usricon = true;
                            this.usrViewBool = true;
                        } else {
                            this.usrViewBool = true;
                            this.usricon = false;
                            this.referencevaling = false;
                            this.referencevalings = true;
                            // this.referencevalue = [{
                            //     Id: 'none',
                            //     Name: 'There is no such records'
                            // }]
                        }
                        return false;
                    });
            } else {
                this.referencevalue = [];
                this.usrViewBool = false;
            }

        } catch (error) {
            console.log('Reference eor' + error);
            this.usrViewBool = false;
        }
    }
    closereference(event) {
        document.removeEventListener('click', this.outsideClick);
        this.usrViewBool = false;
    }
    selectreferencevalue(event) {
        // alert('u r in method');
        this.template.querySelector('span[class="clearref"]').style.display = 'block';
        this.searchkey = event.currentTarget.dataset.id;
        console.log(' this.searchkey  :- ', this.searchkey);
        let key = event.currentTarget.dataset.name;
        console.log(' key  :- ', key);
        let select_name = event.currentTarget.dataset.id;
        let vale = event.currentTarget.dataset.title;
        console.log(' vale  :- ', vale);
        // console.log('test by yash :-',event.target.value);
        // console.log('test by yash 2:-',event.detail.value);
        // console.log('test by yash 2:-',event.currentTarget.dataset.title);

        let splitparetan = '<!@!>';
        let splitparetan_2 = '<QF>';
        let fulldata = key + splitparetan + 'refernce<QF>' + select_name + splitparetan_2 + vale;
        console.log('fulldata OUTPUT : ', fulldata);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);
        var error = this.template.querySelector(`[data-id="${key}"]`)
        error.textContent = ""
        this.check_vali_next = true;
        const cssevent3 = new CustomEvent("nextbtvaltrue", {
            detail: key
        });
        this.dispatchEvent(cssevent3);
        this.usrViewBool = false;
        
    }

    // selectreferencevalue(event) {
    //     this.searchkey = event.currentTarget.dataset.name;
    //     this.usrViewBool = false;
    //     this.template.querySelector('span[class="clearref"]').style.display = 'block';
    // }


    referencevalues(event) {
        try {
            this.template.querySelector('span[class="clearref"]').style.display = 'block';
            this.searchkey = event.target.value;
            getreferencevalue({
                    id: this.fieldId,
                    searchkey: this.searchkey
                })
                .then(result => {
                    if (result.referenceval.length > 0) {
                        this.referencevaling = true;
                        this.referencevalings = false;
                        this.referencevalue = result.referenceval;
                        console.log('nimit :- ', JSON.stringify(this.referencevalue));
                        this.reficon = result.objicon;
                        this.usricon = true;
                        this.usrViewBool = true;
                    } else {
                        this.usrViewBool = true;
                        this.usricon = false;
                        this.referencevaling = false;
                        this.referencevalings = true;
                        // this.referencevalue = [{
                        //     Id: 'none',
                        //     Name: 'There is no such records'
                        // }]
                    }
                });
        } catch (error) {
            console.log('Reference error' + error);
            this.usrViewBool = false;
        }
    }
    picklistvalues() {
        try {
            getpicklistvalue({
                    id: this.fieldId
                })
                .then(result => {

                    for (let key in result) {
                        this.picklistvalue.push({
                            value: result[key],
                            key: key
                        });
                        // console.log(this.picklistvalue[key] + 'values');
                    }


                });
        } catch (error) {
            console.log('Picklist error' + error);
        }
    }


    emojiRatingValue(event) {
        try {
            var emojiValue = event.target.value;
            var emojiName = event.target.name;
            if (emojiName != undefined && emojiValue != undefined) {

                var emojiSelectedEle = this.template.querySelectorAll('.emoji-ratingfield-Selected');
                emojiSelectedEle.forEach(element => {
                    element.classList.remove('emoji-ratingfield-Selected');
                });
                var emojiEle = this.template.querySelector('label[title="' + emojiName + '"]');
                emojiEle.classList.add('emoji-ratingfield-Selected');
                let key = event.target.dataset.name;
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + 'emoji<QF>' + emojiValue;
                // console.log('fulldata OUTPUT : ',fulldata);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
            }
        } catch (error) {
            console.log('In the catch part of emojiRatingValue ==>', {
                error
            });
        }
    }


    fielddatarating;
    rating(event) {
        this.fielddatarating = event.target.value;
    }
    fieldrating;
    ratingvalued(event) {
        this.fieldrating = event.target.value;
    }




    //retrieve canvase and context
    knn() {
        canvasElement = this.template.querySelector('canvas');
        ctx = canvasElement.getContext("2d");
        // super();
        this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
        this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
        this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
        this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
    }
    knns(event) {
        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; //white
        ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);

        //convert to png image as dataURL
        this.dataURL = canvasElement.toDataURL("image/png");
        //convert that as base64 encoding
        this.convertedDataURI = this.dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        console.log('OUTPUT : convertedDataURI', this.convertedDataURI);
        console.log('yfeguygfu :- ', this.convertedDataURI);



        let key = event.target.dataset.name;
        var sig_fildeArr = key.split('<!@!>');
        this.sig_filde_id = sig_fildeArr[0];
        console.log(' in chi filde_id :- ' + this.sig_filde_id);
        let splitparetan = '<!@!>';
        let vale = '';
        var pera_m = {
            con_id: this.convertedDataURI,
            filde_id: this.sig_filde_id,
        };
        let fulldata = key + splitparetan + vale;
        const cssevent_sing = new CustomEvent("sigconverteddataurl", {
            detail: pera_m
        });
        this.dispatchEvent(cssevent_sing);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata

        });
        this.dispatchEvent(cssevent1);
    }
    // knn(event) {
    //     console.log('u r in sig');
    //     canvasElement = this.template.querySelector('canvas');
    //     ctx = canvasElement.getContext("2d");
    //     // super();
    //     this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
    //     this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
    //     this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
    //     this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));

    //     ctx.globalCompositeOperation = "destination-over";
    //     ctx.fillStyle = "#FFF"; //white
    //     ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);

    //     //convert to png image as dataURL
    //     this.dataURL = canvasElement.toDataURL("image/png");
    //     //convert that as base64 encoding
    //     this.convertedDataURI = this.dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
    //     console.log('OUTPUT : convertedDataURI', this.convertedDataURI);
    //     console.log('yfeguygfu :- ',this.convertedDataURI);


    //     const cssevent_sing = new CustomEvent("sigconverteddataurl", {
    //         detail: this.convertedDataURI
    //     });
    //     this.dispatchEvent(cssevent_sing);
    //     let key = event.target.dataset.name;
    //     let splitparetan = '<!@!>';
    //     let vale = '';
    //         let fulldata = key + splitparetan + vale;
    //         const cssevent1 = new CustomEvent("passfieldvalue", {
    //             detail: fulldata
    //         });
    //         this.dispatchEvent(cssevent1);
    // }

    //handler for mouse move operation
    handleMouseMove(event) {
        this.searchCoordinatesForEvent('move', event);
    }

    //handler for mouse down operation
    handleMouseDown(event) {
        this.searchCoordinatesForEvent('down', event);
    }

    //handler for mouse up operation
    handleMouseUp(event) {
        this.searchCoordinatesForEvent('up', event);
    }

    //handler for mouse out operation
    handleMouseOut(event) {
        this.searchCoordinatesForEvent('out', event);
    }

    /*
        handler to perform save operation.
        save signature as attachment.
        after saving shows success or failure message as toast
    */
    handleSaveClick(event) {
        //set to draw behind current content
        let key = event.target.dataset.name;
        let splitparetan = '<!@!>';
        let vale = '';
        let fulldata = key + splitparetan + vale;
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);
        // var error = this.template.querySelector(`[data-id="${key}"]`)
        // error.textContent = ""
        // this.check_vali_next = true;
        // const cssevent3 = new CustomEvent("nextbtvaltrue", {
        //     detail: key
        // });
        // this.dispatchEvent(cssevent3);






        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; //white
        ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);

        //convert to png image as dataURL
        dataURL = canvasElement.toDataURL("image/png");
        //convert that as base64 encoding
        this.convertedDataURI = this.dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        console.log();

        //call Apex method imperatively and use promise for handling success & failure
        // signatureSave({
        //         fieldId: this.fieldId,
        //         fieldData: this.convertedDataURI
        //     })
        //     .then(result => {
        //         //show success message
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title: 'Success',
        //                 message: 'Attachment created with Signature',
        //                 variant: 'success',
        //             }),
        //         );
        //     })
        //     .catch(error => {
        //         //show error message
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title: 'Error creating Attachment record',
        //                 message: error.body.message,
        //                 variant: 'error',
        //             }),
        //         );
        //     });
    }


    //clear the signature from canvas
    handleClearClick() {
        ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
        this.convertedDataURI = '';
        const cssevent_sing = new CustomEvent("sigconverteddataurl", {
            detail: this.convertedDataURI
        });
    }

    searchCoordinatesForEvent(requestedEvent, event) {
        event.preventDefault();
        if (requestedEvent === 'down') {
            this.setupCoordinate(event);
            isDownFlag = true;
            isDotFlag = true;
            if (isDotFlag) {
                this.drawDot();
                isDotFlag = false;
            }
        }
        if (requestedEvent === 'up' || requestedEvent === "out") {
            isDownFlag = false;
        }
        if (requestedEvent === 'move') {
            if (isDownFlag) {
                this.setupCoordinate(event);
                this.redraw();
            }
        }
    }

    //This method is primary called from mouse down & move to setup cordinates.
    setupCoordinate(eventParam) {
        //get size of an element and its position relative to the viewport 
        //using getBoundingClientRect which returns left, top, right, bottom, x, y, width, height.
        const clientRect = canvasElement.getBoundingClientRect();
        prevX = currX;
        prevY = currY;
        currX = eventParam.clientX - clientRect.left;
        currY = eventParam.clientY - clientRect.top;
    }

    //For every mouse move based on the coordinates line to redrawn
    redraw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x; //sets the color, gradient and pattern of stroke
        ctx.lineWidth = y;
        ctx.closePath(); //create a path from current point to starting point
        ctx.stroke(); //draws the path
    }

    //this draws the dot
    drawDot() {
        ctx.beginPath();
        ctx.fillStyle = x; //blue color
        ctx.fillRect(currX, currY, y, y); //fill rectrangle with coordinates
        ctx.closePath();
    }
    //////////////////////////////Signature - End//////////////////////////////////////////////////////////

    //////////////////////////////FileUpload - Start////////////////////////////////////////////////////////





    handleFilesChange(event) {
        try {
            if (event.target.files.length > 0) {
                const fileName = event.target.files[0].name;
                this.fileName = fileName;
                this.uploadHelper(event);
            } else {
                console.log('error');
            }
        } catch (error) {
            console.log({
                error
            });
        }
    }

    MAX_FILE_SIZE = 4500000; //Max file size 4.5 MB 
    CHUNK_SIZE = 750000; //Chunk Max size 750Kb 

    uploadHelper(event) {
        try {
            const file = event.target.files[0];
            if (file.size > this.MAX_FILE_SIZE) {
                this.fileName = 'Alert : File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size;
                return;
            }

            const reader = new FileReader();
            reader.onload = () => {
                const fileContents = reader.result;
                const base64 = 'base64,';
                const dataStart = fileContents.indexOf(base64) + base64.length;
                const encodedFileContents = fileContents.substring(dataStart);
                this.uploadProcess(file, encodedFileContents);
            };
            reader.readAsDataURL(file);
        } catch (error) {
            console.log({
                error
            });
        }
    }

    uploadProcess(file, fileContents) {
        try {
            let startPosition = 0;
            let endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
            this.uploadInChunk(file, fileContents, startPosition, endPosition, '');
        } catch (error) {
            console.log({
                error
            });
        }
    }

    uploadInChunk(file, fileContents, startPosition, endPosition, attachId) {
        try {
            const getchunk = fileContents.substring(startPosition, endPosition);
            const params = {
                fieldId: this.fieldId,
                fileName: file.name,
                base64Data: encodeURIComponent(getchunk),
                contentType: file.type,
            };
            saveFile(params)
                .then(result => {
                    if (!result) {
                        console.log("Something Went Wrong In Save Data, Please Reload Page");
                    } else {
                        const fieldData = result;
                        // Event For pass data to preview
                        const fId = this.fId;
                        const fieldLabel = this.FieldAttribute.Label__c;
                        const requiredField = this.FieldAttribute.Required_Field__c;
                        const target = [fId, fieldLabel, fieldData, requiredField];
                        const previewEvent = new CustomEvent('preview', {
                            detail: {
                                formFieldData: target
                            }
                        });
                        this.dispatchEvent(previewEvent);
                    }
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Attachment created Successfully',
                            variant: 'success',
                        }),
                    );
                })
                .catch(error => {
                    console.log({
                        error
                    });
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating Attachment record',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        } catch (error) {
            console.log({
                error
            });
        }
    }
    selectedvalues(event) {
        try {
            if (this.selmultipicklistvalues.length > 0) {
                var i;
                this.selmultipicklistvalues.forEach((element, index) => {
                    if (element.value == event.currentTarget.dataset.id) {
                        i = index;
                    }
                })
                if (i == undefined) {
                    this.selmultipicklistvalues.push({
                        value: event.currentTarget.dataset.id,
                        key: event.currentTarget.dataset.name
                    });
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
                } else {
                    this.selmultipicklistvalues.splice(i, 1);
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'none';

                }

            } else {
                this.selmultipicklistvalues.push({
                    value: event.currentTarget.dataset.id,
                    key: event.currentTarget.dataset.name
                });
                this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
            }
        } catch (error) {
            console.log(error + 'selected error');
        }
    }
    unselectedvalues(event) {
        try {
            if (this.selmultipicklistvalues.length > 0) {
                var i;
                this.selmultipicklistvalues.forEach((element, index) => {
                    if (element.value == event.currentTarget.dataset.id) {
                        i = index;
                    }
                })
                if (i == undefined) {
                    this.selmultipicklistvalues.push({
                        value: event.currentTarget.dataset.id,
                        key: event.currentTarget.dataset.name
                    });
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
                } else {
                    this.selmultipicklistvalues.splice(i, 1);
                    this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'none';

                }

            } else {
                this.selmultipicklistvalues.push({
                    value: event.currentTarget.dataset.id,
                    key: event.currentTarget.dataset.name
                });
                this.template.querySelector('div[data-id="' + event.currentTarget.dataset.id + '"]').style.display = 'block';
            }
        } catch (error) {
            console.log(error + 'unselected error');
        }
    }
    rightarrowmulti(event) {
        try {


        let splitparetan = '<!@!>';
        let sel_val = event.currentTarget.dataset.name;
        sel_val = sel_val + splitparetan + 'm_pick<QF>';
        console.log('tetsss: - ', sel_val);
        let splitparetan_2 = '<QF>';

        for (let i = 0; i < this.selmultipicklistvalues.length; i++) {
            this.template.querySelector('div[data-id="' + this.selmultipicklistvalues[i].value + '"]').style.display = 'none';
        }
        for (var j = 0; j < this.selmultipicklistvalues.length; j++) {
            for (var i = 0; i < this.picklistvalue.length; i++) {
                if (this.picklistvalue[i].value == this.selmultipicklistvalues[j].value) {
                    this.selectedmultipicklistvalues.push(this.selmultipicklistvalues[j]);
                    let cur_val = this.selmultipicklistvalues[j].value;
                    let cur_key = this.selmultipicklistvalues[j].key;
                    console.log('cur_val ', cur_val);
                    sel_val = sel_val + cur_val + '<?QF>' + cur_key + splitparetan_2;
                    console.log('sel_val :- ', sel_val);
                    this.picklistvalue.splice(i, 1);
                }
            }
        }
        this.selmultipicklistvalues = [];
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: sel_val
        });
            console.log('Nimit test 1');
        this.dispatchEvent(cssevent1);
            console.log('Nimit test 2');
        } catch (error) {
            console.log('Rightarrowerror ', JSON.stringify(error));
        }
    }
    leftarrowmulti(event) {
        let splitparetan = '<!@!>';
        let sel_val = event.currentTarget.dataset.name;
        sel_val = sel_val + splitparetan + 'm_pick<QF>';
        console.log('tetsss: - ', sel_val);
        let splitparetan_2 = '<QF>';
        for (let i = 0; i < this.selmultipicklistvalues.length; i++) {
            this.template.querySelector('div[data-id="' + this.selmultipicklistvalues[i].value + '"]').style.display = 'none';
        }
        for (var j = 0; j < this.selmultipicklistvalues.length; j++) {
            for (var i = 0; i < this.selectedmultipicklistvalues.length; i++) {
                if (this.selectedmultipicklistvalues[i].value == this.selmultipicklistvalues[j].value) {
                    this.picklistvalue.push(this.selmultipicklistvalues[j]);
                    this.selectedmultipicklistvalues.splice(i, 1);
                }
            }
        }
        for (let i = 0; i < this.selectedmultipicklistvalues.length; i++) {
            let cur_val = this.selectedmultipicklistvalues[i].value;
            let cur_key = this.selectedmultipicklistvalues[i].key;
            console.log('cur_val ', cur_val);
            sel_val = sel_val + cur_val + '<?QF>' + cur_key + splitparetan_2;
            console.log('sel_val :- ', sel_val);
        }
        this.selmultipicklistvalues = [];
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: sel_val
        });
        this.dispatchEvent(cssevent1);

    }
    // add by yash/
    Set_error_msg(msg, datakey) {
        var error = this.template.querySelector(`[data-id="${datakey}"]`)
        console.log('** error variable ===>' + JSON.stringify(error));
        console.log('** error variable 1 ===>' + error.textContent);
        error.textContent = msg;
        error.style.color = "red";
        // this.check_vali_next = false;
        console.log('yash stru :- ', JSON.stringify(this.error_validation_json));
        const cssevent2 = new CustomEvent("nextbtval", {
            detail: datakey
        });
        this.dispatchEvent(cssevent2);
    }
    remove_error_msg(key, vale) {
        let splitparetan = '<!@!>';
        let fulldata = key + splitparetan + vale;
        console.log('fulldata OUTPUT : ', fulldata);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);
        var error = this.template.querySelector(`[data-id="${key}"]`)
        error.textContent = ""
        this.check_vali_next = true;
        const cssevent3 = new CustomEvent("nextbtvaltrue", {
            detail: key
        });
        this.dispatchEvent(cssevent3);

    }
    // add_all_filde_value(key, value) {
    //     let testt = 'no';
    //     let ind;
    //     var keyArr = key.split('<!@!>');
    //     for (let i = 0; i < this.all_filde_value.length; i++) {
    //         if (this.all_filde_value[i] == keyArr[0]) {
    //             console.log('u r in for loop if ');
    //             testt = 'yes'
    //             ind = i;
    //         }
    //     }
    //     if (testt == 'yes') {
    //         console.log(' u r in testt if');
    //         this.all_filde_value[ind] = value;

    //         } else {
    //         console.log(' u r in testt else');
    //         this.all_filde_value[keyArr[0]] = value;

    //     }
    //     console.log('new json :- ', JSON.stringify(this.all_filde_value));

    // }
    OnFieldClick(event) {
        console.log('test by tyash for val :- ', this.validation.Field_Validations__c);
        console.log('u r in onchange : ');
        console.log('OUTPUT OnFieldClick : ', event.target.dataset.name);
        let key = event.target.dataset.name;
        console.log(' mini :- ', this.minimum);
        console.log(' mini :- ', this.maximum);
        console.log('key OUTPUT : ', key);
        let vale = event.target.value;
        let fild_teye = event.target.type;
        console.log('tey OUTPUT : ', fild_teye);
        console.log('vale OUTPUT : ', vale);
        if (fild_teye == 'select-one') {
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + 'select-one<QF>' + vale;
            let f_data = 'select-one<QF>' + vale;
            console.log('fulldata OUTPUT : ', fulldata);

            // this.add_all_filde_value(key, f_data);

            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
            var error = this.template.querySelector(`[data-id="${key}"]`)
            error.textContent = ""
            this.check_vali_next = true;
            const cssevent3 = new CustomEvent("nextbtvaltrue", {
                detail: key
            });
            this.dispatchEvent(cssevent3);
            // this.remove_error_msg(key,vale);
        } else if (fild_teye == 'text') {
            if (this.minimum > vale.length) {
                var msg = 'Please enter a minimum ' + this.minimum + ' chater.';
                this.Set_error_msg(msg, key);
            } else {
                // let splitparetan = '<!@!>';
                // let fulldata = key + splitparetan + vale;
                // console.log('fulldata OUTPUT : ', fulldata);
                // const cssevent1 = new CustomEvent("passfieldvalue", {
                //     detail: fulldata
                // });
                // this.dispatchEvent(cssevent1);
                // var error = this.template.querySelector(`[data-id="${key}"]`)
                // error.textContent = ""
                // this.check_vali_next = true;
                // const cssevent3 = new CustomEvent("nextbtvaltrue", {
                //     detail: key
                // });
                // this.dispatchEvent(cssevent3);
                var text_val = vale + '<QF>';
                // this.add_all_filde_value(key, vale);
                this.remove_error_msg(key, text_val);
            }
        } else if (fild_teye == 'number') {
            let min_val = event.target.min;
            console.log(' min_val :- ', min_val);
            let max_val = event.target.max;
            console.log(' max_val :- ', max_val);
            console.log(' max_val 11111:- ', this.minimum);
            console.log(' max_val 22222:- ', this.maximum);
            if (parseInt(this.minimum) > parseInt(vale) || parseInt(this.maximum) < parseInt(vale)) {
                // alert('hey');
                // let max_val =  event.target.min;
                // console.log(' max_val :- ',max_val);
                var error = this.template.querySelector(`[data-id="${key}"]`)
                console.log('** error variable ===>' + JSON.stringify(error));
                console.log('** error variable 1 ===>' + error.textContent);
                error.textContent = "Please enter a velue between " + this.minimum + ' to ' + this.maximum;
                error.style.color = "red";
                console.log('yash stru :- ', JSON.stringify(this.error_validation_json));
                const cssevent2 = new CustomEvent("nextbtval", {
                    detail: key
                });
                this.dispatchEvent(cssevent2);
            } else {
                console.log('u r in num');
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + vale;
                console.log('fulldata OUTPUT : ', fulldata);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`)
                error.textContent = ""
                this.check_vali_next = true;
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
            }
            // alert('enter min val');

        } else if (fild_teye == 'date') {
            // alert('y r in date val');
            let min = event.target.min;
            console.log('min val :- ', min);
            let max = event.target.max;
            if (min != '' && max != '') {
                if (vale < min || vale > max) {
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    console.log('** error variable ===>' + JSON.stringify(error));
                    console.log('** error variable 1 ===>' + error.textContent);
                    error.textContent = "Please enter a date betwin ", min, ' to ', max;
                    error.style.color = "red";
                    this.check_vali_next = false;
                    const cssevent2 = new CustomEvent("nextbtval", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent2);
                } else {
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + vale;
                    console.log('fulldata OUTPUT : ', fulldata);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    error.textContent = ""
                    this.check_vali_next = true;
                    const cssevent3 = new CustomEvent("nextbtvaltrue", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent3);
                }
            } else if (min != '' && max == '') {
                if (min <= vale) {
                    // alert('y r in only min');
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + vale;
                    console.log('fulldata OUTPUT : ', fulldata);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    error.textContent = ""
                    this.check_vali_next = true;
                    const cssevent3 = new CustomEvent("nextbtvaltrue", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent3);
                } else {
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    console.log('** error variable ===>' + JSON.stringify(error));
                    console.log('** error variable 1 ===>' + error.textContent);
                    error.textContent = "Please enter a date after to ", min;
                    error.style.color = "red";
                    this.check_vali_next = false;
                    const cssevent2 = new CustomEvent("nextbtval", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent2);
                }
            } else if (min == '' && max != '') {
                if (max >= vale) {
                    // alert('y r in only max');
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + vale;
                    console.log('fulldata OUTPUT : ', fulldata);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    var error = this.template.querySelector(`[data-id="${key}"]`);
                    error.textContent = "";
                    this.check_vali_next = true;
                    const cssevent3 = new CustomEvent("nextbtvaltrue", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent3);
                } else {
                    var error = this.template.querySelector(`[data-id="${key}"]`);
                    console.log('** error variable ===>' + JSON.stringify(error));
                    console.log('** error variable 1 ===>' + error.textContent);
                    error.textContent = "Please enter a date a bove to ", max;
                    error.style.color = "red";
                    this.check_vali_next = false;
                    const cssevent2 = new CustomEvent("nextbtval", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent2);
                }
            } else {
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + vale;
                console.log('fulldata OUTPUT : ', fulldata);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`);
                error.textContent = "";
                this.check_vali_next = true;
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);

            }
        } else if (fild_teye == 'datetime-local') {
            let min = event.target.min;
            let max = event.target.max;
            console.log('min val :- ', min);
            console.log('max val :- ', max);
            console.log('vale val :- ', vale);
            const valdatetime = new Date(vale);
            if (min != '' && max != '') {
                var min_date_time = min.split('T');
                var min_time = min_date_time[1];
                var max_date_time = max.split('T');
                var max_time = max_date_time[1];
                var che_max_timeArr = max_time.split(':');
                var che_min_timeArr = min_time.split(':');
                var full_max_time = max_date_time[0] + 'T' + che_max_timeArr[0] + ':' + che_max_timeArr[1];
                var full_min_time = min_date_time[0] + 'T' + che_min_timeArr[0] + ':' + che_min_timeArr[1];
                console.log('full_max_time :- ', full_max_time);
                console.log('full_min_time :- ', full_min_time);
                const maxdatetime = new Date(full_max_time);
                const mindatetime = new Date(full_min_time);
                // alert('y r in2');
                if (valdatetime < mindatetime || valdatetime > maxdatetime) {
                    var msg = 'Please enter a date betwin ' + mindatetime + ' to ' + maxdatetime;
                    this.Set_error_msg(msg, key);
                } else {
                    this.remove_error_msg(key, vale);
                }
            } else if (min != '' && max == '') {
                var min_date_time = min.split('T');
                var min_time = min_date_time[1];
                var che_min_timeArr = min_time.split(':');
                var full_min_time = min_date_time[0] + 'T' + che_min_timeArr[0] + ':' + che_min_timeArr[1];
                const mindatetime = new Date(full_min_time);
                if (valdatetime < mindatetime) {
                    var msg = 'Please enter a date above ' + mindatetime;
                    this.Set_error_msg(msg, key);
                } else {
                    this.remove_error_msg(key, vale);
                }

            } else if (min == '' && max != '') {
                var max_date_time = max.split('T');
                var max_time = max_date_time[1];
                var che_max_timeArr = max_time.split(':');
                var full_max_time = max_date_time[0] + 'T' + che_max_timeArr[0] + ':' + che_max_timeArr[1];
                const maxdatetime = new Date(full_max_time);
                if (valdatetime > maxdatetime) {
                    var msg = 'Please enter a date before ' + maxdatetime;
                    this.Set_error_msg(msg, key);
                } else {
                    this.remove_error_msg(key, vale);
                }

            } else {
                this.remove_error_msg(key, vale);
            }
        } else if (fild_teye == 'email') {
            var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            if (vale.match(mailformat)) {
                if (this.minimum > vale.length) {
                    // alert('pls enter min chater');
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    console.log('** error variable ===>' + JSON.stringify(error));
                    console.log('** error variable 1 ===>' + error.textContent);
                    error.textContent = 'Please enter a minimum ' + this.minimum + ' chater. ';
                    error.style.color = "red";
                    this.check_vali_next = false;
                    console.log('yash stru :- ', JSON.stringify(this.error_validation_json));
                    const cssevent2 = new CustomEvent("nextbtval", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent2);
                } else {
                    let splitparetan = '<!@!>';
                    let fulldata = key + splitparetan + vale;
                    console.log('fulldata OUTPUT : ', fulldata);
                    const cssevent1 = new CustomEvent("passfieldvalue", {
                        detail: fulldata
                    });
                    this.dispatchEvent(cssevent1);
                    var error = this.template.querySelector(`[data-id="${key}"]`)
                    error.textContent = ""
                    this.check_vali_next = true;
                    const cssevent3 = new CustomEvent("nextbtvaltrue", {
                        detail: key
                    });
                    this.dispatchEvent(cssevent3);
                }
            } else {
                var error = this.template.querySelector(`[data-id="${key}"]`)
                console.log('** error variable ===>' + JSON.stringify(error));
                console.log('** error variable 1 ===>' + error.textContent);
                error.textContent = " You have entered an invalid email address! ";
                error.style.color = "red";
                const cssevent2 = new CustomEvent("nextbtval", {
                    detail: key
                });
                this.dispatchEvent(cssevent2);
            }

        } else if (fild_teye == 'textarea') {
            if (this.minimum > vale.length) {
                // alert('pls enter min chater');
                var error = this.template.querySelector(`[data-id="${key}"]`)
                console.log('** error variable ===>' + JSON.stringify(error));
                console.log('** error variable 1 ===>' + error.textContent);
                error.textContent = 'Please enter a minimum ' + this.minimum + ' chater. ';
                error.style.color = "red";
                this.check_vali_next = false;
                console.log('yash stru :- ', JSON.stringify(this.error_validation_json));
                const cssevent2 = new CustomEvent("nextbtval", {
                    detail: key
                });
                this.dispatchEvent(cssevent2);
            } else {
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + 'textarea<QF>' + vale;
                console.log('fulldata OUTPUT : ', fulldata);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`)
                error.textContent = ""
                this.check_vali_next = true;
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
            }

        } else if (fild_teye == 'url') {
            var expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
            if (vale.match(expression)) {
                let splitparetan = '<!@!>';
                let fulldata = key + splitparetan + vale;
                console.log('fulldata OUTPUT : ', fulldata);
                const cssevent1 = new CustomEvent("passfieldvalue", {
                    detail: fulldata
                });
                this.dispatchEvent(cssevent1);
                var error = this.template.querySelector(`[data-id="${key}"]`)
                error.textContent = ""
                this.check_vali_next = true;
                const cssevent3 = new CustomEvent("nextbtvaltrue", {
                    detail: key
                });
                this.dispatchEvent(cssevent3);
            } else {
                var error = this.template.querySelector(`[data-id="${key}"]`)
                console.log('** error variable ===>' + JSON.stringify(error));
                console.log('** error variable 1 ===>' + error.textContent);
                error.textContent = " You have entered an invalid Link ";
                error.style.color = "red";
                const cssevent2 = new CustomEvent("nextbtval", {
                    detail: key
                });
                this.dispatchEvent(cssevent2);
            }

        } else {
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + vale;
            console.log('fulldata OUTPUT : ', fulldata);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
            var error = this.template.querySelector(`[data-id="${key}"]`)
            error.textContent = ""
            this.check_vali_next = true;
            const cssevent3 = new CustomEvent("nextbtvaltrue", {
                detail: key
            });
            this.dispatchEvent(cssevent3);

        }
    }
    @api show_error_msg(strString) {
        try {
            var error = this.template.querySelector(`[data-id="${strString}"]`);
            console.log('** error variable ===>' + JSON.stringify(error));
            console.log('** error variable 1 ===>' + error.textContent);
            error.textContent = "Please enter a valid number";
            error.style.color = "red";
            this.check_vali_next = false;
        } catch (error) {
            console.log("In the catch block ==> Method :** onDragOver ** || LWC:** formBuilder ** ==>", {
                error
            });
            console.log('above error ==>' + error);

        }
    }
    full_name(event) {
        try {
            // alert('yash');
            let label_name = event.target.name;
            let f_name = event.target.value;
            this.fullName[label_name] = f_name;
            // console.log( 'full name json :- ',JSON.stringify(this.fullName));
            let ne = this.fullName['salutation'];
            let ne2 = this.fullName['f_name'];
            let ne3 = this.fullName['s_name'];
            let FullName = 'fullname<QF>' + ne + '<QF>' + ne2 + '<QF>' + ne3;
            // console.log(' ne4 :-',FullName);
            var nameArr = FullName.split('<QF>');
            // console.log('data key OUTPUT : ',nameArr[0]);
            // console.log('data object OUTPUT : ',nameArr[1]);
            // console.log('data value OUTPUT : ',nameArr[2]);
            let key = event.target.dataset.name;
            let splitparetan = '<!@!>';
            let fulldata = key + splitparetan + FullName;
            // console.log('fulldata OUTPUT : ',fulldata);
            const cssevent1 = new CustomEvent("passfieldvalue", {
                detail: fulldata
            });
            this.dispatchEvent(cssevent1);
        } catch (error) {
            console.log('OUTPUT : Yash 1', error);
        }
    }
    address(event) {
        // alert('yash');
        let label_name = event.target.name;
        let ads_val = event.target.value;
        this.Address[label_name] = ads_val;
        // console.log( 'full name json :- ',JSON.stringify(this.fullName));
        let street = this.Address['street'];
        let city = this.Address['city'];
        let state = this.Address['state'];
        let zipcode = this.Address['zipcode'];
        let country = this.Address['country'];
        let FullAdd = 'add<QF>' + street + '<QF>' + city + '<QF>' + state + '<QF>' + zipcode + '<QF>' + country;
        console.log(' ne4 :-', FullAdd);
        var nameArr = FullAdd.split('<QF>');
        console.log('data key OUTPUT : ', nameArr[0]);
        console.log('data object OUTPUT : ', nameArr[1]);
        console.log('data value OUTPUT : ', nameArr[2]);
        let key = event.target.dataset.name;
        let splitparetan = '<!@!>';
        let fulldata = key + splitparetan + FullAdd;
        // console.log('fulldata OUTPUT : ',fulldata);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);

    }
    radiobutton(event) {
        let radio_val = event.target.value;
        // alert(radio_val);
        // var radio_val = this.template.querySelector(`input[name="${label_name}"]:checked`).value; 
        // alert('hello');
        // alert(radio_val);
        let key = event.target.dataset.name;
        console.log(" key    :- ", key);
        let splitparetan = '<!@!>';
        let splitparetan2 = 'redio<QF>';
        let fulldata = key + splitparetan + splitparetan2 + radio_val;
        // console.log('fulldata OUTPUT : ',fulldata);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);
    }
    check_box(event) {
        // alert('yash');
        let radio_val = event.target.value;
        let add_var = 'yes';
        for (let i = 0; i < this.chexk_val_list.length; i++) {
            if (this.chexk_val_list[i] == radio_val) {
                add_var = 'No';
                this.chexk_val_list.splice(i, 1);
            }
        }
        if (add_var == 'yes') {
            this.chexk_val_list.push(radio_val);
        }
        console.log('chek val :- ', JSON.stringify(this.chexk_val_list));
        let full_cheh_val;
        for (let i = 0; i < this.chexk_val_list.length; i++) {
            full_cheh_val = full_cheh_val + '<QF>' + this.chexk_val_list[i];
        }
        console.log(' full_cheh_val:- ', full_cheh_val);
        let key = event.target.dataset.name;
        let splitparetan = '<!@!>';
        let fulldata = key + splitparetan + 'chk_box<QF>' + full_cheh_val;
        // console.log('fulldata OUTPUT : ',fulldata);
        const cssevent1 = new CustomEvent("passfieldvalue", {
            detail: fulldata
        });
        this.dispatchEvent(cssevent1);

    }

    get displayText() {
        if (!this.termsAndConditionValue) {
            return 'Terms of Services';
        }
        return this.termsAndConditionValue;
    }
    clearreference() {
        this.template.querySelector('span[class="clearref"]').style.display = 'none';
        this.searchkey = '';
        this.usrViewBool = false;
    }
}