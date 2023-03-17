import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import copyIcon from '@salesforce/resourceUrl/CopyUrlIcon';
import htmlIcon from '@salesforce/resourceUrl/html';
import jsIcon from '@salesforce/resourceUrl/js';
import cssIcon from '@salesforce/resourceUrl/css'; //static resource for copy url icon
import siteUrl from "@salesforce/apex/customMetadata.siteUrl";
// import {
//     loadStyle
// } from 'lightning/platformResourceLoader';
import GroupRadio from '@salesforce/resourceUrl/groupRadio';
import qrcode from './qrcode.js';

export default class Qf_publish extends LightningElement {
    copy_Icon = copyIcon;
    html_Icon = htmlIcon;
    css_Icon = cssIcon;
    js_Icon = jsIcon;
    @track spinner = false;
    readonly = true;
    lightBoxOpt; // Required to check css
    formSiteURL = true; // Not sure
    usingAura = true; // proper required css
    usingLWC; // proper required css
    formIFrame; // proper required css
    formLightBox;
    formTextLink = true;
    formImageLink;
    formAutoPopup;
    floatingButton;
    formQRCode;
    @track formurl = '';
    @track srcurl;
    @api currentformid;
    @track publishment_value = 'aura';
    @track text_b_color = "background-color: #b2CCE5;";
    @track img_b_color = "background-color: #ffffff;";
    @track auto_b_color = "background-color: #ffffff;";
    @track floating_b_color = "background-color: #ffffff;";
    aura = false;
    lwc = false;
    iframe = false;
    QRCode = false;
    lightBox = false;

    connectedCallback() {
        this.spinner = true;
        console.log('OUTPUT to connectedcallback : ', this.currentformid);
        siteUrl({
                Formid: this.currentformid
            })
            .then(data => {
                this.formurl = data;
                this.srcurl = data;
                if (this.formurl.includes("User Configuration tab")) {
                    this.srcurl = '';
                    this.template.querySelector('.inputBox').style.color = 'red';
                }
                this.spinner = false;
                this.error = undefined;
            })
            .catch(error => {
                console.log({
                    error
                });
                this.message = 'Something Went Wrong In Publish Page';
                this.showerror(this.message);
                this.spinner = false;
            })
        this.aura = true;

    }


    renderedCallback() {

        // Promise.all([
        //         loadStyle(this, GroupRadio)
        //     ]).then(() => {
        //         console.log('Files loaded');
        //     })
        //     .catch(error => {
        //         console.log(error.body.message);
        //     });

    }


    // get option() {
    //     return [{
    //             'label': 'Aura Component',
    //             'value': 'aura',
    //             'checked': 'true'
    //         },
    //         {
    //             'label': 'LWC',
    //             'value': 'lwc'
    //         },
    //         {
    //             'label': 'iFrame',
    //             'value': 'iframe'
    //         },
    //         {
    //             'label': 'QR Code',
    //             'value': 'QR Code'
    //         },
    //         {
    //             'label': 'Lightbox',
    //             'value': 'lightBox'
    //         },
    //     ]
    // }

    copyTextFieldHelper(event) {
        this.copyToClipboard('.inputBox', '.urlCopied');
    }




    copyDivToClipboard_1() {
        this.copyToClipboard(".copyCodeSection_12", ".copiedtext1");
    }
    copyDivToClipboard_2() {
        this.copyToClipboard(".copyCodeSection_22", ".copiedtext2");
    }
    copyDivToClipboard_3() {
        this.copyToClipboard(".copyCodeSection_32", ".copiedtext3");
    }

    copyToClipboard(elementSelector, copiedTextSelector) {
        try {
            const range = document.createRange();
            let parentDiv = null;
            let hiddenInput = null;

            if (elementSelector === '.codestyle') {
                parentDiv = event.currentTarget.parentNode.parentNode.querySelector('.codestyle');
                range.selectNode(parentDiv);
            } else if (elementSelector === '.inputBox') {
                hiddenInput = this.template.querySelector('.inputBox');
                range.selectNode(hiddenInput);
            } else {
                range.selectNode(this.template.querySelector(elementSelector));
            }

            window.getSelection().removeAllRanges();
            window.getSelection().addRange(range);
            document.execCommand("copy");

            const copied = this.template.querySelector(copiedTextSelector);
            copied.style.display = 'block';
            setTimeout(() => {
                copied.style.display = 'none';
                window.getSelection().removeAllRanges();
            }, 1500);
        } catch (e) {
            if (copiedTextSelector === '.urlCopied') {
                component.find("toastCmp").showToastModel("Something went wrong", "error");
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Something went wrong',
                        variant: 'error'
                    })
                );
            }
        }
    }


    copy_code_fir_lwc(event) {
        console.log('method in copy_code_fir_lwc');
        this.copyToClipboard('.codestyle', null);
    }

    handleRadioChange(event) {
        console.log('handleRadioChange----->', event.target.value);
        const selectedOption = event.target.value;

        if (selectedOption == 'aura') {
            this.usingAura = true;
            this.aura = true;
            this.lwc = false;
            this.iframe = false;
            this.QRCode = false;
            this.lightBox = false;
        } else {
            this.usingAura = false;
        }


        if (selectedOption == 'lwc') {
            this.usingLWC = true;
            this.aura = false;
            this.lwc = true;
            this.iframe = false;
            this.QRCode = false;
            this.lightBox = false;
        } else {
            this.usingLWC = false;
        }


        if (selectedOption == 'iframe') {
            this.formIFrame = true;
            this.aura = false;
            this.lwc = false;
            this.iframe = true;
            this.QRCode = false;
            this.lightBox = false;
        } else {
            this.formIFrame = false;
        }


        if (selectedOption == 'QRCode') {
            this.formQRCode = true;
            this.aura = false;
            this.lwc = false;
            this.iframe = false;
            this.QRCode = true;
            this.lightBox = false;
        } else {
            this.formQRCode = false;
        }

        if (selectedOption == 'lightBox') {
            this.formLightBox = true;
            this.lightBoxOpt = true;
            this.aura = false;
            this.lwc = false;
            this.iframe = false;
            this.QRCode = false;
            this.lightBox = true;
        } else {
            this.formLightBox = false;
            this.lightBoxOpt = false;
        }
    }


    handleLightBoxChange(event) {
        console.log('u r in select lightbox');

        var getDiv = event.target.dataset.id;
        console.log('u r in select lightbox :-', getDiv);

        var img = 'lightBoxAcc';


        if (getDiv == 'textLink') {
            this.formTextLink = true;
            this.formImageLink = false;
            this.formAutoPopup = false;
            this.floatingButton = false;

            this.text_b_color = "background-color: #b2CCE5;";
            this.img_b_color = "background-color: #ffffff;";
            this.auto_b_color = "background-color: #ffffff;";
            this.floating_b_color = "background-color: #ffffff;";
        }
        if (getDiv == 'imageLink') {
            this.formTextLink = false;
            this.formImageLink = true;
            this.formAutoPopup = false;
            this.floatingButton = false;
            this.text_b_color = "background-color: #ffffff;";
            this.img_b_color = "background-color: #b2CCE5;";
            this.auto_b_color = "background-color: #ffffff;";
            this.floating_b_color = "background-color: #ffffff;";
        }
        if (getDiv == 'autoPopup') {
            this.formTextLink = false;
            this.formImageLink = false;
            this.formAutoPopup = true;
            this.floatingButton = false;
            this.text_b_color = "background-color: #ffffff;";
            this.img_b_color = "background-color: #ffffff;";
            this.auto_b_color = "background-color: #b2CCE5;";
            this.floating_b_color = "background-color: #ffffff;";
        }
        if (getDiv == 'floatingBtn') {
            this.formTextLink = false;
            this.formImageLink = false;
            this.formAutoPopup = false;
            this.floatingButton = true;
            this.text_b_color = "background-color: #ffffff;";
            this.img_b_color = "background-color: #ffffff;";
            this.auto_b_color = "background-color: #ffffff;";
            this.floating_b_color = "background-color: #b2CCE5;";
        }


    }


    qrGenerate() {
        const qrCodeGenerated = new qrcode(0, 'H');

        let strForGenearationOfQRCode = this.formurl;
        qrCodeGenerated.addData(strForGenearationOfQRCode);
        qrCodeGenerated.make();
        let element = this.template.querySelector(".qrcode2");
        element.innerHTML = qrCodeGenerated.createSvgTag({});
    }

    errorpopupcall(event) {
        location.reload();
    }

    @api showerror() {
        console.log('this.error_popup => ', this.error_popup);
        this.error_popup = true;
        let errordata = {
            header_type: 'Notification Page',
            Message: this.message
        };
        const showpopup = new CustomEvent('showerrorpopup', {
            detail: errordata
        });
        this.dispatchEvent(showpopup);
    }

    showerrorpopup(event) {
        console.log('showerrorpopup', event.detail.Message);
        this.template.querySelector('c-errorpopup').errormessagee(event.detail.header_type, event.detail.Message);
    }

}