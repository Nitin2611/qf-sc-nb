import {
    api,
    LightningElement,
    track
} from 'lwc';
import close from '@salesforce/resourceUrl/popup_close';
import alert from '@salesforce/resourceUrl/popup_alert';

export default class Errorpopup extends LightningElement {
    alert_img = alert;
    close_img = close;
    show = false;
    @api header_type;
    @api error_messagee;

    @api errormessagee(type, messagee) {
        console.log('OUTPUT : show: ', this.show);
        this.show = true;
        console.log('OUTPUT : show :::', this.show);
        this.header_type = type;
        console.log('header_type==>', this.header_type);
        this.error_messagee = messagee;
        console.log('error_messagee=> ', this.error_messagee);
    }

    hideError() {
        this.show = false;
    }

    reload(event) {
        const reload = new CustomEvent('errorpopup');
        this.dispatchEvent(reload);
        this.show = false;
    }
}