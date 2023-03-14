import { LightningElement } from 'lwc';
// import { loadScript } from 'lightning/platformResourceLoader';
import pagenotfound from '@salesforce/resourceUrl/PageNotFound';

export default class PageNotFound extends LightningElement {
    pnf = pagenotfound;

    // showControls = false;
    // videoUrl;

    // handleLoadedMetadata(event) {
    //     console.log(event);
    //     const video = event.target;
    //     video.play();
    // }
    // connectedCallback() {
    //     loadScript(this, pagenotfound)
    //     .then(() => {
    //         this.videoUrl = pagenotfound;
    //     })
    //     .catch(error => {
    //         console.error(error);
    //     });
    // }
}