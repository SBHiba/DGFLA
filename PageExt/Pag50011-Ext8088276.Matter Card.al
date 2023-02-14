pageextension 50011 "DGF Matter Card" extends "SBX Matter Card"
{
    layout
    {
        addafter("Invoice Period")
        {
            field("DGF Billing Time Range (min)"; Rec."DGF Billing Time Range (min)")
            {
                ApplicationArea = SBXSBLawyer;
                Importance = Promoted;

                trigger OnValidate()
                begin
                    bTimeRangeinvoicingNotNull := Rec."DGF Billing Time Range (min)" <> 0;
                    CurrPage.Update;
                end;
            }
            group(DGFRangeGrpinvoicing)
            {
                ShowCaption = false;
                Visible = bTimeRangeinvoicingNotNull or (Rec."DGF Billing Time Range (min)" <> 0);
                field("DGF Billing Rounding Range"; Rec."DGF Billing Rounding Range")
                {
                    ApplicationArea = SBXSBLawyer;
                    Editable = bTimeRangeinvoicingNotNull or (Rec."DGF Billing Time Range (min)" <> 0);
                }
            }
        }

        addafter("Primary Contact No.")
        {
            field("DGF Sell-to Contact No."; Rec."DGF Sell-to Contact No.")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }

        addafter("Bill-to Contact No.")
        {
            field("DGF Bill-to Contact No."; Rec."DGF Bill-to Contact No.")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }

        addafter("Comm. Addr. Code")
        {
            field("DGF Ship-to Contact No."; Rec."DGF Ship-to Contact No.")
            {
                ApplicationArea = SBXSBLawyer;
            }
            field("DGF Ship-to Contact"; Rec."DGF Ship-to Contact")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }
        addafter("Time Range (min)")
        {
            field("DGF Inv. Time Range (min)"; Rec."DGF Inv. Time Range (min)")
            {
                ApplicationArea = SBXSBLawyer;
                Importance = Promoted;

                trigger OnValidate()
                begin
                    InvbTimeRangeNotNull := Rec."DGF Inv. Time Range (min)" <> 0;
                    CurrPage.Update();
                end;
            }
        }
        addafter(RangeGrp)
        {
            group(DGFInvRangeGrp)
            {
                ShowCaption = false;
                Visible = InvbTimeRangeNotNull;
                field("DGF Inv. Rounding Range (min)"; Rec."DGF Inv. Rounding Range (min)")
                {
                    ApplicationArea = SBXSBLawyer;
                    Editable = InvbTimeRangeNotNull;
                    ShowMandatory = InvbTimeRangeNotNull;
                }

            }
        }
        addlast(GeneralGrp)
        {
            field("DGF Creation Status"; Rec."DGF Creation Status")
            {
                ApplicationArea = All;
            }
            field("DGF Lawyers / Notaries Confid Agre"; Rec."DGF Lawyers / Notaries Confid Agre")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(InfoActionGrp)
        {
            action(DGFRunBillToAddresses)
            {
                ApplicationArea = SBXSBLawyer;
                Caption = 'Bill-to Addresses', Comment = 'Adresses de facturation';
                Image = SuggestCustomerBill;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "DGF Related Bill-to Addr.";
                RunPageLink = "Matter No." = field("Matter No.");
                RunPageMode = View;
                ShortCutKey = 'Alt+F';
                ToolTip = 'View or edit Bill-to Addresses.';
            }
        }
    }
    var
        bTimeRangeinvoicingNotNull: Boolean;
        InvbTimeRangeNotNull: Boolean;


    trigger OnAfterGetRecord()
    begin
        bTimeRangeinvoicingNotNull := Rec."DGF Billing Time Range (min)" <> 0;
        InvbTimeRangeNotNull := Rec."DGF Inv. Time Range (min)" <> 0;

    end;
}