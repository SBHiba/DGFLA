/* comment
end comment */

page 50006 "DGF New Matter Card"
{
    Caption = 'Matter Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Informations,Sales,Purchase,Entries';
    RefreshOnActivate = true;
    SourceTable = "SBX Matter Header";

    layout
    {
        area(content)
        {

            group(GeneralGrp)
            {
                Caption = 'General';
                Editable = bEditablePage_g;
                field("Matter No."; Rec."Matter No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                    Visible = bMatterNoVisible_g;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    ShowMandatory = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Sell-to Name"; Rec."Sell-to Name")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Sell-to Name 2"; Rec."Sell-to Name 2")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                    Visible = false;
                }
                field("Matter Type"; Rec."Matter Type")
                {
                    ApplicationArea = SBXSBLawyer;
                    Visible = false;
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;

                    trigger OnAssistEdit()
                    var
                        recContact_L: Record Contact;
                    begin
                        //SBLFR2.01.01.00-SB-AR
                        if Rec."Primary Contact No." <> '' then begin
                            recContact_L.Get(Rec."Primary Contact No.");
                            recContact_L.SetRecFilter;
                            PAGE.Run(PAGE::"Contact Card", recContact_L);
                        end;
                    end;
                }
                field("Primary Contact Name"; Rec."Primary Contact Name")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Sell-to Address Code"; Rec."Sell-to Address Code")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                }
                field("Matter Category"; Rec."Matter Category")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        //CurrPage.UPDATE(TRUE);
                        CurrPage.Update;
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = SBXSBLawyer;
                    ShowMandatory = true;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                }
                field("Partner No."; Rec."Partner No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Partner Name"; Rec."Partner Name")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;
                }
                field("Responsible No."; Rec."Responsible No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Responsible Name"; Rec."Responsible Name")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Secretary No."; Rec."Secretary No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Additional;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = SBXSBLawyer;
                    ShowMandatory = false;
                }

            }
            group(Communication)
            {
                Caption = 'Communication';
                Editable = bEditablePage_g;
                field("Comm. Addr. Code"; Rec."Comm. Addr. Code")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Comm. Preference"; Rec."Comm. Preference")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;
                }
            }
            group("Apporteur d'Affaires")
            {
                Caption = 'Business Developper';
                Editable = bEditablePage_g;
                field("Introducer No."; Rec."Introducer No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Introducer Name"; Rec."Introducer Name")
                {
                    ApplicationArea = SBXSBLawyer;
                    Importance = Promoted;
                }
            }
        }
        area(factboxes)
        {
            part(FactboxPicture; "SBX Matter Picture")
            {
                ApplicationArea = Basic, Suite, SBXSBLawyer;
                Caption = 'Picture';
                SubPageLink = "Matter No." = FIELD("Matter No.");
                Visible = false;
            }

            part(FactBoxUserTasks; "SBX Matter User Tasks Part")
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Activities';
                SubPageLink = "SBX Matter No." = field("Matter No.");
            }

            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(8088265),
                              "No." = FIELD("Matter No.");
                Visible = NOT IsOfficeAddin;
            }
            part(Control1000000064; "SBXMatter Conflict Check Ftbox")
            {
                ApplicationArea = SBXConflictCheck;
                SubPageLink = "Matter No." = FIELD("Matter No.");
            }

            systempart(Control1000000060; MyNotes)
            {
                ApplicationArea = SBXSBLawyer;
                Visible = false;
            }
            systempart(Control1000000061; Notes)
            {
                ApplicationArea = SBXSBLawyer;
                Visible = true;
            }
            systempart(Control1000000063; Links)
            {
                ApplicationArea = SBXSBLawyer;
            }
        }
    }

    actions
    {

        area(Processing)
        {
            group("StatuSGrp")
            {
                Caption = 'Change Status';
                Image = Status;
                action(Open)
                {
                    ApplicationArea = SBXSBLawyer;
                    AccessByPermission = tabledata "SBX Matter Header" = M;
                    Caption = 'Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortcutKey = 'Ctrl+o';

                    trigger OnAction()
                    begin
                        cuMatterStatus_g.ReOpen(Rec);
                        CurrPage.Update(true);
                    end;
                }
                action(ChangeStatus)
                {
                    ApplicationArea = SBXSBLawyer;
                    AccessByPermission = tabledata "SBX Matter Header" = M;
                    Caption = 'Change Status';
                    Image = Status;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        cuMatterStatus_g.Run(Rec);
                        if recMatterHeader_g.Get(Rec."Matter No.") then
                            CurrPage.Update(true);
                    end;
                }
            }
            group(ConflictGrp)
            {
                Caption = 'Conflict Check';
                Image = Check;
                action(RelatedParties)
                {
                    ApplicationArea = SBXConflictCheck;
                    Caption = 'Related Parties';
                    Image = PersonInCharge;
                    RunObject = Page "SBXRelated Parties Matter List";
                    RunPageLink = "Matter No." = FIELD("Matter No.");
                }
                action("Conflict Check")
                {
                    ApplicationArea = SBXConflictCheck;
                    Caption = 'Conflict Check';
                    Image = CheckList;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        recRPToMatter_L: Record "SBX Matter Related Parties";
                    begin
                        Clear(cuConflictSearch_g);
                        Clear(recRPToMatter_L);
                        recRPToMatter_L.Reset;
                        recRPToMatter_L.SetRange("Matter No.", Rec."Matter No.");
                        cuConflictSearch_g.Run(recRPToMatter_L);
                        CurrPage.Update(true);
                    end;
                }
            }
            group(MatterInfoGrp)
            {
                Caption = 'Matter';
                Image = Job;
                action(CreateLetter)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Send a Letter';
                    Image = PostMail;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        recMatter_L: Record "SBX Matter Header";
                        pLettersEditor_L: Page "SBX Letters Editor";
                    begin
                        recMatter_L.Reset();
                        recMatter_L.SetRange("Matter No.", Rec."Matter No.");
                        recMatter_L.FindFirst();
                        Clear(pLettersEditor_L);
                        pLettersEditor_L.SetMatterHeader(recMatter_L);
                        pLettersEditor_L.RunModal();
                    end;
                }
                action(MatterLockByPassword)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Password';
                    Image = Lock;

                    trigger OnAction()
                    begin
                        Clear(pMatterLockedByPassword_g);
                        recMatterHeader_g.Reset;
                        recMatterHeader_g.SetRange("Matter No.", Rec."Matter No.");
                        if Rec."Password" = '' then
                            pMatterLockedByPassword_g.NewPassword()
                        else
                            pMatterLockedByPassword_g.ModifyPassword();
                        pMatterLockedByPassword_g.SetTableView(recMatterHeader_g);
                        pMatterLockedByPassword_g.RunModal;
                        CurrPage.Update;
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(Function_CustomerCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Sell-to Customer No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the customer on the sales document.';
            }
            group(InfoActionGrp)
            {
                Caption = 'Informations';
                Image = Info;
                action(Originating)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Originating';
                    Image = NewOpportunity;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "SBX Internal Originating";
                    RunPageLink = Type = CONST(Matter), "No." = FIELD("Matter No.");
                    RunPageMode = View;
                    ToolTip = 'View the list of the people, who are at the origin of the matter (business contributors of the matter)';
                }
                action(Collaborators)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Collaborators';
                    Image = ExportSalesPerson;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "SBX Matter Collaborators";
                    RunPageLink = "Matter No." = FIELD("Matter No.");
                }
                action(RelatedPartiesList)
                {
                    ApplicationArea = SBXConflictCheck;
                    Caption = 'Related Parties';
                    Image = Relatives;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "SBXRelated Parties Matter List";
                    RunPageLink = "Matter No." = FIELD("Matter No.");
                }
                action(ContactsMatter)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Contacts';
                    Image = ContactPerson;
                    RunObject = Page "SBX Contacts Matter";
                    RunPageLink = "Matter No." = FIELD("Matter No.");
                    RunPageView = where("Matter Typology" = const(Matter));
                }
                action(ChildMatter)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Child Matter(s)';
                    Image = List;
                    RunObject = Page "SBX Matters List";
                    RunPageLink = "Parent Matter No." = FIELD("Matter No.");
                    RunPageView = SORTING("Parent Matter No.", "Matter No.")
                                  WHERE("Parent Matter" = CONST(Child));
                    ToolTip = 'View the list of children''s Matters.';
                }
                action(MultiBilltoCustomer)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Mutli Bill-to Customers';
                    Image = CoupledUsers;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        pMultiBilltoCustomersMatter_L: Page "SBX Multi Bill-to Cust. Matter";
                        recMultiBilltoCustomersMatter_L: Record "SBX Multi Bill-to Cust Matter";
                    begin
                        Clear(pMultiBilltoCustomersMatter_L);
                        recMultiBilltoCustomersMatter_L.Reset;
                        recMultiBilltoCustomersMatter_L.FilterGroup := 2;
                        recMultiBilltoCustomersMatter_L.SetRange("Matter No.", Rec."Matter No.");
                        recMultiBilltoCustomersMatter_L.FilterGroup := 0;
                        pMultiBilltoCustomersMatter_L.SetTableView(recMultiBilltoCustomersMatter_L);
                        pMultiBilltoCustomersMatter_L.Run;
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            action(CommentAct)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "SBX Matter Comment Sheet";
                RunPageLink = "Table Name" = CONST(Matter), "No." = FIELD("Matter No.");
            }

        }
    }




    trigger OnAfterGetCurrRecord()
    begin
        SetMatterEditable;
        IsOfficeAddin := OfficeManagement.IsAvailable;
        CheckLimit();
        Clear(cuRPMgt_g);
        bConflictCheck_g := not cuRPMgt_g.CheckConflictCheckNone(Rec."Matter No.");


        SetMatterNoVisible();
        CurrPage.FactBoxUserTasks.Page.SetChangeMatter(Rec);
    end;

    trigger OnAfterGetRecord()
    var
        recSalesDocStep_L: Record "SBX Sales Document Step";
        cuMatterDocMgt_L: codeunit "SBX Matter Sales Document Mgt";
    begin

        SetMatterEditable;

        CheckLimit();
        SendAlertNotification();

        Clear(cuRPMgt_g);
        bConflictCheck_g := not cuRPMgt_g.CheckConflictCheckNone(Rec."Matter No.");

        SetMatterNoVisible();
        recMatterSetup_G.get;
        bEnableMatterWorkFlow_g := recMatterSetup_G."Activate Matter Workflow";
        if recMatterSetup_G."Activate Matter Workflow" then begin
            if not recSalesDocStep_L.Get(recSalesDocStep_L."Steps Type"::Matter, Rec."Matter Category", Rec."SBX Doc Step Line No.") then begin
                if not recSalesDocStep_L.Get(recSalesDocStep_L."Steps Type"::Matter, '', Rec."SBX Doc Step Line No.") then begin
                    recSalesDocStep_L.Reset();
                    recSalesDocStep_L.SetCurrentKey(Position);
                    recSalesDocStep_L.SetRange("Steps Type", recSalesDocStep_L."Steps Type"::Matter);
                    recSalesDocStep_L.SetRange("Matter Category", Rec."Matter Category");
                    if not recSalesDocStep_L.findfirst() then
                        recSalesDocStep_L.setrange("Matter Category", '');
                    if recSalesDocStep_L.FindFirst() then begin
                        Rec.Validate("SBX Doc Step Line No.", recSalesDocStep_L."Step Line No.");
                    end;
                end;
            end;

            Rec.SetRange("Step Matter Category Filter", recSalesDocStep_L."Matter Category");

            BindSubscription(cuMatterDocMgt_L);
            UnbindSubscription(cuMatterDocMgt_L);
        end;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recSalesDocStep_L: Record "SBX Sales Document Step";
        cuMatterDocMgt_L: codeunit "SBX Matter Sales Document Mgt";
    begin
        recMatterSetup_G.Get();
        if recMatterSetup_G."Activate Matter Workflow" then begin
            recSalesDocStep_L.Reset();
            recSalesDocStep_L.SetCurrentKey(Position);
            recSalesDocStep_L.SetRange("Steps Type", recSalesDocStep_L."Steps Type"::Matter);
            recSalesDocStep_L.SetRange("Matter Category", Rec."Matter Category");
            if not recSalesDocStep_L.findfirst() then
                recSalesDocStep_L.setrange("Matter Category", '');

            if recSalesDocStep_L.FindFirst() then begin
                //Validate("SBX Sales Doc Step Line No.", recSalesDocumentStep_g."Step Line No.");
                BindSubscription(cuMatterDocMgt_L);
                UnbindSubscription(cuMatterDocMgt_L);
            end;
        end;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindRec(Which));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetMatterNoVisible;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(NextRec(Steps));
    end;

    trigger OnOpenPage()
    var
        recSalesDocStep_L: Record "SBX Sales Document Step";
    begin
        SetMatterNoVisible;
        SetMatterEditable;

        CheckLockPassword;
        CheckBlockOpenMatter;

        if recUserSetup_g.Get(UserId) then begin
            if recUserSetup_g."SBX Matter Category Filter" <> '' then begin
                Rec.FilterGroup := 2;
                Rec.SetFilter("Matter Category", recUserSetup_g."SBX Matter Category Filter");
                Rec.FilterGroup := 0;
            end;
        end;
        if not recSalesDocStep_L.Get(recSalesDocStep_L."Steps Type"::Matter, Rec."Matter Category", Rec."SBX Doc Step Line No.") then
            if not recSalesDocStep_L.Get(recSalesDocStep_L."Steps Type"::Matter, '', Rec."SBX Doc Step Line No.") then;

        if recSalesDocStep_L."Step Line No." <> 0 then
            Rec.SetRange("Step Matter Category Filter", recSalesDocStep_L."Matter Category");

    end;

    var
        bMatterNoVisible_g: Boolean;
        cuMatterMgt_g: Codeunit "SBX Matter Management";
        cuMatterStatus_g: Codeunit "SBX Matter Change Status";
        bEditablePage_g: Boolean;
        cuCueSetup_g: Codeunit "Cues And KPIs";
        cuConflictSearch_g: Codeunit "SBX Conflict Check Search";
        recMatterSetup_G: Record "SBX Matter Setup";
        bTemplateMatter_g: Boolean;
        cuExtractMatLedgEntries_g: Codeunit "SBX Extract Matter Ledg. Entry";
        CREATESALESINVOICE: Label 'Create Sales Invoice', MaxLength = 150;
        cuCopyMatterSalesDoc_g: Report "SBX Copy Matter Sales Document";
        cuCopyMatterPurchDoc_g: Report "SBX Copy Matter Purch Document";
        recSalesHeader_g: Record "Sales Header";
        cuMatterEventManual_g: Codeunit "SBX Matter Dyn. Event Manual";
        SENDMAILCOLLAB: Label 'Do you want to execute the pre-invoicing Alert?', MaxLength = 150;
        CuCreateBatchPurchProcess_g: Codeunit "SBX Matter Management";
        WARNINGLIMIT: Label 'The  Budget Warning Limit Amount has been reached!', MaxLength = 150;
        sWarningMessage_g: Text[100];
        bWarning_g: Boolean;
        bHideWarning_G: Boolean;
        bEditPackageAmount_g: Boolean;
        bVisiblePackageAmount_g: Boolean;
        bLedesBilling, bTimeRangeNotNull : Boolean;
        pMatterLockedByPassword_g: Page "SBX Matter Locked By Password";
        recMatterHeader_g: Record "SBX Matter Header";
        recMatterHeaderFindRec_g: Record "SBX Matter Header";
        cuComplianceMgt_g: Codeunit "SBX Matter Compliance Mgt.";
        bConflictCheck_g: Boolean;
        cuRPMgt_g: Codeunit "SBX Related Parties Mgt";
        recUserSetup_g: Record "User Setup";
        bEditTimeRange: Boolean;
        AlertNotification_g: Notification;
        bFlatAmount_g: Boolean;
        cuAgingBillingMatter_g: Codeunit "SBX Aging Billing Matter Mgt";
        bEditableByInvoicingType: Boolean;
        IsOfficeAddin: Boolean;
        OfficeManagement: Codeunit "Office Management";
        bEnableMatterWorkFlow_g: Boolean;
        bStepVisible: Boolean;
        VisibleExtendedPrice: Boolean;
        cuMethodCalcPrice: codeunit "Price Calculation Mgt.";
        ExtendedPriceEnabled: Boolean;



    local procedure SetMatterNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        recMatterSetup_G.Get;
        bTemplateMatter_g := recMatterSetup_G."Auto. Propose Template Matter";
        bFlatAmount_g := (Rec."Invoicing Type" = Rec."Invoicing Type"::"Recurring Amount");
        bStepVisible := recMatterSetup_G."Activate Matter Workflow";
        VisibleExtendedPrice := cuMethodCalcPrice.IsExtendedPriceCalculationEnabled();
    end;

    local procedure SetMatterEditable()
    var
        recMatterCollab_L: Record "SBX Matter Collaborator";
        cUserID_L: Code[50];
    begin
        if Rec.Confidential then begin
            bEditablePage_g := (UserId = Rec."Created By");
            if not bEditablePage_g then begin
                cUserID_L := cuMatterMgt_g.GetResourceNoByUSERID(UserId, false);
                if cUserID_L = '' then
                    bEditablePage_g := Rec.Status = Rec.Status::Open
                else
                    bEditablePage_g := (Rec.Status = Rec.Status::Open) and (cuMatterMgt_g.AccessPrivateMatterWithUser(UserId, recMatterHeader_g));
            end;
        end else
            bEditablePage_g := Rec.Status = Rec.Status::Open;
        // CurrPage.EDITABLE:=(Status=Status::Open);


        bEditPackageAmount_g := Rec."Invoicing Type" = Rec."Invoicing Type"::Package;
        bVisiblePackageAmount_g := Rec."Invoicing Type" = Rec."Invoicing Type"::Package;
        bEditableByInvoicingType := Rec."Invoice Period" <> Rec."Invoice Period"::None;
        bLedesBilling := Rec."Electronic Invoice";
    end;

    local procedure SetMatterEditPackage()
    begin
        bEditPackageAmount_g := Rec."Invoicing Type" = Rec."Invoicing Type"::Package;
        bVisiblePackageAmount_g := Rec."Invoicing Type" = Rec."Invoicing Type"::Package;
    end;

    local procedure CheckBlockOpenMatter()
    var
        BLOCKUSERNOTAUT_L: Label 'You can not open Matter No. %1 %2. You must be the creator or be a collaborator.', MaxLength = 250;
        recMatterCollab_L: Record "SBX Matter Collaborator";
        cUserID_L: Code[50];
    begin
        if Rec."Matter No." <> '' then begin
            if Rec.Confidential then begin
                bEditablePage_g := (UserId = Rec."Created By");
                if not bEditablePage_g then begin
                    Clear(pMatterLockedByPassword_g);
                    recMatterHeader_g.Reset;
                    recMatterHeader_g.SetRange("Matter No.", Rec."Matter No.");
                    if not cuMatterMgt_g.AccessPrivateMatterWithUser(UserId, recMatterHeader_g) then
                        Error(BLOCKUSERNOTAUT_L, Rec."Matter No.", Rec.Name);
                end;
            end;
        end;
    end;

    local procedure CheckLockPassword()
    var
        recLockedEntityAccessEntry_L: Record "SBX Locked Entity Access Entry";
    begin
        if Rec."Matter No." <> '' then begin
            if not recLockedEntityAccessEntry_L.CheckLockedEntityAccessEntry(Database::"SBX Matter Header", Rec."Matter No.", UserId) then begin
                if Rec."Password" <> '' then begin
                    Clear(pMatterLockedByPassword_g);
                    recMatterHeader_g.Reset;
                    recMatterHeader_g.SetRange("Matter No.", Rec."Matter No.");
                    Clear(pMatterLockedByPassword_g);
                    pMatterLockedByPassword_g.SetTableView(recMatterHeader_g);
                    pMatterLockedByPassword_g.LookupMode(true);
                    pMatterLockedByPassword_g.AccessPassword();
                    if pMatterLockedByPassword_g.RunModal <> ACTION::LookupOK then Error('');
                end;
            end;
        end;
    end;

    local procedure CheckLimit()
    begin
        bWarning_g := Rec.IsOverLimit;
        bHideWarning_G := bWarning_g;
        if bWarning_g then
            sWarningMessage_g := WARNINGLIMIT
        else
            Clear(sWarningMessage_g);
    end;

    local procedure SendAlertNotification()
    begin
        AlertNotification_g.Id := '00000000-0000-0000-0000-000000000001';
        if bWarning_g then begin
            if AlertNotification_g.GetData('Sent') <> Format(true) then begin
                AlertNotification_g.Message(sWarningMessage_g);
                AlertNotification_g.Scope := NOTIFICATIONSCOPE::LocalScope;
                AlertNotification_g.SetData('Sent', Format(true));
                AlertNotification_g.Send;
            end;
        end else begin
            AlertNotification_g.SetData('Sent', Format(false));
            AlertNotification_g.Recall;
        end;
    end;

    local procedure FindRec(Which: Text): Boolean
    var
        recMatterHeader_L: Record "SBX Matter Header";
        bMatterFind_L: Boolean;
    begin
        recMatterHeaderFindRec_g.Copy(Rec);
        if not recMatterHeaderFindRec_g.Find(Which) then
            exit(false);

        if not cuMatterMgt_g.AccessPrivateMatterWithUser(UserId, recMatterHeaderFindRec_g) then
            repeat
                bMatterFind_L := recMatterHeaderFindRec_g.Find('>');
                if not bMatterFind_L then
                    exit(false);

            until (bMatterFind_L = true) and (cuMatterMgt_g.AccessPrivateMatterWithUser(UserId, recMatterHeaderFindRec_g));

        Rec := recMatterHeaderFindRec_g;
        exit(true);
    end;

    local procedure NextRec(Steps: Integer): Integer
    var
        recMatterHeader_L: Record "SBX Matter Header";
        intResultSteps_L: Integer;
    begin
        recMatterHeaderFindRec_g.Copy(Rec);
        repeat
            intResultSteps_L := recMatterHeaderFindRec_g.Next(Steps);
        until (intResultSteps_L = 0) or (cuMatterMgt_g.AccessPrivateMatterWithUser(UserId, recMatterHeaderFindRec_g));

        if intResultSteps_L <> 0 then
            Rec := recMatterHeaderFindRec_g;

        exit(intResultSteps_L);
    end;


}

