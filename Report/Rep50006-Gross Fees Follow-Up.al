report 50006 "DGF Gross Fees Follow-Up"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50006-Gross Fees Follow-Up.rdlc';

    Caption = 'Gross Fees Follow-Up', Comment = 'fr-FR = Suivi de la production';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    MaximumDatasetSize = 1000000;


    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = sorting("Resource Group No.") where(Type = const(Person), "SBX Resource Type" = const(Partner), Blocked = const(false));
            RequestFilterFields = "No.", "SBX Inactive";
            PrintOnlyIfDetail = true;

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(ReportFilter; txtFilter_g)
            { }
            column(StartDate; DateStartingPeriod_g)
            { }
            column(EndDate; DateEndingPeriod_g)
            { }
            column(ContributionRate; ContributionRate / 100)
            { }
            column(SalesAccrualsPercent; SalesAccrualsPercent / 100)
            { }
            column(Resource_No; Resource."No.")
            { }
            column(Resource_Name; Resource.Name)
            { }
            column(Job_Title; "Job Title")
            { }
            column(DisplayOrder; ResourceGroup."SBX Name 2")
            { }
            column(DisplayDetails; DisplayDetails)
            { }


            dataitem("SBX Matter Header"; "SBX Matter Header")
            {
                DataItemLink = "Partner No." = field("No.");
                DataItemTableView = sorting("Partner No.") where("Matter Type" = const(Chargeable));
                CalcFields = "Sales Amount (Actual) (LCY)";

                column(Matter_No; "Matter No.")
                { }
                column(MatterName; Name)
                { }
                column(SellToName; "Sell-to Name")
                { }
                column(MatterPartner; "Partner No.")
                { }
                column(MatterSourceLawyer; OringinatingLawyer)
                { }
                column(SalesAmountActual; "Sales Amount (Actual) (LCY)" + ExpenseAsFeesAmt + ProvisionAmt)
                { }
                column(GrossFeesAccrualsAmt; GrossFeesAccrualsAmt)
                { }
                column(ExpenseAccrualsAmt; ExpenseAccrualsAmt)
                { }


                trigger OnPreDataItem()
                begin
                    "SBX Matter Header".SetRange("Non Billable Filter", false);
                    "SBX Matter Header".SetRange("Planning Date Filter", 0D, DateEndingPeriod_g);
                    "SBX Matter Header".SetRange("Document Date Filter", DateStartingPeriod_g, DateEndingPeriod_g);
                    "SBX Matter Header".SetFilter("Matter Entry Type Filter", '%1|%2', "SBX Matter Header"."Matter Entry Type Filter"::Service, "SBX Matter Header"."Matter Entry Type Filter"::Adjustment);
                end;

                trigger OnAfterGetRecord()
                var
                    MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                    MatterValueEntry_L: Record "SBX Matter Value Entry";
                    SalesCrMemoLine_L: Record "Sales Cr.Memo Line";
                    SalesInvoiceLine_L: Record "Sales Invoice Line";
                    InternalOriginating_L: Record "SBX Internal Originating";

                begin
                    // Ajout des frais facturés en hono au CA
                    ExpenseAsFeesAmt := 0;
                    MatterValueEntry_L.Reset();
                    MatterValueEntry_L.SetRange("Matter No.", "Matter No.");
                    MatterValueEntry_L.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    //MatterValueEntry_L.SetRange("Planning Date", 0D, DateEndingPeriod_g); // remettre condition si temps estimé sont ajoutés sur la période en cours (notamment pour les estimations de temps pr dossier closing)
                    MatterValueEntry_L.SetRange("Document Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterValueEntry_L.SetRange("Matter Ledg. Entry Type", MatterValueEntry_L."Matter Ledg. Entry Type"::Sales);
                    MatterValueEntry_L.SetRange("Matter Entry Type", MatterValueEntry_L."Matter Entry Type"::Expense, MatterValueEntry_L."Matter Entry Type"::"External Expense");
                    if MatterValueEntry_L.FindSet() then
                        repeat
                            case MatterValueEntry_L."Document Type" of
                                MatterValueEntry_L."Document Type"::"Credit Memo":
                                    begin
                                        SalesCrMemoLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesCrMemoLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesCrMemoLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesCrMemoLine_L.FindFirst();
                                        if SalesCrMemoLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;

                                MatterValueEntry_L."Document Type"::Invoice:
                                    begin
                                        SalesInvoiceLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesInvoiceLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesInvoiceLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesInvoiceLine_L.FindFirst();
                                        if SalesInvoiceLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;
                            end;
                        until MatterValueEntry_L.Next() = 0;


                    // Calcul FAE
                    GrossFeesAccrualsAmt := 0;
                    ExpenseAccrualsAmt := 0;
                    MatterLedgerEntry_L.Reset();
                    MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                    MatterLedgerEntry_L.SetRange("Planning Date", CalcDate('<-CY-1Y>', DateStartingPeriod_g), DateEndingPeriod_g);
                    MatterLedgerEntry_L.SetRange("Date Filter", 0D, DateEndingPeriod_g);
                    //MatterLedgerEntry_L.SetRange("Matter Entry Type", MatterLedgerEntry_L."Matter Entry Type"::Service);
                    MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Expected) (LCY)");
                    if MatterLedgerEntry_L.FindSet() then
                        repeat
                            if MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" <> 0 then begin
                                Case MatterLedgerEntry_L."Matter Entry Type" of
                                    MatterLedgerEntry_L."Matter Entry Type"::Adjustment,
                                    MatterLedgerEntry_L."Matter Entry Type"::Service:
                                        GrossFeesAccrualsAmt += MatterLedgerEntry_L."Reference Amount";
                                    else
                                        ExpenseAccrualsAmt += MatterLedgerEntry_L."Reference Amount";
                                end;
                            end;
                        until MatterLedgerEntry_L.Next() = 0;

                    // Gestion Provision
                    ProvisionAmt := 0;
                    MatterPrepaymentEntry.Reset();
                    MatterPrepaymentEntry.SetRange("Matter No.", "Matter No.");
                    MatterPrepaymentEntry.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterPrepaymentEntry.SetRange("Entry Type", MatterPrepaymentEntry."Entry Type"::Service);
                    if MatterPrepaymentEntry.FindSet() then
                        repeat
                            ProvisionAmt += MatterPrepaymentEntry."Amount (LCY)";
                        until MatterPrepaymentEntry.Next() = 0;

                    if ("Sales Amount (Actual) (LCY)" + ExpenseAsFeesAmt + ProvisionAmt) = 0 then
                        // if GrossFeesAccrualsAmt = 0 then
                        //     if ExpenseAccrualsAmt = 0 then
                                CurrReport.Skip();


                    // Origine du dossier
                    OringinatingLawyer := '';
                    InternalOriginating_L.Reset();
                    InternalOriginating_L.SetRange(Type, InternalOriginating_L.Type::Matter);
                    InternalOriginating_L.SetRange("No.", "Matter No.");
                    InternalOriginating_L.SetFilter(Percentage, '>0');
                    IF InternalOriginating_L.FindSet() then
                        repeat
                            OringinatingLawyer += InternalOriginating_L."Resource No." + '_';
                        until InternalOriginating_L.Next() = 0;

                    OringinatingLawyer := DelChr(OringinatingLawyer, '>', '_');
                end;

            }

            dataitem("SBX Internal Originating"; "SBX Internal Originating")
            {
                DataItemLink = "Resource No." = field("No.");
                DataItemTableView = sorting("Resource No.") where(Type = const(Matter), Percentage = filter(<> 0));

                column(MatterNo_Origin; "No.")
                { }
                column(MatterName_Origin; MatterName)
                { }
                column(SellToName_Origin; SellToName)
                { }
                column(PartnerNo_Origin; MatterPartnerNo)
                { }
                column(SourceLawyer_Origin; "Resource No.")
                { }
                column(SalesActualMatterAmt_Origin; SalesActualMatterAmt + ExpenseAsFeesAmt + ProvisionAmt)
                { }


                trigger OnPreDataItem()
                begin
                    MatterName := '';
                    MatterPartnerNo := '';
                    SellToName := '';
                end;

                trigger OnAfterGetRecord()
                var
                    MatterHeader_L: Record "SBX Matter Header";
                    MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                    MatterValueEntry_L: Record "SBX Matter Value Entry";
                    SalesCrMemoLine_L: Record "Sales Cr.Memo Line";
                    SalesInvoiceLine_L: Record "Sales Invoice Line";

                begin
                    MatterHeader_L.Get("No.");
                    if MatterHeader_L."Matter Type" <> MatterHeader_L."Matter Type"::Chargeable then
                        CurrReport.Skip();
                    if MatterHeader_L."Partner No." = "Resource No." then
                        CurrReport.Skip();

                    MatterName := MatterHeader_L.Name;
                    MatterPartnerNo := MatterHeader_L."Partner No.";
                    SellToName := MatterHeader_L."Sell-to Name";

                    // Matter Billed Service Amount
                    SalesActualMatterAmt := 0;
                    MatterHeader_L.Reset();
                    MatterHeader_L.SetRange("Matter No.", "No.");
                    MatterHeader_L.SetRange("Non Billable Filter", false);
                    MatterHeader_L.SetRange("Planning Date Filter", 0D, DateEndingPeriod_g);
                    MatterHeader_L.SetRange("Document Date Filter", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterHeader_L.SetFilter("Matter Entry Type Filter", '%1|%2', MatterHeader_L."Matter Entry Type Filter"::Service, MatterHeader_L."Matter Entry Type Filter"::Adjustment);
                    MatterHeader_L.FindFirst();
                    MatterHeader_L.CalcFields("Sales Amount (Actual) (LCY)");
                    SalesActualMatterAmt := MatterHeader_L."Sales Amount (Actual) (LCY)";

                    // Ajout des frais facturés en hono au CA
                    ExpenseAsFeesAmt := 0;
                    MatterValueEntry_L.Reset();
                    MatterValueEntry_L.SetRange("Matter No.", "No.");
                    MatterValueEntry_L.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    //MatterValueEntry_L.SetRange("Planning Date", 0D, DateEndingPeriod_g); // remettre condition si temps estimé sont ajoutés sur la période en cours (notamment pour les estimations de temps pr dossier closing)
                    MatterValueEntry_L.SetRange("Document Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterValueEntry_L.SetRange("Matter Ledg. Entry Type", MatterValueEntry_L."Matter Ledg. Entry Type"::Sales);
                    MatterValueEntry_L.SetRange("Matter Entry Type", MatterValueEntry_L."Matter Entry Type"::Expense, MatterValueEntry_L."Matter Entry Type"::"External Expense");
                    if MatterValueEntry_L.FindSet() then
                        repeat
                            case MatterValueEntry_L."Document Type" of
                                MatterValueEntry_L."Document Type"::"Credit Memo":
                                    begin
                                        SalesCrMemoLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesCrMemoLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesCrMemoLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesCrMemoLine_L.FindFirst();
                                        if SalesCrMemoLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;

                                MatterValueEntry_L."Document Type"::Invoice:
                                    begin
                                        SalesInvoiceLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesInvoiceLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesInvoiceLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesInvoiceLine_L.FindFirst();
                                        if SalesInvoiceLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;
                            end;
                        until MatterValueEntry_L.Next() = 0;

                    // Gestion Provision
                    ProvisionAmt := 0;
                    MatterPrepaymentEntry.Reset();
                    MatterPrepaymentEntry.SetRange("Matter No.", "No.");
                    MatterPrepaymentEntry.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterPrepaymentEntry.SetRange("Entry Type", MatterPrepaymentEntry."Entry Type"::Service);
                    if MatterPrepaymentEntry.FindSet() then
                        repeat
                            ProvisionAmt += MatterPrepaymentEntry."Amount (LCY)";
                        until MatterPrepaymentEntry.Next() = 0;

                    if (SalesActualMatterAmt + ExpenseAsFeesAmt + ProvisionAmt) = 0 then
                        CurrReport.Skip();

                end;
            }

            dataitem(Matter_Contribution; "SBX Matter Header")
            {
                //DataItemLink = "Partner No." = field("No.");
                DataItemTableView = sorting("Partner No.") where("Matter Type" = const(Chargeable));
                CalcFields = "Sales Amount (Actual) (LCY)";

                column(MatterNo_Conttribution; "Matter No.")
                { }
                column(MatterName_Contribution; Name)
                { }
                column(SellToName_Contribution; "Sell-to Name")
                { }
                column(MatterPartner_Contribution; "Partner No.")
                { }
                column(MatterSourceLawyer_Contribution; OringinatingLawyer)
                { }

                column(MaxContributionAmt_Contribution; MaxContributionAmt)
                { }
                column(MinContributionAmt_Contribution; MinContributionAmt)
                { }

                // column(GrossFeesQty_Contribution; MatterGrossFessQty)
                // { }
                column(SalesAmountActual_Contribution; "Sales Amount (Actual) (LCY)" + ExpenseAsFeesAmt + ProvisionAmt)
                { }
                // column(PartnerGrossFeesQty_Contribution; decQty_g)
                // { }
                column(PartnerSalesActualAmt_Contribution; decAmt_g)
                { }


                trigger OnPreDataItem()
                begin
                    Matter_Contribution.SetFilter("Partner No.", '<>%1', Resource."No.");

                    Matter_Contribution.SetRange("Non Billable Filter", false);
                    Matter_Contribution.SetRange("Planning Date Filter", 0D, DateEndingPeriod_g);
                    Matter_Contribution.SetRange("Document Date Filter", DateStartingPeriod_g, DateEndingPeriod_g);
                    Matter_Contribution.SetFilter("Matter Entry Type Filter", '%1|%2', "SBX Matter Header"."Matter Entry Type Filter"::Service, "SBX Matter Header"."Matter Entry Type Filter"::Adjustment);
                end;

                trigger OnAfterGetRecord()
                var
                    MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                    InternalOriginating_L: Record "SBX Internal Originating";
                    MatterValueEntry_L: Record "SBX Matter Value Entry";
                    SalesCrMemoLine_L: Record "Sales Cr.Memo Line";
                    SalesInvoiceLine_L: Record "Sales Invoice Line";

                begin
                    InternalOriginating_L.SetRange(Type, InternalOriginating_L.Type::Matter);
                    InternalOriginating_L.SetRange("No.", Matter_Contribution."Matter No.");
                    InternalOriginating_L.SetRange("Resource No.", Resource."No.");
                    InternalOriginating_L.SetFilter(Percentage, '<>0');
                    if not InternalOriginating_L.IsEmpty then
                        CurrReport.Skip();


                    // Gestion Provision
                    ProvisionAmt := 0;
                    MatterPrepaymentEntry.Reset();
                    MatterPrepaymentEntry.SetRange("Matter No.", "Matter No.");
                    MatterPrepaymentEntry.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterPrepaymentEntry.SetRange("Entry Type", MatterPrepaymentEntry."Entry Type"::Service);
                    if MatterPrepaymentEntry.FindSet() then
                        repeat
                            ProvisionAmt += MatterPrepaymentEntry."Amount (LCY)";
                        until MatterPrepaymentEntry.Next() = 0;

                    // Il faudrait déplacer le code ci dessous après calcul des Frais facturé en hono...
                    if ("Sales Amount (Actual) (LCY)" + ProvisionAmt) = 0 then
                        CurrReport.Skip();


                    // // Calcul Montant production Associé 
                    // MatterGrossFessQty := 0;
                    Clear(decAmt_g);
                    MaxContributionAmt := 0;
                    MinContributionAmt := 0;
                    MatterLedgerEntry_L.Reset();
                    MatterLedgerEntry_L.SetCurrentKey("Matter Entry Type", "Matter No.", Status, Type, "No.");
                    MatterLedgerEntry_L.SetRange("Matter Entry Type", MatterLedgerEntry_L."Matter Entry Type"::Service);
                    MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                    MatterLedgerEntry_L.SetRange(Type, MatterLedgerEntry_L.Type::Resource);
                    MatterLedgerEntry_L.SetRange("No.", Resource."No.");
                    MatterLedgerEntry_L.SetRange("Planning Date", 0D, DateEndingPeriod_g);
                    MatterLedgerEntry_L.SetRange("Non Billable", false);
                    MatterLedgerEntry_L.SetRange("Write Off", false);
                    MatterLedgerEntry_L.SetRange("Date Filter", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Actual) (LCY)");
                    if MatterLedgerEntry_L.FindSet() then
                        repeat
                            decAmt_g += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)";
                        until MatterLedgerEntry_L.Next() = 0;

                    if decAmt_g = 0 then
                        CurrReport.Skip();

                    // Ajout des frais facturés en hono au CA
                    ExpenseAsFeesAmt := 0;
                    MatterValueEntry_L.Reset();
                    MatterValueEntry_L.SetRange("Matter No.", "Matter No.");
                    MatterValueEntry_L.SetRange("Posting Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    //MatterValueEntry_L.SetRange("Planning Date", 0D, DateEndingPeriod_g); // remettre condition si temps estimé sont ajoutés sur la période en cours (notamment pour les estimations de temps pr dossier closing)
                    MatterValueEntry_L.SetRange("Document Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    MatterValueEntry_L.SetRange("Matter Ledg. Entry Type", MatterValueEntry_L."Matter Ledg. Entry Type"::Sales);
                    MatterValueEntry_L.SetRange("Matter Entry Type", MatterValueEntry_L."Matter Entry Type"::Expense, MatterValueEntry_L."Matter Entry Type"::"External Expense");
                    if MatterValueEntry_L.FindSet() then
                        repeat
                            // Vérifier Calcul Frais transformés en hono                                    
                            case MatterValueEntry_L."Document Type" of
                                MatterValueEntry_L."Document Type"::"Credit Memo":
                                    begin
                                        SalesCrMemoLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesCrMemoLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesCrMemoLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesCrMemoLine_L.FindFirst();
                                        if SalesCrMemoLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;

                                MatterValueEntry_L."Document Type"::Invoice:
                                    begin
                                        SalesInvoiceLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                        SalesInvoiceLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                        SalesInvoiceLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        SalesInvoiceLine_L.FindFirst();
                                        if SalesInvoiceLine_L."SBX Cost Switch Service" then
                                            ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;
                            end;
                        until MatterValueEntry_L.Next() = 0;


                    // Calcul montant contribution ==> sur CA !!!!!
                    // if MatterGrossFessQty <> 0 then begin
                    //     if decQty_g / MatterGrossFessQty * 100 > ContributionRate then
                    //         MaxContributionAmt := "Sales Amount (Actual) (LCY)" + ExpenseAsFeesAmt
                    //     else
                    //         MinContributionAmt := decAmt_g;
                    // end;

                    if ("Sales Amount (Actual) (LCY)" + ProvisionAmt + ExpenseAsFeesAmt) <> 0 then begin
                        if decAmt_g / ("Sales Amount (Actual) (LCY)" + ProvisionAmt + ExpenseAsFeesAmt) * 100 > ContributionRate then
                            MaxContributionAmt := "Sales Amount (Actual) (LCY)" + ExpenseAsFeesAmt
                        else
                            MinContributionAmt := decAmt_g;
                    end;


                    // Origine du dossier
                    OringinatingLawyer := '';
                    InternalOriginating_L.Reset();
                    InternalOriginating_L.SetRange(Type, InternalOriginating_L.Type::Matter);
                    InternalOriginating_L.SetRange("No.", "Matter No.");
                    InternalOriginating_L.SetFilter(Percentage, '>0');
                    IF InternalOriginating_L.FindSet() then
                        repeat
                            OringinatingLawyer += InternalOriginating_L."Resource No." + '_';
                        until InternalOriginating_L.Next() = 0;

                    OringinatingLawyer := DelChr(OringinatingLawyer, '>', '_');
                end;
            }


            trigger OnAfterGetRecord()
            var
                DefaultDim_L: Record "Default Dimension";
                DimensionValue_L: Record "Dimension Value";

            begin
                Clear(CodeDpmtAnalytics_g);
                Clear(NameDpmtAnalytics);
                if Resource."SBX Termination Date" <> 0D then
                    if Resource."SBX Termination Date" < DateStartingPeriod_g then
                        CurrReport.Skip;

                if Resource."Employment Date" <> 0D then
                    if Resource."Employment Date" > DateEndingPeriod_g then
                        CurrReport.Skip;

                DefaultDim_L.SetRange("Table ID", Database::Resource);
                DefaultDim_L.SetRange("Dimension Code", MatterSetup."Dept Dimension Code");
                DefaultDim_L.SetRange("No.", "No.");
                if DefaultDim_L.FindFirst then begin
                    DimensionValue_L.Get(MatterSetup."Dept Dimension Code", DefaultDim_L."Dimension Value Code");
                    CodeDpmtAnalytics_g := DefaultDim_L."Dimension Value Code";
                    NameDpmtAnalytics := DimensionValue_L.Name;
                end;
            end;
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(content)
            {
                group(MandatoryInfoGrp)
                {
                    Caption = 'Option';

                    field(" DateStartingPeriod_g"; DateStartingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            if DateStartingPeriod_g = 0D then
                                Error(Missing_Date);
                        end;
                    }
                    field(DateEndingPeriod_g; DateEndingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if DateEndingPeriod_g = 0D then
                                Error(Missing_Date);
                        end;
                    }

                    field(SalesAccrualsPercent; SalesAccrualsPercent)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Sales Accruals % withheld', Comment = 'FRA="% FAE retenu"';
                    }
                    field(ContributionRate; ContributionRate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Limit Contribution %', Comment = 'FRA="Seuil contribution CA"';
                    }

                    field(DisplayDetails; DisplayDetails)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display details by matter', Comment = 'FRA="Afficher détails par dossier"';
                    }
                }
            }
        }

    }

    labels
    {
        ReportTitle = 'Gross Fees Follow-Up - Withheld Turn Over Overview', Comment = 'FRA = "Suivi de la production - récap. CA retenu"';
        PageCaption = 'Page';
        Period = 'Period:';
        FilterCaption = 'Filter:';
        DpmtCaption = 'Department';
        Total = 'Total';
        PartnerLbl = 'Partner', Comment = 'FRA = Responsable';
        SourceLbl = 'Origin', Comment = 'FRA = Origine';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;

        LowerContributionLbl = 'Contribution <', Comment = 'FRA="Contribution <"';
        UpperContributionLbl = 'Contribution >', Comment = 'FRA="Contribution >"';
        GrossFeesPartnerLbl = 'Partner Gross Fees Turn Over', comment = 'FRA="CA Produit"';
        GrossFeesMatterLbl = 'Matter Gross Fees Turn Over', Comment = 'FRA="CA Dossiers"';
        WithHeldGrossFeesLbl = 'WithHeld Gross Fees', comment = 'FRA="Production retenue"';
        GrossFeesLbl = 'Gross Fees', Comment = 'FRA = "Honoraires"';
        WithheldPercentLbl = 'Withheld %', Comment = 'FRA = "% retenu"';
        WithheldAmtLbl = 'Withheld Accruals', Comment = 'FRA = "FAE retenues"';
        TurnOverWithheldLbl = 'Withheld Turn Over', Comment = 'FRA = "CA retenu"';

    }


    trigger OnInitReport()
    begin
        MatterSetup.Get();
        ContributionRate := MatterSetup."Contribution Rate";

        DGFLASetup.Get();
        SalesAccrualsPercent := DGFLASetup."Sales Accruals % retained";

        // // Hack pour la période du POC
        // DateStartingPeriod_g := CalcDate('<-CY>', 20210920D);
        // DateEndingPeriod_g := CalcDate('<CY>', 20211017D);
    end;

    trigger OnPreReport()
    begin
        if (DateStartingPeriod_g = 0D) or (DateEndingPeriod_g = 0D) then
            Error(Missing_Date);
    end;

    var
        MatterSetup: Record "SBX Matter Setup";
        DGFLASetup: Record "DGF Setup";
        ResourceGroup: Record "Resource Group";
        MatterPrepaymentEntry: Record "SBX Matter Prepayment Entry";
        DateEndingPeriod_g, DateStartingPeriod_g : Date;
        decQty_g, decAmt_g, GrossFeesAccrualsAmt, ExpenseAccrualsAmt, SalesActualMatterAmt, MatterGrossFessQty, ExpenseAsFeesAmt : Decimal;
        ContributionRate, MaxContributionAmt, MinContributionAmt : Decimal;
        ProvisionAmt: Decimal;
        SalesAccrualsPercent: Integer;
        DisplayDetails: Boolean;
        Missing_Date: Label 'Start and end dates are mandatory.', Comment = 'FRA = Les dates de début et de fin sont obligatoires.';
        CodeDpmtAnalytics_g: Text[30];
        NameDpmtAnalytics: Text[50];
        txtFilter_g: Text;
        OringinatingLawyer: Code[20];
        MatterName: Text;
        MatterPartnerNo: Code[20];
        SellToName: Text;
}

