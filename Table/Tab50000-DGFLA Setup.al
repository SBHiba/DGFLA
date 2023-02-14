table 50000 "DGF Setup"
{
    Caption = 'DGFLA Setup', comment = 'FRA = Paramètres DGFLA';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(20; "Yearly Capacity (Qty)"; Decimal)
        {
            Caption = 'Yearly Capacity (Qty)', Comment = 'FRA = Capacité annuelle (qté)';
            InitValue = 1800;
        }
        field(21; "Weekly Capacity (Qty)"; Decimal)
        {
            Caption = 'Weekly Capacity (Qty)', Comment = 'FRA = Capacité hebdomadaire (qté)';
            InitValue = 40;
        }

        field(22; "Weekly Profit. Threshold (Qty)"; Decimal)
        {
            Caption = 'Weekly Profitability Threshold (Qty)', Comment = 'FRA = Seuil rentabilité hebdomadaire (qté)';
            InitValue = 10;
        }
        field(23; "Yearly Base (Qty)"; Decimal)
        {
            Caption = 'Yearly Base (Qty)', Comment = 'FRA = Base annuelle (qté)';
            InitValue = 1400;
        }
        field(24; "Weekly Base (Qty)"; Decimal)
        {
            Caption = 'Weekly Base (Qty)', Comment = 'FRA = Base hebdomadaire (qté)';
            InitValue = 27;
        }

        field(30; "Sales Accruals % retained"; Integer)
        {
            Caption = 'Sales Accruals % retained', Comment = 'FRA = % Retenu FAE';
            MinValue = 0;
            MaxValue = 100;
            InitValue = 50;
        }

        field(50; "Seizure day allowed for proc."; enum "DGF Days List")
        {
            Caption = 'Seizure day allowed for procedure', Comment = 'FRA = Jour limite procédure';
        }

        field(51; "Time Entry allowed for proc."; Time)
        {
            Caption = 'Time Entry allowed for procedure', Comment = 'FRA = Heure limite procédure';
        }
        field(52; "Enable out of proc. Mgt"; Boolean)
        {
            Caption = 'Enable out of procedure Mgt', Comment = 'FRA = Activer gestion du hors proédure';
        }
        //>>Reminder Mail : Dillig #22Github - Hiba 06/02/23
        field(53; "Diligence Reminder Mail Perid"; DateFormula)
        {
            Caption = 'Diligence Reminder Mail Perid', Comment = 'FRA = Période de relance pour saisie de diligence';
        }
        //<<Reminder Mail : Dillig #22Github - Hiba 06/02/23
        //>>Double Approval Github #26 #27 - Hiba 13/02

        field(54; "Double Approval"; Boolean)
        {
            Caption = 'Double Approval';
            trigger OnValidate()
            var
                ExpenseSetup: Record "SBX Expense Setup";
            begin
                ExpenseSetup.Get();
                ExpenseSetup.TestField("SBX Approval by Matter Partner");
            end;
        }
        field(55; "Approver Type"; Enum "Workflow Approver Type")
        {
            ValuesAllowed = 1, 2;
            Caption = 'Approver Type';
        }
        field(56; "Approver"; Code[50])
        {
            Caption = 'Approver';
            DataClassification = CustomerContent;
            TableRelation = if ("Approver Type" = const(Approver)) "User Setup"."User ID"
            else
            "Workflow User Group".Code;
        }
        //<<Double Approval Github #26 #27 - Hiba 13/02

    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
