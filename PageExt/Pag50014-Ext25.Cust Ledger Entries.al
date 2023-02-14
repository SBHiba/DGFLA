pageextension 50014 "Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("SBX Sell-to Customer No.")
        {
            field("DGFLA Sell-to Name"; Rec."DGFLA Sell-to Name")
            {
                Caption = 'Sell-to Cust. Name', comment = 'client donneur d''ordre';
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
