/*pageextension 50100 "DGF Admin Profile RC" extends "SBX Administrator Role Center"
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

        addafter(Control8088263) // Customer Balance Chart Account
        {
            part(NewCustomer; "DGF New Customers List")
            {
                Caption = 'Nouveaux Clients';
                ApplicationArea = SBXSBLawyer;
            }

            part(NewMatters; "DGF New Matters List")
            {
                Caption = 'Nouveaux Dossiers';
                ApplicationArea = SBXSBLawyer;
            }
        }


    }

    actions
    {
        addlast(reporting)
        {
            action(SBXTimeFollowUpReport)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Time Follow-up by resource';
                Image = "Report";
                // Promoted = true;
                // PromotedCategory = "Report";
                // PromotedIsBig = true;
                RunObject = Report "DGF Time Entries Follow-Up";
                Visible = true;
            }
            action(SBXBoniMaliListReport)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Boni/Mali';
                Image = "Report";
                RunObject = Report "DGF Boni-Mali List";
                Visible = true;
            }
        }


        // addlast(processing)
        // {
        //     action(SBXInitMyCust)
        //     {
        //         ApplicationArea = SBXSBLawyer;
        //         Caption = 'init. Mes clients par Associé';
        //         Image = Process;

        //         trigger OnAction()
        //         begin

        //         end;
        //     }
        // }
    }

}*/