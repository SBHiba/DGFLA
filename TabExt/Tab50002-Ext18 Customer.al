tableextension 50002 "DGF Customer" extends Customer
{
    fields
    {
        field(50000; Status; Option)
        {
            OptionMembers = Prospect,Actif,Inactif;
            OptionCaption = 'Lead,Active,Inactive', Comment = 'FRA = Prospect,Actif,Inactif';
            Editable = true;
        }
        field(50001; Confidential; Boolean)
        {
            Caption = 'Confidential', Comment = 'FRA = Confidentiel';
        }
        field(50002; "Account Manager"; Code[20])
        {
            Caption = 'Resp. Admin. Client et CAC';
            TableRelation = Resource."No.";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(DGFKey1; Status)
        { }
        key(DGFKey2; "Account Manager")
        { }
    }
}
