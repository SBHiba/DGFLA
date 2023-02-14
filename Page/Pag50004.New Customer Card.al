page 50004 "DGF New Customer Card"
{
    Caption = 'New Customer Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,New Document,Approve,Request Approval,Prices,Navigate,Customer';
    RefreshOnActivate = true;
    SourceTable = Customer;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    Visible = NoFieldVisible;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';

                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the name.';
                    Visible = false;
                }

                field("Document Sending Profile"; Rec."Document Sending Profile")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the preferred method of sending documents to this customer, so that you do not have to select a sending option every time that you post and send a document to the customer. Sales documents to this customer will be sent using the specified sending profile and will override the default document sending profile.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the customer card was last modified.';
                }
                field("Disable Search by Name"; Rec."Disable Search by Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that you can change customer name in the document, because the name is not used in search.';
                }
            }
            group(AddressAndContact)
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region of the address.';


                    }
                    field(City; Rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    group(Control10)
                    {
                        ShowCaption = false;
                        Visible = IsCountyVisible;
                        field(County; Rec.County)
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the state, province or county as a part of the address.';
                        }
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            Rec.DisplayMap;
                        end;
                    }
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(MobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the customer''s mobile telephone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s fax number.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer''s home page address.';
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the language to be used on printouts for this customer.';
                }
                group(ContactDetails)
                {
                    Caption = 'Contact';
                    field("Primary Contact No."; Rec."Primary Contact No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Code';
                        Importance = Additional;
                        ToolTip = 'Specifies the contact number for the customer.';
                    }
                    field(ContactName; Rec.Contact)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Name';
                        Editable = ContactEditable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';

                        trigger OnValidate()
                        begin
                            ContactOnAfterValidate;
                        end;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control149; "Customer Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = NOT IsOfficeAddin;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
                Visible = NOT IsOfficeAddin;
            }
            part(Details; "Office Customer Details")
            {
                ApplicationArea = All;
                Caption = 'Details';
                SubPageLink = "No." = FIELD("No.");
                Visible = IsOfficeAddin;
            }

            part(Control1905532107; "Dimensions FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Customer")
            {
                Caption = 'Customer';
                Image = Customer;
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action(ShipToAddresses)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to Addresses';
                    Image = ShipAddress;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = FIELD("No.");
                    ToolTip = 'View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.';
                }
                action(Contact)
                {
                    AccessByPermission = TableData Contact = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ToolTip = 'View or edit detailed information about the contact person at the customer.';

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
                action("Comments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category9;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                action(CustomerReportSelections)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Layouts';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ToolTip = 'Set up a layout for different types of documents such as invoices, quotes, and credit memos.';

                    trigger OnAction()
                    var
                        CustomReportSelection: Record "Custom Report Selection";
                    begin
                        CustomReportSelection.SetRange("Source Type", DATABASE::Customer);
                        CustomReportSelection.SetRange("Source No.", Rec."No.");
                        PAGE.RunModal(PAGE::"Customer Report Selections", CustomReportSelection);
                    end;
                }
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    var
        WorkflowStepInstance: Record "Workflow Step Instance";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        if NewMode then
            CreateCustomerFromTemplate
        else
            if FoundationOnly then
                StartBackgroundCalculations();
        ActivateFields;
        SetCreditLimitStyle();

        if CRMIntegrationEnabled or CDSIntegrationEnabled then begin
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
            if Rec."No." <> xRec."No." then
                CRMIntegrationManagement.SendResultNotification(Rec);
        end;

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        if AnyWorkflowExists then begin
            CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
            WorkflowStepInstance.SetRange("Record ID", Rec.RecordId);
            ShowWorkflowStatus := not WorkflowStepInstance.IsEmpty();
            if ShowWorkflowStatus then
                CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
            OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
            if OpenApprovalEntriesExist then
                OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId)
            else
                OpenApprovalEntriesExistCurrUser := false;
        end;
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        PrevCountryCode := '*';
        FoundationOnly := ApplicationAreaMgmtFacade.IsFoundationEnabled;

        ContactEditable := true;

        OpenApprovalEntriesExistCurrUser := true;

        CaptionTxt := CurrPage.Caption;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then
            if Rec."No." = '' then
                if DocumentNoVisibility.CustomerNoSeriesIsDefault then
                    NewMode := true;
    end;

    trigger OnOpenPage()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        EnvironmentInfo: Codeunit "Environment Information";
        ItemReferenceMgt: Codeunit "Item Reference Management";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        OfficeManagement: Codeunit "Office Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled();
        CDSIntegrationEnabled := CRMIntegrationManagement.IsCDSIntegrationEnabled();
        if CRMIntegrationEnabled or CDSIntegrationEnabled then
            if IntegrationTableMapping.Get('CUSTOMER') then
                BlockedFilterApplied := IntegrationTableMapping.GetTableFilter().Contains('Field39=1(0)');
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();

        OnBeforeGetSalesPricesAndSalesLineDisc(LoadOnDemand);
        SetNoFieldVisible();

        IsSaaS := EnvironmentInfo.IsSaaS();
        IsOfficeAddin := OfficeManagement.IsAvailable;
        WorkFlowEventFilter :=
            WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
            WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;
        SetWorkFlowEnabled();
        OnAfterOnOpenPage(Rec, xRec);
    end;

    local procedure StartBackgroundCalculations()
    var
        CustomerCardCalculations: Codeunit "Customer Card Calculations";
        Args: Dictionary of [Text, Text];
    begin
        if (BackgroundTaskId <> 0) then
            CurrPage.CancelBackgroundTask(BackgroundTaskId);

        DaysPastDueDate := 0;
        ExpectedMoneyOwed := 0;
        AvgDaysToPay := 0;
        TotalMoneyOwed := 0;
        AttentionToPaidDay := false;
        AmountOnPostedInvoices := 0;
        AmountOnPostedCrMemos := 0;
        AmountOnOutstandingInvoices := 0;
        AmountOnOutstandingCrMemos := 0;
        Totals := 0;
        AdjmtCostLCY := 0;
        AdjCustProfit := 0;
        AdjProfitPct := 0;
        CustInvDiscAmountLCY := 0;
        CustPaymentsLCY := 0;
        CustSalesLCY := 0;
        CustProfit := 0;
        NoPostedInvoices := 0;
        NoPostedCrMemos := 0;
        NoOutstandingInvoices := 0;
        NoOutstandingCrMemos := 0;
        OverdueBalance := 0;



        CurrPage.EnqueueBackgroundTask(BackgroundTaskId, Codeunit::"Customer Card Calculations", Args);

        Session.LogMessage('0000D4Q', StrSubstNo(PageBckGrndTaskStartedTxt, Rec."No."), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', CustomerCardServiceCategoryTxt);
    end;

    var
        CalendarMgmt: Codeunit "Calendar Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CustomerMgt: Codeunit "Customer Mgt.";
        FormatAddress: Codeunit "Format Address";
        StyleTxt: Text;
        [InDataSet]
        ContactEditable: Boolean;
        CRMIntegrationEnabled: Boolean;
        CDSIntegrationEnabled: Boolean;
        BlockedFilterApplied: Boolean;
        ExtendedPriceEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        NoFieldVisible: Boolean;
        BalanceExhausted: Boolean;
        AttentionToPaidDay: Boolean;
        IsOfficeAddin: Boolean;
        NoPostedInvoices: Integer;
        NoPostedCrMemos: Integer;
        NoOutstandingInvoices: Integer;
        NoOutstandingCrMemos: Integer;
        Totals: Decimal;
        AmountOnPostedInvoices: Decimal;
        AmountOnPostedCrMemos: Decimal;
        AmountOnOutstandingInvoices: Decimal;
        AmountOnOutstandingCrMemos: Decimal;
        AdjmtCostLCY: Decimal;
        AdjCustProfit: Decimal;
        CustProfit: Decimal;
        AdjProfitPct: Decimal;
        CustInvDiscAmountLCY: Decimal;
        CustPaymentsLCY: Decimal;
        CustSalesLCY: Decimal;
        OverdueBalance: Decimal;
        OverduePaymentsMsg: Label 'Overdue Payments';
        DaysPastDueDate: Decimal;
        PostedInvoicesMsg: Label 'Posted Invoices (%1)', Comment = 'Invoices (5)';
        CreditMemosMsg: Label 'Posted Credit Memos (%1)', Comment = 'Credit Memos (3)';
        OutstandingInvoicesMsg: Label 'Ongoing Invoices (%1)', Comment = 'Ongoing Invoices (4)';
        OutstandingCrMemosMsg: Label 'Ongoing Credit Memos (%1)', Comment = 'Ongoing Credit Memos (4)';
        ShowMapLbl: Label 'Show on Map';
        CustomerCardServiceCategoryTxt: Label 'Customer Card', Locked = true;
        PageBckGrndTaskStartedTxt: Label 'Page Background Task to calculate customer statistics for customer %1 started.', Locked = true, Comment = '%1 = Customer No.';
        PageBckGrndTaskCompletedTxt: Label 'Page Background Task to calculate customer statistics completed successfully.', Locked = true;
        ExpectedMoneyOwed: Decimal;
        TotalMoneyOwed: Decimal;
        AvgDaysToPay: Decimal;
        FoundationOnly: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        AnyWorkflowExists: Boolean;
        NewMode: Boolean;
        WorkFlowEventFilter: Text;
        CaptionTxt: Text;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsSaaS: Boolean;
        IsCountyVisible: Boolean;
        StatementFileNameTxt: Label 'Statement', Comment = 'Shortened form of ''Customer Statement''';
        LoadOnDemand: Boolean;
        PrevCountryCode: Code[10];
        BackgroundTaskId: Integer;

    [TryFunction]
    local procedure TryGetDictionaryValueFromKey(var DictionaryToLookIn: Dictionary of [Text, Text]; KeyToSearchFor: Text; var ReturnValue: Text)
    begin
        ReturnValue := DictionaryToLookIn.Get(KeyToSearchFor);
    end;

    local procedure SetWorkFlowEnabled()
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        AnyWorkflowExists := WorkflowManagement.AnyWorkflowExists();
        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer, WorkFlowEventFilter);
    end;

    local procedure ActivateFields()
    begin
        ContactEditable := Rec."Primary Contact No." = '';
        if Rec."Country/Region Code" <> PrevCountryCode then
            IsCountyVisible := FormatAddress.UseCounty(Rec."Country/Region Code");
        PrevCountryCode := Rec."Country/Region Code";
        OnAfterActivateFields(Rec);
    end;

    local procedure SetCreditLimitStyle()
    begin
        StyleTxt := '';
        BalanceExhausted := false;
        if Rec."Credit Limit (LCY)" > 0 then
            BalanceExhausted := Rec."Balance (LCY)" >= Rec."Credit Limit (LCY)";
        if BalanceExhausted then
            StyleTxt := 'Unfavorable';
    end;

    local procedure HasCustomBaseCalendar(): Boolean
    begin
        if Rec."Base Calendar Code" = '' then
            exit(false)
        else
            exit(CalendarMgmt.CustomizedChangesExist(Rec));
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
    end;

    procedure RunReport(ReportNumber: Integer; CustomerNumber: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.", CustomerNumber);
        REPORT.RunModal(ReportNumber, true, true, Customer);
    end;

    local procedure CreateCustomerFromTemplate()
    var
        Customer: Record Customer;
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
    begin
        OnBeforeCreateCustomerFromTemplate(NewMode, Customer);

        if not NewMode then
            exit;
        NewMode := false;

        if CustomerTemplMgt.InsertCustomerFromTemplate(Customer) then begin
            VerifyVatRegNo(Customer);
            Rec.Copy(Customer);
            CurrPage.Update();
        end else
            if CustomerTemplMgt.TemplatesAreNotEmpty() then
                CurrPage.Close;
    end;

    local procedure VerifyVatRegNo(var Customer: Record Customer)
    var
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        EUVATRegistrationNoCheck: Page "EU VAT Registration No Check";
        CustomerRecRef: RecordRef;
    begin
        if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then
            if Customer."Validate EU Vat Reg. No." then begin
                EUVATRegistrationNoCheck.SetRecordRef(Customer);
                Commit();
                EUVATRegistrationNoCheck.RunModal;
                EUVATRegistrationNoCheck.GetRecordRef(CustomerRecRef);
                CustomerRecRef.SetTable(Customer);
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterActivateFields(var Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnOpenPage(var Customer: Record Customer; xCustomer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    [Scope('OnPrem')]
    procedure SetCaption(var InText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCustomerFromTemplate(var NewMode: Boolean; var Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSalesPricesAndSalesLineDisc(var LoadOnDemand: Boolean)
    begin
    end;
}

