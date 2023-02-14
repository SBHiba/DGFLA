/* Comment 
Colour1 = '#0c3374'
Colour2 = '#5B9B3F'
Colour3 = '#E49F32'
FontColour1 = 'White'
FontColour2 = 'Black'
FontColour3 = 'DimGray'

end comment */

report 50010 "DGF Days Sales Outstanding"
{
    ApplicationArea = All;
    Caption = 'Days Sales Outstanding by Customer';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50010-Days Sales Outstanding.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;

            column(CompanyName; CompanyProperty.DisplayName())
            { }
            column(PeriodCaption; StrSubstNo(ReportPeriodLbl, StartingDate, EndingDate))
            { }
            column(StartBillingPeriod; StartingDate)
            { }
            column(EndBillingPeriod; EndingDate)
            { }
            column(ReportFilter; txtFilter)
            { }
            column(CustomerNo; "No.")
            { }
            column(Name_Customer; Name)
            {
                IncludeCaption = true;
            }
            column(SearchName_Customer; "Search Name")
            { }
            column(SBX_PSB_Group_Name; "SBX PSB Group Name")
            {
                IncludeCaption = true;
            }
            column(AccountManager_Customer; "DGF Account Manager")
            { }
            column(GenBusPostingGroup_Customer; "Gen. Bus. Posting Group")
            { }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                PrintOnlyIfDetail = true;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Document Type", "Customer No.", "Posting Date", "Currency Code") where("Document Type" = const(Invoice), Open = const(false));

                column(Document_Date; "Document Date")
                { }
                column(Document_No_; "Document No.")
                { }
                column(SBX_Matter_No_; "SBX Matter No.")
                { }
                column(SBX_Partner_No_; "SBX Partner No.")
                { }
                column(SBX_Responsible_No_; "SBX Responsible No.")
                { }

                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    PrintOnlyIfDetail = true;
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.", "Entry Type", "Posting Date") where("Entry Type" = const(Application), Unapplied = const(false));

                    dataitem(DetailedCustLedgEntryPayment; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Applied Cust. Ledger Entry No." = field("Applied Cust. Ledger Entry No.");
                        DataItemTableView = sorting("Applied Cust. Ledger Entry No.", "Entry Type") where("Entry Type" = const(Application), Unapplied = const(false));

                        column(PaymentDate; PaymentDate)
                        { }

                        column(PaymentDocumentNo; "SBX Initial Document No.")
                        { }
                        column(DSO; PaymentDate - "Cust. Ledger Entry"."Document Date")
                        { }


                        trigger OnPreDataItem()
                        begin
                            DetailedCustLedgEntryPayment.SetRange("Initial Document Type", DetailedCustLedgEntryPayment."Initial Document Type"::Payment);
                        end;

                        trigger OnAfterGetRecord()
                        var
                            CustLedgerEntry_L: Record "Cust. Ledger Entry";
                        begin
                            CustLedgerEntry_L.Get(DetailedCustLedgEntryPayment."Cust. Ledger Entry No.");
                            PaymentDate := CustLedgerEntry_L."Document Date";
                        end;
                    }
                }

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SetRange("Document Date", StartingDate, EndingDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "SBX PSB Group Name" = '' then
                    "SBX PSB Group Name" := "Search Name";
            end;
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(StartindDate; StartingDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date', Comment = 'FRA = Début période';

                        trigger OnValidate()
                        begin
                            if StartingDate = 0D then
                                ERROR(ERR_DateLbl);
                            EndingDate := CalcDate('<CY>', StartingDate);
                        end;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Ending Date', comment = 'FRA = Fin période';

                        trigger OnValidate()
                        begin
                            if EndingDate = 0D then
                                ERROR(ERR_DateLbl);
                        end;
                    }
                }
            }
        }

        trigger OnInit()
        begin
            if StartingDate = 0D then
                StartingDate := CalcDate('<-CY>', WorkDate());

            if EndingDate = 0D then
                EndingDate := CalcDate('<CM>', WorkDate());
        end;
    }


    labels
    {
        ReportTitle = 'Days Sales Outstanding', comment = 'FRA = Délai moyen de paiement';
        PageCaption = 'Page', Comment = 'FRA = Page';
        Period = 'Period:', comment = 'FRA = Période :';
        FilterCaption = 'Filter:', comment = 'FRA = Filtre :';

    }

    trigger OnPreReport()
    begin
        txtFilter := Customer.GetFilters;
    end;

    var
        EndingDate, StartingDate : Date;
        PaymentDate: Date;
        ERR_DateLbl: Label 'Vous devez sélectionner une période de calcul pour l''état.', Comment = 'FRA = Vous devez sélectionner une période de calcul pour l''état.';
        ReportPeriodLbl: Label 'Period: %1.. %2', Comment = 'FRA = Période : %1.. %2';
        txtFilter: Text;

}
