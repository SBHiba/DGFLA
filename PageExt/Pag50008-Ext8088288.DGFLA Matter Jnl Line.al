pageextension 50008 "DGF Matter Jnl Line" extends "SBX Matter Journal Lines"
{
    layout
    {
        addlast(Group)
        {
            field("DGF Procedure"; Rec."DGF Procedure")
            {
                ApplicationArea = Basic;
                Visible = bVisibleProcedure_g;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        recMatterSetup_L: Record "SBX Matter Setup";
        recUserSetup_L: Record "User Setup";
    begin
        recMatterSetup_L.Get();
        bVisibleProcedure_g := false;
        if recUserSetup_L.Get(UserId) then
            bVisibleProcedure_g := recUserSetup_L."Time Sheet Admin.";
    end;

    var
        bVisibleProcedure_g: Boolean;
}