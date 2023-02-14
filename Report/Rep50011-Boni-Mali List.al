/* Comment  
End Comment */

report 50011 "DGF Boni-Mali List"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50011-Boni-Mali List.rdlc';

    Caption = 'Boni/Mali', Comment = 'Boni/Mali Summary';
    Permissions = TableData "Sales Header Archive" = R, TableData "Sales Line Archive" = R;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;

    dataset
    {
        dataitem("SBX Matter Header"; "SBX Matter Header")
        {
            DataItemTableView = sorting("Sell-to Customer No.", "Partner No.", Status);
            RequestFilterFields = "Sell-to Customer No.";
            CalcFields = "Partner Name", "Responsible Name";

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(PeriodCaption; StrSubstNo(ReportPeriodLbl, StartCumulDate, EndingDate))
            { }
            // column(StartBillingPeriod; StartingDate)
            // { }
            column(EndBillingPeriod; EndingDate)
            { }
            column(StartCumulPeriod; StartCumulDate)
            { }
            // column(WIPEndDate; WIPEndDate)
            // { }
            column(ReportFilters; txtFilter)
            { }
            column(LocalCurrency; codeCurrency)
            { }
            column(Matter_No_; "Matter No.")
            { }
            column(MatterName; Name)
            { }
            column(PartnerNo_; "Partner No.")
            { }
            column(PartnerName; "Partner Name")
            { }
            column(ResponsibleNo; "Responsible No.")
            { }
            column(ResponsibleName; "Responsible Name")
            { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            { }
            column(Sell_to_Customer_Name; "Sell-to Name")
            { }
            column(BillCustomerNo; "Bill-to Customer No.")
            { }
            column(BillCustomerName; "Bill-to Name")
            { }


            // // Wip before billing 
            // column(PreInvoiceServiceAmt; PreInvoiceServiceAmt + PreInvoiceAdjAmt) // Montant Honos Préfacturation
            // { }
            // column(PreInvoiceExpenseAmt; PreInvoiceExpenseAmt) // Montant Frais Préfacturation
            // { }

            // // Billed
            // column(BilledServiceAmt; BilledServiceAmt + BilledAdjAmt) // Montant Honos Facturé
            // { }
            // column(BilledExpenseAmt; BilledExpenseAmt) // Montant Frais Facturé
            // { }
            // column(BilledExpenseAsFeesAmt; ExpenseAsFeesAmt) // Montant Frais passé en Honoraire
            // { }
            // column(FeesModifiedAmt; FeesModifiedAmt) // Montant Honos tranformés
            // { }

            // // Postponed WIP
            // column(WIPMatterAmt; WIPMatterAmt) // Montant Report => Planning Date < Début période facturation et Posting Date < Fin Période facturation, document Date < Fin période facturation
            // { }

            // Cumul Boni-Mali
            column(BoniMaliCumulAmt; BoniMaliCumulAmt) // Montant cumul Boni/Mali
            { }

            // Provision
            column(ProvisionAmt; ProvisionAmt)
            { }


            trigger OnPreDataItem() // dataitem "Matter Header"
            begin
                // SetRange("Starting Date", 0D, StartingDate);
                // SetFilter("Ending Date", '%1|>%2', 0D, CalcDate('<-3M>', StartingDate));

                FirstLineHasBeenOutput := false;
            end;


            trigger OnAfterGetRecord()
            var
                MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                MatterValueEntry_L: Record "SBX Matter Value Entry";
                MatterPrepaymentEntry_L: Record "SBX Matter Prepayment Entry";
                MatterRegister_L: Record "SBX Matter Register";

            begin
                // Calcul montant provision
                ProvisionAmt := 0;
                MatterPrepaymentEntry_L.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                MatterPrepaymentEntry_L.SetRange("Matter No.", "Matter No.");
                MatterPrepaymentEntry_L.SetRange("Posting Date", StartCumulDate, EndingDate); //
                if MatterPrepaymentEntry_L.FindSet() then
                    repeat
                        ProvisionAmt += MatterPrepaymentEntry_L."Amount (LCY)";
                    until MatterPrepaymentEntry_L.Next() = 0;


                /// Calcul Cumul Boni/Mali
                BoniMaliCumulAmt := 0;
                MatterLedgerEntry_L.Reset();
                MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                MatterLedgerEntry_L.SetFilter("Matter Entry Type", '<>%1', MatterLedgerEntry_L."Matter Entry Type"::Adjustment);
                // MatterLedgerEntry_L.SetRange(Status, MatterLedgerEntry_L.Status::Closed);
                MatterLedgerEntry_L.SetRange("Posting Date", 0D, EndingDate);
                MatterLedgerEntry_L.SetRange("Planning Date", 0D, EndingDate); //CalcDate('<-1D>', StartingDate)); // 
                MatterLedgerEntry_L.SetRange("Date Filter", StartCumulDate, EndingDate);
                // MatterLedgerEntry_L.Setrange("Write Off", false); // ==> cas particulier pour la perte

                MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Actual) (LCY)", "Sales Amount (Expected) (LCY)");
                if MatterLedgerEntry_L.FindSet() then
                    repeat
                        case MatterLedgerEntry_L."Matter Journal Template Name" of
                            '': // => les diligences saisies à partir des documents vente et achat (pour les traiter à part)
                                begin
                                    // Déterminer si l'ériture vient d'un document vente ou achat
                                    // MatterRegister_L.SetCurrentKey("From Matter Led. Entry No.", "To Matter Ledg. Entry No.");
                                    // MatterRegister_L.SetFilter("From Matter Led. Entry No.", '<=%1', MatterLedgerEntry_L."Entry No.");
                                    // if MatterRegister_L.FindLast() then begin
                                    // if MatterRegister_L."Source Code" = SourceCodeSetup.Sales then begin
                                    if MatterLedgerEntry_L."Source Code" = SourceCodeSetup.Sales then begin
                                        if MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" <> 0 then
                                            BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)";
                                    end else begin // Pas un document Vente (calcul normal)
                                        if MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" <> 0 then
                                            BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" - MatterLedgerEntry_L."Reference Amount"
                                        else
                                            // si montant facturé est nul, sans passer par la perte...
                                            if (not MatterLedgerEntry_L."Write Off") and (MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" = 0) then
                                                BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" - MatterLedgerEntry_L."Reference Amount";
                                    end;
                                    // end;
                                end;

                            else begin
                                if MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" <> 0 then
                                    BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" - MatterLedgerEntry_L."Reference Amount"
                                else
                                    // si montant facturé est nul, sans passer par la perte...
                                    if (not MatterLedgerEntry_L."Write Off") and (MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" = 0) then
                                        BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)" - MatterLedgerEntry_L."Reference Amount";
                            end;
                        end;
                    until MatterLedgerEntry_L.Next() = 0;



                // ==> cas particulier de la perte
                MatterValueEntry_L.Reset();
                MatterValueEntry_L.SetRange("Matter No.", "Matter No.");
                MatterValueEntry_L.SetRange("Posting Date", 0D, EndingDate);
                MatterValueEntry_L.SetRange("Planning Date", 0D, EndingDate);
                MatterValueEntry_L.SetRange("Document Date", StartCumulDate, EndingDate);
                MatterValueEntry_L.SetRange("Entry Sub Type", MatterValueEntry_L."Entry Sub Type"::"Write Off");
                if MatterValueEntry_L.FindSet() then
                    repeat
                        MatterLedgerEntry_L.Get(MatterValueEntry_L."Matter ledger Entry No.");
                        if MatterValueEntry_L."Sales Amount (Expected) (LCY)" < 0 then
                            BoniMaliCumulAmt += 0 - MatterLedgerEntry_L."Reference Amount"
                        else
                            BoniMaliCumulAmt += MatterLedgerEntry_L."Reference Amount";
                    until MatterValueEntry_L.Next() = 0;

                // ==> cas particulier Ajustement global
                MatterLedgerEntry_L.Reset();
                MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                MatterLedgerEntry_L.SetRange(Status, MatterLedgerEntry_L.Status::Closed);
                MatterLedgerEntry_L.Setrange("Write Off", false);
                MatterLedgerEntry_L.SetRange("Matter Entry Type", MatterLedgerEntry_L."Matter Entry Type"::Adjustment);
                MatterLedgerEntry_L.SetRange("Posting Date", 0D, EndingDate);
                MatterLedgerEntry_L.SetRange("Planning Date", 0D, EndingDate);
                MatterLedgerEntry_L.SetRange("Date Filter", StartCumulDate, EndingDate);
                MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Actual) (LCY)");
                if MatterLedgerEntry_L.FindSet() then
                    repeat
                        BoniMaliCumulAmt += MatterLedgerEntry_L."Sales Amount (Actual) (LCY)";
                    until MatterLedgerEntry_L.Next() = 0;

                // FirstLineHasBeenOutput := true;

                if (ProvisionAmt = 0) and (BoniMaliCumulAmt = 0) then CurrReport.Skip();

            end;

        }
    }

    requestpage
    {
        SaveValues = false;
        Caption = 'Options';

        layout
        {
            area(content)
            {
                group(PaymentPeriodGrp)
                {
                    Caption = 'Options';
                    // Caption = 'Billing Period', comment = 'FRA = Période facturation';
                    // field(StartindDate; StartingDate)
                    // {
                    //     ApplicationArea = SBXSBLawyer;
                    //     Caption = 'Date début';

                    //     trigger OnValidate()
                    //     begin
                    //         if StartingDate = 0D then
                    //             ERROR(ERR_ENDDATE);
                    //         EndingDate := CalcDate('<CM>', StartingDate);
                    //         StartCumulDate := CalcDate('<-CY>', StartingDate);
                    //     end;
                    // }

                    field(StartCumulDate; StartCumulDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Date début';

                        trigger OnValidate()
                        begin
                            if StartCumulDate = 0D then
                                ERROR(ERR_ENDDATE);
                        end;
                    }

                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Date fin';

                        trigger OnValidate()
                        begin
                            if EndingDate = 0D then
                                ERROR(ERR_ENDDATE);
                        end;
                    }

                }

                // group(OthersOptionsGrp)
                // {
                //     Caption = 'Others Options';
                //     Visible = false;

                //     field(ResGrpFilter; ResGrpFilter)
                //     {
                //         ApplicationArea = SBXSBLawyer;
                //         Caption = 'Resource Group Filter', Comment = 'FRA = Filtre Groupe ressource';
                //         TableRelation = "Resource Group"."No.";
                //         ShowMandatory = true;

                //         trigger OnValidate()
                //         begin
                //             if ResGrpFilter = '' then
                //                 Error(ErrGrpRes);
                //         end;
                //     }
                // }
            }
        }
    }

    labels
    {
        PartnerCaption = 'Associé';
        ResponsibleCaption = 'Responsable';
        DpmtLbl = 'Départment';
        MatterLbl = 'Dossier';
        CustomerLbl = 'Client';
        DocNoCaption = 'N° document';
        DocDateCaption = 'Date Doc.';
        TotalCaption = 'Total';
        SubTotalCation = 'sous-total';
        BilledCaption = 'Facturation';
        PreInvoiceCatpion = 'Préfacturation';
        FeesAmountCaption = 'Honoraires';
        DisbursementCaption = 'Débours';
        ExpenseAmountCaption = 'Frais';
        OutsourcingAmountCaption = 'Frais externe';
        LCYCaption = 'Devise';
        PageLbl = 'Page';
        Title = 'BONI / MALI', Comment = 'FRA = BONI / MALI';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;
    }


    trigger OnInitReport()
    begin
        recGLSetup_g.Get;
        recGLSetup_g.TestField("LCY Code");
        codeCurrency := recGLSetup_g."LCY Code";

        StartingDate := CalcDate('<-CM>', WorkDate());
        EndingDate := Calcdate('<CM>', WorkDate());

        bDisplayByPartner := true;
        ResGrpFilter := 'STAGIAIRE|ASSISTANT';

        // // Hack pour POC
        // StartingDate := 20211001D;
        // EndingDate := 20211031D;
        // StartCumulDate := 20210101D;
    end;

    trigger OnPreReport()
    begin
        if "SBX Matter Header".GetFilters > '' then
            txtFilter := StrSubstNo(FilterTxt, "SBX Matter Header".GetFilters);

        // if PartnerFilter > '' then
        //     txtFilter += ' ' + PartnerFilter;

        SourceCodeSetup.Get();
    end;


    var
        recGLSetup_g: Record "General Ledger Setup";
        SourceCodeSetup: Record "Source Code Setup";
        bDisplayByPartner, bDisplayByResponsible, FirstLineHasBeenOutput : Boolean;
        codeCurrency: Code[10];
        PartnerFilter, ResGrpFilter : Code[250];
        EndingDate, StartingDate, StartCumulDate, WIPEndDate : Date;
        CurrencyFactor: Decimal;
        PreInvoiceAdjAmt, PreInvoiceExpenseAmt, PreInvoiceServiceAmt : Decimal;
        BilledAdjAmt, BilledExpenseAmt, BilledServiceAmt, ExpenseAsFeesAmt, WIPMatterAmt, BoniMaliCumulAmt, FeesModifiedAmt, ProvisionAmt : Decimal;
        FilterTxt: Label 'Filtre : %1', Comment = 'FRA = Filtre : %1';
        ReportPeriodLbl: Label 'Période : %1.. %2', Comment = 'FRA = Période facturation : %1.. %2 - Date début cumul : %3';
        ERR_ENDDATE: Label 'Vous devez sélectionner une période de facturation.', Comment = 'FRA = Vous devez sélectionner une période de facturation.';
        DpmtSalesLine, txtFilter : Text;
        txtDimCode_g: array[8] of Text[30];
        txtDimValue_g: array[8] of Text[50];
        ErrGrpRes: Label 'Ce champ ne peut pas être vide', Comment = 'Ce champ ne peut pas être vide';
        LastVersionNo: Integer;


    procedure SetRequestProperties(_BeginningDate: Date; _ClosingDate: Date; _FilterPartner: Code[150])
    begin
        StartingDate := _BeginningDate;
        EndingDate := _ClosingDate;
        PartnerFilter := _FilterPartner;
    end;

    local procedure ClearElements()
    begin
        // Clear();
    end;
}

