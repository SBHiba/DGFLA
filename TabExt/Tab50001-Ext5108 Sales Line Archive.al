tableextension 50001 "DGF Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(8088262; "DGF Matter No."; Code[20])
        {
            Caption = 'Matter No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Header"."Matter No." where("Matter Type" = const(Chargeable));
            DataClassification = CustomerContent;
        }
        field(8088263; "DGF Matter Line No."; Integer)
        {
            Caption = 'Matter Line No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Line"."Line No." where("Matter No." = FIELD("DGF Matter No."));
            DataClassification = CustomerContent;
        }
        field(8088264; "DGF Matter Ledger Entry No."; Integer)
        {
            Caption = 'Matter Ledger Entry No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(8088265; "DGF Source Quantity"; Decimal)
        {
            Caption = 'Source Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088266; "DGF Matter Entry Type"; Enum "SBX Matter Entry Type")
        {
            Caption = 'Matter Entry Type';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088267; "DGF Postpone"; Boolean)
        {
            Caption = 'Postpone';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088268; "DGF Matter Entry Description"; Text[250])
        {
            Caption = 'Matter Entry Description';
            DataClassification = CustomerContent;
        }

        field(8088289; "DGF Apply Matter Prepayment"; Enum "SBX Apply Matter Prepayment")
        {
            Caption = 'Apply Matter Prepayment';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088291; "DGF Applies-to Inv Doc. No."; Code[20])
        {
            Caption = 'Applies-to Inv Doc. No.';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088292; "DGF Quantity Adjusted (Base)"; Decimal)
        {
            Caption = 'Quantity Adjusted (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088293; "DGF Line Amount Adjusted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount Adjusted';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088294; "DGF Line Adjusted %"; Decimal)
        {
            Caption = 'Line Adjusted %';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088295; "DGF Total Line Amount Adjusted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Line Amount Adjusted';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088296; "DGF Write Off"; Boolean)
        {
            Caption = 'Write Off';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088297; "DGF Cost Switch Service"; Boolean)
        {
            Caption = 'Switch to Fee';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        // field(8088298; "DGF Comment Line"; Boolean)
        // {
        //     CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = FIELD("Document Type"),
        //                                                     "No." = FIELD("Document No."),
        //                                                     "Document Line No." = FIELD("Line No.")));
        //     Caption = 'Comment';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088299; "DGF Transfer"; Boolean)
        {
            Caption = 'Transfer';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088300; "DGF Entry Time"; Text[12])
        {
            AutoFormatExpression = '<Hours24,2>:<Minutes,2>';
            AutoFormatType = 1;
            Caption = 'Entry Time';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088301; "DGF Source Entry Time"; Text[12])
        {
            AutoFormatExpression = '<Hours24,2>:<Minutes,2>';
            AutoFormatType = 1;
            Caption = 'Source Entry Time';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088302; "DGF Planning Date"; Date)
        {
            Caption = 'Planning Date';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088303; "DGF Line Unit Price Adj"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Line Unit Price Adjustement';
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
        field(8088312; "DGF Nature Code"; Code[20])
        {
            Caption = 'Nature Code';
            Description = 'Demo DGFLA';
            TableRelation = IF (Type = CONST(Resource), "DGF Matter Entry Type" = CONST(Service)) "Work Type"
            ELSE
            IF (Type = CONST(Item), "DGF Matter Entry Type" = FILTER(Expense)) Resource
            ELSE
            IF (Type = CONST(Item), "DGF Matter Entry Type" = CONST("External Expense")) Vendor
            ELSE
            IF (Type = CONST("G/L Account"), "DGF Matter Entry Type" = CONST(Service)) "Work Type"
            ELSE
            IF (Type = CONST("G/L Account"), "DGF Matter Entry Type" = FILTER(Expense)) Item WHERE("SBX Matter Entry Type" = FILTER(Expense))
            ELSE
            IF (Type = CONST("G/L Account"), "DGF Matter Entry Type" = CONST("External Expense")) Item WHERE("SBX Matter Entry Type" = CONST("External Expense"));
            DataClassification = CustomerContent;
        }
        field(8088313; "DGF Sales Topic"; Code[20])
        {
            Caption = 'Sales Billing Topic';
            Description = 'SBLFR4.03.02.00';
            TableRelation = "SBX Sales Topic";
            DataClassification = CustomerContent;
        }
        field(8088314; "DGF Flat Matter Line"; Boolean)
        {
            Caption = 'Flat Matter Line';
            Description = 'SBLFR4.03.03.00';
            DataClassification = CustomerContent;
        }

        field(8088315; "DGF Financial Discount"; Boolean)
        {
            Caption = 'Financial Discount';
            DataClassification = SystemMetadata;
        }
        field(8088316; "DGF Reference Amount"; Decimal)
        {
            Caption = 'Reference Amount';
            Editable = true;
        }
    }

    keys
    {
        key(SBXDEMOKey1; "DGF Matter No.")
        { }
    }
}
