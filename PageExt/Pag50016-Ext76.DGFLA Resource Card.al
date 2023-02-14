pageextension 50016 "DGFLA Resource Card" extends "Resource Card"
{
    layout
    {
        addlast("SBX SBL TimekeeperGrp")
        {
            field("DGFLA Division"; Rec."DGFLA Division")
            {
                ApplicationArea = All;
            }
            field("DGFLA Seniority"; Rec."DGFLA Seniority")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(reporting)
        {
            action(RunRepDetForecastView_DGFLA)
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
