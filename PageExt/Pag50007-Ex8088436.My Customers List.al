pageextension 50007 "DGF My Customers List" extends "SBX My Customers List"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("SBX PSB Group Name")
        {
            Visible = false;
        }
    }

    actions
    {
        addfirst(Navigation)
        {
            action(DGFRunCustEntries)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Ecritures client', Comment = 'Ecritures client';
                Image = CustomerLedger;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Sell-to Customer No." = field("Customer No."), "SBX Partner No." = field(filter("SBX Partner Filter"));
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
                PromotedIsBig = true;
                RunObject = Page "DGF Related Bill-to Addr.";
                RunPageLink = "Sell-to Customer No." = field("Customer No.");
                RunPageView = where("Matter No." = const(''));
                ShortCutKey = 'Alt+F';
                ToolTip = 'View or edit Bill-to Addresses for the customer.';
            }

        }
    }

    // trigger OnOpenPage()
    // var
    //     DGFManagement_L: Codeunit "DGF Management";
    //     PartnerFilter: Code[250];
    // begin
    //     PartnerFilter := DGFManagement_L.GetPartnerFilterByProfil();
    //     if PartnerFilter <> '' then begin
    //         Rec.FilterGroup(2);
    //         Rec.SetFilter("SBX Partner Filter", PartnerFilter);
    //         Rec.FilterGroup(0);
    //     end
    // end;
}