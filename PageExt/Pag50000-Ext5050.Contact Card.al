pageextension 50000 "DGF Contact Card" extends "Contact Card"
{
    layout
    {
        modify("SBX Approval Status")
        {
            Editable = true;
        }

        addafter("E-Mail")
        {
            field("DGF E-Mail 2"; Rec."E-Mail 2")
            {
                ApplicationArea = All;
            }
        }

        addafter("Phone No.")
        {
            field(DGFPager; Rec.Pager)
            {
                ApplicationArea = All;
                Caption = 'Téléphone 2';
            }
        }
    }

    actions
    {
    }
}