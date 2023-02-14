tableextension 50008 "DGF Matter Ledger Entry" extends "SBX Matter Ledger Entry"
{
    fields
    {
        field(50000; "DGF Out of Procedure"; Boolean)
        {
            Caption = 'Out of Procedure', Comment = 'FRA = Hors procédure';
            DataClassification = CustomerContent;
        }

    }

}