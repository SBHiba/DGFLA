report 50001 "DGF Time Entries Follow-Up"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50001-Time Entries Follow-Up.rdlc';
    Caption = 'Time Entries Follow-Up', Comment = 'FRA="Suivi des heures"';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    AdditionalSearchTerms = 'DGFLA';
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = sorting("Resource Group No.") where(Type = const(Person), Blocked = const(false));
            RequestFilterFields = "No.", "Resource Group No.", "Use Time Sheet", "SBX Inactive";

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(OptionCalendarDisplay; oDisplayCalendar_g)
            { }
            column(ReportFilter; txtFilter_g)
            { }
            column(IncludeNonBillable; IncludeNonBillable)
            { }
            column(Resource_No; Resource."No.")
            {
                IncludeCaption = true;
            }
            column(ResCardHyperlink; ResCardHyperlink)
            { }
            column(Resource_Name; Resource.Name)
            { }
            column(Resource_JobTitle; Resource."Job Title")
            { }
            column(Resource_Dpmt; CodeDpmtAnalytics_g)
            { }
            column(StartDate; DateStartingPeriod_g)
            { }
            column(EndDate; DateEndingPeriod_g)
            { }
            column(DisplayOrder; ResourceGroup."SBX Name 2")
            { }
            column(Unit_Price; "Unit Price")
            { }


            dataitem(DateTable; Date)
            {
                DataItemTableView = sorting("Period Type", "Period Start") where("Period Type" = const(week));
                column(StartingPeriodDate; DateTable."Period Start")
                { }
                column(EndingPeriodDate; DateTable."Period End")
                { }
                column(PlanningDay; txtPlanningDay_g)
                { }
                column(PlanningWeek; txtPlanningWeek_g)
                { }
                column(PlanningMonth; txtPlanningMonth_g)
                { }
                column(PlanningYear; txtPlanningYear_g)
                { }
                column(CapacityWeekQty; CapacityWeekQty) // Budget
                { }
                column(BaseQty; WeeklyBaseQty) // Base 1400 H ramené à la semaine
                { }
                column(MinWorkingWeek_Hours; MinWorkingWeek_g) // Seuil rentabilité semaine
                { }
                column(MLE_Qty; decQty_g)
                { }
                column(AbsQty; AbsQty)
                { }


                trigger OnPreDataItem()
                begin
                    DateTable.SetRange("Period Start", DateStartingPeriod_g, DateEndingPeriod_g);
                end;

                trigger OnAfterGetRecord()
                var
                    recMatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                    recAbsenceEntry_L: Record "Employee Absence";
                    MatterHeader_L: Record "SBX Matter Header";

                begin
                    txtPlanningDay_g := Format(DateTable."Period Start", 0, '<WeekDay Text>');
                    txtPlanningWeek_g := WeekInitiale + Format(DateTable."Period Start", 0, '<Week>');
                    txtPlanningMonth_g := Format(DateTable."Period Start", 0, '<Month Text>');
                    txtPlanningYear_g := Format(DateTable."Period Start", 0, '<Year4>');

                    // Matter Ledger Entry
                    Clear(decQty_g);
                    recMatterLedgerEntry_L.SetCurrentKey("Planning Date", Status, "Matter No.", Type, "No.", "Action Code");
                    recMatterLedgerEntry_L.SetRange("Planning Date", DateTable."Period Start", DateTable."Period End");
                    recMatterLedgerEntry_L.SetRange(Type, recMatterLedgerEntry_L.Type::Resource);
                    recMatterLedgerEntry_L.SetRange("No.", Resource."No.");
                    recMatterLedgerEntry_L.SetRange("Matter Entry Type", recMatterLedgerEntry_L."Matter Entry Type"::Service);
                    // if not IncludeNonBillable then ==> inclure le non facturable, mais exclure les dossiers non facturable (Bureau)
                    //     recMatterLedgerEntry_L.SetRange("Non Billable", false);
                    recMatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                    recMatterLedgerEntry_L.SetRange("DGF Out of Procedure", false);
                    recMatterLedgerEntry_L.SetRange("Matter Type", recMatterLedgerEntry_L."Matter Type"::Chargeable);
                    if recMatterLedgerEntry_L.FindSet() then
                        repeat
                            // MatterHeader_L.Get(recMatterLedgerEntry_L."Matter No.");
                            // if MatterHeader_L."Matter Type" = MatterHeader_L."Matter Type"::Chargeable then
                            decQty_g += recMatterLedgerEntry_L.Quantity;
                        until recMatterLedgerEntry_L.Next() = 0;

                    // Absence Entry
                    // Clear(AbsQty);
                    // if not bSkipAbsenceEntries then begin
                    //     recAbsenceEntry_L.SetCurrentKey("Employee No.", "From Date");
                    //     recAbsenceEntry_L.SetRange("SBX Ress. No.", Resource."No.");
                    //     recAbsenceEntry_L.SetRange("From Date", DateTable."Period Start", DateTable."Period End");
                    //     if recAbsenceEntry_L.FindSet then
                    //         repeat
                    //             if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                    //                 Error(NoDaylyAbsenceEntries);
                    //             AbsQty += recAbsenceEntry_L."Quantity (Base)" * recMatterSetup_g."Nb of Hours Worked";
                    //         until recAbsenceEntry_L.Next = 0;
                    // end;

                    // Valeur initialisation depuis le début de l'année 
                    Clear(InitBillableQty);
                    Clear(InitCapacityWeekQty);
                    Clear(InitWeeklyBaseQty);
                    Clear(InitMinWorkingWeek);

                    if (not FirstLineHasBeenOutput) and InitializeCumulative then begin
                        // Matter Ledger Entry    
                        recMatterLedgerEntry_L.SetCurrentKey("Planning Date", Status, "Matter No.", Type, "No.", "Action Code");
                        recMatterLedgerEntry_L.SetRange("Planning Date", CalcDate('<-CY>', DateStartingPeriod_g), CalcDate('<-1D>', DateStartingPeriod_g));
                        recMatterLedgerEntry_L.SetRange(Type, recMatterLedgerEntry_L.Type::Resource);
                        recMatterLedgerEntry_L.SetRange("No.", Resource."No.");
                        recMatterLedgerEntry_L.SetRange("Matter Entry Type", recMatterLedgerEntry_L."Matter Entry Type"::Service);
                        // if not IncludeNonBillable then
                        //     recMatterLedgerEntry_L.SetRange("Non Billable", false);
                        recMatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                        recMatterLedgerEntry_L.SetRange("DGF Out of Procedure", false);
                        if recMatterLedgerEntry_L.FindSet() then
                            repeat
                                MatterHeader_L.Get(recMatterLedgerEntry_L."Matter No.");
                                if MatterHeader_L."Matter Type" = MatterHeader_L."Matter Type"::Chargeable then
                                    InitBillableQty += recMatterLedgerEntry_L.Quantity;
                            until recMatterLedgerEntry_L.Next() = 0;

                        InitCapacityWeekQty := (DateTable."Period No." - 1) * CapacityWeekQty;
                        InitWeeklyBaseQty := (DateTable."Period No." - 1) * WeeklyBaseQty;
                        InitMinWorkingWeek := (DateTable."Period No." - 1) * MinWorkingWeek_g;

                        FirstLineHasBeenOutput := true;
                    end;
                end;
            }

            trigger OnPreDataItem()
            var
                DateTable_L: Record Date;
            begin
                txtFilter_g := Resource.GetFilters;
                DateTable_L.SetRange("Period Type", DateTable_L."Period Type"::Week);
                DateTable_L.SetRange("Period Start", DateStartingPeriod_g);
                if DateTable_L."Period No." <> 1 then
                    InitializeCumulative := true;
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

                ResCardHyperlink := GetUrl(CurrentClientType, CompanyName, ObjectType::"Page", page::"Resource Card", Resource, false);

                FirstLineHasBeenOutput := false;

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
                    field(oDisplayCalendar_g; oDisplayCalendar_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display Period';
                        OptionCaption = 'Day,Week,Month,Quarter,Year';
                        Enabled = false;
                    }
                    field(" DateStartingPeriod_g"; DateStartingPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            if DateStartingPeriod_g = 0D then
                                Error(Missing_Date);

                            case oDisplayCalendar_g of
                                oDisplayCalendar_g::Day:
                                    DateEndingPeriod_g := CalcDate('<CW>', DateStartingPeriod_g);

                                oDisplayCalendar_g::Week:
                                    begin
                                        DateStartingPeriod_g := CalcDate('<-CW>', DateStartingPeriod_g);
                                        DateEndingPeriod_g := CalcDate('<CW>', DateStartingPeriod_g);
                                    end;

                                oDisplayCalendar_g::Month:
                                    begin
                                        DateStartingPeriod_g := CalcDate('<-CM>', DateStartingPeriod_g);
                                        DateEndingPeriod_g := CalcDate('<CM>', DateStartingPeriod_g);
                                    end;

                                oDisplayCalendar_g::Quarter:
                                    DateEndingPeriod_g := CALCDATE('<CQ>', DateStartingPeriod_g);

                                oDisplayCalendar_g::Year:
                                    DateEndingPeriod_g := CalcDate('<CY>', DateStartingPeriod_g)
                            end;
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

                            case oDisplayCalendar_g of
                                oDisplayCalendar_g::Day:
                                    DateEndingPeriod_g := CalcDate('<CW>', DateEndingPeriod_g);

                                oDisplayCalendar_g::Week:
                                    DateEndingPeriod_g := CalcDate('<CW>', DateEndingPeriod_g);

                                oDisplayCalendar_g::Month:
                                    DateEndingPeriod_g := CalcDate('<CM>', DateEndingPeriod_g);

                                oDisplayCalendar_g::Quarter:
                                    DateEndingPeriod_g := CALCDATE('<CM>', DateEndingPeriod_g);

                                oDisplayCalendar_g::Year:
                                    DateEndingPeriod_g := CalcDate('<CY>', DateEndingPeriod_g)
                            end;

                        end;
                    }

                    field(IncludeNonBillable; IncludeNonBillable)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Visible = false;
                        Caption = 'Include non billable', comment = 'FRA="Inclure non facturable"';
                    }

                    field(CapacityWeekQty; CapacityWeekQty)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Weekly Budget', Comment = 'FRA = Budget hebdo.';
                    }

                    field(WeeklyBaseQty; WeeklyBaseQty)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Weekly Base Hours', Comment = 'FRA = Base heures (semaine)';
                    }

                    field(MinWorkingWeek; MinWorkingWeek_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Min. qty of hours to be completed', Comment = 'FRA= Nbre d''heures min. à effecturer';
                    }
                }
            }
        }

        actions
        { }

        trigger OnInit()
        begin
            IncludeNonBillable := true;
        end;

    }

    labels
    {
        ReportTitle = 'Time entries Follow-Up by Resource', Comment = 'FRA = Suivi des heures par ressource';
        PageCaption = 'Page';
        Period = 'Period';
        FilterCaption = 'Filter';
        TimeKeeperCaption = 'Timekeeper';
        JobTitleCaption = 'Job Title';
        DpmtCaption = 'Department';
        DayCAption = 'Day';
        WeekCaption = 'Week';
        MonthCaption = 'Month';
        QuarterCaption = 'Quarter';
        YearCaption = 'Year';
        Total = 'Total';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;
        CapacityWeekQtyLbl = 'Budget', Comment = 'FRA = Budget';
        ProducedLbl = 'Produced', comment = 'FRA = Réalisé';
        WeeklyGapLbl = 'Weekly Gap', Comment = 'FRA = Ecart / sem.';
        CumulativeProdLbl = 'Cumulative Produced', comment = 'FRA = Cumul réalisé';
        CumulativeCapdLbl = 'Cumulative BUdget', Comment = 'FRA = Cumul Budget';
        CumulativeGapLbl = 'Cumulative Gap', Comment = 'FRA = Cumul écart';
        ProdRateLbl = 'Produced Rate', Comment = 'FRA = Taux réalisé';
        YearlyBaseLbl = 'Yearly Base Qty', Comment = 'FRA = Base 1400 h';
        CumulativeMinProfitQtyLbl = 'Cumulative profit threshold', Comment = 'FRA="Cumul Seuil rentabilité"';
        AllResourceLbl = 'Pour l''ensemble des ressources', comment = 'FRA="Pour l''ensemble des ressources"';
        OutOfProcMentionLbl = 'Les heures "hors procédure" ne sont pas prises en compte', Comment = 'FRA="Les heures "hors procédure" ne sont pas prises en compte"';
        NonBillableMentionLbl = 'Les heures des dossiers non facturables ne sont pas prises en compte', Comment = 'FRA="Les heures des dossiers non facturables ne sont pas prises en compte"';
        OnlyBillableMentionLbl = 'Seules les heures facturables sont prises en compte', Comment = 'FRA="Seules les heures facturables sont prises en compte"';
    }


    trigger OnInitReport()
    var
        UnitMeasure_L: Record "Unit of Measure";
        HRSetup_L: Record "Human Resources Setup";

    begin
        recMatterSetup_g.Get();
        recMatterSetup_g.TestField("Nb of Hours Worked");
        recMatterSetup_g.TestField("Dept Dimension Code");

        DGFLASetup.Get();
        MinWorkingWeek_g := DGFLASetup."Weekly Profit. Threshold (Qty)";
        CapacityWeekQty := DGFLASetup."Weekly Capacity (Qty)";
        WeeklyBaseQty := DGFLASetup."Weekly Base (Qty)";
        oDisplayCalendar_g := oDisplayCalendar_g::Week;

        // HRSetup_L.Get;
        // HRSetup_L.TestField(HRSetup_L."Base Unit of Measure");
        // if UnitMeasure_L.Get(HRSetup_L."Base Unit of Measure") then begin
        //     if UnitMeasure_L."SBX Time Type" <> UnitMeasure_L."SBX Time Type"::"Worked Days" then begin
        //         Message(txtWarningAbsence);
        //         bSkipAbsenceEntries := true;
        //     end;
        // end else
        //     bSkipAbsenceEntries := true;

        // Hack POC pour la période 
        // DateStartingPeriod_g := CalcDate('<-CW>', 20210920D);
        // DateEndingPeriod_g := CalcDate('<CW>', 20211017D);
    end;

    trigger OnPreReport()
    begin
        if (DateStartingPeriod_g = 0D) or (DateEndingPeriod_g = 0D) then
            Error(Missing_Date);
    end;

    trigger OnPostReport()
    begin
    end;

    var
        recMatterSetup_g: Record "SBX Matter Setup";
        DGFLASetup: Record "DGF Setup";
        ResourceGroup: Record "Resource Group";
        bSkipAbsenceEntries, InitializeCumulative, FirstLineHasBeenOutput, IncludeNonBillable : Boolean;
        DateEndingPeriod_g, DateStartingPeriod_g : Date;
        AbsQty, WeeklyBaseQty, InitWeeklyBaseQty, decQty_g, InitBillableQty : Decimal;
        MinWorkingWeek_g, InitMinWorkingWeek, CapacityWeekQty, InitCapacityWeekQty : Decimal;
        txtWarningAbsence: Label 'Absence entries are not present, for the Absence Base unit of Measeure is not of type Working Day.';
        NoDaylyAbsenceEntries: Label 'Absence not entered per day, please start processing to split the absence into a daily entries', Comment = 'FRA = Absence non saisie par jour, veuillez lancer le traitement pour transformer les absence en écritures quotidiennes';
        Missing_Date: Label 'Start and end dates are mandatory.', Comment = 'FRA = Les dates de début et de fin sont obligatoires.';
        WeekInitiale: Label 'W', Comment = 'FRA = S';
        oDisplayCalendar_g: Option Day,Week,Month,Quarter,Year;
        ResCardHyperlink: Text;
        txtPlanningWeek_g: Text[4];
        txtPlanningYear_g: Text[4];
        txtPlanningDay_g: Text[20];
        txtPlanningMonth_g: Text[20];
        CodeDpmtAnalytics_g: Text[30];
        NameDpmtAnalytics: Text[50];
        txtFilter_g: Text;
}

