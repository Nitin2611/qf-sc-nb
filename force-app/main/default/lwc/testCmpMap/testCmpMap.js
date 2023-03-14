import { LightningElement,track } from 'lwc';
import getMapRecord from '@salesforce/apex/objectSelection.getStandardIconMap';
 
export default class TestMapCmp extends LightningElement {    

    @track mapData= []; 

    connectedCallback(){
        this.getRecords();        
    }

    getRecords(){
        getMapRecord({ })
        .then(result => {
            console.log('res-->>',result);                        
            var conts = result;
            for(var key in conts){
                this.mapData.push({value:conts[key], key:key});
            }           
            // result.forEach((value, key) => {
            //     console.log(`${key} is ${value}`);
            // });
        })
    }

}