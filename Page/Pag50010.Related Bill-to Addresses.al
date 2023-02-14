page 50010 "DGF Related Bill-to Addr."
{
    ApplicationArea = SBXSBLawyer;
    Caption = 'Related Bill-to Addresses';
    PageType = List;
    SourceTable = "Related Bill-to Contacts";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.', Comment = 'N° Client';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Matter No."; Rec."Matter No.")
                {
                    ToolTip = 'Specifies the value of the Matter No. field.', Comment = 'N° Dossier';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.', Comment = 'N° Contact';
                    ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ToolTip = 'Specifies the value of the Contact Name field.', Comment = 'Nom Contact';
                    ApplicationArea = All;
                }
                field(Role; Rec.Role)
                {
                    ToolTip = 'Specifies the value of the Role field.', Comment = 'Role';
                    ApplicationArea = All;
                }
            }
        }
    }
}
