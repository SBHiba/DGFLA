page 50005 "DGF New Matters List"
{
    // //SBL2.01.0000-SB-AR : Compliance Mgt with Matter Registered And Delete Matter Header
    //                        Improvement Conflict Check comparated with Matter category;
    // SBLFR2.01.01.00-SB-AR : Rename Caption ML FR Facture to Proforma
    //                         Add Filter Group on Open Page
    Caption = 'New Matters List';
    CardPageID = "DGF New Matter Card";
    Editable = false;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,Informations,Sales,Purchase,Entries';
    SourceTable = "SBX Matter Header";
    UsageCategory = Lists;
    ApplicationArea = SBXSBLSuite;
    RefreshOnActivate = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Name;
                field("Matter No."; Rec."Matter No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Style = Strong;
                    StyleExpr = bStyleStrongParentNo_g;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = SBXSBLawyer;
                    Style = Strong;
                    StyleExpr = bStyleStrongParentNo_g;
                }

                field("Sell-to Name"; Rec."Sell-to Name")
                {
                    ApplicationArea = SBXSBLawyer;
                    Lookup = false;
                }

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Responsible No."; Rec."Responsible No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Visible = true;
                }
                field("Partner No."; Rec."Partner No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Matter Category"; Rec."Matter Category")
                {
                    ApplicationArea = SBXSBLawyer;
                }
            }
        }
    }



    actions
    {
        area(processing)
        {

            group(SBXWorkFlow)
            {
                Caption = 'Steps';


                action(SBXPrevious)
                {
                    ApplicationArea = SBXMatterStep;
                    Caption = 'Previous';
                    ToolTip = 'Change step of the invoice. Reserved button if the sales process is activated.';
                    Image = PreviousSet;
                    PromotedIsBig = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        pstepeditor_L: Page "SBX Matter Step Editor";
                        cuMatterSalesDocument_L: codeunit "SBX Matter Sales Document Mgt";
                        recMatterHeader_L: Record "SBX Matter Header";
                    begin
                        //with Rec do begin
                        //Rec.Modify;
                        CurrPage.SetSelectionFilter(recMatterHeader_L);
                        if recMatterHeader_L.FindSet() then
                            repeat
                                recMatterHeader_L.LockTable(true);
                                cuMatterSalesDocument_L.MatterDocPreviousStep(recMatterHeader_L, true);
                            until recMatterHeader_L.Next() = 0;
                        //end;
                    end;

                }
                action(SBXNext)
                {
                    ApplicationArea = SBXMatterStep;
                    Caption = 'Next';
                    ToolTip = 'Change step of the invoice. Reserved button if the sales process is activated.';
                    Image = NextSet;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        cuMatterSalesDocument_L: codeunit "SBX Matter Sales Document Mgt";
                        recMatterHeader_L: Record "SBX Matter Header";
                    begin
                        //with Rec do begin
                        //Rec.Modify;
                        CurrPage.SetSelectionFilter(recMatterHeader_L);
                        if recMatterHeader_L.FindSet() then
                            repeat
                                recMatterHeader_L.LockTable(true);
                                Commit();
                                cuMatterSalesDocument_L.MatterDocNextStep(recMatterHeader_L, true);
                            until recMatterHeader_L.Next() = 0;
                        //end;
                    end;
                }
            }
            group(SBXConflictCheckGrp)
            {
                Caption = 'Conflict Check';
                Image = Check;
                action("Conflict Check")
                {
                    AccessByPermission = tabledata "SBX Matter Related Parties" = R;
                    ApplicationArea = SBXConflictCheck;
                    Caption = 'Conflict Check';
                    Enabled = bConflictCheck_g;
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        recRPToMatter_L: Record "SBX Matter Related Parties";
                    begin
                        CheckLockPassword;

                        Clear(cuConflictSearch_g);
                        Clear(recRPToMatter_L);
                        recRPToMatter_L.Reset;
                        recRPToMatter_L.SetRange("Matter No.", Rec."Matter No.");
                        cuConflictSearch_g.Run(recRPToMatter_L);
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindRec(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(NextRec(Steps));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
    end;

    trigger OnOpenPage()
    begin
        SetMatterVisibility;


        if recUserSetup_g.Get(UserId) then begin
            if recUserSetup_g."SBX Matter Category Filter" <> '' then begin
                Rec.FilterGroup := 2;
                Rec.SetFilter("Matter Category", recUserSetup_g."SBX Matter Category Filter");
                Rec.FilterGroup := 0;
            end;
        end;
        RefreshSetView(Rec);

        Rec.FilterGroup := 2;
        Rec.SetFilter(SystemCreatedAt, '%1..', CreateDateTime(CalcDate('<-4D>', WorkDate()), 0T));
        Rec.SetFilter(Name, '<>%1', '');
        Rec.SetRange(Confidential, false);
        Rec.SetRange(Status, Rec.Status::"In Progress");
        Rec.FilterGroup := 1;
    end;

    var
        recSalesHeader_g: Record "Sales Header";
        recMatterHeader_g: Record "SBX Matter Header";
        recMatterHeaderFindRec_g: Record "SBX Matter Header";
        recMatterSetup_G: Record "SBX Matter Setup";
        recUserSetup_g: Record "User Setup";
        cuCopyMatterPurchDoc_g: Report "SBX Copy Matter Purch Document";
        cuCopyMatterSalesDoc_g: Report "SBX Copy Matter Sales Document";
        cuCueSetup_g: Codeunit "Cues And KPIs";
        cuConflictSearch_g: Codeunit "SBX Conflict Check Search";
        cuExtractMatLedgEntries_g: Codeunit "SBX Extract Matter Ledg. Entry";
        cuMatterStatus_g: Codeunit "SBX Matter Change Status";
        cuComplianceMgt_g: Codeunit "SBX Matter Compliance Mgt.";
        cuMatterEventManual_g: Codeunit "SBX Matter Dyn. Event Manual";
        CuCreateBatchPurchProcess_g: Codeunit "SBX Matter Management";
        cuMatterMgt_g: Codeunit "SBX Matter Management";
        cuRPMgt_g: Codeunit "SBX Related Parties Mgt";
        pMatterLockedByPassword_g: Page "SBX Matter Locked By Password";
        bConflictCheck_g: Boolean;
        bRefresSetView: Boolean;
        bSortingbyMatter_g: Boolean;
        bStyleStrongParentNo_g: Boolean;
        bTemplateMatter_g: Boolean;
        iIndentNo_g: Integer;
        CREATESALESINVOICE: Label 'Create Sales Invoice';
        SENDMAILCOLLAB: Label 'Do you want to inform the contributors about the billing of the matter?';
        ExtendedPriceEnabled: Boolean;

    procedure SetRefreshSetView(_bRefresSetView: Boolean)
    var
    begin
        bRefresSetView := _bRefresSetView;
    end;

    Local procedure RefreshSetView(var _Rec: Record "SBX Matter Header")
    var
        recMatterHeader_L: Record "SBX Matter Header";
    begin

        if not bRefresSetView then
            exit;

        recMatterHeader_L.SetView(_Rec.GetView());
        CurrPage.SetTableView(recMatterHeader_L);
    end;

    local procedure GetMatterSetup()
    var
        SETUPNOTREAD_L: Label 'You don''t have permissions to read table %1.';
    begin
        if not recMatterSetup_G.ReadPermission then
            Error(SETUPNOTREAD_L, recMatterSetup_G.TableCaption);

        recMatterSetup_G.Get;
    end;


    procedure GetSelectionFilter(): Text
    var
        recMatterHeader_L: Record "SBX Matter Header";
        cuSelectionFilterManagement_L: Codeunit "SBX Matter SelectionFilterMgt";
    begin
        CurrPage.SetSelectionFilter(recMatterHeader_L);
        exit(cuSelectionFilterManagement_L.GetSelectionFilterForMatterHeader(recMatterHeader_L));
    end;

    local procedure SetMatterVisibility()
    var
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
    begin
        recMatterSetup_G.Get;
        bTemplateMatter_g := recMatterSetup_G."Auto. Propose Template Matter";
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
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

        //EXIT(FALSE);
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

    local procedure CheckLockPassword()
    var
        recLockedEntityAccessEntry_L: Record "SBX Locked Entity Access Entry";
    begin
        if Rec."Matter No." <> '' then begin
            if Rec."Password" <> '' then begin
                if not recLockedEntityAccessEntry_L.CheckLockedEntityAccessEntry(Database::"SBX Matter Header", Rec."Matter No.", UserId) then begin
                    Clear(pMatterLockedByPassword_g);
                    recMatterHeader_g.Reset;
                    recMatterHeader_g.SetRange("Matter No.", Rec."Matter No.");

                    Clear(pMatterLockedByPassword_g);
                    pMatterLockedByPassword_g.SetTableView(recMatterHeader_g);
                    pMatterLockedByPassword_g.LookupMode(true);
                    pMatterLockedByPassword_g.AccessPassword();
                    if pMatterLockedByPassword_g.RunModal <> ACTION::LookupOK then
                        Error('');
                end;
            end;
        end;
    end;

}

