pageextension 50005 "DGF Matter Ledger Entries" extends "SBX Matter Ledger Entries"
{
    layout
    {
        addafter("Non Billable")
        {
            field("DGF Out of Procedure"; Rec."DGF Out of Procedure")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }
    }

    actions
    {
        addafter(Diligence)
        {
            action(DGF_SwitchProcedure)
            {
                Caption = 'Switch to Procedure';
                ApplicationArea = SBXSBLawyer;
                Visible = bWitchProcedure_g;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    recMatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                    recMatterLedgerEntry2_L: Record "SBX Matter Ledger Entry";
                    lblConfirm_L: Label 'Do you want to make your "Out of Procedure" entries in Procedure?';
                begin
                    CurrPage.SetSelectionFilter(recMatterLedgerEntry_L);
                    recMatterLedgerEntry_L.SetRange("DGF Out of Procedure", true);
                    if not recMatterLedgerEntry_L.IsEmpty then
                        if not Confirm(lblConfirm_L, false) then
                            exit;

                    if recMatterLedgerEntry_L.FindSet() then
                        repeat

                            recMatterLedgerEntry2_L := recMatterLedgerEntry_L;
                            recMatterLedgerEntry2_L."DGF Out of Procedure" := false;
                            recMatterLedgerEntry2_L.Modify();

                        until recMatterLedgerEntry_L.Next() = 0;
                end;
            }
        }
    }

    var
        bWitchProcedure_g: Boolean;

    trigger OnOpenPage()
    var
        recUSerSetup_L: Record "User Setup";
    begin
        bWitchProcedure_g := false;
        if recUSerSetup_L.get(UserId) then begin
            bWitchProcedure_g := recUSerSetup_L."Time Sheet Admin.";
        end;
    end;

}