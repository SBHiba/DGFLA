tableextension 50003 "DGF Sales Line" extends "Sales Line"
{
    procedure DGF_CalcBaseQty(recSalesLine: record "Sales Line"; Qty: Decimal): Decimal
    begin
        recMatterSetup_g.Get();
        recSalesLine.TestField("Qty. per Unit of Measure");
        exit(Round(Qty * recSalesLine."Qty. per Unit of Measure", recMatterSetup_g."Quantity Rounding Precision"));
    end;

    var
        recMatterSetup_g: Record "SBX Matter Setup";
}