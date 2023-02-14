tableextension 50000 "DGF Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(8088262; "SBX Matter No."; Code[20])
        {
            Caption = 'Matter No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Header"."Matter No.";
            DataClassification = CustomerContent;
            AccessByPermission = Tabledata "SBX Matter Header" = R;
        }
        field(8088263; "SBX Matter Total Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("No."),
                                                                        "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                        "Version No." = field("Version No."),
                                                                        "SBX Matter Entry Type" = field("SBX Matter Entry Type Filter"),
                                                                        "SBX Matter No." = filter(<> ''),
                                                                        "SBX Matter Line No." = filter(<> 0)));
            Caption = 'Matter Total Line Amount';
            Description = 'Demo DGFLA';
        }
        field(8088264; "SBX Matter Entry Type Filter"; Enum "SBX Matter Entry Type")
        {
            Caption = 'Matter Entry Type Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
        field(8088266; "SBX Matter No. Filter"; Code[20])
        {
            Caption = 'Matter No. Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
        field(8088267; "SBX Matter Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive".Amount where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "SBX Matter Entry Type" = field("SBX Matter Entry Type Filter"),
                                                                "SBX Matter No." = field("SBX Matter No. Filter"),
                                                                "SBX Matter Line No." = filter(<> 0)));
            Caption = 'Matter Amount';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088268; "SBX Sell-to Address Code"; Code[10])
        {
            Caption = 'Sell-to Address Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = if ("Sell-to Customer No." = filter(<> '')) "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(8088269; "SBX Bill-to Address Code"; Code[10])
        {
            Caption = 'Bill-to Address Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = IF ("Bill-to Customer No." = filter(<> '""')) "Ship-to Address".Code where("Customer No." = field("Bill-to Customer No."));
        }
        field(8088270; "SBX Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Demo DGFLA';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(8088271; "SBX Matter LEDES Code"; Code[10])
        {
            Caption = 'Matter LEDES Code';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
            TableRelation = "SBX LEDES Mapping"."LEDES Code" where(Type = const(Matter), "LEDES Format" = field("SBX LEDES Format Filter"), "Primary Key NAV 1" = field("SBX Matter No."));
        }
        field(8088282; "SBX Print Invoice Details"; Boolean)
        {
            Caption = 'Print Detailed Invoice';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088283; "SBX Electronic Invoice"; Boolean)
        {
            Caption = 'Electronic Invoice';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088284; "SBX LEDES Format"; Enum "SBX LEDES Format")
        {
            Caption = 'LEDES Format';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088285; "SBX Memo"; Boolean)
        {
            Caption = 'Memo';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088286; "SBX Approval Reinforced"; Boolean)
        {
            Caption = 'Approval Reinforced';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088289; "SBX Matter Prepayment"; Boolean)
        {
            Caption = 'Matter Prepayment';
            Description = 'Demo DGFLA';
            Editable = false;
            DataClassification = CustomerContent;
        }
        // field(8088290; "SBX Matter Total Pr Line Amnt"; Decimal)
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
        field(8088291; "SBX Matter Cost with Serv Filt"; Boolean)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Matter Cost with Serv. Filter';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        // field(8088292; "SBX Matter Presentation Exist"; Boolean)
        // {
        //     CalcFormula = Exist("SBX Matter Presentation Module" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        //     Caption = 'Matter Presentation Exist';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088294; "SBX Matter Adj. Service"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "SBX Matter Entry Type" = const(Adjustment),
                                                                "SBX Cost Switch Service" = const(true)));
            Caption = 'Matter Adj. Service';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088295; "SBX Matter Adj. Expense"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive"."Line Amount" where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No."),
                                                                "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                "Version No." = field("Version No."),
                                                                "SBX Matter Entry Type" = const(Adjustment),
                                                                "SBX Cost Switch Service" = const(false)));
            Caption = 'Matter Adj. Expense';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        field(8088296; "SBX Matter Total Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line Archive".Amount where("Document Type" = field("Document Type"),
                                                         "Document No." = field("No."),
                                                         "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                         "Version No." = field("Version No."),
                                                         "SBX Matter Entry Type" = field("SBX Matter Entry Type Filter"),
                                                         "SBX Matter No." = filter(<> ''),
                                                         "SBX Matter Line No." = filter(<> 0)));
            Caption = 'Matter Total Line Amount';
            Description = 'Demo DGFLA';
            FieldClass = FlowField;
        }
        // field(8088297; "SBX Matter Total Pres. Amount"; Decimal)
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
        // field(8088298; "SBX Memo No."; Integer)
        // {
        //     Caption = 'Memo No.';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     TableRelation = "SBX Matter Mail Editor"."Entry No.";
        //     DataClassification = CustomerContent;
        // }
        // field(8088299; "SBX Cover Letter No."; Integer)
        // {
        //     Caption = 'Cover Letter No.';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     TableRelation = "SBX Matter Mail Editor"."Entry No.";
        //     DataClassification = CustomerContent;
        // }
        // field(8088300; "SBX Memo Posted"; Boolean)
        // {
        //     CalcFormula = Lookup("SBX Matter Mail Editor".Posted where("Entry No." = field("SBX Memo No.")));
        //     Caption = 'Memo Posted';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088301; "SBX Document Signed"; Boolean)
        {
            Caption = 'Document Signed';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088302; "SBX Source Amount"; Decimal)
        {
            Caption = 'Source Amount';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088303; "SBX Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            Description = 'Demo DGFLA';
            TableRelation = User."User Name";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8088304; "SBX Paper Process"; Boolean)
        {
            Caption = 'Paper Process';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088305; "SBX Sales Doc Step Line No."; Integer)
        {
            Caption = 'Sales Doc Step Line No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Sales Document Step"."Step Line No." where("Steps Type" = const(Sales), "Matter Category" = const(''));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(8088306; "SBX Sales Doc Step Name"; Text[100])
        {
            CalcFormula = Lookup("SBX Sales Document Step"."Step Name" where("Step Line No." = field("SBX Sales Doc Step Line No."), "Steps Type" = const(Sales), "Matter Category" = const('')));
            Caption = 'Step Name';
            Description = 'Demo DGFLA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8088307; "SBX Sales Doc Step Condition"; Guid)
        {
            Caption = 'Sales Doc Step Condition';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088308; "SBX To Merge"; Boolean)
        {
            Caption = 'To merge';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088309; "SBX Hide Memo Tablix"; Boolean)
        {
            Caption = 'Hide Memo Tablix';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088310; "SBX Starting Period Date"; Date)
        {
            Caption = 'Starting Period Date';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088311; "SBX Ending Period Date"; Date)
        {
            Caption = 'Ending Period Date';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088312; "SBX Matter Description"; Text[150])
        {
            Caption = 'Matter Description';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088313; "SBX Matter Description 2"; Text[50])
        {
            Caption = 'Matter Description 2';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088314; "SBX Cont. Job Title"; Text[50])
        {
            Caption = 'Cont. Job Title';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088315; "SBX Campaign Lot No."; Code[20])
        {
            Caption = 'Campaign Lot No.';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088320; "SBX Partner No."; Code[20])
        {
            CaptionClass = 'SBL,PAR';
            Caption = 'Partner No.';
            Description = 'SBLFR3.01.02.00';
            TableRelation = Resource."No." where("SBX Resource Type" = const(Partner));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(8088321; "SBX Responsible No."; Code[20])
        {
            Caption = 'Responsible No.';
            Description = 'SBLFR3.01.02.00';
            TableRelation = Resource."No." where("SBX Billing Manager" = const(true));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }

        field(8088350; "SBX Main Document"; Boolean)
        {
            Caption = 'Main Document', Comment = 'FRA: Document Cadre';
            Description = 'MultiBilling - Split Invoicing';
            DataClassification = CustomerContent;
        }

        field(8088351; "SBX Main Document No."; Code[20])
        {
            Caption = 'Main Document No.', Comment = 'FRA: N° Document Cadre';
            Description = 'MultiBilling - Split Invoicing';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(8088352; "SBX Cancel All Split Billing"; Boolean)
        {
            Caption = 'Cancel All Split Billing';
            DataClassification = SystemMetadata;
        }

        field(8088353; "SBX Main Document Amount"; Decimal)
        {
            Caption = 'Main Document Amount';
            DataClassification = SystemMetadata;
        }

        field(8088501; "SBX LEDES Format Filter"; Enum "SBX LEDES Format")
        {
            Caption = 'LEDES Format Filter';
            Description = 'Demo DGFLA';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(SBXDEMOKey1; "SBX Matter No.")
        { }
    }
}
