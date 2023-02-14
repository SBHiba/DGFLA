tableextension 50007 "DGF Resource" extends Resource
{
    fields
    {
        field(50000; "DGF Seniority"; Integer)
        {
            Caption = 'Seniority', Comment = 'Ancienneté';
            DataClassification = CustomerContent;
        }

        field(50001; "DGF Division"; Code[1])
        {
            Caption = 'Division', Comment = 'Pôle';
            DataClassification = CustomerContent;
        }

    }
}
