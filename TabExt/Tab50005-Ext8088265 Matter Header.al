tableextension 50005 "DGF Matter Header" extends "SBX Matter Header"
{
    fields
    {
        field(50001; "DGF Billing Time Range (min)"; Integer)
        {
            Caption = 'Billing Time Range (min)', Comment = 'FRA = Palier facturation';

            trigger OnValidate()
            begin
                if "Time Range (min)" = 0 then
                    "DGF Billing Rounding Range" := "DGF Billing Rounding Range"::None;
            end;
        }
        field(50002; "DGF Billing Rounding Range"; Enum "SBX Rounding Mode")
        {
            Caption = 'Billing Rounding Range', Comment = 'FRA = Arrondi palier fact.';
        }

        field(50003; "DGF Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.', Comment = 'FRA = N° Contact donneur d''ordre';
            TableRelation = Contact."No." where(Type = const(Person));

            trigger OnValidate()
            var
                Contact_L: Record Contact;
            begin
                if "Sell-to Customer No." <> '' then
                    if "DGF Sell-to Contact No." <> '' then
                        if Contact_L.Get("DGF Sell-to Contact No.") then
                            if Contact_L.Type = Contact_L.Type::Person then
                                "Primary Contact Name" := Contact_L.Name;
            end;
        }
        field(50004; "DGF Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.', Comment = 'FRA = N° Contact client facturé';
            TableRelation = Contact."No." where(Type = const(Person));

            trigger OnValidate()
            var
                Contact_L: Record Contact;
            begin
                if "Sell-to Customer No." <> '' then
                    if "DGF Bill-to Contact No." <> '' then
                        if Contact_L.Get("DGF Bill-to Contact No.") then
                            if Contact_L.Type = Contact_L.Type::Person then
                                "Bill-to Contact" := Contact_L.Name;
            end;
        }
        field(50005; "DGF Ship-to Contact No."; Code[20])
        {
            Caption = 'Ship-to Contact No.', Comment = 'FRA = N° Contact Destinataire';
            TableRelation = Contact."No." where(Type = const(Person));

            trigger OnValidate()
            var
                Contact_L: Record Contact;
            begin
                if "Sell-to Customer No." <> '' then
                    if "DGF Ship-to Contact No." <> '' then begin

                        if Contact_L.Get("DGF Ship-to Contact No.") then
                            if Contact_L.Type = Contact_L.Type::Person then
                                "DGF Ship-to Contact" := Contact_L.Name;
                    end else
                        "DGF Ship-to Contact" := '';
            end;
        }

        field(50006; "DGF Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact', Comment = 'FRA = Contact Destinataire';
        }
        field(50007; "Creation Status"; Enum "DGF Creation Status")
        {
            Caption = 'Creation Status';
        }
        field(50008; "Lawyers / Notaries Confid Agre"; Boolean)
        {
            Caption = 'Lawyers / Notaries Confidentiality Agreement';
        }
        field(50009; "Inv. Time Range (min)"; Integer)
        {
            Caption = 'Invoicing Time Range (min)';
            Description = 'SBL2.00.0000';

            trigger OnValidate()
            begin
                if "Inv. Time Range (min)" = 0 then
                    "Inv. Rounding Range (min)" := "Inv. Rounding Range (min)"::None;
            end;
        }
        field(50010; "Inv. Rounding Range (min)"; Enum "SBX Rounding Mode")
        {
            Caption = 'Invoicing Rounding Range (min)';
            Description = 'SBL2.00.0000';
        }

    }
}