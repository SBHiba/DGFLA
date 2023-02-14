tableextension 50006 "Cust. Ledger Entries" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "DGFLA Sell-to Name"; Text[100])
        {
            Caption = 'Sell-to Name', comment = 'FRA = Client donneur d''ordre';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Editable = false;
        }

    }
}
