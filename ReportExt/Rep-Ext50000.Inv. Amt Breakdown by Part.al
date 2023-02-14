reportextension 50000 "Inv. Amt Breakdown by Part." extends "SBX Inv. Amt Brkdwn by Matter"
{
    dataset
    {
        modify("Matter Header")
        {
            RequestFilterFields = "Matter No.", "Sell-to Customer No.";

            trigger OnBeforePreDataItem()
            var
                cuMatterMgt_L: Codeunit "SBX Matter Management";
                PartnerFilter_L: code[2048];

            begin
                PartnerFilter_L := cuMatterMgt_L.GetResNoFilterByProfil();
                if PartnerFilter_L > '' then begin

                    "Matter Header".FilterGroup(2);
                    "Matter Header".SetFilter("Partner No.", PartnerFilter_L);
                    "Matter Header".FilterGroup(0);
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            modify(bDisplayPartner)
            { Visible = false; }

            modify(bDisplayResp)
            { Visible = false; }
        }
    }
}
