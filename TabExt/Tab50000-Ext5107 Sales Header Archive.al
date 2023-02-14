tableextension 50000 "DGF Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(8088262; "DGF Matter No."; Code[20])
        {
            Caption = 'Matter No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Header"."Matter No.";
            DataClassification = CustomerContent;
            AccessByPermission = Tabledata "SBX Matter Header" = R;
        }
        field(8088263; "DGF Matter Total Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("No."),
                                                                        "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                        "Version No." = field("Version No."),
                                                                        "DGF Matter Entry Type" = field("DGF Matter Entry Type Filter"),
                                                                        "DGF Matter No." = filter(<> ''),
                                                                        "DGF Matter Line No." = filter(<> 0)));
            Caption = 'Matter Total Line Amount';
            Description = 'Demo DGFLA';
        }
        field(8088264; "DGF Matter Entry Type Filter"; Enum "SBX Matter Entry Type")
        {
            Caption = 'Matter Entry Type Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
        field(8088266; "DGF Matter No. Filter"; Code[20])
        {
            Caption = 'Matter No. Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
        field(8088267; "DGF Matter Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive".Amount where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "DGF Matter Entry Type" = field("DGF Matter Entry Type Filter"),
                                                                "DGF Matter No." = field("DGF Matter No. Filter"),
                                                                "DGF Matter Line No." = filter(<> 0)));
            Caption = 'Matter Amount';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088268; "DGF Sell-to Address Code"; Code[10])
        {
            Caption = 'Sell-to Address Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = if ("Sell-to Customer No." = filter(<> '')) "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(8088269; "DGF Bill-to Address Code"; Code[10])
        {
            Caption = 'Bill-to Address Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = IF ("Bill-to Customer No." = filter(<> '""')) "Ship-to Address".Code where("Customer No." = field("Bill-to Customer No."));
        }
        field(8088270; "DGF Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Demo DGFLA';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(8088271; "DGF Matter LEDES Code"; Code[10])
        {
            Caption = 'Matter LEDES Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = "SBX LEDES Mapping"."LEDES Code" where(Type = const(Matter), "LEDES Format" = field("DGF LEDES Format Filter"), "Primary Key NAV 1" = field("DGF Matter No."));
        }
        field(8088282; "DGF Print Invoice Details"; Boolean)
        {
            Caption = 'Print Detailed Invoice';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088283; "DGF Electronic Invoice"; Boolean)
        {
            Caption = 'Electronic Invoice';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088284; "DGF LEDES Format"; Enum "SBX LEDES Format")
        {
            Caption = 'LEDES Format';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088285; "DGF Memo"; Boolean)
        {
            Caption = 'Memo';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088286; "DGF Approval Reinforced"; Boolean)
        {
            Caption = 'Approval Reinforced';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088289; "DGF Matter Prepayment"; Boolean)
        {
            Caption = 'Matter Prepayment';
            Description = 'Demo DGFLA';
            Editable = false;
            DataClassification = CustomerContent;
        }
        // field(8088290; "DGF Matter Total Pr Line Amnt"; Decimal)
        // {
        //     AutoFormatExpression = "Currency Code";
        //     AutoFormatType = 1;
        //     CalcFormula = Sum("SBX Matter Presentation Module"."Line Amount" where("Document Type" = field("Document Type"),
        //                                                                         "Document No." = field("No."),
        //                                                                         "Matter Entry Type" = field("SBX Matter Entry Type Filter")));
        //     Caption = 'Matter Total Pres. Line Amount';

        //     Description = 'Demo DGFLA';
        //     FieldClass = FlowField;
        // }
        field(8088291; "DGF Matter Cost with Serv Filt"; Boolean)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Matter Cost with Serv. Filter';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        // field(8088292; "DGF Matter Presentation Exist"; Boolean)
        // {
        //     CalcFormula = Exist("SBX Matter Presentation Module" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        //     Caption = 'Matter Presentation Exist';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088294; "DGF Matter Adj. Service"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "DGF Matter Entry Type" = const(Adjustment),
                                                                "DGF Cost Switch Service" = const(true)));
            Caption = 'Matter Adj. Service';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088295; "DGF Matter Adj. Expense"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "DGF Matter Entry Type" = const(Adjustment),
                                                                "DGF Cost Switch Service" = const(false)));
            Caption = 'Matter Adj. Expense';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088296; "DGF Matter Total Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive".Amount where("Document Type" = field("Document Type"),
                                                         "Document No." = field("No."),
                                                         "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                         "Version No." = field("Version No."),
                                                         "DGF Matter Entry Type" = field("DGF Matter Entry Type Filter"),
                                                         "DGF Matter No." = filter(<> ''),
                                                         "DGF Matter Line No." = filter(<> 0)));
            Caption = 'Matter Total Line Amount';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        // field(8088297; "DGF Matter Total Pres. Amount"; Decimal)
        // {
        //     AutoFormatExpression = "Currency Code";
        //     AutoFormatType = 1;
        //     CalcFormula = Sum("SBX Matter Presentation Module".Amount where("Document Type" = field("Document Type"),
        //                                                                  "Document No." = field("No."),
        //                                                                  "Matter Entry Type" = field("SBX Matter Entry Type Filter")));
        //     Caption = 'Matter Total Pres. Amount';
        //     Description = 'Demo DGFLA';
        //     FieldClass = FlowField;
        // }
        // field(8088298; "DGF Memo No."; Integer)
        // {
        //     Caption = 'Memo No.';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     TableRelation = "SBX Matter Mail Editor"."Entry No.";
        //     DataClassification = CustomerContent;
        // }
        // field(8088299; "DGF Cover Letter No."; Integer)
        // {
        //     Caption = 'Cover Letter No.';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     TableRelation = "SBX Matter Mail Editor"."Entry No.";
        //     DataClassification = CustomerContent;
        // }
        // field(8088300; "DGF Memo Posted"; Boolean)
        // {
        //     CalcFormula = Lookup("SBX Matter Mail Editor".Posted where("Entry No." = field("SBX Memo No.")));
        //     Caption = 'Memo Posted';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088301; "DGF Document Signed"; Boolean)
        {
            Caption = 'Document Signed';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088302; "DGF Source Amount"; Decimal)
        {
            Caption = 'Source Amount';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088303; "DGF Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            Description = 'Demo DGFLA';
            TableRelation = User."User Name";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8088304; "DGF Paper Process"; Boolean)
        {
            Caption = 'Paper Process';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088305; "DGF Sales Doc Step Line No."; Integer)
        {
            Caption = 'Sales Doc Step Line No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Sales Document Step"."Step Line No." where("Steps Type" = const(Sales), "Matter Category" = const(''));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(8088306; "DGF Sales Doc Step Name"; Text[100])
        {
            CalcFormula = Lookup("SBX Sales Document Step"."Step Name" where("Step Line No." = field("DGF Sales Doc Step Line No."), "Steps Type" = const(Sales), "Matter Category" = const('')));
            Caption = 'Step Name';
            Description = 'Demo DGFLA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8088307; "DGF Sales Doc Step Condition"; Guid)
        {
            Caption = 'Sales Doc Step Condition';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088308; "DGF To Merge"; Boolean)
        {
            Caption = 'To merge';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088309; "DGF Hide Memo Tablix"; Boolean)
        {
            Caption = 'Hide Memo Tablix';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088310; "DGF Starting Period Date"; Date)
        {
            Caption = 'Starting Period Date';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088311; "DGF Ending Period Date"; Date)
        {
            Caption = 'Ending Period Date';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088312; "DGF Matter Description"; Text[150])
        {
            Caption = 'Matter Description';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088313; "DGF Matter Description 2"; Text[50])
        {
            Caption = 'Matter Description 2';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088314; "DGF Cont. Job Title"; Text[50])
        {
            Caption = 'Cont. Job Title';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088315; "DGF Campaign Lot No."; Code[20])
        {
            Caption = 'Campaign Lot No.';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088320; "DGF Partner No."; Code[20])
        {
            CaptionClass = 'SBL,PAR';
            Caption = 'Partner No.';
            Description = 'SBLFR3.01.02.00';
            TableRelation = Resource."No." where("SBX Resource Type" = const(Partner));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(8088321; "DGF Responsible No."; Code[20])
        {
            Caption = 'Responsible No.';
            Description = 'SBLFR3.01.02.00';
            TableRelation = Resource."No." where("SBX Billing Manager" = const(true));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }

        field(8088350; "DGF Main Document"; Boolean)
        {
            Caption = 'Main Document', Comment = 'FRA: Document Cadre';
            Description = 'MultiBilling - Split Invoicing';
            DataClassification = CustomerContent;
        }

        field(8088351; "DGF Main Document No."; Code[20])
        {
            Caption = 'Main Document No.', Comment = 'FRA: N° Document Cadre';
            Description = 'MultiBilling - Split Invoicing';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(8088352; "DGF Cancel All Split Billing"; Boolean)
        {
            Caption = 'Cancel All Split Billing';
            DataClassification = SystemMetadata;
        }

        field(8088353; "DGF Main Document Amount"; Decimal)
        {
            Caption = 'Main Document Amount';
            DataClassification = SystemMetadata;
        }

        field(8088501; "DGF LEDES Format Filter"; Enum "SBX LEDES Format")
        {
            Caption = 'LEDES Format Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(SBXDEMOKey1; "DGF Matter No.")
        { }
    }
}
