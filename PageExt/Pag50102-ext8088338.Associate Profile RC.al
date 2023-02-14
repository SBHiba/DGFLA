pageextension 50102 "DGF Associate Profile RC" extends "SBX Associate Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(DGFPartnerFigures; "DGF Partner Activities")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }

        modify(UserTaskPart)
        { Visible = false; }

        addbefore(Control1000000025)
        {
            part(DGFNewCustomer; "DGF New Customers List")
            {
                Caption = 'Nouveaux Clients';
                ApplicationArea = SBXSBLawyer;
            }

            part(DGFNewMatters; "DGF New Matters List")
            {
                Caption = 'Nouveaux Dossiers';
                ApplicationArea = SBXSBLawyer;
            }
        }
    }

    actions
    {
        // Area Creation
        modify(TransSheetAction)
        { Visible = false; }


    }

}