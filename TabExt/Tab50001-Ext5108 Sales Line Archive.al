tableextension 50001 "DGF Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(8088262; "SBX Matter No."; Code[20])
        {
            Caption = 'Matter No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Header"."Matter No." where("Matter Type" = const(Chargeable));
            DataClassification = CustomerContent;
        }
        field(8088263; "SBX Matter Line No."; Integer)
        {
            Caption = 'Matter Line No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Line"."Line No." where("Matter No." = FIELD("SBX Matter No."));
            DataClassification = CustomerContent;
        }
        field(8088264; "SBX Matter Ledger Entry No."; Integer)
        {
            Caption = 'Matter Ledger Entry No.';
            Description = 'Demo DGFLA';
            TableRelation = "SBX Matter Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(8088265; "SBX Source Quantity"; Decimal)
        {
            Caption = 'Source Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088266; "SBX Matter Entry Type"; Enum "SBX Matter Entry Type")
        {
            Caption = 'Matter Entry Type';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088267; "SBX Postpone"; Boolean)
        {
            Caption = 'Postpone';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088268; "SBX Matter Entry Description"; Text[250])
        {
            Caption = 'Matter Entry Description';
            DataClassification = CustomerContent;
        }

        field(8088289; "SBX Apply Matter Prepayment"; Enum "SBX Apply Matter Prepayment")
        {
            Caption = 'Apply Matter Prepayment';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088291; "SBX Applies-to Inv Doc. No."; Code[20])
        {
            Caption = 'Applies-to Inv Doc. No.';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088292; "SBX Quantity Adjusted (Base)"; Decimal)
        {
            Caption = 'Quantity Adjusted (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088293; "SBX Line Amount Adjusted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount Adjusted';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088294; "SBX Line Adjusted %"; Decimal)
        {
            Caption = 'Line Adjusted %';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088295; "SBX Total Line Amount Adjusted"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Line Amount Adjusted';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088296; "SBX Write Off"; Boolean)
        {
            Caption = 'Write Off';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088297; "SBX Cost Switch Service"; Boolean)
        {
            Caption = 'Switch to Fee';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        // field(8088298; "SBX Comment Line"; Boolean)
        // {
        //     CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = FIELD("Document Type"),
        //                                                     "No." = FIELD("Document No."),
        //                                                     "Document Line No." = FIELD("Line No.")));
        //     Caption = 'Comment';
        //     Description = 'Demo DGFLA';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(8088299; "SBX Transfer"; Boolean)
        {
            Caption = 'Transfer';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088300; "SBX Entry Time"; Text[12])
        {
            AutoFormatExpression = '<Hours24,2>:<Minutes,2>';
            AutoFormatType = 1;
            Caption = 'Entry Time';
            Description = 'Demo DGFLA';
            DataClassification = CustomerContent;
        }
        field(8088301; "SBX Source Entry Time"; Text[12])
        {
            AutoFormatExpression = '<Hours24,2>:<Minutes,2>';
            AutoFormatType = 1;
            Caption = 'Source Entry Time';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088302; "SBX Planning Date"; Date)
        {
            Caption = 'Planning Date';
            Description = 'Demo DGFLA';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(8088303; "SBX Line Unit Price Adj"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Line Unit Price Adjustement';
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
        field(8088312; "SBX Nature Code"; Code[20])
        {
            Caption = 'Nature Code';
            Description = 'Demo DGFLA';
            TableRelation = IF (Type = CONST(Resource), "SBX Matter Entry Type" = CONST(Service)) "Work Type"
            ELSE
            IF (Type = CONST(Item), "SBX Matter Entry Type" = FILTER(Expense)) Resource
            ELSE
            IF (Type = CONST(Item), "SBX Matter Entry Type" = CONST("External Expense")) Vendor
            ELSE
            IF (Type = CONST("G/L Account"), "SBX Matter Entry Type" = CONST(Service)) "Work Type"
            ELSE
            IF (Type = CONST("G/L Account"), "SBX Matter Entry Type" = FILTER(Expense)) Item WHERE("SBX Matter Entry Type" = FILTER(Expense))
            ELSE
            IF (Type = CONST("G/L Account"), "SBX Matter Entry Type" = CONST("External Expense")) Item WHERE("SBX Matter Entry Type" = CONST("External Expense"));
            DataClassification = CustomerContent;
        }
        field(8088313; "SBX Sales Topic"; Code[20])
        {
            Caption = 'Sales Billing Topic';
            Description = 'SBLFR4.03.02.00';
            TableRelation = "SBX Sales Topic";
            DataClassification = CustomerContent;
        }
        field(8088314; "SBX Flat Matter Line"; Boolean)
        {
            Caption = 'Flat Matter Line';
            Description = 'SBLFR4.03.03.00';
            DataClassification = CustomerContent;
        }

        field(8088315; "SBX Financial Discount"; Boolean)
        {
            Caption = 'Financial Discount';
            DataClassification = SystemMetadata;
        }
        field(8088316; "SBX Reference Amount"; Decimal)
        {
            Caption = 'Reference Amount';
            Editable = true;
        }
    }

    keys
    {
        key(SBXDEMOKey1; "SBX Matter No.")
        { }
    }
}
