public without sharing class objectSelection{
    public objectSelection(){
    }

    @AuraEnabled
    public static List<String> fetchParentObject(){
        try{
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Set<String> QFObjects = new Set<String>();
            List<QFObjects__mdt> metadataRecords = [SELECT Label
                                                    FROM QFObjects__mdt];
            for (QFObjects__mdt record : metadataRecords){
                QFObjects.add(record.Label);
            }

            Set<String> Objects = new Set<String>();
            for (Schema.SObjectType d : gd.values()){
                Schema.DescribeSObjectResult ds = d.getDescribe();
                if (!ds.isCreateable())
                    continue;
                if (ds.isCustom() == false && ds.getRecordTypeInfos().size() > 0 && !(QFObjects.contains(ds.getName())))
                    Objects.add(ds.getName());
                else if (ds.isCustom() && !(QFObjects.contains(ds.getName())))
                    Objects.add(ds.getName());
            }
            List<String> ParentObjs = new List<String>(Objects);
            ParentObjs.sort ();
            return ParentObjs;

        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'fetchChildObject1');
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<String> fetchChildObject(String parent){
        try{
            Set<string> SObjectList = new Set<string>();
            Schema.SObjectType convertType = Schema.getGlobalDescribe().get(parent);
            Schema.DescribeSObjectResult R = convertType.getDescribe();
            for (Schema.ChildRelationship cr : R.getChildRelationships()){
                String temp = String.valueOf(cr.getChildSObject());
                SObjectList.add(temp) ;
            }
            List<String> ChildObject = new List<String>(SObjectList);
            return ChildObject;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'fetchChildObject1');
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static Map<String, List<String>> fetchChildObject1(List<String> parentList){
        Map<String, List<String>> SObjectMap = new Map<String, List<String>>();
        try{
        for (String Par : parentList){
            List<String> Sobject2 = new List<String>();
            Schema.SObjectType convertType = Schema.getGlobalDescribe().get(Par);
            Schema.DescribeSObjectResult R = convertType.getDescribe();
            for (Schema.ChildRelationship cr : R.getChildRelationships()){
                if (parentList.contains(String.valueOf(cr.getChildSObject()))){
                    if (!SObjectMap.containsKey(Par)){
                        SObjectMap.put(Par, new List<String>());
                    }
                    SObjectMap.get(par).add(String.valueOf(cr.getChildSObject()));
                }
            }
        }
        System.debug('SObjectMap>>' + SObjectMap);
        return SObjectMap;


        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'fetchChildObject1');
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<String> temp2(List<String> Parent){
        try{

        List<String> Temp2 = new List<String>();
        List<String> Test = new List<String>();
        // Test = Parent;
        Map<String, List<String>> ParentObjects = new Map<String, List<String>>();
        ParentObjects = fetchChildObject1(Parent);
        for (String lst : ParentObjects.keySet()){
            if ((ParentObjects.get(lst)).size() >= 1){
                Temp2.add(lst);
            }
        }
        return Temp2;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'temp2');
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<String> temp3(List<String> Parent){
        try{
        List<String> Temp3 = new List<String>();
        List<String> Test = new List<String>();
        // Test = fetchParentObject();
        Test = Parent;
        Map<String, List<String>> ParentObjects = new Map<String, List<String>>();
        ParentObjects = fetchChildObject1(Test) ;
        for (String lst : ParentObjects.keySet()){
            if ((ParentObjects.get(lst)).size() >= 2){
                Temp3.add(lst);
            }
        }
        return Temp3;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'saveMapped_object');
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static String saveMapped_object(String Mapped_Objects, String FormTitle, String FormDesc, String ProgressIndicator, String CaptchaType){
        try{
            String Styles = 'width:100%;padding-top:0%;padding-bottom:0%;padding-left:0%;padding-right:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;';
            String PageStyle = 'padding-top:0%;padding-bottom:0%;background-color:#FFFFFF;background-size:auto;background-position:top center;background-repeat:Repeat;background-attachment:Fixed;border-color:#000000;border-style:Solid;border-width:1px;border-radius:0px;';
            String FieldStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#242424;font-size:12px;font-style:Normal;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
            String HoverStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#000000;font-size:12px;font-style:Normal;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
            String FocusStyle = 'background-color:#FFFFFF;border-color:#000000;border-style:Solid;border-width:1px;border-radius:5px;font-family:Arial;font-weight:Normal;color:#000000;font-size:12px;font-style:Normal;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;line-height:1.5;';
            String LabelStyle = 'justify-content:Left;font-family:Arial;font-weight:Normal;font-style:Normal;font-size:12px;line-height:1;color:#000000;margin-top:0px;margin-bottom:0px;';
            String ButtonStyle = ' background-color: #6699CC;border-color:#FFFFFF; height: 35px; width: 120px; font-size: 16px; border-width:0px; border-style:Solid; border-radius: 28px; font-family:Arial;font-weight:Normal;color:#FFFFFF;font-style:Normal;padding-left:5%px;padding-right:0px;padding-top:0px;padding-bottom:0px;';
            Form__c form = new Form__c(Name = FormTitle, Mapped_Objects__c = Mapped_Objects, Captcha_Type__c = CaptchaType, Form_Description__c = FormDesc, Progress_Indicator__c = ProgressIndicator, Form_Styling__c = Styles, All_Field_Styling__c = FieldStyle, Page_CSS__c = PageStyle, Label_CSS__c = LabelStyle, All_Field_Focus__c = FocusStyle, All_Field_Hover__c = HoverStyle, Button_CSS__c = ButtonStyle, Button_Position__c = 'justify-content:Center;gap:0px;');
            Database.insert (form);
            List<String> lst = Mapped_Objects.split(',');
            System.debug(form.Id);
            List<Form_Page__c> FormPages = new List<Form_Page__c>();
            Integer pageNum = 1;
            for (String obj : lst){
                Form_Page__c Fpage = new Form_Page__c(Name = obj + ' Page', Form__c = form.Id, Page_Number__c = pageNum);
                FormPages.add(Fpage);
                pageNum++;
            }
            Database.insert (FormPages);

            Thankyou_Page__c thankyoupage = new Thankyou_Page__c(Name = form.Name, Form__c = form.Id, Thankyou_Page_Type__c = 'None');
            insert thankyoupage;
            return form.Id;
        } catch (Exception e){
            error_handler.insert_errordata(e, 'objectSelection', 'saveMapped_object');
            System.debug(e.getMessage());
            //throw new AuraHandledException(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static Map<String, String> getStandardIconMap(){

        Map<String, String> objectIconMap = new Map<String, String>{'Account' => 'standard:account',
                                                                    'Address' => 'standard:address',
                                                                    'AlternativePaymentMethod' => 'standard:payment_gateway',
                                                                    'Announcement' => 'standard:announcement',
                                                                    'AppAnalyticsQueryRequest' => 'standard:care_request_reviewer',
                                                                    'AppointmentTopicTimeSlot' => 'standard:timeslot',
                                                                    'ApptBundleAggrDurDnscale' => 'standard:event',
                                                                    'ApptBundleAggrPolicy' => 'standard:aggregation_policy',
                                                                    'ApptBundleConfig' => 'standard:bundle_config',
                                                                    'ApptBundlePolicy' => 'standard:bundle_policy',
                                                                    'ApptBundlePolicySvcTerr' => 'standard:service_territory_policy',
                                                                    'ApptBundlePropagatePolicy' => 'standard:propagation_policy',
                                                                    'ApptBundleRestrictPolicy' => 'standard:restriction_policy',
                                                                    'ApptBundleSortPolicy' => 'standard:sort_policy',
                                                                    'Asset' => 'standard:asset_object',
                                                                    'AssetDowntimePeriod' => 'standard:asset_downtime_period',
                                                                    'AssetRelationship' => 'standard:asset_relationship',
                                                                    'AssetWarranty' => 'standard:asset_warranty',
                                                                    'AssociatedLocation' => 'standard:location',
                                                                    'AttributeDefinition' => 'standard:variation_attribute_setup',
                                                                    'AuthorizationForm' => 'standard:form',
                                                                    'AuthorizationFormConsent' => 'standard:form',
                                                                    'AuthorizationFormDataUse' => 'standard:form',
                                                                    'AuthorizationFormText' => 'standard:form',
                                                                    'BusinessBrand' => 'standard:store',
                                                                    'CalendarView' => 'standard:date_input',
                                                                    'Campaign' => 'standard:campaign',
                                                                    'CampaignMember' => 'standard:campaign_members',
                                                                    'CardPaymentMethod' => 'standard:contract_payment',
                                                                    'Case' => 'standard:case',
                                                                    'CollaborationGroup' => 'standard:live_chat',
                                                                    'CollaborationGroupRecord' => 'standard:live_chat',
                                                                    'CommSubscription' => 'standard:product_consumed',
                                                                    'CommSubscriptionChannelType' => 'standard:channel_program_levels',
                                                                    'CommSubscriptionConsent' => 'standard:product_consumed',
                                                                    'CommSubscriptionTiming' => 'standard:channel_program_history',
                                                                    'ConsumptionRate' => 'standard:product_consumed_state',
                                                                    'ConsumptionSchedule' => 'standard:product_consumed_state',
                                                                    'Contact' => 'standard:contact',
                                                                    'ContactPointAddress' => 'standard:address',
                                                                    'ContactPointConsent' => 'standard:address',
                                                                    'ContactPointEmail' => 'standard:email',
                                                                    'ContactPointPhone' => 'standard:call',
                                                                    'ContactPointTypeConsent' => 'standard:contact',
                                                                    'ContactRequest' => 'standard:contact_request',
                                                                    'ContentVersion' => 'standard:file',
                                                                    'Contract' => 'standard:contract',
                                                                    'ContractGroupPlan' => 'standard:contract',
                                                                    'ContractGroupPlanGroupClass' => 'standard:contract',
                                                                    'ContractLineItem' => 'standard:contract_line_item',
                                                                    'Customer' => 'standard:customer',
                                                                    'DataUseLegalBasis' => 'standard:product_consumed',
                                                                    'DataUsePurpose' => 'standard:product_consumed',
                                                                    'DigitalWallet' => 'standard:connect_wallet',
                                                                    'DuplicateRecordItem' => 'custom:custom49',
                                                                    'DuplicateRecordSet' => 'standard:record',
                                                                    'EngagementChannelType' => 'standard:channel_programs',
                                                                    'Entitlement' => 'standard:entitlement',
                                                                    'EntitlementContact' => 'standard:people',
                                                                    'Event' => 'standard:event',
                                                                    'Expense' => 'standard:expense',
                                                                    'ExpenseReport' => 'standard:expense_report',
                                                                    'ExpenseReportEntry' => 'standard:expense_report_entry',
                                                                    'ExpressionFilter' => 'standard:filter',
                                                                    'ExpressionFilterCriteria' => 'standard:filter_criteria',
                                                                    'FinanceTransaction' => 'standard:crypto_transaction',
                                                                    'FlowRecordRelation' => 'standard:flow',
                                                                    'GroupCensus' => 'standard:groups',
                                                                    'GroupCensusMember' => 'standard:groups',
                                                                    'GroupCensusMemberPlan' => 'standard:groups',
                                                                    'GroupClass' => 'standard:groups',
                                                                    'GroupClassContribution' => 'standard:groups',
                                                                    'Idea' => 'standard:solution',
                                                                    'Image' => 'custom:custom38',
                                                                    'Individual' => 'standard:individual',
                                                                    'InsuranceContract' => 'standard:entitlement_policy',
                                                                    'JobProfile' => 'standard:job_profile',
                                                                    'Lead' => 'standard:lead',
                                                                    'LegalEntity' => 'standard:entity',
                                                                    'ListEmail' => 'standard:list_email',
                                                                    'ListEmailIndividualRecipient' => 'standard:email',
                                                                    'ListEmailRecipientSource' => 'standard:email',
                                                                    'Location' => 'standard:location',
                                                                    'LocationGroup' => 'standard:location',
                                                                    'LocationGroupAssignment' => 'standard:location',
                                                                    'Macro' => 'standard:macros',
                                                                    'MacroInstruction' => 'standard:macros',
                                                                    'MaintenanceAsset' => 'standard:maintenance_asset',
                                                                    'MaintenancePlan' => 'standard:maintenance_plan',
                                                                    'MaintenanceWorkRule' => 'standard:maintenance_work_rule',
                                                                    'Opportunity' => 'standard:opportunity',
                                                                    'Order' => 'standard:orders',
                                                                    'OrgMetric' => 'standard:dashboard',
                                                                    'OrgMetricScanResult' => 'standard:dashboard_ea',
                                                                    'OrgMetricScanSummary' => 'standard:dashboard_component',
                                                                    'PartyConsent' => 'custom:custom69',
                                                                    'Payment' => 'standard:contract_payment',
                                                                    'PaymentAuthAdjustment' => 'standard:contract_payment',
                                                                    'PaymentAuthorization' => 'standard:contract_payment',
                                                                    'PaymentGateway' => 'standard:payment_gateway',
                                                                    'PaymentGatewayLog' => 'standard:payment_gateway',
                                                                    'PaymentGroup' => 'standard:partner_fund_request',
                                                                    'PaymentLineInvoice' => 'standard:payment_gateway',
                                                                    'Pricebook2' => 'standard:pricebook',
                                                                    'ProcessException' => 'standard:process_exception',
                                                                    'Product2' => 'standard:product',
                                                                    'ProductConsumed' => 'standard:product_consumed',
                                                                    'ProductConsumptionSchedule' => 'standard:product_consumed',
                                                                    'ProductItem' => 'standard:product_item',
                                                                    'ProductRequest' => 'standard:product_request',
                                                                    'ProductRequestLineItem' => 'standard:product_request_line_item',
                                                                    'ProductRequired' => 'standard:product_required',
                                                                    'ProductServiceCampaign' => 'standard:product_service_campaign',
                                                                    'ProductServiceCampaignItem' => 'standard:product_service_campaign_item',
                                                                    'ProductTransfer' => 'standard:product_transfer',
                                                                    'ProductWarrantyTerm' => 'standard:product_warranty_term',
                                                                    'ProfileSkill' => 'standard:skill',
                                                                    'ProfileSkillEndorsement' => 'standard:skill_entity',
                                                                    'ProfileSkillUser' => 'standard:skill_entity',
                                                                    'PromptAction' => 'standard:prompt',
                                                                    'PromptError' => 'standard:prompt',
                                                                    'QuickText' => 'standard:quick_text',
                                                                    'Recommendation' => 'standard:feedback',
                                                                    'RecommendationResponse' => 'standard:feedback',
                                                                    'RecordAction' => 'standard:record',
                                                                    'Refund' => 'standard:contract_payment',
                                                                    'RefundLinePayment' => 'standard:contract_payment',
                                                                    'ResourceAbsence' => 'standard:resource_absence',
                                                                    'ReturnOrder' => 'standard:return_order',
                                                                    'ReturnOrderLineItem' => 'standard:return_order_line_item',
                                                                    'SchedulingConstraint' => 'standard:scheduling_constraint',
                                                                    'Scorecard' => 'standard:scan_card',
                                                                    'ScorecardAssociation' => 'standard:scan_card',
                                                                    'ScorecardMetric' => 'standard:scan_card',
                                                                    'SearchPromotionRule' => 'standard:search',
                                                                    'Seller' => 'standard:partner_fund_allocation',
                                                                    'SerializedProduct' => 'standard:serialized_product',
                                                                    'ServiceAppointment' => 'standard:service_appointment',
                                                                    'ServiceContract' => 'standard:service_contract',
                                                                    'ServiceCrew' => 'standard:service_crew',
                                                                    'ServiceCrewMember' => 'standard:service_crew_member',
                                                                    'ServiceResource' => 'standard:service_resource',
                                                                    'ServiceResourcePreference' => 'standard:service_territory',
                                                                    'ServiceTerritory' => 'standard:service_territory',
                                                                    'ServiceTerritoryLocation' => 'standard:location',
                                                                    'SetupAssistantStep' => 'standard:setup_modal',
                                                                    'Shift' => 'standard:shift',
                                                                    'ShiftTemplate' => 'standard:shift_template',
                                                                    'Shipment' => 'standard:shipment',
                                                                    'ShipmentItem' => 'standard:shipment',
                                                                    'Solution' => 'standard:solution',
                                                                    'Task' => 'standard:task',
                                                                    'TimeSheet' => 'standard:timesheet',
                                                                    'TimeSheetEntry' => 'standard:timesheet_entry',
                                                                    'TravelMode' => 'standard:location',
                                                                    'UnitOfMeasure' => 'custom:custom79',
                                                                    'UserEmailPreferredPerson' => 'standard:people',
                                                                    'WarrantyTerm' => 'standard:warranty_term',
                                                                    'WorkAccess' => 'standard:work_queue',
                                                                    'WorkBadge' => 'standard:skill_requirement',
                                                                    'WorkBadgeDefinition' => 'standard:skill_requirement',
                                                                    'WorkOrder' => 'standard:work_order',
                                                                    'WorkOrderLineItem' => 'standard:work_order_item',
                                                                    'WorkPlan' => 'standard:work_plan',
                                                                    'WorkPlanSelectionRule' => 'standard:work_plan_rule',
                                                                    'WorkPlanTemplate' => 'standard:work_plan_template',
                                                                    'WorkPlanTemplateEntry' => 'standard:work_plan_template_entry',
                                                                    'WorkStep' => 'standard:work_step',
                                                                    'WorkStepTemplate' => 'standard:work_step_template',
                                                                    'WorkThanks' => 'standard:thanks',
                                                                    'WorkType' => 'standard:work_type',
                                                                    'WorkTypeGroup' => 'standard:work_type_group',
                                                                    'WorkTypeGroupMember' => 'standard:team_member'};    

        return objectIconMap;
    }
}