page 50011 "DGF Partner Activities"
{
    Caption = 'Activités';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "SBX Matter Cue";

    layout
    {
        area(content)
        {
            cuegroup(DGFMyControl1)
            {
                CueGroupLayout = Wide;
                Caption = 'Ma production dans la procédure';
                ShowCaption = false;

                field(MyGrossFeesQty; MyGrossFeesQty)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Mes Heures dans la procédure cette année';
                    ShowCaption = true;
                    // AutoFormatType = 0;
                    // DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    var
                        MatterLedgerEntriesList_L: Page "SBX Matter Ledger Entries";
                    begin
                        MatterLedgerEntriesList_L.SetTableView(MatterLedgerEntry);
                        MatterLedgerEntriesList_L.Run();
                    end;
                }
            }
            cuegroup(DGFControl1)
            {
                CueGroupLayout = Wide;
                ShowCaption = false;

                field(GrossFeesQty; GrossFeesQty)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Heures facturables cette année';
                    ShowCaption = true;
                    AutoFormatType = 0;
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    var
                        MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                        MatterLedgerEntriesList_L: Page "SBX Matter Ledger Entries";
                    begin
                        MatterLedgerEntry_L.SetCurrentKey(Type, "No.", "Matter Entry Type", "Planning Date", "Non Billable");
                        MatterLedgerEntry_L.SetRange(Type, MatterLedgerEntry_L.Type::Resource);
                        MatterLedgerEntry_L.FilterGroup(2);
                        MatterLedgerEntry_L.SetRange("Matter Entry Type", MatterLedgerEntry_L."Matter Entry Type"::Service);
                        MatterLedgerEntry_L.SetFilter("Partner No.", FilterPartnerNo);
                        MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                        MatterLedgerEntry_L.FilterGroup(0);
                        MatterLedgerEntry_L.SetRange("Planning Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
                        MatterLedgerEntry_L.SetRange("Non Billable", false);
                        Clear(MatterLedgerEntriesList_L);
                        MatterLedgerEntriesList_L.SetTableView(MatterLedgerEntry_L);
                        MatterLedgerEntriesList_L.Run();
                    end;
                }
                field(WIPamtLCY; WIPamtLCY)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Encours à facturer';
                    ShowCaption = true;
                    AutoFormatExpression = SBXGetAmountFormat;
                    AutoFormatType = 11;
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    var
                        MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                        MatterLedgerEntriesList_L: Page "SBX Matter Ledger Entries";
                    begin
                        MatterLedgerEntry_L.SetCurrentKey(Type, "No.", "Matter Entry Type", "Planning Date", "Non Billable");
                        MatterLedgerEntry_L.SetRange(Type, MatterLedgerEntry_L.Type::Resource);
                        MatterLedgerEntry_L.FilterGroup(2);
                        MatterLedgerEntry_L.SetRange("Matter Entry Type", MatterLedgerEntry_L."Matter Entry Type"::Service);
                        MatterLedgerEntry_L.SetFilter("Partner No.", FilterResNo);
                        MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                        MatterLedgerEntry_L.FilterGroup(0);
                        MatterLedgerEntry_L.SetRange("Planning Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
                        MatterLedgerEntry_L.SetRange("Non Billable", false);
                        Clear(MatterLedgerEntriesList_L);
                        MatterLedgerEntriesList_L.SetTableView(MatterLedgerEntry_L);
                        MatterLedgerEntriesList_L.Run();
                    end;
                }
                field(SalesAmountYTD; SalesAmountYTD)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Facturé cette année';
                    ShowCaption = true;
                    AutoFormatExpression = SBXGetAmountFormat;
                    AutoFormatType = 11;
                    DecimalPlaces = 0 : 0;

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry_L: Record "Cust. Ledger Entry";
                        CustLedgerList_L: Page "Customer Ledger Entries";
                    begin
                        CustLedgerEntry_L.Copy(CustLedgerEntry);
                        CustLedgerEntry_L.MarkedOnly(true);
                        CustLedgerEntry_L.SetRange("Document Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
                        Clear(CustLedgerList_L);
                        CustLedgerList_L.SetTableView(CustLedgerEntry_L);
                        CustLedgerList_L.Run();
                    end;
                }
                field(PaymentAmountYTD; PaymentAmountYTD)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Paiements reçus cette année';
                    ShowCaption = true;
                    AutoFormatExpression = SBXGetAmountFormat;
                    AutoFormatType = 11;
                    DecimalPlaces = 0 : 0;
                }
            }

            cuegroup(DGFMyCustomers)
            {
                Caption = 'Activités Client';
                ShowCaption = false;

                field(DGFMyCustomersList; intMyCustomers)
                {
                    ApplicationArea = SBXSBLawyer;
                    Caption = 'Mes Clients';
                    ShowCaption = true;

                    trigger OnDrillDown()
                    var
                        pageSBXMyCustomers_L: Page "SBX My Customers List";
                    begin
                        if MyCustomer.FindSet() then begin
                            pageSBXMyCustomers_L.SetTableView(MyCustomer);
                            pageSBXMyCustomers_L.Run();
                        end;
                    end;
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        Resource_L: Record Resource;
        CustLedgerEntry_L: Record "Cust. Ledger Entry";
        MatterHeader_L: Record "SBX Matter Header";

    begin
        Clear(cuMatterMgt);
        FilterResNo := '-non defini-';
        FilterPartnerNo := '-non defini-';

        if not cuMatterMgt.GetResourceByUSERID(Resource_L, UserId, false) then
            exit;

        FilterResNo := Resource_L."No.";
        case Resource_L."SBX Resource Type" of
            Resource_L."SBX Resource Type"::Partner:
                begin
                    FilterPartnerNo := Resource_L."No.";
                    bEnablePaymentReport := true;
                end;

            Resource_L."SBX Resource Type"::Clerk,
            Resource_L."SBX Resource Type"::Administrative:
                begin
                    FilterPartnerNo := cuMatterMgt.GetPartnersWithSecretary(UserId, true);
                    bEnablePaymentReport := true;
                end;

            Resource_L."SBX Resource Type"::Board,
            Resource_L."SBX Resource Type"::Accountant,
            Resource_L."SBX Resource Type"::Billing,
            Resource_L."SBX Resource Type"::Administrator:
                begin
                    FilterPartnerNo := '';
                    bEnablePaymentReport := true;
                end;

            Resource_L."SBX Resource Type"::Manager,
            Resource_L."SBX Resource Type"::Senior:
                begin
                    bEnablePaymentReport := false;
                end;

            else begin
                bEnablePaymentReport := false;
            end;
        end;

        // Calculation for Sales Invoice Amount
        Clear(SalesAmountYTD);
        CustLedgerEntry_L.Reset();
        CustLedgerEntry_L.SetCurrentKey("SBX Partner No.", "SBX Responsible No.", "SBX Matter No.");
        CustLedgerEntry_L.SetRange("Document Type", CustLedgerEntry_L."Document Type"::Invoice, CustLedgerEntry_L."Document Type"::"Credit Memo");
        if FilterPartnerNo <> '' then
            CustLedgerEntry_L.SetFilter("SBX Partner No.", FilterResNo);
        CustLedgerEntry_L.SetRange("Document Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
        CustLedgerEntry_L.CalcSums("Sales (LCY)");
        SalesAmountYTD := CustLedgerEntry_L."Sales (LCY)";

        if CustLedgerEntry_L.FindSet() then begin
            repeat
                CustLedgerEntry_L.Mark(true);
            until CustLedgerEntry_L.Next() = 0;
            CustLedgerEntry.Copy(CustLedgerEntry_L);
        end;

        // SalesAmount := Round(SalesAmountYTD, 1);


        // Calculation for Gross Fees and WIP
        Clear(WIPamtLCY);
        Clear(GrossFeesQty);
        MatterHeader_L.Reset();
        MatterHeader_L.SetCurrentKey(Status, "Partner No.", "Matter Category", Blocked);
        //MatterHeader_L.SetRange(Status, MatterHeader_L.Status::Open, MatterHeader_L.Status::"In Progress");
        MatterHeader_L.SetRange("Matter Type", MatterHeader_L."Matter Type"::Chargeable);
        MatterHeader_L.SetRange("Planning Date Filter", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
        MatterHeader_L.SetRange("Matter Entry Type Filter", MatterHeader_L."Matter Entry Type Filter"::Service);
        MatterHeader_L.SetRange("Non Billable Filter", false);
        if FilterPartnerNo <> '' then
            MatterHeader_L.SetFilter("Partner No.", FilterPartnerNo);
        MatterHeader_L.SetAutoCalcFields("Gross Fess (Qty)", "Sales Amount (Expected) (LCY)");
        if MatterHeader_L.FindSet() then
            repeat
                WIPamtLCY += MatterHeader_L."Sales Amount (Expected) (LCY)";
                GrossFeesQty += MatterHeader_L."Gross Fess (Qty)";
            until MatterHeader_L.Next() = 0;

        MatterHeader.Copy(MatterHeader_L);
        // WIPamt := Round(WIPamtLCY, 1);
        // GrossFeesQtyYTD := Round(GrossFeesQty, 1);


        // Calculation for Paid Amount
        Clear(PaymentAmountYTD);
        DetailedCustLedgEntry.Reset();
        CustLedgerEntry_L.Reset();
        DetailedCustLedgEntry.SetCurrentKey("Initial Document Type", "Entry Type", "Customer No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date");
        DetailedCustLedgEntry.SetFilter("Initial Document Type", '%1|%2', DetailedCustLedgEntry."Initial Document Type"::Invoice, DetailedCustLedgEntry."Initial Document Type"::"Credit Memo");
        DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
        DetailedCustLedgEntry.SetRange("Posting Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
        if DetailedCustLedgEntry.Find('-') then begin
            repeat
                CustLedgerEntry_L.SetRange("Entry No.", DetailedCustLedgEntry."Cust. Ledger Entry No.");
                if FilterPartnerNo <> '' then
                    CustLedgerEntry_L.SetFilter("SBX Partner No.", FilterPartnerNo);
                if CustLedgerEntry_L.FindFirst() then begin
                    CustLedgerEntry_L.CalcFields("Amount (LCY)");
                    if CustLedgerEntry_L."Amount (LCY)" <> 0 then
                        PaymentAmountYTD += -CustLedgerEntry_L."Sales (LCY)" * (DetailedCustLedgEntry."Amount (LCY)" / CustLedgerEntry_L."Amount (LCY)");
                end;

            until DetailedCustLedgEntry.Next() = 0;
        end;
        PaymentAmount := Round(PaymentAmountYTD, 1);


        // My customers count
        MyCustomer.Reset();
        MyCustomer.SetRange("User ID", UserId);
        intMyCustomers := MyCustomer.Count;

        // Calcul Heures procédure
        Clear(MyGrossFeesQty);
        MatterLedgerEntry.SetCurrentKey(Type, "No.", "Matter Entry Type", "Planning Date", "Non Billable");
        MatterLedgerEntry.SetRange(Type, MatterLedgerEntry.Type::Resource);
        MatterLedgerEntry.SetRange("No.", FilterResNo);
        MatterLedgerEntry.SetRange("Matter Entry Type", MatterLedgerEntry."Matter Entry Type"::Service);
        MatterLedgerEntry.SetRange("Planning Date", CalcDate('<-CY>', WorkDate), CalcDate('<CM>', WorkDate));
        MatterLedgerEntry.SetRange("Closed by Ledger Entry No.", 0);
        MatterLedgerEntry.SetRange("DGF Out of Procedure", false);
        if MatterLedgerEntry.FindSet() then
            repeat
                MyGrossFeesQty += MatterLedgerEntry.Quantity;
            until MatterLedgerEntry.Next() = 0;
    end;


    var
        cuMatterMgt: Codeunit "SBX Matter Management";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        MatterHeader: Record "SBX Matter Header";
        MatterLedgerEntry: Record "SBX Matter Ledger Entry";
        MyCustomer: Record "My Customer";
        bEnablePaymentReport: Boolean;
        FilterResNo, FilterPartnerNo : Code[50];
        SalesAmount, SalesAmountYTD : Decimal;
        GrossFeesAmount, GrossFeesAmountYTD : Decimal;
        GrossFeesQty, GrossFeesQtyYTD : Decimal;
        PaymentAmount, PaymentAmountYTD : Decimal;
        WIPamt, WIPamtLCY : Decimal;
        MyGrossFeesQty: Decimal;
        intMyCustomers: Integer;

    // local procedure CalculateCueFieldValues()
    // var
    //     ActivitiesMgt: Codeunit "Activities Mgt.";
    // begin
    //     if FieldActive("Cash Accounts Balance") then
    //         "Cash Accounts Balance" := ActivitiesMgt.CalcCashAccountsBalances;
    // end;

    procedure SBXGetAmountFormat(): Text
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        UserPersonalization: Record "User Personalization";
        CurrencySymbol: Text[10];
    begin
        GeneralLedgerSetup.Get();
        CurrencySymbol := GeneralLedgerSetup.GetCurrencySymbol;

        if UserPersonalization.Get(UserSecurityId) and (CurrencySymbol <> '') then
            case UserPersonalization."Locale ID" of
                1036, // fr-FR
                1030, // da-DK
                1053, // sv-Se
                1044: // no-no
                    exit('<Precision,0:0><Standard Format,0> ' + CurrencySymbol);

                2057, // en-gb
                1033, // en-us
                4108, // fr-ch
                1031, // de-de
                2055, // de-ch
                1040, // it-it
                2064, // it-ch
                1043, // nl-nl
                2067, // nl-be
                2060, // fr-be
                3079, // de-at
                1035, // fi
                1034: // es-es
                    exit(CurrencySymbol + '<Precision,0:0><Standard Format,0>');
            end;

        exit(SBXGetDefaultAmountFormat);
    end;

    local procedure SBXGetDefaultAmountFormat(): Text
    begin
        exit('<Precision,0:0><Standard Format,0>');
    end;
}

