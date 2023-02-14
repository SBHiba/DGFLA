pageextension 50001 "DGF Comment Sheet" extends "Comment Sheet"
{
    layout
    {
        modify(Code)
        {
            Visible = true;
            Enabled = EnableProperty;
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Table Name" = Rec."Table Name"::Resource then
            EnableProperty := true;
    end;

    var
        EnableProperty: Boolean;
}
