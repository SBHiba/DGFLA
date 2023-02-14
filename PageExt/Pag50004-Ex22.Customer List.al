pageextension 50004 "DGF Customer List" extends "Customer List"
{
    layout
    {
        addafter("Name 2")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = SBXSBLawyer;
            }
            field("SBX PSB Group Name"; Rec."SBX PSB Group Name")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }
        modify("Search Name")
        {
            Visible = true;
        }

    }

    actions
    {
        addfirst(processing)
        {
            action(SBXInitMyCust)
            {
                ApplicationArea = SBXSBLawyer;

                Image = Process;
                trigger OnAction()
                var
                    MatterManagement_L: Codeunit "SBX Matter Management";
                    MatterHeader_L: Record "SBX Matter Header";
                begin
                    MatterHeader_L.Reset();
                    if MatterHeader_L.FindSet() then
                        repeat
                            MatterManagement_L.FillAutoMyCustomerFromMatter(MatterHeader_L);
                        until MatterHeader_L.Next() = 0;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        DGFManagement_L: Codeunit "DGF Management";
        PartnerFilter: Code[250];
    begin
        PartnerFilter := DGFManagement_L.GetPartnerFilterByProfil();
        if PartnerFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("SBX Partner Filter", PartnerFilter);
            Rec.FilterGroup(0);
        end;
    end;

}