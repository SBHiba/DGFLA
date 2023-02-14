report 50003 "DGF Time converted Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50003-Time converted Summary.rdlc';

    ApplicationArea = SBXSBLawyer;
    Caption = 'Time converted Summary', Comment = 'FRA = Récapitulatif des heures transformées';
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;
    dataset
    {
        dataitem(MainLoop; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(ReportFilter; txtFilter_g)
            { }
            column(StartDate; DateStartingPeriod_g)
            { }
            column(EndDate; DateEndingPeriod_g)
            { }
            column(DisplayTimeConverted; DisplayTimeConverted)
            { }
            column(DisplayExpenseConverted; DisplayExpenseConverted)
            { }

            dataitem(SBXMatterLedgerEntryService; "SBX Matter Ledger Entry")
            {
                DataItemTableView = sorting("Matter Entry Type", "Matter No.", Type, "No.", "Write Off") where("Matter Entry Type" = const(Service), "Write Off" = const(false), Status = filter(Closed), "Closed by Ledger Entry No." = const(0), "Non Billable" = const(false));
                CalcFields = "Invoiced Quantity", "Sales Amount (Actual) (LCY)";
                RequestFilterFields = "Matter No.", "Sell-to Customer No.";
                RequestFilterHeading = 'Trainee''s fees converted', Comment = 'FRA = Honoraires Stagiaire transf.';


                column(MatterNo; "Matter No.")
                { }
                column(ClosedQuantity; "Closed Quantity")
                { }
                column(ReferenceAmount; "Reference Amount")
                { }
                column(SalesAmountActualLCY; "Sales Amount (Actual) (LCY)")
                { }
                column(InvoicedQuantity; "Invoiced Quantity")
                { }

                dataitem(MatterHeader; "SBX Matter Header")
                {
                    DataItemTableView = sorting("Matter No.");
                    DataItemLink = "Matter No." = field("Matter No.");

                    column(Matter_Name; Name)
                    { }
                    column(Sell_to_Name; "Sell-to Name")
                    { }
                }

                trigger OnPreDataItem()
                begin
                    if not DisplayTimeConverted then
                        CurrReport.Break();

                    SetRange("Planning Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    if ResGrpFilter <> '' then
                        SetFilter("Resource Group No.", ResGrpFilter);
                end;

                trigger OnAfterGetRecord()
                begin
                end;
            }
            dataitem(SBXMatterLedgerEntryExpense; "SBX Matter Ledger Entry")
            {
                DataItemTableView = sorting("Matter Entry Type", "Matter No.", Type, "No.", "Write Off") where("Write Off" = const(false), Status = filter(Closed), "Closed by Ledger Entry No." = const(0), "Non Billable" = const(false));
                CalcFields = "Invoiced Quantity", "Sales Amount (Actual) (LCY)";
                RequestFilterFields = "Matter No.", "Sell-to Customer No.";
                RequestFilterHeading = 'Expenses converted', Comment = 'FRA = Frais transf.';

                column(MatterNo_Expense; "Matter No.")
                { }
                column(ClosedQuantity_Expense; "Closed Quantity")
                { }
                column(ReferenceAmount_Expense; "Reference Amount")
                { }
                column(SalesAmountActualLCY_Expense; "Sales Amount (Actual) (LCY)")
                { }
                column(InvoicedQuantity_Expense; "Invoiced Quantity")
                { }

                dataitem(MatterHeaderExp; "SBX Matter Header")
                {
                    DataItemTableView = sorting("Matter No.");
                    DataItemLink = "Matter No." = field("Matter No.");

                    column(Matter_Name_Exp; Name)
                    { }
                    column(Sell_to_Name_Exp; "Sell-to Name")
                    { }
                }


                trigger OnPreDataItem()
                begin
                    if not DisplayExpenseConverted then
                        CurrReport.Break();

                    SetRange("Matter Entry Type", "Matter Entry Type"::Expense, "Matter Entry Type"::"External Expense");
                    SetRange("Planning Date", DateStartingPeriod_g, DateEndingPeriod_g);
                end;

                trigger OnAfterGetRecord()
                var
                    MatterValueEntry_L: Record "SBX Matter Value Entry";
                    SalesInvoiceLine_L: Record "Sales Invoice Line";
                begin
                    // récupérer la facture (écriture valeur dossier) pour déterminer si coché passer en honoraires
                    // MatterValueEntry_L.SetCurrentKey("Matter ledger Entry No.", "Matter Ledg. Entry Type", "Entry Sub Type"); !?
                    MatterValueEntry_L.SetRange("Matter ledger Entry No.", "Entry No.");
                    MatterValueEntry_L.SetRange("Matter Ledg. Entry Type", MatterValueEntry_L."Matter Ledg. Entry Type"::Sales);
                    MatterValueEntry_L.SetRange("Entry Sub Type", MatterValueEntry_L."Entry Sub Type"::" ");
                    if MatterValueEntry_L.FindLast() then begin
                        SalesInvoiceLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                        SalesInvoiceLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                        SalesInvoiceLine_L.SetRange("SBX Matter Ledger Entry No.", "Entry No.");
                        SalesInvoiceLine_L.FindFirst();
                        if not SalesInvoiceLine_L."SBX Cost Switch Service" then
                            CurrReport.Skip();
                    end else
                        CurrReport.Skip();

                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(OptionGroupName)
                {
                    Caption = 'Option', Comment = 'FRA = Option';

                    field(oDisplayCalendar; oDisplayCalendar_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display Period';
                        OptionCaption = 'Day,Week,Month,Quarter,Year', Comment = 'FRA = Jour,Semaine,Mois,Trimestre,Année';
                        Enabled = false;
                        Visible = false;
                    }
                    field(DateStartingPeriod; DateStartingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date', Comment = 'FRA = Date début';

                        trigger OnValidate()
                        begin
                            if DateStartingPeriod_g = 0D then
                                Error(Missing_Date);
                        end;
                    }
                    field(DateEndingPeriod_g; DateEndingPeriod_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Ending Date', Comment = 'FRA = Date fin';

                        trigger OnValidate()
                        begin
                            if DateEndingPeriod_g = 0D then
                                Error(Missing_Date);
                        end;
                    }

                    field(ResGrpFilter; ResGrpFilter)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Resource Group Filter', Comment = 'FRA = Filtre Groupe ressource';
                        TableRelation = "Resource Group"."No.";
                        ShowMandatory = true;
                        Visible = false;

                        trigger OnValidate()
                        begin
                            if ResGrpFilter = '' then
                                Error(ErrGrpRes);
                        end;
                    }

                    field(DisplayTimeConverted; DisplayTimeConverted)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display time converted', Comment = 'FRA = Afficher les heures transformées';
                    }

                    field(DisplayExpenseConverted; DisplayExpenseConverted)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display Expenses converted', Comment = 'FRA = Afficher les frais transformés';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

        trigger OnInit()
        begin
            oDisplayCalendar_g := oDisplayCalendar_g::Week;
            ResGrpFilter := 'STAGIAIRE|ASSISTANT';
            DisplayTimeConverted := true;
            DisplayExpenseConverted := true;

            // Hack POC 
            DateStartingPeriod_g := 20210901D;
            DateEndingPeriod_g := 20211130D;
        end;
    }

    labels
    {
        ReportTitle = 'Time converted Summary', Comment = 'Récapitulatif des heures transformées';
        PageCaption = 'Page', Comment = 'FRA = Page';
        Period = 'Period:', Comment = 'FRA = Période :';
        FilterCaption = 'Filter:', Comment = 'FRA = Filtre :';
        WeekCaption = 'Week', Comment = 'FRA = Semaine';
        Total = 'Total';
        ProducedLbl = 'Produced', comment = 'FRA = Réalisé';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;
    }

    trigger OnPreReport()
    begin
        if (DateStartingPeriod_g = 0D) or (DateEndingPeriod_g = 0D) then
            Error(Missing_Date);

        txtFilter_g := SBXMatterLedgerEntryService.GetFilters;
        if txtFilter_g <> '' then
            txtFilter_g += ' | ' + SBXMatterLedgerEntryExpense.GetFilters;
    end;


    var
        DisplayTimeConverted, DisplayExpenseConverted : Boolean;
        DateStartingPeriod_g, DateEndingPeriod_g : Date;
        oDisplayCalendar_g: Option Day,Week,Month,Quarter,Year;
        ResGrpFilter: Code[250];
        txtFilter_g: Text;
        Missing_Date: Label 'Start and end dates are mandatory.', Comment = 'Les dates de début et de fin sont obligatoires.';
        ErrGrpRes: Label 'This field cannot be empty', Comment = 'Ce champ ne peut pas être vide';

}
