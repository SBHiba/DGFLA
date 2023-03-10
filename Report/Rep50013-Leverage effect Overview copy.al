report 50013 "DGF Leverage effect Overview2"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50013-Leverage effect Overview copy.rdlc';
    Caption = 'Leverage effect Overview Copy', Comment = 'Tableau Effet de levier';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = sorting("Resource Group No.") where(Type = const(Person), Blocked = const(false));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Resource Group No.";

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(ReportFilter; txtFilter_g)
            { }
            column(YearlyBaseQty; YearlyBaseQty)
            { }
            column(StartDate; DateStartingPeriod_g)
            { }
            column(EndDate; DateEndingPeriod_g)
            { }
            column(PartnerGrp; PartnerGrp)
            { }
            column(TraineeGrp; TraineeGrp)
            { }

            column(Resource_No; Resource."No.")
            { }
            column(Resource_Name; Resource.Name)
            { }
            column(Resource_JobTitle; Resource."Job Title")
            { }
            column(Resource_Dpmt; CodeDpmtAnalytics_g)
            { }
            column(DisplayOrder; ResourceGroup."SBX Name 2")
            { }
            column(Unit_Price; "Unit Price")
            { }



            dataitem("SBX Matter Ledger Entry"; "SBX Matter Ledger Entry")
            {
                DataItemTableView = sorting("Matter Entry Type", "Matter No.", Type, "No.") where("Matter Entry Type" = const(Service)
                                                                                                , "Closed by Ledger Entry No." = const(0)
                                                                                                , Type = const(Resource)
                                                                                                , "Non Billable" = const(false)
                                                                                                );
                DataItemLink = "No." = field("No.");

                column(Quantity; Quantity)
                { }
                column(Reference_Amount; "Reference Amount")
                { }
                column(Resource_Group_No_; "Resource Group No.")
                { }
                column(Partner_No_; "Partner No.")
                { }
                column(PartnerRate; decQty)
                { }
                column(PartnerFilter; PartnerFilter)
                { }

                trigger OnPreDataItem()
                begin
                    // Eval avec etat = 0,1,2
                    "SBX Matter Ledger Entry".SetRange("Planning Date", DateStartingPeriod_g, DateEndingPeriod_g);
                    "SBX Matter Ledger Entry".SetRange("Write Off", false);

                    // if PartnerFilter <> '' then
                    //     SetRange("Partner No.", PartnerFilter);

                    // Filtrer les ??critures pour ne r??cup??rer que les saisies via feuille de temps (et exclure les ajouts de temps ?? partir de la facturation)
                    // "SBX Matter Ledger Entry".SetFilter("Matter Journal Batch User ID", '<>%1', ''); ==> ne fonctionne pas avec les imports Lamy
                    // "SBX Matter Ledger Entry".SetFilter("Matter Journal Template Name", '<>%1', ''); ==> ne fonctionne pas avec les imports Lamy
                    // SetFilter("Source Code", '<>%1', SourceCodeSetup.Sales);
                    //SetRange("Matter Type", "SBX Matter Ledger Entry"."Matter Type"::Chargeable);
                end;

                trigger OnAfterGetRecord()
                var
                    Resource_L: Record Resource;
                begin
                    Resource_L.Get("Partner No.");
                    decQty := Resource_L."Unit Price";
                end;

            }

            trigger OnPreDataItem()
            begin
                // Utilisateur avec PTA, PTB PTNER et AS
                Resource.SetFilter("Resource Group No.", '%1|%2', PartnerGrp, CollabGrp);
                txtFilter_g := Resource.GetFilters;
            end;

            trigger OnAfterGetRecord()
            var
                DefaultDim_L: Record "Default Dimension";
                DimensionValue_L: Record "Dimension Value";
            begin
                Clear(CodeDpmtAnalytics_g);
                Clear(NameDpmtAnalytics);
                if Resource."SBX Termination Date" <> 0D then
                    if Resource."SBX Termination Date" < DateStartingPeriod_g then
                        CurrReport.Skip;

                if Resource."Employment Date" <> 0D then
                    if Resource."Employment Date" > DateEndingPeriod_g then
                        CurrReport.Skip;

                DefaultDim_L.SetRange("Table ID", Database::Resource);
                DefaultDim_L.SetRange("Dimension Code", recMatterSetup_g."Dept Dimension Code");
                DefaultDim_L.SetRange("No.", "No.");
                if DefaultDim_L.FindFirst then begin
                    DimensionValue_L.Get(recMatterSetup_g."Dept Dimension Code", DefaultDim_L."Dimension Value Code");
                    CodeDpmtAnalytics_g := DefaultDim_L."Dimension Value Code";
                    NameDpmtAnalytics := DimensionValue_L.Name;
                end;

                If "Resource Group No." <> '' then
                    ResourceGroup.Get("Resource Group No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(MandatoryInfoGrp)
                {
                    Caption = 'Option';
                    field(" DateStartingPeriod_g"; DateStartingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            if DateStartingPeriod_g = 0D then
                                Error(Missing_Date);

                            // DateStartingPeriod_g := CalcDate('<-CY>', DateStartingPeriod_g);
                            // DateEndingPeriod_g := CalcDate('<CY>', DateStartingPeriod_g);
                        end;
                    }
                    field(DateEndingPeriod_g; DateEndingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if DateEndingPeriod_g = 0D then
                                Error(Missing_Date);
                        end;
                    }

                    field(YearlyBaseQty; YearlyBaseQty)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Base Hours (year)', Comment = 'Base Heures (ann??e)';

                        trigger OnValidate()
                        begin
                            if YearlyBaseQty = 0 then
                                Error(NoNullValueErr);
                        end;
                    }
                    field(PartnerFilter; PartnerFilter)
                    {
                        ShowMandatory = false;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Associ?? responsable';
                        TableRelation = Resource."No." where("SBX Resource Type" = const(Partner));

                        trigger OnValidate()
                        begin
                        end;
                    }

                    field(PartnerGrp; PartnerGrp)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Partner Group', Comment = 'Groupe Associ??';
                        TableRelation = "Resource Group"."No.";
                        Visible = false;
                    }

                    field(TraineeGrp; TraineeGrp)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Trainee Group', Comment = 'Groupe Stagiaire';
                        TableRelation = "Resource Group"."No.";
                        Visible = false;
                    }
                }
            }
        }
    }

    labels
    {
        ReportTitle = 'Occupancy rate of lawyers (partners and associates) by Partner', Comment = 'Taux d''occupation des avocats (associ??s et collab.) par associ??';
        PageCaption = 'Page';
        Period = 'Period:';
        FilterCaption = 'Filter:';
        TimeKeeperCaption = 'Timekeeper';
        JobTitleCaption = 'Job Title';
        DpmtCaption = 'Department';
        Total = 'Total';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;
        CapacityWeekQtyLbl = 'Budget', Comment = 'FRA = Budget';
        ProducedLbl = 'Produced', comment = 'FRA = R??alis??';
        WeeklyGapLbl = 'Weekly Gap', Comment = 'FRA = Ecart / sem.';
        CumulativeProdLbl = 'Cumulative Produced', comment = 'Cumul r??alis??';
        CumulativeCapdLbl = 'Cumulative BUdget', Comment = 'Cumul Budget';
        CumulativeGapLbl = 'Cumulative Gap', Comment = 'Cumul ??cart';
        ProdRateLbl = 'Produced Rate', Comment = 'Taux r??alis??';
        YearlyBaseLbl = 'Yearly Base Qty', Comment = 'Base 1400 h';
        CumulativeMinProfitQtyLbl = 'Cumulative profit threshold', Comment = 'Cumul Seuil rentabilit??';
    }


    trigger OnInitReport()
    begin
        DGFLASetup.Get();
        YearlyBaseQty := DGFLASetup."Yearly Base (Qty)";

        SourceCodeSetup.Get();

        PartnerGrp := 'ASSOCIE';
        TraineeGrp := 'STAGIAIRE';
        CollabGrp := 'AVOCAT';

        // // Hack pour la p??riode du POC
        // DateStartingPeriod_g := 20210101D;
        // DateEndingPeriod_g := 20211231D;
    end;

    trigger OnPreReport()
    begin
        if (DateStartingPeriod_g = 0D) or (DateEndingPeriod_g = 0D) then
            Error(Missing_Date);
        if YearlyBaseQty = 0 then
            Error(NoNullValueErr);
    end;


    var
        recMatterSetup_g: Record "SBX Matter Setup";
        DGFLASetup: Record "DGF Setup";
        ResourceGroup: Record "Resource Group";
        SourceCodeSetup: Record "Source Code Setup";
        DateEndingPeriod_g, DateStartingPeriod_g : Date;
        YearlyBaseQty, decQty : Decimal;
        Missing_Date: Label 'Start and end dates are mandatory.', Comment = 'Les dates de d??but et de fin sont obligatoires.';
        NoNullValueErr: Label 'Null value are not allowed.', Comment = 'La valeur nulle n''est pas autoris??e';
        PartnerGrp, TraineeGrp, CollabGrp : Code[50];
        CodeDpmtAnalytics_g: Text[30];
        NameDpmtAnalytics: Text[50];
        txtFilter_g: Text;
        PartnerFilter: Code[20];
}

