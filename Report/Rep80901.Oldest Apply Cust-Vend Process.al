report 80901 "DGFLA Oldest Apply Cust - Vend"
{
    Caption = 'Oldest Apply Cust - Vend';
    Permissions = TableData "Cust. Ledger Entry" = RM,
                  TableData "Vendor Ledger Entry" = RM,
                  TableData "Detailed Cust. Ledg. Entry" = RM,
                  TableData "Detailed Vendor Ledg. Entry" = RM;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    ApplicationArea = All;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Customer; Customer)
        {
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(false));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Customer) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;
                end;

                trigger OnAfterGetRecord()
                begin
                    cuOldApply_g.CustApplyOldestEntries("Cust. Ledger Entry", 0, bExcludeOldestDate);
                end;
            }

            dataitem(OldestApply; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(false));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Customer) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;

                    OldestApply.SetView("Cust. Ledger Entry".GetView);
                end;

                trigger OnAfterGetRecord()
                begin

                    cuOldApply_g.CustApplyOldestEntries(OldestApply, 1, bExcludeOldestDate);
                end;
            }

            dataitem(FinalCustSameAmount; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(false));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Customer) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;

                    FinalCustSameAmount.SetView("Cust. Ledger Entry".GetView);
                end;

                trigger OnAfterGetRecord()
                begin
                    cuOldApply_g.CustApplyOldestEntries("Cust. Ledger Entry", 0, bExcludeOldestDate);
                end;
            }

            trigger OnPreDataItem()
            begin
                if (optPayment_g <> optPayment_g::Customer) and (optPayment_g <> optPayment_g::Both) then
                    CurrReport.Break;
                Customer.SetAutoCalcFields("Balance (LCY)");
            end;

            trigger OnAfterGetRecord()
            begin
                if bBalanceLCY then begin
                    if "Balance (LCY)" <> 0 then
                        CurrReport.Skip;
                end;
            end;
        }

        dataitem(Vendor; Vendor)
        {
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(true));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Vendor) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;
                end;

                trigger OnAfterGetRecord()
                begin
                    cuOldApply_g.VendApplyOldestEntries("Vendor Ledger Entry", 0, bExcludeOldestDate);
                end;
            }

            dataitem(OldestApplyVendor; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(true));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Vendor) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;

                    OldestApplyVendor.SetView("Vendor Ledger Entry".GetView);
                end;

                trigger OnAfterGetRecord()
                begin
                    cuOldApply_g.VendApplyOldestEntries(OldestApplyVendor, 1, bExcludeOldestDate);
                end;
            }

            dataitem(FinalVendorSameAmount; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Currency Code", "Posting Date") WHERE(Open = CONST(true), Positive = CONST(true));

                trigger OnPreDataItem()
                begin
                    if (optPayment_g <> optPayment_g::Vendor) and (optPayment_g <> optPayment_g::Both) then
                        CurrReport.Break;

                    OldestApplyVendor.SetView("Vendor Ledger Entry".GetView);
                end;

                trigger OnAfterGetRecord()
                begin
                    cuOldApply_g.VendApplyOldestEntries("Vendor Ledger Entry", 0, bExcludeOldestDate);
                end;
            }

            trigger OnPreDataItem()
            begin
                if (optPayment_g <> optPayment_g::Vendor) and (optPayment_g <> optPayment_g::Both) then
                    CurrReport.Break;

                Vendor.SetAutoCalcFields("Balance (LCY)");
            end;

            trigger OnAfterGetRecord()
            begin
                if bBalanceLCY then begin
                    if "Balance (LCY)" <> 0 then
                        CurrReport.Skip;
                end;
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                field(fieldoptPayment_g; optPayment_g)
                {
                    Caption = 'Treatment To', Comment = 'FRA=Traitement Pour';
                    OptionCaption = ' ,Customer,Vendor,Both', Comment = 'FRA= ,Client,Fournisseur,Les deux';
                    ApplicationArea = All;
                }

                field(bBalanceLCY; bBalanceLCY)
                {
                    Caption = 'Exclude if Balance <> 0';
                    ApplicationArea = All;
                }

                field(bExcludeOldestDate; bExcludeOldestDate)
                {
                    Caption = 'Exclude Filter Oldest Date';
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnPreReport()
    begin
        optPayment_g := optPayment_g::Both;
    end;

    var
        optPayment_g: Option " ",Customer,Vendor,Both;
        cuOldApply_g: Codeunit "DGFLA Oldest Apply Cust - Vend";
        bBalanceLCY, bExcludeOldestDate : Boolean;
}

