pageextension 50003 "DGF Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Name 2")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Statut';
                ShowMandatory = true;
            }
            field(Confidential; Rec.Confidential)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Confidentiel';
            }
        }
        modify("Search Name")
        {
            Visible = true;
        }
        modify("IC Partner Code")
        {
            Visible = true;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
            ApplicationArea = SBXSBLSuite;
        }
        modify("Balance Due")
        {
            Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        addafter("Salesperson Code")
        {
            field("Account Manager"; Rec."Account Manager")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }
        modify(TotalSales2)
        {
            Visible = false;
            ApplicationArea = SBXSBLSuite;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Visible = false;
            ApplicationArea = SBXSBLSuite;
        }
        modify(AdjCustProfit)
        {
            Visible = false;
            ApplicationArea = SBXSBLSuite;
        }



        modify(Payments) // Tab
        {
            Visible = true;
        }

        modify("Payment Balance (LCY)")
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify("Payment in progress (LCY)")
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify("""Balance (LCY)"" - ""Payment in progress (LCY)""")
        {
            ApplicationArea = SBXSBLSuite;
        }

        // Group Statistics
        modify(Statistics)
        {
            Visible = true;
        }
        modify("Balance (LCY)2")
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(ExpectedCustMoneyOwed)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(TotalMoneyOwed)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(CalcCreditLimitLCYExpendedPct)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify("Payments (LCY)")
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify("CustomerMgt.AvgDaysToPay(""No."")")
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(DaysPaidPastDueDate)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(AmountOnPostedInvoices)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(AmountOnCrMemo)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(AmountOnOutstandingInvoices)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(AmountOnOutstandingCrMemos)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(Totals)
        {
            ApplicationArea = SBXSBLSuite;
        }
        modify(CustInvDiscAmountLCY)
        {
            ApplicationArea = SBXSBLSuite;
        }
        // modify(AgedAccReceivableChart)
        // {
        //     Visible = false;
        // }

        // Factbox
        modify(Control149) // Image du client
        {
            Visible = false;
        }



    }

    actions
    {
        addfirst("&Customer")
        {
            action(DGFRunCustEntries)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Ecritures client', Comment = 'Ecritures client';
                Image = CustomerLedger;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Sell-to Customer No." = field("No."), "SBX Partner No." = field("SBX Partner Filter");
                RunPageMode = View;
                RunPageView = sorting("Sell-to Customer No.", "Posting Date", "Currency Code");
                ShortCutKey = 'Alt+E';
                ToolTip = 'View the customer ledger entries.';
            }

            action(DGFRunBillToAddresses)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Adresses facturation', Comment = 'Adresses facturation';
                Image = SuggestCustomerBill;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                RunObject = Page "DGF Related Bill-to Addr.";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = where("Matter No." = const(''));
                ShortCutKey = 'Alt+F';
                ToolTip = 'View or edit Bill-to Addresses for the customer.';
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    var
        DGFManagement_L: Codeunit "DGF Management";
        PartnerFilter: Code[250];
    begin
        PartnerFilter := DGFManagement_L.GetPartnerFilterByProfil();
        if PartnerFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("SBX Partner Filter", PartnerFilter);
            Rec.FilterGroup(0);
        end
    end;
}