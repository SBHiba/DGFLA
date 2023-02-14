tableextension 50004 "DGF Matter Journal Line" extends "SBX Matter Journal Line"
{
    fields
    {
        field(50000; "DGF Procedure"; Boolean)
        {
            Caption = 'Procedure';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recUserSetup_L: Record "User Setup";
            begin
                recUserSetup_L.Get(UserId);
                recUserSetup_L.testfield("Time Sheet Admin.", true);
            end;
        }

    }

}