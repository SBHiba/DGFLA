codeunit 50000 "DGF Event Handler"
{
    trigger OnRun()
    begin

    end;

    var
        ArchiveManagement: Codeunit ArchiveManagement;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Extract Matter Ledg. Entry", 'OnAfterGenerateBillingCampaignAfterInsertSalesInvoice', '', false, false)]
    local procedure RunAfterGenerateBillingCampainAfterInsertSalesInvoice(
        _dEndingDate: Date;
        _dStartingDate: Date;
        var _recMatterHeader: Record "SBX Matter Header";
        var _recSalesInvoice: Record "Sales Header"
    )
    begin
        ArchiveManagement.StoreSalesDocument(_recSalesInvoice, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Extract Matter Ledg. Entry", 'OnAfterOpenMatterTmpLedgEntriesToSalesInvLine', '', false, false)]
    local procedure RunAfterOpenMatterTmpLedgEntriesToSalesInvLine(
        _recSourceMatterHeader: Record "SBX Matter Header";
        _recSourceOrChildMatterHeader: Record "SBX Matter Header";
        var _recSalesInvoice: Record "Sales Header"
    )
    begin
        ArchiveManagement.StoreSalesDocument(_recSalesInvoice, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Matter Jnl.-Check Line", 'OnBeforeRunCheck', '', false, false)]
    local procedure RunSBXMatterJnlCheckLineBeforeRunCheck(
        var _recMatterJnlLine: Record "SBX Matter Journal Line"
    )
    var
        recDGFSetup_L: Record "DGF Setup";
    begin
        recDGFSetup_L.Get();
        recDGFSetup_L.TestField("Seizure day allowed for proc.");
        recDGFSetup_L.testfield("Time Entry allowed for proc.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Matter Jnl.-Post Line", 'OnAfterInitMatterLedgerEntry', '', false, false)]
    local procedure RunMatterJnlPostLineAfterInitMatterLedgerEntry(
        var _recMatterJnlLine: Record "SBX Matter Journal Line";
        var _recMatterLedgerEntry: Record "SBX Matter Ledger Entry"
    )
    var
        cuDGFMgt_L: codeunit "DGF Management";
    begin

        _recMatterLedgerEntry."DGF Out of Procedure" := cuDGFMgt_L.SetDGFTimeSheetOutOfProcedure(_recMatterJnlLine);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Matter Jnl.-Post Line", 'OnAfterCloseMatterLedgerEntry', '', false, false)]
    local procedure RunMatterJnlPostLineAfterCloseMatterLedgerEntry(
        var _recMatterJnlLine: Record "SBX Matter Journal Line";
        var _recMatterLedgerEntry: Record "SBX Matter Ledger Entry";
        var _recOldMatterLedgerEntry: Record "SBX Matter Ledger Entry"
    )
    begin
        _recMatterLedgerEntry."DGF Out of Procedure" := _recOldMatterLedgerEntry."DGF Out of Procedure";
    end;

    [EventSubscriber(ObjectType::Table, Database::"SBX Matter Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure RunMatterJnlLineAfterSetupNewLine(
        _recLastMatterJnlLine: Record "SBX Matter Journal Line";
        var Rec: Record "SBX Matter Journal Line"
    )
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"SBX Matter Journal Line", 'OnAfterSetUpNewDiligence', '', false, false)]
    local procedure RunMatterJnlLineAfterSetupNewDiligence(
        _recLastMatterJnlLine: Record "SBX Matter Journal Line";
        var Rec: Record "SBX Matter Journal Line"
    )
    begin
    end;

    //>>Double Approval Github #26 #27 - Hiba 13/02

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Matter Jnl.-Post Line", 'OnAfterInitExpenseLedgerEntry', '', false, false)]
    local procedure OnAfterInitExpenseLedgerEntry(var _recMatterJnlLine: Record "SBX Matter Journal Line"; var _recExpenseLedgerEntry: Record "SBX Expense Ledger Entry");
    var
        ExpenseSetup: Record "SBX Expense Setup";
        DGFSetup: Record "DGF Setup";
        MatterHeader: Record "SBX Matter Header";
        WorkflowUserGroup: Record "Workflow User Group";
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        AccWorkflowUserGroupMember: Record "Workflow User Group Member";
        SeqNo: Integer;
        Resource: Record Resource;
    begin
        SeqNo := 1;
        ExpenseSetup.Get();
        DGFSetup.Get();
        if not DGFSetup."Double Approval" then
            exit
        else
            ExpenseSetup.TestField("SBX Approval by Matter Partner");

        DGFSetup.TestField("Approver Type");
        DGFSetup.TestField(Approver);

        MatterHeader.Get(_recMatterJnlLine."Matter No.");

        Resource.get(MatterHeader."Partner No.");
        Resource.TestField("SBX User ID");

        if WorkflowUserGroup.get(Copystr(Format(Resource."SBX User ID"), 1, 14) + ' / Acc') then
            WorkflowUserGroup.Delete();

        //Evolution to Add : Check if Already Exist : Skip

        WorkflowUserGroup.Init();
        WorkflowUserGroup.Validate(Code, Copystr(Format(Resource."SBX User ID"), 1, 14) + ' / Acc');
        WorkflowUserGroup.Insert();

        WorkflowUserGroupMember.Init();
        WorkflowUserGroupMember.Validate("Workflow User Group Code", WorkflowUserGroup.Code);
        WorkflowUserGroupMember.Validate("User Name", Resource."SBX User ID");
        WorkflowUserGroupMember.Validate("Sequence No.", SeqNo);
        WorkflowUserGroupMember.Insert();

        AccWorkflowUserGroupMember.Reset();
        AccWorkflowUserGroupMember.SetRange("Workflow User Group Code", DGFSetup.Approver);
        if AccWorkflowUserGroupMember.FindSet() then
            repeat
                WorkflowUserGroupMember.Init();
                WorkflowUserGroupMember.Validate("Workflow User Group Code", WorkflowUserGroup.Code);
                WorkflowUserGroupMember.Validate("User Name", AccWorkflowUserGroupMember."User Name");
                WorkflowUserGroupMember.Validate("Sequence No.", SeqNo + 1);
                WorkflowUserGroupMember.Insert();
            until AccWorkflowUserGroupMember.Next() = 0;

        _recExpenseLedgerEntry."Approver Type" := DGFSetup."Approver Type";
        _recExpenseLedgerEntry."Approver User" := WorkflowUserGroup.Code;
        _recExpenseLedgerEntry."Double Approval" := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"SBX Expense Approval Entry", 'OnAfterLastUserGroupSequenceNo', '', false, false)]
    local procedure OnAfterLastUserGroupSequenceNo(ExpenseLedgerEntry: Record "SBX Expense Ledger Entry");
    var
        WorkflowUserGroup: Record "Workflow User Group";
    begin
        WorkflowUserGroup.get(ExpenseLedgerEntry."Approver User");
        WorkflowUserGroup.Delete();
    end;

    [EventSubscriber(ObjectType::Table, Database::"SBX Expense Approval Entry", 'OnAfterRejectReqForApprTypeWorkflowUserGroup', '', false, false)]
    local procedure OnAfterRejectReqForApprTypeWorkflowUserGroup(ExpenseLedgerEntry: Record "SBX Expense Ledger Entry");
    var
        WorkflowUserGroup: Record "Workflow User Group";
    begin
        WorkflowUserGroup.get(ExpenseLedgerEntry."Approver User");
        WorkflowUserGroup.Delete();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SBX Matter Jnl.-Post Line", 'OnAfterSetStatus', '', false, false)]
    local procedure OnAfterSetStatus(var ExpenseLedgerEntry: Record "SBX Expense Ledger Entry"; Resource: Record Resource);
    var
        ExpenseSetup: Record "SBX Expense Setup";
        DGFSetup: Record "DGF Setup";
    begin
        ExpenseSetup.Get();
        DGFSetup.get();
        if not DGFSetup."Double Approval" then
            exit
        else
            ExpenseSetup.TestField("SBX Approval by Matter Partner");

        DGFSetup.TestField("Approver Type");
        DGFSetup.TestField(Approver);


        if (Resource."SBX Resource Type" = Resource."SBX Resource Type"::Partner) then
            ExpenseLedgerEntry."Approval Status" := ExpenseLedgerEntry."Approval Status"::Approved;
    end;
    //<<Double Approval Github #26 #27 - Hiba 13/02
}