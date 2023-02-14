table 50001 "DGF Related Bill-to Contacts"
{
    Caption = 'Adresses de facturation', Comment = 'Related Bill-to Contacts';
    DataClassification = ToBeClassified;
    Description = 'insérer une ligne avec Matter No. = "", dès qu''on insert une enregistrement avec un Matter No.';

    fields
    {
        field(1; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', Comment = 'N° Client';
            DataClassification = SystemMetadata;
            TableRelation = Customer."No.";
        }
        field(2; "Contact No."; Code[20])
        {
            Caption = 'Contact No.', Comment = 'N° Contact';
            DataClassification = SystemMetadata;
            TableRelation = Contact."No.";
        }
        field(3; "Matter No."; Code[20])
        {
            Caption = 'Matter No.', Comment = 'N° Dossier';
            DataClassification = SystemMetadata;
            TableRelation = "SBX Matter Header"."Matter No.";
        }
        field(4; Role; Text[80])
        {
            Caption = 'Role', Comment = 'Role';
            DataClassification = SystemMetadata;
        }
        field(5; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name', Comment = 'Nom Contact';
            // DataClassification = SystemMetadata;
            Description = '';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Contact No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Sell-to Customer No.", "Contact No.", "Matter No.")
        {
            Clustered = true;
        }
    }
}
