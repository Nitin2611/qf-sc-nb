public class qf_guide2_Controller {

    @AuraEnabled
    public static List<Site> getSites() {
        try {
            return [SELECT Id, Name, MasterLabel, Subdomain, SiteType, Status FROM Site WHERE Status='Active' ];
        } catch (Exception e) {
            // error_handler.insert_errordata(e,'qf_guide2_Controller','saveSecureUrl');
            return null;
        }
    }

    @AuraEnabled
    public static void saveSecureUrl(Id selectedSiteid) {
        try {
            SiteDetail siteDetail = [SELECT Id, SecureUrl FROM SiteDetail WHERE DurableId = :selectedSiteid];
            QuickForm_Administration__c customSetting = QuickForm_Administration__c.getOrgDefaults();
            customSetting.SecureUrl__c = siteDetail.SecureUrl;
            customSetting.SiteId__c = selectedSiteid;
            upsert customSetting;
        } catch (Exception e) {
            // error_handler.insert_errordata(e,'qf_guide2_Controller','saveSecureUrl');
            // return null;
        }
    }

    @AuraEnabled
    public static String getSettingData() {
        try {
            QuickForm_Administration__c customSetting = QuickForm_Administration__c.getOrgDefaults();
            return customSetting.SiteId__c;    
        } catch (Exception e) {
            // error_handler.insert_errordata(e,'qf_guide2_Controller','saveSecureUrl');
            return null;
        }
    }

    // get site from org 
    @AuraEnabled
    public static List<String> getSitePrefixes() {
        try {
            List<String> sitePrefixes = new List<String>();
            for(Site site : [SELECT Id, Name, Subdomain, SiteType, Status FROM Site WHERE Status='Active']) {
                if(site.SiteType == 'Site') {
                    sitePrefixes.add(site.Subdomain);
                }
            }
            return sitePrefixes;
            
        } catch (Exception e) {
            // error_handler.insert_errordata(e,'qf_guide2_Controller','saveSecureUrl');
            return null;
        }
    }
}