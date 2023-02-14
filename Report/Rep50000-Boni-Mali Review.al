/* Comment
End Comment */

report 50000 "DGF Boni-Mali Review"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50000-Boni-Mali Review.rdlc';
    Caption = 'Tableau Boni/Mali', Comment = 'Boni/Mali Review';
    Permissions = TableData "Sales Header Archive" = R, TableData "Sales Line Archive" = R;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem("SBX Matter Header"; "SBX Matter Header")
        {
            DataItemTableView = sorting("Sell-to Customer No.", "Partner No.", Status);
            RequestFilterFields = "Sell-to Customer No.";
            CalcFields = "Partner Name", "Responsible Name";

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(PeriodCaption; StrSubstNo(ReportPeriodLbl, StartingDate, EndingDate, StartCumulDate))
            { }
            column(StartBillingPeriod; StartingDate)
            { }
            column(EndBillingPeriod; EndingDate)
            { }
            column(StartCumulPeriod; StartCumulDate)
            { }
            column(WIPEndDate; WIPEndDate)
            { }
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


            // Wip before billing 
            column(PreInvoiceServiceAmt; PreInvoiceServiceAmt + PreInvoiceAdjAmt) // Montant Honos Préfacturation
            { }
            column(PreInvoiceExpenseAmt; PreInvoiceExpenseAmt) // Montant Frais Préfacturation
            { }

            // Billed
            column(BilledServiceAmt; BilledServiceAmt + BilledAdjAmt) // Montant Honos Facturé
            { }
            column(BilledExpenseAmt; BilledExpenseAmt) // Montant Frais Facturé
            { }
            column(BilledExpenseAsFeesAmt; ExpenseAsFeesAmt) // Montant Frais passé en Honoraire
            { }
            column(FeesModifiedAmt; FeesModifiedAmt) // Montant Honos tranformés
            { }

            // Postponed WIP
            column(WIPMatterAmt; WIPMatterAmt) // Montant Report => Planning Date < Début période facturation et Posting Date < Fin Période facturation, document Date < Fin période facturation
            { }

            // Cumul Boni-Mali
            column(BoniMaliCumulAmt; BoniMaliCumulAmt) // Montant cumul Boni/Mali
            { }

            // Provision
            column(ProvisionAmt; ProvisionAmt)
            { }


            trigger OnPreDataItem() // dataitem "Matter Header"
            begin
                // SetRange("Planning Date Filter", 0D, StartindDate);
                // SetRange("Posting Date Filter", 0D, EndingDate);
                // SetRange("Document Date Filter", 0D, EndingDate);
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Ending Date", '%1|>%2', 0D, CalcDate('<-3M>', StartingDate));

                FirstLineHasBeenOutput := false;
            end;


            trigger OnAfterGetRecord()
            var
                SaleslineArchive_L: Record "Sales line Archive";
                SalesHeaderArchive_L: Record "Sales Header Archive";
                SalesInvoiceLine_L: Record "Sales Invoice Line";
                SalesCrMemoLine_L: Record "Sales Cr.Memo Line";
                SalesInvoiceHeader_L: Record "Sales Invoice Header";
                MatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                MatterValueEntry_L: Record "SBX Matter Value Entry";
                MatterPrepaymentEntry_L: Record "SBX Matter Prepayment Entry";
                MatterRegister_L: Record "SBX Matter Register";

            begin
                // if FirstLineHasBeenOutput then ClearElements();

                // Calcul Montants préfacturation (en se basant sur les Sales Line Archive)
                PreInvoiceServiceAmt := 0;
                PreInvoiceAdjAmt := 0;
                PreInvoiceExpenseAmt := 0;
                WIPMatterAmt := 0;
                WIPEndDate := 0D;
                SaleslineArchive_L.Reset();
                SaleslineArchive_L.SetCurrentKey("SBX Matter No.");
                SaleslineArchive_L.SetRange("SBX Matter No.", "Matter No.");
                SaleslineArchive_L.SetRange("Document Type", SaleslineArchive_L."Document Type"::Invoice);
                SaleslineArchive_L.SetRange("Doc. No. Occurrence", 1);
                SaleslineArchive_L.SetRange("Shipment Date", StartingDate, EndingDate);
                SaleslineArchive_L.SetFilter("SBX Matter Ledger Entry No.", '<>0'); // => SA : ne prendre que les lignes avec un N° MLE, car non saisi lors de la facturation  
                // SaleslineArchive_L.SetRange(SystemCreatedAt, CreateDateTime(StartindDate, ''), CreateDateTime(EndingDate,''));
                SaleslineArchive_L.SetFilter(Type, '<>%1', SaleslineArchive_L.Type::" ");

                if SaleslineArchive_L.FindSet() then
                    repeat
                        // Détermination du Dernier N° d'archive
                        LastVersionNo := 1;
                        SalesHeaderArchive_L.Get(SalesHeaderArchive_L."Document Type"::Invoice, SaleslineArchive_L."Document No.", 1, 1);
                        SalesHeaderArchive_L.CalcFields("No. of Archived Versions");
                        LastVersionNo := SalesHeaderArchive_L."No. of Archived Versions";
                        CurrencyFactor := 1;

                        if LastVersionNo = SaleslineArchive_L."Version No." then begin
                            SalesHeaderArchive_L.Get(SalesHeaderArchive_L."Document Type"::Invoice, SaleslineArchive_L."Document No.", 1, LastVersionNo);

                            if SalesHeaderArchive_L."Date Archived" > WIPEndDate then
                                WIPEndDate := SalesHeaderArchive_L."Date Archived";
                            //     if SaleslineArchive_L."SBX Planning Date" > WIPEndDate then
                            //         WIPEndDate := SaleslineArchive_L."SBX Planning Date";

                            if SalesHeaderArchive_L."Currency Factor" <> 0 then
                                CurrencyFactor := SalesHeaderArchive_L."Currency Factor";

                            case SaleslineArchive_L."SBX Matter Entry Type" of
                                // SaleslineArchive_L."SBX Matter Entry Type"::Adjustment,
                                SaleslineArchive_L."SBX Matter Entry Type"::Service:
                                    PreInvoiceServiceAmt += SaleslineArchive_L."SBX Reference Amount" / CurrencyFactor;

                                SaleslineArchive_L."SBX Matter Entry Type"::Expense,
                                SaleslineArchive_L."SBX Matter Entry Type"::"3",
                                SaleslineArchive_L."SBX Matter Entry Type"::"External Expense":
                                    PreInvoiceExpenseAmt += SaleslineArchive_L."SBX Reference Amount" / CurrencyFactor;

                            // SaleslineArchive_L."SBX Matter Entry Type"::" ":
                            //     begin
                            //         case SaleslineArchive_L."SBX Apply Matter Prepayment" of
                            //             SaleslineArchive_L."SBX Apply Matter Prepayment"::Service:
                            //                 PreInvoiceServiceAmt += SaleslineArchive_L."SBX Reference Amount";

                            //             SaleslineArchive_L."SBX Apply Matter Prepayment"::Expense:
                            //                 PreInvoiceExpenseAmt += SaleslineArchive_L."SBX Reference Amount";

                            //             else
                            //                 PreInvoiceAdjAmt += SaleslineArchive_L."SBX Reference Amount";
                            //         end;
                            //     end;
                            end;

                            // // Calcul Montants Report 
                            // WIPMatterAmt := 0;
                            MatterLedgerEntry_L.Reset();
                            MatterLedgerEntry_L.SetRange("Entry No.", SaleslineArchive_L."SBX Matter Ledger Entry No.");
                            MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                            MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0); // ne pas prendre en compte si transfert !
                            MatterLedgerEntry_L.SetRange("Date Filter", 0D, EndingDate);
                            MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Expected) (LCY)");
                            if MatterLedgerEntry_L.FindSet() then
                                repeat
                                    if MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" <> 0 then
                                        WIPMatterAmt += MatterLedgerEntry_L."Reference Amount";
                                until MatterLedgerEntry_L.Next() = 0;

                        end;
                    until SaleslineArchive_L.Next() = 0;


                // // Calcul Montants préfacturation (en se basant sur les MLE)  -- INEXACT, car des temps du mois en cours peuvent être ajoutés à la proforma (facturation à date...)
                // PreInvoiceServiceAmt := 0;
                // PreInvoiceAdjAmt := 0;
                // PreInvoiceExpenseAmt := 0;
                // MatterLedgerEntry_L.Reset();
                // MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                // MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                // MatterLedgerEntry_L.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartingDate));
                // MatterLedgerEntry_L.SetRange("Planning Date", 0D, CalcDate('<-1D>', StartingDate));
                // MatterLedgerEntry_L.SetRange("Date Filter", 0D, CalcDate('<-1D>', StartingDate));
                // MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Expected) (LCY)");
                // if MatterLedgerEntry_L.FindSet() then
                //     repeat
                //         if MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" <> 0 then begin
                //             case MatterLedgerEntry_L."Matter Entry Type" of
                //                 MatterLedgerEntry_L."Matter Entry Type"::Service:
                //                     PreInvoiceServiceAmt += MatterLedgerEntry_L."Reference Amount";

                //                 MatterLedgerEntry_L."Matter Entry Type"::Expense,
                //                 MatterLedgerEntry_L."Matter Entry Type"::"3",
                //                 MatterLedgerEntry_L."Matter Entry Type"::"External Expense":
                //                     PreInvoiceExpenseAmt += MatterLedgerEntry_L."Reference Amount";
                //             end;
                //         end;
                //     until MatterLedgerEntry_L.Next() = 0;



                // Calcul Montants facturés (en se basant sur les Matter Ledger Entries) + Montants transformés
                BilledServiceAmt := 0;
                BilledExpenseAmt := 0;
                BilledAdjAmt := 0;
                ExpenseAsFeesAmt := 0;
                FeesModifiedAmt := 0;

                MatterValueEntry_L.Reset();
                MatterValueEntry_L.SetRange("Matter No.", "Matter No.");
                MatterValueEntry_L.SetRange("Posting Date", StartingDate, EndingDate);
                //MatterValueEntry_L.SetRange("Planning Date", 0D, EndigDate); //
                MatterValueEntry_L.SetRange("Document Date", StartingDate, EndingDate);
                MatterValueEntry_L.SetRange("Matter Ledg. Entry Type", MatterValueEntry_L."Matter Ledg. Entry Type"::Sales);
                if MatterValueEntry_L.FindSet() then
                    repeat
                        case MatterValueEntry_L."Matter Entry Type" of
                            MatterValueEntry_L."Matter Entry Type"::Service:
                                begin
                                    BilledServiceAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    // Vérifier Honos transformés (stagiaire, Assistantes, ...)
                                    if MatterValueEntry_L."Sales Amount (Actual) (LCY)" <> 0 then begin
                                        MatterLedgerEntry_L.Reset();
                                        MatterLedgerEntry_L.SetRange("Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                        MatterLedgerEntry_L.SetFilter("Resource Group No.", ResGrpFilter);
                                        if MatterLedgerEntry_L.FindFirst() then
                                            FeesModifiedAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                    end;

                                end;

                            MatterValueEntry_L."Matter Entry Type"::Adjustment:
                                BilledServiceAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";

                            MatterValueEntry_L."Matter Entry Type"::Expense,
                            MatterValueEntry_L."Matter Entry Type"::"3",
                            MatterValueEntry_L."Matter Entry Type"::"External Expense":
                                begin
                                    // Vérifier Calcul Frais transformés en hono                                    
                                    case MatterValueEntry_L."Document Type" of
                                        MatterValueEntry_L."Document Type"::"Credit Memo":
                                            begin
                                                SalesCrMemoLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                                SalesCrMemoLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                                SalesCrMemoLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                                SalesCrMemoLine_L.FindFirst();
                                                if SalesCrMemoLine_L."SBX Cost Switch Service" then begin
                                                    BilledServiceAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                                    ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                                end else
                                                    BilledExpenseAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                            end;

                                        MatterValueEntry_L."Document Type"::Invoice:
                                            begin
                                                SalesInvoiceLine_L.SetRange("Document No.", MatterValueEntry_L."Document No.");
                                                SalesInvoiceLine_L.SetRange("Posting Date", MatterValueEntry_L."Posting Date");
                                                SalesInvoiceLine_L.SetRange("SBX Matter Ledger Entry No.", MatterValueEntry_L."Matter ledger Entry No.");
                                                SalesInvoiceLine_L.FindFirst();
                                                if SalesInvoiceLine_L."SBX Cost Switch Service" then begin
                                                    BilledServiceAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                                    ExpenseAsFeesAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                                end else
                                                    BilledExpenseAmt += MatterValueEntry_L."Sales Amount (Actual) (LCY)";
                                            end;
                                    end;

                                end;
                        end;
                    until MatterValueEntry_L.Next() = 0;


                // // Calcul Montants Report (en se basant sur la Matter Ledger Entry) ==> Ne fontionne pas, car on ignore les diligences qui sont ds la préfacturation !
                // WIPMatterAmt := 0;
                // MatterLedgerEntry_L.Reset();
                // MatterLedgerEntry_L.SetRange("Matter No.", "Matter No.");
                // MatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                // MatterLedgerEntry_L.SetRange("Posting Date", 0D, EndingDate);
                // MatterLedgerEntry_L.SetRange("Planning Date", 0D, CalcDate('<-1D>', StartingDate));
                // MatterLedgerEntry_L.SetRange("Date Filter", 0D, EndingDate);
                // MatterLedgerEntry_L.SetAutoCalcFields("Sales Amount (Expected) (LCY)");
                // if MatterLedgerEntry_L.FindSet() then
                //     repeat
                //         if MatterLedgerEntry_L."Sales Amount (Expected) (LCY)" <> 0 then
                //             WIPMatterAmt += MatterLedgerEntry_L."Reference Amount";
                //     until MatterLedgerEntry_L.Next() = 0;


                // Calcul montant provision
                ProvisionAmt := 0;
                MatterPrepaymentEntry_L.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                MatterPrepaymentEntry_L.SetRange("Matter No.", "Matter No.");
                MatterPrepaymentEntry_L.SetRange("Posting Date", StartingDate, EndingDate);
                if MatterPrepaymentEntry_L.FindSet() then
                    repeat
                        ProvisionAmt += MatterPrepaymentEntry_L."Amount (LCY)";
                    until MatterPrepaymentEntry_L.Next() = 0;


                // récupérer le dossier si mouvement
                if (PreInvoiceExpenseAmt = 0)
                    and (PreInvoiceServiceAmt + PreInvoiceAdjAmt = 0)
                    and (BilledServiceAmt + BilledAdjAmt = 0)
                    and (BilledExpenseAmt = 0)
                    and (WIPMatterAmt = 0)
                // and (ProvisionAmt = 0)
                then
                    CurrReport.Skip();


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
                                    MatterRegister_L.SetCurrentKey("From Matter Led. Entry No.", "To Matter Ledg. Entry No.");
                                    MatterRegister_L.SetFilter("From Matter Led. Entry No.", '<=%1', MatterLedgerEntry_L."Entry No.");
                                    if MatterRegister_L.FindLast() then begin
                                        if MatterRegister_L."Source Code" = SourceCodeSetup.Sales then begin
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
                                    end;
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
                    Caption = 'Billing Period', comment = 'FRA = Période facturation';
                    field(StartindDate; StartingDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Date début';

                        trigger OnValidate()
                        begin
                            if StartingDate = 0D then
                                ERROR(ERR_ENDDATE);
                            EndingDate := CalcDate('<CM>', StartingDate);
                            StartCumulDate := CalcDate('<-CY>', StartingDate);
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

                    field(StartCumulDate; StartCumulDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Date début cumul';

                        trigger OnValidate()
                        begin
                            if StartCumulDate = 0D then
                                ERROR(ERR_ENDDATE);
                        end;
                    }
                }

                group(OthersOptionsGrp)
                {
                    Caption = 'Others Options';
                    Visible = false;

                    field(ResGrpFilter; ResGrpFilter)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Resource Group Filter', Comment = 'FRA = Filtre Groupe ressource';
                        TableRelation = "Resource Group"."No.";
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            if ResGrpFilter = '' then
                                Error(ErrGrpRes);
                        end;
                    }
                }
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
        Title = 'BONI/MALI REVIEW', Comment = 'FRA = TABLEAU BONI / MALI';
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
        FilterTxt: Label 'Filter: %1', Comment = 'FRA = Filtre : %1';
        ReportPeriodLbl: Label 'Billing period: %1.. %2 - Cumulative Sarting Date: %3', Comment = 'FRA = Période facturation : %1.. %2 - Date début cumul : %3';
        ERR_ENDDATE: Label 'You must define a billing period.', Comment = 'FRA = Vous devez sélectionner une période de facturation.';
        DpmtSalesLine, txtFilter : Text;
        txtDimCode_g: array[8] of Text[30];
        txtDimValue_g: array[8] of Text[50];
        ErrGrpRes: Label 'This field cannot be empty', Comment = 'Ce champ ne peut pas être vide';
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

