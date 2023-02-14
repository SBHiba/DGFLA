pageextension 50012 "DGF Matter Presentation Module" extends "SBX Matter Presentation Module"
{
    actions
    {
        addafter(RegroupLinesByRes)
        {
            action(DGF_ApplyRange)
            {
                Caption = 'Apply Billig Range';
                ApplicationArea = SBXSBLawyer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    recMatterHeader_L: Record "SBX Matter Header";
                    MatterPresentationModule_L: Record "SBX Matter Presentation Module";
                    cuMatterTimeMgt_L: Codeunit "SBX Matter Time Management";
                begin
                    if recMatterHeader_L.Get(Rec."SBX Matter No.") then
                        if recMatterHeader_L."DGF Billing Time Range (min)" <> 0 then begin
                            MatterPresentationModule_L.SetRange("Document Type", rec."Document Type"::Invoice);
                            MatterPresentationModule_L.SetRange("Document No.", rec."No.");
                            MatterPresentationModule_L.SetRange("Matter Entry Type", MatterPresentationModule_L."Matter Entry Type"::Service); // Pour les ressources uniquement
                            MatterPresentationModule_L.SetRange("Write Off", false);
                            // MatterPresentationModule_L.SetRange("Cost Switch Service", false);
                            // MatterPresentationModule_L.SetRange("Postpone", false);
                            // MatterPresentationModule_L.SetRange("Transfer", false);
                            If MatterPresentationModule_L.FindSet(true) then begin
                                repeat
                                    Clear(cuMatterTimeMgt_L);
                                    cuMatterTimeMgt_L.SliceRoundingUnit(recMatterHeader_L."DGF Billing Time Range (min)", recMatterHeader_L."DGF Billing Rounding Range".AsInteger());
                                    MatterPresentationModule_L.Validate(Quantity, cuMatterTimeMgt_L.CalcTimeDeltaFactor(MatterPresentationModule_L."Entry Time", MatterPresentationModule_L."Unit of Measure Code"));
                                    MatterPresentationModule_L.Modify(true);
                                until MatterPresentationModule_L.Next() = 0;
                                CurrPage.Update(true);
                            end;
                        end;
                end;

            }
        }
    }
}
