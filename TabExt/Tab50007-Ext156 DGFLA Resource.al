tableextension 50007 "DGFLA Resource" extends Resource
{
    fields
    {
        field(50000; "DGFLA Seniority"; Integer)
        {
            Caption = 'Seniority', Comment = 'Ancienneté';
            DataClassification = CustomerContent;
        }

        field(50001; "DGFLA Division"; Code[1])
        {
            Caption = 'Division', Comment = 'Pôle';
            DataClassification = CustomerContent;
        }

    }
}
