tableextension 50009 SBXExpenseLedgerEntryExt extends "SBX Expense Ledger Entry"
{
    fields
    {
        //>>Double Approval Github #26 #27 - Hiba 13/02

        field(50000; "Double Approval"; Boolean)
        {
            Caption = 'Double Approval';
        }
        //<<Double Approval Github #26 #27 - Hiba 13/02

    }

    keys
    {
    }

    fieldgroups
    {
    }

}
