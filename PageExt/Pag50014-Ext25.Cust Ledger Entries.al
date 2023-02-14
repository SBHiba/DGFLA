pageextension 50014 "DGF Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("SBX Sell-to Customer No.")
        {
            field("DGF Sell-to Name"; Rec."DGF Sell-to Name")
            {
                Caption = 'Sell-to Cust. Name', comment = 'client donneur d''ordre';
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
