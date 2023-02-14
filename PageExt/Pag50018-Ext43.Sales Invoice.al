pageextension 50018 "DGF Sales Invoice" extends "Sales Invoice"
{
    actions
    {
        addafter(Comment)
        {
            /*action(DGF_ApplyRange)
            {
                Caption = 'Apply Billing Range';
                ApplicationArea = SBXSBLawyer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    recMatterHeader_L: Record "SBX Matter Header";
                    recSalesLine_L: Record "Sales Line";
                    cuMatterTimeMgt_L: Codeunit "SBX Matter Time Management";
                begin
                    if not (Rec.Status = Rec.Status::Open) then
                        exit;

                    recSalesLine_L.SetRange("Document Type", rec."Document Type"::Invoice);
                    recSalesLine_L.SetRange("Document No.", rec."No.");
                    recSalesLine_L.SetRange("SBX Matter Entry Type", recSalesLine_L."SBX Matter Entry Type"::Service); // Pour les ressources uniquement
                    recSalesLine_L.SetRange("SBX Write Off", false);
                    recSalesLine_L.SetRange("SBX Cost Switch Service", false);
                    recSalesLine_L.SetRange("SBX Postpone", false);
                    recSalesLine_L.SetRange("SBX Transfer", false);
                    If recSalesLine_L.FindSet(true) then begin
                        repeat
                            if recMatterHeader_L.Get(recSalesLine_L."SBX Matter No.") then
                                if recMatterHeader_L."DGF Billing Time Range (min)" <> 0 then begin
                                    Clear(cuMatterTimeMgt_L);
                                    cuMatterTimeMgt_L.SliceRoundingUnit(recMatterHeader_L."DGF Billing Time Range (min)", recMatterHeader_L."DGF Billing Rounding Range".AsInteger());
                                    recSalesLine_L.Validate(Quantity, cuMatterTimeMgt_L.CalcTimeDeltaFactor(recSalesLine_L."SBX Entry Time", recSalesLine_L."Unit of Measure Code"));
                                    recSalesLine_L.Modify(true);
                                end;
                        until recSalesLine_L.Next() = 0;
                        CurrPage.SalesLines.Page.Update(true);
                    end;
                end;
            }*/

            action(DGFApplyTimeRange)
            {
                ApplicationArea = All;
                Caption = 'Apply Time Range';
                Image = ApplyTemplate;
                trigger OnAction()
                var
                    InvoiceTimeRangeMgt: Codeunit "DGF Invoice Time Range Mgt.";
                    SalesLine: Record "Sales Line";
                begin
                    //>>Add Fields Time Range #13Github - Hiba 31/01/23
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange("SBX Matter Entry Type", SalesLine."SBX Matter Entry Type"::Service);
                    if SalesLine.FindSet() then
                        repeat
                            InvoiceTimeRangeMgt.CalcEntryTimeVSQty(SalesLine, SalesLine.FieldNo("SBX Entry Time"), rec."SBX Matter No.");
                        until SalesLine.Next() = 0;
                    //<<Add Fields Time Range #13Github - Hiba 31/01/23
                end;
            }

        }

    }
}