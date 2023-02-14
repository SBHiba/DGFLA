

codeunit 80900 "DGFLA Oldest Apply Cust - Vend"
{
    Permissions = TableData "Cust. Ledger Entry" = RIM,
                  TableData "Vendor Ledger Entry" = RIM,
                  TableData "Detailed Cust. Ledg. Entry" = RIM,
                  TableData "Detailed Vendor Ledg. Entry" = RIM;

    trigger OnRun()
    begin
    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ApplnCurrencyCode: Code[10];
        CodeAppliesID: Code[50];
        AppliedDate: Date;
        AmountRoundingPrecision, AppliedAmount : Decimal;


    [TryFunction]
    procedure CustApplyOldestEntries(var _recCustLedgerEntry: Record "Cust. Ledger Entry"; _optApplyType: Option SameAmount,OldestApply,Both; _bOldestDate: Boolean)
    var
        recCustExchangeLedgerEntry_L: Record "Cust. Ledger Entry";
        recCustLedgerEntry_L: Record "Cust. Ledger Entry";
        recCustToAppliedLedgerEntry_L: Record "Cust. Ledger Entry";
        CustEntryApplyPostedEntries_L: Codeunit "CustEntry-Apply Posted Entries";
        bApply_L: Boolean;
        bBreak_L: Boolean;
        bExclude_L: Boolean;
        CanUseDisc_L: Boolean;
        AppliedAmount_L: Decimal;
        decCurrentAmount_L: Decimal;
    begin
        recCustLedgerEntry_L.SetAutoCalcFields("Remaining Amount", "Remaining Amt. (LCY)");

        if not recCustLedgerEntry_L.Get(_recCustLedgerEntry."Entry No.") then
            exit;
        if recCustLedgerEntry_L.IsEmpty then
            exit;

        if not recCustLedgerEntry_L.Open then
            exit;

        if recCustLedgerEntry_L."Remaining Amount" = 0 then
            exit;

        AppliedAmount := recCustLedgerEntry_L."Remaining Amount";

        // AppliedDate := recCustLedgerEntry_L."Posting Date";
        AppliedDate := WorkDate();
        ApplnCurrencyCode := recCustLedgerEntry_L."Currency Code";
        CodeAppliesID := UserId;

        FindAmountRounding;

        recCustLedgerEntry_L."Applying Entry" := true;
        recCustLedgerEntry_L."Applies-to ID" := CodeAppliesID;
        recCustLedgerEntry_L."Amount to Apply" := recCustLedgerEntry_L."Remaining Amount";
        //CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",recCustLedgerEntry_L);

        decCurrentAmount_L := 0;
        bBreak_L := false;
        bApply_L := false;

        recCustToAppliedLedgerEntry_L.Reset;
        //recCustToAppliedLedgerEntry_L.SETCURRENTKEY("Customer No.",Open,Positive);
        //recCustToAppliedLedgerEntry_L.SETCURRENTKEY("Document Type","Customer No.","Posting Date","Currency Code");
        recCustToAppliedLedgerEntry_L.SetCurrentKey("Customer No.", "Currency Code", "Posting Date");
        recCustToAppliedLedgerEntry_L.SetRange("Customer No.", recCustLedgerEntry_L."Customer No.");
        recCustToAppliedLedgerEntry_L.SetFilter("Entry No.", '<>%1', recCustLedgerEntry_L."Entry No.");
        recCustToAppliedLedgerEntry_L.SetRange(Open, true);
        if not _bOldestDate then begin
            if _optApplyType <> _optApplyType::SameAmount then
                recCustToAppliedLedgerEntry_L.SetRange("Posting Date", 0D, recCustLedgerEntry_L."Posting Date");
            //recCustToAppliedLedgerEntry_L.SETFILTER("Document Type",'<>%1',recCustToAppliedLedgerEntry_L."Document Type"::Payment);
        end;
        recCustToAppliedLedgerEntry_L.SetRange(Positive, true);
        recCustToAppliedLedgerEntry_L.SetAutoCalcFields("Remaining Amount");

        if (_optApplyType = _optApplyType::Both) or (_optApplyType = _optApplyType::SameAmount) then begin
            if ApplnCurrencyCode <> '' then
                recCustToAppliedLedgerEntry_L.SetRange("Currency Code", ApplnCurrencyCode);

            if recCustToAppliedLedgerEntry_L.FindSet then
                repeat
                    if recCustToAppliedLedgerEntry_L."Remaining Amount" = Abs(AppliedAmount) then begin
                        recCustToAppliedLedgerEntry_L."Applying Entry" := true;
                        recCustToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                        recCustToAppliedLedgerEntry_L."Amount to Apply" := Abs(AppliedAmount);
                        CustEntryEdit(recCustToAppliedLedgerEntry_L);
                        recCustToAppliedLedgerEntry_L.Modify;
                        bApply_L := true;
                    end;
                until (recCustToAppliedLedgerEntry_L.Next = 0) or (bApply_L = true);
        end;

        if (_optApplyType = _optApplyType::Both) or (_optApplyType = _optApplyType::OldestApply) then begin

            if not bApply_L then begin
                recCustToAppliedLedgerEntry_L.SetRange("Currency Code");

                if recCustToAppliedLedgerEntry_L.FindSet then
                    repeat
                        bExclude_L := false;
                        if (recCustToAppliedLedgerEntry_L."Document Type" = recCustToAppliedLedgerEntry_L."Document Type"::" ") and (recCustToAppliedLedgerEntry_L."Remaining Amount" < 0) then
                            bExclude_L := true;

                        if not bExclude_L then begin
                            recCustToAppliedLedgerEntry_L."Amount to Apply" := recCustToAppliedLedgerEntry_L."Remaining Amount";

                            recCustExchangeLedgerEntry_L := recCustToAppliedLedgerEntry_L;
                            CustCurrencyExchAmount(recCustExchangeLedgerEntry_L);
                            //CanUseDisc_L := PaymentToleranceMgt.CheckCalcPmtDiscCust(recCustLedgerEntry_L,recCustExchangeLedgerEntry_L,0,FALSE,FALSE);
                            decCurrentAmount_L := recCustExchangeLedgerEntry_L."Amount to Apply";

                            if decCurrentAmount_L >= Abs(AppliedAmount) then begin
                                recCustToAppliedLedgerEntry_L."Applying Entry" := true;
                                recCustToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                                // IF recCustToAppliedLedgerEntry_L.Positive THEN
                                //  AppliedAmount_L := ABS(AppliedAmount)
                                // ELSE
                                //  AppliedAmount_L := -1 * ABS(AppliedAmount);

                                recCustToAppliedLedgerEntry_L."Amount to Apply" := CurrExchRate.ExchangeAmount(
                                                                                                               Abs(AppliedAmount),
                                                                                                               ApplnCurrencyCode,
                                                                                                               recCustToAppliedLedgerEntry_L."Currency Code", recCustToAppliedLedgerEntry_L."Posting Date");
                                CustEntryEdit(recCustToAppliedLedgerEntry_L);
                                recCustToAppliedLedgerEntry_L.Modify();
                                bBreak_L := true;
                                bApply_L := true;
                            end else begin
                                AppliedAmount += decCurrentAmount_L;
                                recCustToAppliedLedgerEntry_L."Applying Entry" := true;
                                recCustToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                                recCustToAppliedLedgerEntry_L."Amount to Apply" := recCustToAppliedLedgerEntry_L."Amount to Apply";
                                CustEntryEdit(recCustToAppliedLedgerEntry_L);
                                recCustToAppliedLedgerEntry_L.Modify;
                                bApply_L := true;
                            end;
                        end;
                    until (recCustToAppliedLedgerEntry_L.Next = 0) or (bBreak_L = true);
            end;
        end;

        if (bApply_L) and (AppliedAmount >= recCustLedgerEntry_L."Amount to Apply") then begin
            CustEntryEdit(recCustLedgerEntry_L);
            recCustLedgerEntry_L.Modify();
            CustEntryApplyPostedEntries_L.Apply(recCustLedgerEntry_L, recCustLedgerEntry_L."Document No.", AppliedDate);
        end;
    end;

    [TryFunction]
    procedure VendApplyOldestEntries(var _recVendorLedgerEntry: Record "Vendor Ledger Entry"; _optApplyType: Option SameAmount,OldestApply,Both; _bOldestDate: Boolean)
    var
        recVendorLedgerEntry_L: Record "Vendor Ledger Entry";
        recVendorToAppliedLedgerEntry_L: Record "Vendor Ledger Entry";
        recVendorExchangeLedgerEntry_L: Record "Vendor Ledger Entry";
        CanUseDisc_L: Boolean;
        bExclude_L: Boolean;
        decCurrentAmount_L: Decimal;
        bBreak_L: Boolean;
        VendorEntryApplyPostedEntries_L: Codeunit "VendEntry-Apply Posted Entries";
        bApply_L: Boolean;
        AppliedAmount_L: Decimal;
    begin
        recVendorLedgerEntry_L.SetAutoCalcFields("Remaining Amount", "Remaining Amt. (LCY)");

        if not recVendorLedgerEntry_L.Get(_recVendorLedgerEntry."Entry No.") then
            exit;
        if recVendorLedgerEntry_L.IsEmpty then
            exit;

        if not recVendorLedgerEntry_L.Open then
            exit;

        if recVendorLedgerEntry_L."Remaining Amount" = 0 then
            exit;

        AppliedAmount := recVendorLedgerEntry_L."Remaining Amount";
        //AppliedDate := recVendorLedgerEntry_L."Posting Date";
        AppliedDate := WorkDate();
        ApplnCurrencyCode := recVendorLedgerEntry_L."Currency Code";
        CodeAppliesID := UserId;

        FindAmountRounding();

        recVendorLedgerEntry_L."Applying Entry" := true;
        recVendorLedgerEntry_L."Applies-to ID" := CodeAppliesID;
        recVendorLedgerEntry_L."Amount to Apply" := recVendorLedgerEntry_L."Remaining Amount";
        //CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",recCustLedgerEntry_L);
        //VendEntryEdit(recVendorLedgerEntry_L);
        //recVendorLedgerEntry_L.MODIFY;

        decCurrentAmount_L := 0;
        bBreak_L := false;
        bApply_L := false;

        recVendorToAppliedLedgerEntry_L.Reset;
        //recVendorToAppliedLedgerEntry_L.SETCURRENTKEY("Customer No.",Open,Positive);
        //recVendorToAppliedLedgerEntry_L.SETCURRENTKEY("Document Type","Customer No.","Posting Date","Currency Code");
        recVendorToAppliedLedgerEntry_L.SetCurrentKey("Vendor No.", "Currency Code", "Posting Date");
        recVendorToAppliedLedgerEntry_L.SetRange("Vendor No.", recVendorLedgerEntry_L."Vendor No.");
        recVendorToAppliedLedgerEntry_L.SetFilter("Entry No.", '<>%1', recVendorLedgerEntry_L."Entry No.");
        recVendorToAppliedLedgerEntry_L.SetRange(Open, true);
        if not _bOldestDate then begin
            if _optApplyType <> _optApplyType::SameAmount then
                recVendorToAppliedLedgerEntry_L.SetRange("Posting Date", 0D, recVendorLedgerEntry_L."Posting Date");
            //recVendorToAppliedLedgerEntry_L.SETFILTER("Document Type",'<>%1',recCustToAppliedLedgerEntry_L."Document Type"::Payment);
        end;
        recVendorToAppliedLedgerEntry_L.SetRange(Positive, false);
        recVendorToAppliedLedgerEntry_L.SetAutoCalcFields("Remaining Amount");

        if (_optApplyType = _optApplyType::Both) or (_optApplyType = _optApplyType::SameAmount) then begin
            if ApplnCurrencyCode <> '' then
                recVendorToAppliedLedgerEntry_L.SetRange("Currency Code", ApplnCurrencyCode);

            if recVendorToAppliedLedgerEntry_L.FindSet then
                repeat
                    if Abs(recVendorToAppliedLedgerEntry_L."Remaining Amount") = AppliedAmount then begin
                        recVendorToAppliedLedgerEntry_L."Applying Entry" := true;
                        recVendorToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                        recVendorToAppliedLedgerEntry_L."Amount to Apply" := recVendorToAppliedLedgerEntry_L."Remaining Amount";
                        VendEntryEdit(recVendorToAppliedLedgerEntry_L);
                        recVendorToAppliedLedgerEntry_L.Modify;
                        bApply_L := true;
                    end;
                until (recVendorToAppliedLedgerEntry_L.Next = 0) or (bApply_L = true);
        end;


        if (_optApplyType = _optApplyType::Both) or (_optApplyType = _optApplyType::OldestApply) then begin

            if not bApply_L then begin
                recVendorToAppliedLedgerEntry_L.SetRange("Currency Code");

                if recVendorToAppliedLedgerEntry_L.FindSet then
                    repeat
                        bExclude_L := false;
                        if (recVendorToAppliedLedgerEntry_L."Document Type" = recVendorToAppliedLedgerEntry_L."Document Type"::" ") and (recVendorToAppliedLedgerEntry_L."Remaining Amount" > 0) then
                            bExclude_L := true;

                        if not bExclude_L then begin
                            recVendorToAppliedLedgerEntry_L."Amount to Apply" := recVendorToAppliedLedgerEntry_L."Remaining Amount";

                            recVendorExchangeLedgerEntry_L := recVendorToAppliedLedgerEntry_L;
                            VendCurrencyExchAmount(recVendorExchangeLedgerEntry_L);
                            //CanUseDisc_L := PaymentToleranceMgt.CheckCalcPmtDiscCust(recCustLedgerEntry_L,recCustExchangeLedgerEntry_L,0,FALSE,FALSE);
                            decCurrentAmount_L := recVendorExchangeLedgerEntry_L."Amount to Apply";

                            if Abs(decCurrentAmount_L) >= AppliedAmount then begin
                                recVendorToAppliedLedgerEntry_L."Applying Entry" := true;
                                recVendorToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                                //      IF recCustToAppliedLedgerEntry_L.Positive THEN
                                //        AppliedAmount_L:=ABS(AppliedAmount)
                                //      ELSE
                                //        AppliedAmount_L:=-1*ABS(AppliedAmount);

                                recVendorToAppliedLedgerEntry_L."Amount to Apply" := CurrExchRate.ExchangeAmount(
                                                                                                                -1 * AppliedAmount,
                                                                                                                ApplnCurrencyCode,
                                                                                                                recVendorToAppliedLedgerEntry_L."Currency Code", recVendorToAppliedLedgerEntry_L."Posting Date");
                                VendEntryEdit(recVendorToAppliedLedgerEntry_L);
                                recVendorToAppliedLedgerEntry_L.Modify;
                                bBreak_L := true;
                                bApply_L := true;
                            end else begin
                                AppliedAmount += decCurrentAmount_L;
                                recVendorToAppliedLedgerEntry_L."Applying Entry" := true;
                                recVendorToAppliedLedgerEntry_L."Applies-to ID" := CodeAppliesID;
                                recVendorToAppliedLedgerEntry_L."Amount to Apply" := recVendorToAppliedLedgerEntry_L."Amount to Apply";
                                VendEntryEdit(recVendorToAppliedLedgerEntry_L);
                                recVendorToAppliedLedgerEntry_L.Modify;
                                bApply_L := true;
                            end;
                        end;
                    until (recVendorToAppliedLedgerEntry_L.Next = 0) or (bBreak_L = true);
            end;
        end;

        if (bApply_L) and (AppliedAmount <= recVendorLedgerEntry_L."Amount to Apply") then begin
            VendEntryEdit(recVendorLedgerEntry_L);
            recVendorLedgerEntry_L.Modify();
            VendorEntryApplyPostedEntries_L.Apply(recVendorLedgerEntry_L, recVendorLedgerEntry_L."Document No.", AppliedDate);
        end;
    end;

    local procedure FindAmountRounding()
    begin
        if ApplnCurrencyCode = '' then begin
            Currency.Init;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
        end else
            if ApplnCurrencyCode <> Currency.Code then
                Currency.Get(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    local procedure CustCurrencyExchAmount(var _CalcCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        if (ApplnCurrencyCode <> _CalcCustLedgEntry."Currency Code") then begin
            _CalcCustLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                _CalcCustLedgEntry."Remaining Amount",
                _CalcCustLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
            _CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                _CalcCustLedgEntry."Remaining Pmt. Disc. Possible",
                _CalcCustLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
            _CalcCustLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                _CalcCustLedgEntry."Amount to Apply",
                _CalcCustLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
        end;
    end;

    local procedure VendCurrencyExchAmount(var _CalcVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        if (ApplnCurrencyCode <> _CalcVendLedgEntry."Currency Code") then begin
            _CalcVendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                _CalcVendLedgEntry."Remaining Amount",
                _CalcVendLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
            _CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                _CalcVendLedgEntry."Remaining Pmt. Disc. Possible",
                _CalcVendLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
            _CalcVendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                _CalcVendLedgEntry."Amount to Apply",
                _CalcVendLedgEntry."Currency Code",
                ApplnCurrencyCode, AppliedDate);
        end;
    end;

    [TryFunction]
    local procedure CustEntryEdit(var _Rec: Record "Cust. Ledger Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        CustLedgEntry := _Rec;
        CustLedgEntry.LockTable;
        CustLedgEntry.Find;
        CustLedgEntry."On Hold" := _Rec."On Hold";
        if CustLedgEntry.Open then begin
            CustLedgEntry."Due Date" := _Rec."Due Date";
            DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
            DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
            DtldCustLedgEntry.ModifyAll("Initial Entry Due Date", _Rec."Due Date");
            CustLedgEntry."Pmt. Discount Date" := _Rec."Pmt. Discount Date";
            CustLedgEntry."Applies-to ID" := _Rec."Applies-to ID";
            CustLedgEntry.Validate("Payment Method Code", _Rec."Payment Method Code");
            CustLedgEntry.Validate("Remaining Pmt. Disc. Possible", _Rec."Remaining Pmt. Disc. Possible");
            CustLedgEntry."Pmt. Disc. Tolerance Date" := _Rec."Pmt. Disc. Tolerance Date";
            CustLedgEntry.Validate("Max. Payment Tolerance", _Rec."Max. Payment Tolerance");
            CustLedgEntry.Validate("Accepted Payment Tolerance", _Rec."Accepted Payment Tolerance");
            CustLedgEntry.Validate("Accepted Pmt. Disc. Tolerance", _Rec."Accepted Pmt. Disc. Tolerance");
            CustLedgEntry.Validate("Amount to Apply", _Rec."Amount to Apply");
            CustLedgEntry.Validate("Applying Entry", _Rec."Applying Entry");
            CustLedgEntry.Validate("Applies-to Ext. Doc. No.", _Rec."Applies-to Ext. Doc. No.");
            CustLedgEntry.Validate("Message to Recipient", _Rec."Message to Recipient");
            CustLedgEntry."Direct Debit Mandate ID" := _Rec."Direct Debit Mandate ID";
        end;
        CustLedgEntry.Validate("Exported to Payment File", _Rec."Exported to Payment File");
        CustLedgEntry.Modify;
        _Rec := CustLedgEntry;
    end;

    [TryFunction]
    local procedure VendEntryEdit(var _Rec: Record "Vendor Ledger Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        VendLedgEntry := _Rec;
        VendLedgEntry.LockTable;
        VendLedgEntry.Find;
        VendLedgEntry."On Hold" := _Rec."On Hold";
        if VendLedgEntry.Open then begin
            VendLedgEntry."Due Date" := _Rec."Due Date";
            DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.");
            DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
            DtldVendLedgEntry.ModifyAll("Initial Entry Due Date", _Rec."Due Date");
            VendLedgEntry."Pmt. Discount Date" := _Rec."Pmt. Discount Date";
            VendLedgEntry."Applies-to ID" := _Rec."Applies-to ID";
            VendLedgEntry.Validate("Payment Method Code", _Rec."Payment Method Code");
            VendLedgEntry.Validate("Remaining Pmt. Disc. Possible", _Rec."Remaining Pmt. Disc. Possible");
            VendLedgEntry."Pmt. Disc. Tolerance Date" := _Rec."Pmt. Disc. Tolerance Date";
            VendLedgEntry.Validate("Max. Payment Tolerance", _Rec."Max. Payment Tolerance");
            VendLedgEntry.Validate("Accepted Payment Tolerance", _Rec."Accepted Payment Tolerance");
            VendLedgEntry.Validate("Accepted Pmt. Disc. Tolerance", _Rec."Accepted Pmt. Disc. Tolerance");
            VendLedgEntry.Validate("Amount to Apply", _Rec."Amount to Apply");
            VendLedgEntry.Validate("Applying Entry", _Rec."Applying Entry");
            VendLedgEntry.Validate("Applies-to Ext. Doc. No.", _Rec."Applies-to Ext. Doc. No.");
            VendLedgEntry.Validate("Message to Recipient", _Rec."Message to Recipient");
        end;
        VendLedgEntry.Validate("Exported to Payment File", _Rec."Exported to Payment File");
        VendLedgEntry.Validate("Creditor No.", _Rec."Creditor No.");
        VendLedgEntry.Validate("Payment Reference", _Rec."Payment Reference");
        VendLedgEntry.Modify();

        _Rec := VendLedgEntry;
    end;
}
