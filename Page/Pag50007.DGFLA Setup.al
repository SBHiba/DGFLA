page 50007 "DGF Setup"
{
    Caption = 'DGFLA Setup', Comment = 'fr-FR = Paramètres DGFLA';
    PageType = Card;
    SourceTable = "DGF Setup";
    ApplicationArea = SBXSBLawyer;
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'FRA = Général';
                field("Yearly Capacity (Qty)"; Rec."Yearly Capacity (Qty)")
                {
                    ToolTip = 'Specifies the value of the yealy capacity (Qty) field', Comment = 'FRA = Capacité annuelle (qté)';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Weekly Capacity (Qty)"; Rec."Weekly Capacity (Qty)")
                {
                    ToolTip = 'Specifies the value of the Weekly Capacity (Qty) field', Comment = 'FRA = Capacité hebdomadaire (qté)';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Yearly Base (Qty)"; Rec."Yearly Base (Qty)")
                {
                    ToolTip = 'Specifies the value of the yearly Base (Qty) field', Comment = 'FRA = Base annuelle (qté)';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Weekly Base (Qty)"; Rec."Weekly Base (Qty)")
                {
                    ToolTip = 'Specifies the value of the Weekly Base (Qty) field', Comment = 'FRA = Base hebdomadaire (qté)';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Weekly Profit. Threshold (Qty)"; Rec."Weekly Profit. Threshold (Qty)")
                {
                    ToolTip = 'Specifies the value of the Weekly Profitability Threshold (Qty) field', Comment = 'FRA = Seuil rentabilité hebdomadaire (qté)';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Diligence Reminder Mail Perid"; Rec."Diligence Reminder Mail Perid")
                {
                    ApplicationArea = All;

                }
            }
            group(FeesFollowUpGrp)
            {
                Caption = 'Follow up of the production', Comment = 'FRA = Suivi production';

                field("Sales Accruals % retained"; Rec."Sales Accruals % retained")
                {
                    ApplicationArea = SBXSBLawyer;
                }
            }
            //>>ouble Approval Github #26 #27 - Hiba 13/02

            field("Double approval"; Rec."Double approval")
            {
                ApplicationArea = All;
            }
            group(DoubleExpensePost)
            {
                ShowCaption = false;
                Visible = Rec."Double approval";
                field("Approver Type"; Rec."Approver Type")
                {
                    ApplicationArea = All;
                }
                field(Approver; Rec.Approver)
                {
                    ApplicationArea = All;
                }
            }
            //<<Double Approval Github #26 #27 - Hiba 13/02

            group(SBXProcedure)
            {
                Caption = 'Procedure';

                field("Activate out of proc. Mgt"; Rec."Enable out of proc. Mgt")
                {
                    ToolTip = 'Specifies if the out of procedure management is enabled', Comment = 'FRA=Indique si la gestion des hors procédure est active';
                    ApplicationArea = SBXSBLawyer;
                }

                field("Seizure day allowed for proc."; Rec."Seizure day allowed for proc.")
                {
                    ToolTip = 'Specifies the value of the Seizure day allowed for procedure field';
                    ApplicationArea = SBXSBLawyer;
                }
                field("Time Entry allowed for proc."; Rec."Time Entry allowed for proc.")
                {
                    ToolTip = 'Specifies the value of the Time Entry allowed for procedure field';
                    ApplicationArea = SBXSBLawyer;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}
