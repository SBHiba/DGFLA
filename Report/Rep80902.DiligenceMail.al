report 80902 "Diligence Mail"
{
    Caption = 'Diligence Mail';
    ProcessingOnly = true;
    ApplicationArea = All;
    trigger OnPreReport()
    begin
        CheckDiligenceEntry();
    end;

    local procedure CheckDiligenceEntry()
    var
        MatterLedgerEntry: Record "SBX Matter Ledger Entry";
        StartDate: Date;
        DGFSetup: Record "DGF Setup";
    begin
        DGFSetup.Get();
        DGFSetup.TestField("Diligence Reminder Mail Perid");
        StartDate := CalcDate(Format(DGFSetup."Diligence Reminder Mail Perid"), Today);
        MatterLedgerEntry.Reset();
        MatterLedgerEntry.SetRange("Matter Journal Batch User ID", UserId);
        MatterLedgerEntry.SetRange("Posting Date", StartDate, Today);
        if not MatterLedgerEntry.FindFirst() then
            SendMail();
    end;

    local procedure SendMail()
    var
        UserSetup: Record "User Setup";
        Body: Label 'You did not enter any due diligence on the last week';
        Subject: Label 'Reminder : Dilligence Entry';
    begin
        UserSetup.get(UserId);
        if UserSetup."E-Mail" = '' then
            exit;
        SendTo.Add(UserSetup."E-Mail");
        EmailMessage.Create(SendTo, Subject, Body, false);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SendTo: List of [Text];

}
