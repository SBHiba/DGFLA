pageextension 50016 "DGF Resource Card" extends "Resource Card"
{
    layout
    {
        addlast("SBX SBL TimekeeperGrp")
        {
            field("DGF Division"; Rec."DGF Division")
            {
                ApplicationArea = All;
            }
            field("DGF Seniority"; Rec."DGF Seniority")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(reporting)
        {
            action(DGFRunRepDetForecastView_DGFLA)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Details Lawyer Forecast View';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    recRessouce_L: Record Resource;
                    repDGFLADetailsForecastView: Report "DGF Details Forecast View";
                begin
                    recRessouce_L.SetRange("No.", Rec."No.");
                    repDGFLADetailsForecastView.SetTableView(recRessouce_L);
                    repDGFLADetailsForecastView.Run();
                end;
            }
        }
    }
}
