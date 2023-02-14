pageextension 50002 "DGF Prop. Adjust." extends "SBX Apply Proport. Adjustment"
{
    var
        decTotalServQuantity_q: Decimal;
        decServQuantity_g: Decimal;

    local procedure UpdateQty()
    var
    begin
        if not bSuggestAmount_g then begin
            if bAdjustmentVisible then begin
                decServQuantity_g := 0;
                decTotalServQuantity_q := CalcServiceQuantity();
            end;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ErrServAdjAmount: Label 'No Adjustment Amount if Adjustment Quantity used';
    begin
        if CloseAction = ACTION::OK then begin
            if bAdjustmentVisible then begin
                if decServQuantity_g <> 0 then begin
                    if decServAdjAmt_g <> 0 then
                        Error(ErrServAdjAmount);
                    subQueryQty();
                end;
            end;
        end;
    end;

    procedure CalcServiceQuantity(): Decimal
    var
        recSalesLine_L: Record "Sales Line";
        recMatterLine_L: Record "SBX Matter Line";
        decServiceQty_L: Decimal;
        recMatterHeader_L: Record "SBX Matter Header";
    begin
        if cMatterNo_g <> '' then
            recMatterHeader_L.Get(cMatterNo_g);

        recSalesLine_L.Reset;
        recSalesLine_L.SetCurrentKey("Document Type", "Document No.", Type);
        recSalesLine_L.SetRange("Document Type", recSalesHeader_g."Document Type");
        recSalesLine_L.SetRange("Document No.", recSalesHeader_g."No.");
        if cMatterNo_g <> '' then
            recSalesLine_L.SetRange("SBX Matter No.", cMatterNo_g);
        recSalesLine_L.SetRange(Type, recSalesLine_L.Type::Resource);

        if cResource_g <> '' then
            recSalesLine_L.SetFilter("No.", cResource_g);

        recSalesLine_L.SetRange("SBX Write Off", false);
        recSalesLine_L.SetRange("SBX Transfer", false);
        recSalesLine_L.SetRange("SBX Postpone", false);

        if recSalesLine_L.FindSet then
            repeat
                if recMatterLine_L.Get(recSalesLine_L."SBX Matter No.", recSalesLine_L."SBX Matter Line No.") then begin
                    if recMatterLine_L."Matter Entry Type" = recMatterLine_L."Matter Entry Type"::Service then
                        decServiceQty_L += recSalesLine_L."Quantity";
                end;
            until recSalesLine_L.Next = 0;

        exit(decServiceQty_L);
    end;

    local procedure subQueryQty()
    var
        recSalesLine_L: Record "Sales Line";
        decCalcAdjustment_L: Decimal;
        recCurrency_L: Record Currency;
        decTotalAdj_L: Decimal;
        decTotalGap_L: Decimal;

    begin
        if recSalesHeader_g."Currency Code" = '' then
            recCurrency_L.InitRoundingPrecision
        else begin
            recSalesHeader_g.TestField("Currency Factor");
            recCurrency_L.Get(recSalesHeader_g."Currency Code");
            recCurrency_L.TestField("Amount Rounding Precision");
        end;

        decTotalAdj_L := 0;
        recSalesLine_L.Reset;
        recSalesLine_L.SetCurrentKey("Document Type", "Document No.", Type);
        recSalesLine_L.SetRange("Document Type", recSalesHeader_g."Document Type");
        recSalesLine_L.SetRange("Document No.", recSalesHeader_g."No.");

        if cMatterNo_g <> '' then
            recSalesLine_L.SetRange("SBX Matter No.", cMatterNo_g);

        recSalesLine_L.SetRange(Type, recSalesLine_L.Type::Resource);
        if cResource_g <> '' then
            recSalesLine_L.SetFilter("No.", cResource_g);

        recSalesLine_L.SetRange("SBX Write Off", false);
        recSalesLine_L.SetRange("SBX Transfer", false);
        recSalesLine_L.SetRange("SBX Postpone", false);
        recSalesLine_L.SetRange("SBX Matter Entry Type", recSalesLine_L."SBX Matter Entry Type"::Service);
        if recSalesLine_L.FindSet(true) then
            repeat
                decCalcAdjustment_L := 0;
                if decTotalServQuantity_q <> 0 then
                    decCalcAdjustment_L := Round(((decServQuantity_g / decTotalServQuantity_q)) * (recSalesLine_L.Quantity), recCurrency_L."Amount Rounding Precision");

                recSalesLine_L.Validate(Quantity, Round(decCalcAdjustment_L, recCurrency_L."Amount Rounding Precision"));
                decTotalAdj_L += recSalesLine_L.Quantity;
                recSalesLine_L.Modify(true);
            until recSalesLine_L.Next = 0;

        decTotalGap_L := decServQuantity_g - decTotalAdj_L;
        if decTotalGap_L <> 0 then begin
            // recMatterSetup_L.Get();
            recSalesLine_L.Reset;
            recSalesLine_L.SetRange("Document Type", recSalesHeader_g."Document Type");
            recSalesLine_L.SetRange("Document No.", recSalesHeader_g."No.");
            if cMatterNo_g <> '' then
                recSalesLine_L.SetFilter("SBX Matter No.", cMatterNo_g);
            recSalesLine_L.SetRange(Type, recSalesLine_L.Type::Resource);
            if cResource_g <> '' then
                recSalesLine_L.SetFilter("No.", cResource_g);
            recSalesLine_L.SetRange("SBX Write Off", false);
            recSalesLine_L.SetRange("SBX Transfer", false);
            recSalesLine_L.SetRange("SBX Postpone", false);

            if recSalesLine_L.FindLast() then begin
                recSalesLine_L.Validate(Quantity, recSalesLine_L.Quantity + decTotalGap_L);
                recSalesLine_L.Modify(true);
            end;
        end;
    end;
}