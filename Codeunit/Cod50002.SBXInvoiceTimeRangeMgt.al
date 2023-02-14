codeunit 50002 "DGF Invoice Time Range Mgt."
{
    //>>Add Fields Time Range #13Github - Hiba 31/01/23
    procedure CalcEntryTimeVSQty(var SalesLine: Record "Sales Line"; _iFieldNo: Integer; MatterNo: Code[20])
    var
        CallWhseCheck: Boolean;
        recResource_L: Record Resource;
        recMatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
        decQty_L: Decimal;
        MatterHeader: Record "SBX Matter Header";
    begin
        MatterHeader.get(MatterNo);
        with SalesLine do begin
            Clear(cuMatterTimeMgt_g);
            recExpenseSetup_g.Get;

            cuMatterTimeMgt_g.SliceRoundingUnit(MatterHeader."Inv. Time Range (min)", MatterHeader."Inv. Rounding Range (min)".AsInteger());
            validate(Quantity, cuMatterTimeMgt_g.CalcTimeDeltaFactor("SBX Entry Time", "Unit of Measure Code"));
            // "Quantity (Base)" := CalcBaseQty1(Quantity);

            Modify();
            UpdateAmounts;
        end;
    end;

    local procedure CalcBaseQty1(Qty: Decimal): Decimal
    begin
        MatterSetup_g.Get();
        exit(Round(Qty, MatterSetup_g."Quantity Rounding Precision"));

    end;

    var
        cuMatterTimeMgt_g: Codeunit "SBX Matter Time Management";
        recExpenseSetup_g: Record "SBX Expense Setup";
        MatterSetup_g: Record "SBX Matter Setup";




}
