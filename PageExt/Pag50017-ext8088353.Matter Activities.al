pageextension 50017 "DGF Matter Activites" extends "SBX Matter Activities"
{
    layout
    {

        addbefore("Customers - Blocked")
        {
            field("DGF Cust. Prospect Status"; Rec."DGF Cust. Prospect Status")
            {
                // Caption = 'Customers Blocked';
                ApplicationArea = SBXSBlawyer;
                DrillDownPageId = "Customer List";
            }
            field("DGF My Customers"; Rec."DGF My Customers")
            {
                // Caption = 'Customers Blocked';
                ApplicationArea = SBXSBlawyer;
                DrillDownPageId = "Customer List";
            }

        }
        addfirst(MatterMgtGrp)
        {
            field("DGF Matter Creation Step"; Rec."DGF Matter Creation Step")
            {
                ApplicationArea = SBXSBlawyer;
                DrillDownPageId = "SBX Matters List";
            }
            field("DGF Matter Prospection Step"; Rec."DGF Matter Prospection Step")
            {
                ApplicationArea = SBXSBlawyer;
                DrillDownPageId = "SBX Matters List";
            }
        }

        modify("Matters Count - Creation")
        { Visible = false; }

        modify("Matters Count - Waiting App")
        { Visible = false; }

        modify("Matters Count - App Refused")
        { Visible = false; }

        modify(COnflictCheckMgtGrp) // Cue Group
        { Visible = false; }
    }
}
