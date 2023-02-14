report 50114 "DGF Agenda Meeting 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50114-Agenda Meeting copy.rdlc';

    Caption = 'TEST SA', Comment = 'Réunion Agenda Collab.';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(Company; Company)
        {
            PrintOnlyIfDetail = true;


            column(Name; Name)
            { }

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
                column(Resource_No; Resource."No.")
                {
                    IncludeCaption = true;
                }
                column(ResCardHyperlink; ResCardHyperlink)
                { }
                column(ReportForecastViewHyperlink; ReportForecastViewHyperlink)
                { }
                column(Resource_Name; Resource.Name)
                { }
                column(Resource_JobTitle; Resource."Job Title")
                { }
                column(Resource_Dpmt; CodeDpmtAnalytics_g)
                { }
                column(MinDateYear; MinDateYear)
                { }
                column(DisplayOrder; ResourceGroup."SBX Name 2")
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Seniority_ResourceDGFLA; "DGF Seniority")
                { }
                column(Division_DGFLAResource; "DGF Division")
                { }


                dataitem(DateTable; Date)
                {
                    DataItemTableView = sorting("Period Type", "Period Start") where("Period Type" = const(week));

                    column(StartingPeriodDate;
                    DateTable."Period Start")
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
                    column(MLE_BillableQty; BillableQty)
                    { }
                    column(MLE_BillableQtyCumul; BillableQtyCumul)
                    { }
                    column(MLE_NotBillableQty; NotBillableQty)
                    { }
                    column(AbsenceDates4PreviousPeriod; AbsenceDates4PreviousPeriodTxt)
                    { }
                    column(AbsenceDates4NextPeriods; AbsenceDates4NextPeriodsTxt)
                    { }
                    column(PeriodComment; PeriodCommentTxt)
                    { }
                    column(MLE_NotBillableQtyCumul; NotBillableQtyCumul)
                    { }
                    column(AbsQty; AbsQty)
                    { }
                    column(AbsQtyCumul; AbsQtyCumul)
                    { }
                    column(NextForecastQty; NextForecastQty)
                    { }
                    column(NextForecastQtyBureau; NextForecastQtyBureau)
                    { }
                    column(ForecastQty; ForecastQty)
                    { }
                    column(ForecastQtyCumul; ForecastQtyCumul)
                    { }
                    column(WeekAverageBillableQty; WeekAverageBillableQty)
                    { }
                    column(MinDate4Cumul; MinDate4Cumul)
                    { }
                    column(WeekPeriodNo; WeekPeriodNo)
                    { }


                    trigger OnPreDataItem()
                    begin
                        DateTable.SetRange("Period Start", DateStartingPreviousPeriod_g);
                    end;


                    trigger OnAfterGetRecord()
                    var
                        recMatterLedgerEntry_L: Record "SBX Matter Ledger Entry";
                        SBXTimeSheetForecast_L: Record "SBX SBL TimeSheet Forecast";
                        recAbsenceEntry_L: Record "Employee Absence";
                        recMatter_L: Record "SBX Matter Header";
                        recCommentLine_L: Record "Comment Line";
                        EndPeriodAbsence_L, StartPeriodAbsence_L : Date;

                    begin
                        txtPlanningDay_g := Format(DateTable."Period Start", 0, '<WeekDay Text>');
                        txtPlanningWeek_g := WeekInitiale + Format(DateTable."Period Start", 0, '<Week>');
                        txtPlanningMonth_g := Format(DateTable."Period Start", 0, '<Month Text>');
                        txtPlanningYear_g := Format(DateTable."Period Start", 0, '<Year4>');

                        // Matter Ledger Entry
                        Clear(BillableQty);
                        Clear(NotBillableQty);
                        recMatterLedgerEntry_L.ChangeCompany(Company.Name);
                        recMatterLedgerEntry_L.SetCurrentKey("Planning Date", Status, "Matter No.", Type, "No.", "Action Code");
                        recMatterLedgerEntry_L.SetRange("Planning Date", DateTable."Period Start", DateTable."Period End");
                        recMatterLedgerEntry_L.SetRange(Type, recMatterLedgerEntry_L.Type::Resource);
                        recMatterLedgerEntry_L.SetRange("No.", Resource."No.");
                        recMatterLedgerEntry_L.SetRange("Matter Entry Type", recMatterLedgerEntry_L."Matter Entry Type"::Service);
                        recMatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                        // recMatterLedgerEntry_L.SetRange("DGF Out of Procedure", false); (dans et hors procédure)
                        if recMatterLedgerEntry_L.FindSet() then
                            repeat
                                if recMatterLedgerEntry_L."Non Billable" then begin
                                    if recMatterLedgerEntry_L."Sell-to Customer No." = InternalCustomerNo then
                                        NotBillableQty += recMatterLedgerEntry_L.Quantity;
                                end else
                                    BillableQty += recMatterLedgerEntry_L."Invoicing Quantity";
                            until recMatterLedgerEntry_L.Next = 0;

                        NotBillableQty := Round(NotBillableQty, 0.0001, '=');
                        BillableQty := Round(BillableQty, 0.0001, '=');

                        // Absence Entry for Dates
                        Clear(AbsQty);
                        AbsenceDates4PreviousPeriodTxt := '';
                        // if not bSkipAbsenceEntries then begin
                        recAbsenceEntry_L.ChangeCompany(Company.Name);
                        recAbsenceEntry_L.SetCurrentKey("Employee No.", "From Date");
                        recAbsenceEntry_L.SetRange("Employee No.", Resource."No.");
                        recAbsenceEntry_L.SetRange("From Date", DateTable."Period Start", DateTable."Period End"); // previous period
                        EndPeriodAbsence_L := 0D;
                        if recAbsenceEntry_L.FindSet() then
                            repeat

                                if EndPeriodAbsence_L <> 0D then begin
                                    if CalcDate('<+1D>', EndPeriodAbsence_L) = recAbsenceEntry_L."From Date" then
                                        EndPeriodAbsence_L := recAbsenceEntry_L."To Date"
                                    else begin
                                        if StartPeriodAbsence_L <> EndPeriodAbsence_L then
                                            AbsenceDates4PreviousPeriodTxt += ' au ' + Format(EndPeriodAbsence_L);
                                        EndPeriodAbsence_L := 0D;
                                    end;
                                end;

                                if EndPeriodAbsence_L = 0D then begin
                                    if AbsenceDates4PreviousPeriodTxt <> '' then
                                        AbsenceDates4PreviousPeriodTxt += '<br>';

                                    AbsenceDates4PreviousPeriodTxt += recAbsenceEntry_L.Description + ' du ' + format(recAbsenceEntry_L."From Date");
                                    StartPeriodAbsence_L := recAbsenceEntry_L."From Date";
                                    if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                                        AbsenceDates4PreviousPeriodTxt += ' au ' + Format(recAbsenceEntry_L."To Date")
                                    else
                                        if recAbsenceEntry_L."To Date" = recAbsenceEntry_l."From Date" then
                                            EndPeriodAbsence_L := recAbsenceEntry_L."To Date";
                                end;
                                AbsQty += recAbsenceEntry_L.Quantity * recMatterSetup_g."Nb of Hours Worked";
                            until recAbsenceEntry_L.Next = 0;
                        if (EndPeriodAbsence_L <> 0D) and (StartPeriodAbsence_L <> EndPeriodAbsence_L) then
                            AbsenceDates4PreviousPeriodTxt += ' au ' + Format(EndPeriodAbsence_L);

                        AbsQty := Round(AbsQty, 0.0001, '=');

                        recAbsenceEntry_L.Reset();
                        recAbsenceEntry_L.SetCurrentKey("Employee No.", "From Date");
                        recAbsenceEntry_L.SetRange("Employee No.", Resource."No.");
                        recAbsenceEntry_L.SetFilter("From Date", '<%1', DateTable."Period Start"); // previous period
                        recAbsenceEntry_L.SetFilter("To Date", '>=%1', DateTable."Period Start"); // previous period
                        EndPeriodAbsence_L := 0D;
                        if recAbsenceEntry_L.FindSet() then
                            repeat
                                if EndPeriodAbsence_L <> 0D then begin
                                    if CalcDate('<+1D>', EndPeriodAbsence_L) = recAbsenceEntry_L."From Date" then
                                        EndPeriodAbsence_L := recAbsenceEntry_L."To Date"
                                    else begin
                                        if StartPeriodAbsence_L <> EndPeriodAbsence_L then
                                            AbsenceDates4PreviousPeriodTxt += ' au ' + Format(EndPeriodAbsence_L);
                                        EndPeriodAbsence_L := 0D;
                                    end;
                                end;

                                if EndPeriodAbsence_L = 0D then begin
                                    if AbsenceDates4PreviousPeriodTxt <> '' then
                                        AbsenceDates4PreviousPeriodTxt += '<br>';
                                    AbsenceDates4PreviousPeriodTxt += recAbsenceEntry_L.Description + ' du ' + format(recAbsenceEntry_L."From Date");
                                    StartPeriodAbsence_L := recAbsenceEntry_L."From Date";
                                    if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                                        AbsenceDates4PreviousPeriodTxt += ' au ' + Format(recAbsenceEntry_L."To Date")
                                    else
                                        if recAbsenceEntry_L."To Date" = recAbsenceEntry_l."From Date" then
                                            EndPeriodAbsence_L := recAbsenceEntry_L."To Date";
                                end;
                            until recAbsenceEntry_L.Next = 0;
                        if (EndPeriodAbsence_L <> 0D) and (StartPeriodAbsence_L <> EndPeriodAbsence_L) then
                            AbsenceDates4PreviousPeriodTxt += ' au ' + Format(EndPeriodAbsence_L);



                        AbsenceDates4NextPeriodsTxt := '';
                        recAbsenceEntry_L.Reset();
                        recAbsenceEntry_L.SetCurrentKey("Employee No.", "From Date");
                        recAbsenceEntry_L.SetRange("Employee No.", Resource."No.");
                        recAbsenceEntry_L.SetRange("From Date", CurrDateStartingPeriod, CalcDate('<CM+3M>', CurrDateEndingPeriod)); // Next periods
                        EndPeriodAbsence_L := 0D;
                        if recAbsenceEntry_L.FindSet() then
                            repeat
                                if EndPeriodAbsence_L <> 0D then begin
                                    if CalcDate('<+1D>', EndPeriodAbsence_L) = recAbsenceEntry_L."From Date" then
                                        EndPeriodAbsence_L := recAbsenceEntry_L."To Date"
                                    else begin
                                        if StartPeriodAbsence_L <> EndPeriodAbsence_L then
                                            AbsenceDates4NextPeriodsTxt += ' au ' + Format(EndPeriodAbsence_L);
                                        EndPeriodAbsence_L := 0D;
                                    end;
                                end;

                                if EndPeriodAbsence_L = 0D then begin
                                    if AbsenceDates4NextPeriodsTxt <> '' then
                                        AbsenceDates4NextPeriodsTxt += '<br>';
                                    AbsenceDates4NextPeriodsTxt += recAbsenceEntry_L.Description + ' du ' + format(recAbsenceEntry_L."From Date");
                                    StartPeriodAbsence_L := recAbsenceEntry_L."From Date";
                                    if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                                        AbsenceDates4NextPeriodsTxt += ' au ' + Format(recAbsenceEntry_L."To Date")
                                    else
                                        if recAbsenceEntry_L."To Date" = recAbsenceEntry_l."From Date" then
                                            EndPeriodAbsence_L := recAbsenceEntry_L."To Date";
                                end;
                            until recAbsenceEntry_L.Next = 0;
                        if (EndPeriodAbsence_L <> 0D) and (StartPeriodAbsence_L <> EndPeriodAbsence_L) then
                            AbsenceDates4NextPeriodsTxt += ' au ' + Format(EndPeriodAbsence_L);

                        recAbsenceEntry_L.SetFilter("From Date", '<%1', CurrDateStartingPeriod); // Next periods
                        recAbsenceEntry_L.SetFilter("To Date", '>=%1', CurrDateStartingPeriod); // Next periods
                        EndPeriodAbsence_L := 0D;
                        if recAbsenceEntry_L.FindSet() then
                            repeat
                                if EndPeriodAbsence_L <> 0D then begin
                                    if CalcDate('<+1D>', EndPeriodAbsence_L) = recAbsenceEntry_L."From Date" then
                                        EndPeriodAbsence_L := recAbsenceEntry_L."To Date"
                                    else begin
                                        if StartPeriodAbsence_L <> EndPeriodAbsence_L then
                                            AbsenceDates4NextPeriodsTxt += ' au ' + Format(EndPeriodAbsence_L);
                                        EndPeriodAbsence_L := 0D;
                                    end;
                                end;

                                if EndPeriodAbsence_L = 0D then begin
                                    if AbsenceDates4NextPeriodsTxt <> '' then
                                        AbsenceDates4NextPeriodsTxt += '<br>';
                                    AbsenceDates4NextPeriodsTxt += recAbsenceEntry_L.Description + ' du ' + format(recAbsenceEntry_L."From Date");
                                    StartPeriodAbsence_L := recAbsenceEntry_L."From Date";
                                    if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                                        AbsenceDates4NextPeriodsTxt += ' au ' + Format(recAbsenceEntry_L."To Date")
                                    else
                                        if recAbsenceEntry_L."To Date" = recAbsenceEntry_l."From Date" then
                                            EndPeriodAbsence_L := recAbsenceEntry_L."To Date";
                                end;
                            until recAbsenceEntry_L.Next = 0;
                        if (EndPeriodAbsence_L <> 0D) and (StartPeriodAbsence_L <> EndPeriodAbsence_L) then
                            AbsenceDates4NextPeriodsTxt += ' au ' + Format(EndPeriodAbsence_L);




                        // Comment for manual entry
                        PeriodCommentTxt := '';
                        recCommentLine_L.ChangeCompany(Company.Name);
                        recCommentLine_L.Reset();
                        recCommentLine_L.SetRange("Table Name", recCommentLine_L."Table Name"::Resource);
                        recCommentLine_L.SetRange("No.", Resource."No.");
                        recCommentLine_L.SetRange(Date, CurrDateStartingPeriod, CurrDateEndingPeriod);
                        recCommentLine_L.SetRange(Code, 'SIRH');
                        if recCommentLine_L.FindSet() then
                            repeat
                                if PeriodCommentTxt <> '' then
                                    PeriodCommentTxt += '<br>';
                                PeriodCommentTxt += recCommentLine_L.Comment;
                            until recCommentLine_L.Next() = 0;



                        // Forecast Entries
                        Clear(ForecastQty);
                        Clear(NextForecastQty);
                        Clear(NextForecastQtyBureau);
                        SBXTimeSheetForecast_L.ChangeCompany(Company.Name);
                        SBXTimeSheetForecast_L.SetRange("Resource No.", Resource."No.");
                        // SBXTimeSheetForecast_L.SetRange("Non Billable", false); // ==> récupérer F et NF
                        SBXTimeSheetForecast_L.SetRange("Period Type", SBXTimeSheetForecast_L."Period Type"::Week);
                        SBXTimeSheetForecast_L.SetRange("Starting Date", DateTable."Period Start");
                        // SBXTimeSheetForecast_L.SetRange("Ending Date", DateTable."Period End");
                        if SBXTimeSheetForecast_L.FindSet() then
                            repeat
                                ForecastQty += SBXTimeSheetForecast_L."Period Quantity";
                            until SBXTimeSheetForecast_L.Next() = 0;

                        SBXTimeSheetForecast_L.SetRange("Non Billable"); // ==> Saisie sur client Bureau à récupérer 
                        SBXTimeSheetForecast_L.SetRange("Starting Date", CalcDate('<+7D>', DateTable."Period Start"));
                        // SBXTimeSheetForecast_L.SetRange("Ending Date", CalcDate('<+7D>', DateTable."Period End"));
                        if SBXTimeSheetForecast_L.FindSet() then
                            repeat
                                if not SBXTimeSheetForecast_L."Non Billable" then
                                    NextForecastQty += SBXTimeSheetForecast_L."Period Quantity";
                                if recMatter_L.Get(SBXTimeSheetForecast_L."Matter No.") and (recMatter_L."Sell-to Customer No." = InternalCustomerNo) then // heures prévisionnelles Bureau
                                    NextForecastQtyBureau := SBXTimeSheetForecast_L."Period Quantity";
                            until SBXTimeSheetForecast_L.Next() = 0;


                        // Valeurs pour cumul et moyenne heures facturables
                        MinDate4Cumul := MinDateYear;
                        if Resource."Employment Date" <> 0D then
                            if CalcDate('<-CW>', Resource."Employment Date") > MinDate4Cumul then begin
                                MinDate4Cumul := CalcDate('<-CW>', Resource."Employment Date");
                            end;
                        RecDate.Get(RecDate."Period Type"::Week, MinDate4Cumul);

                        // MLE
                        Clear(BillableQtyCumul);
                        Clear(NotBillableQtyCumul);
                        recMatterLedgerEntry_L.Reset();
                        recMatterLedgerEntry_L.SetCurrentKey("Planning Date", Status, "Matter No.", Type, "No.", "Action Code");
                        recMatterLedgerEntry_L.SetRange("Planning Date", MinDate4Cumul, DateTable."Period End");
                        recMatterLedgerEntry_L.SetRange(Type, recMatterLedgerEntry_L.Type::Resource);
                        recMatterLedgerEntry_L.SetRange("No.", Resource."No.");
                        recMatterLedgerEntry_L.SetRange("Matter Entry Type", recMatterLedgerEntry_L."Matter Entry Type"::Service);
                        recMatterLedgerEntry_L.SetRange("Closed by Ledger Entry No.", 0);
                        recMatterLedgerEntry_L.SetRange("DGF Out of Procedure", false);
                        if recMatterLedgerEntry_L.FindSet then
                            repeat
                                if recMatterLedgerEntry_L."Non Billable" then
                                    NotBillableQtyCumul += recMatterLedgerEntry_L.Quantity
                                else
                                    BillableQtyCumul += recMatterLedgerEntry_L."Invoicing Quantity";
                            until recMatterLedgerEntry_L.Next() = 0;

                        // Forecast Entries Cumulative
                        Clear(ForecastQtyCumul);
                        SBXTimeSheetForecast_L.Reset();
                        SBXTimeSheetForecast_L.SetRange("Resource No.", Resource."No.");
                        SBXTimeSheetForecast_L.SetRange("Non Billable", false);
                        SBXTimeSheetForecast_L.SetRange("Period Type", SBXTimeSheetForecast_L."Period Type"::Week);
                        SBXTimeSheetForecast_L.SetRange("Starting Date", MinDate4Cumul, DateTable."Period End");
                        //SBXTimeSheetForecast_L.SetRange("Ending Date", DateTable."Period End");
                        if SBXTimeSheetForecast_L.FindSet() then
                            repeat
                                ForecastQtyCumul += SBXTimeSheetForecast_L."Period Quantity";
                            until SBXTimeSheetForecast_L.Next() = 0;

                        // Absence
                        Clear(WeekPeriodNo);
                        Clear(AbsQtyCumul);
                        recAbsenceEntry_L.Reset();
                        recAbsenceEntry_L.SetCurrentKey("Employee No.", "From Date");
                        // recAbsenceEntry_L.SetRange("SBX Ress. No.", Resource."No.");
                        recAbsenceEntry_L.SetRange("Employee No.", Resource."No.");
                        recAbsenceEntry_L.SetRange("From Date", MinDate4Cumul, DateTable."Period End");
                        if recAbsenceEntry_L.FindSet() then
                            repeat
                                // if (recAbsenceEntry_L."To Date" <> 0D) and (recAbsenceEntry_L."To Date" <> recAbsenceEntry_l."From Date") then
                                //     Error(NoDaylyAbsenceEntries);
                                AbsQtyCumul += recAbsenceEntry_L."Quantity (Base)" * recMatterSetup_g."Nb of Hours Worked";
                                WeekPeriodNo += recAbsenceEntry_L."Quantity (Base)";
                            until recAbsenceEntry_L.Next = 0;



                        // 
                        WeekPeriodNo := Round(WeekPeriodNo / 5, 1, '<');
                        WeekPeriodNo := (DateTable."Period No." - RecDate."Period No." + 1) - WeekPeriodNo;
                        if WeekPeriodNo <> 0 then
                            WeekAverageBillableQty := BillableQtyCumul / WeekPeriodNo
                        else
                            WeekAverageBillableQty := 0;


                        // Round 
                        AbsQtyCumul := Round(AbsQtyCumul, 0.0001, '=');
                        BillableQtyCumul := Round(BillableQtyCumul, 0.0001, '=');
                        NotBillableQtyCumul := Round(NotBillableQtyCumul, 0.0001, '=');
                        ForecastQtyCumul := Round(ForecastQtyCumul, 0.0001, '=');
                        WeekAverageBillableQty := Round(WeekAverageBillableQty, 0.0001, '=');
                    end;
                }

                trigger OnPreDataItem()
                var
                    DateTable_L: Record Date;
                begin
                    txtFilter_g := Resource.GetFilters;

                    Resource.ChangeCompany(Company.Name);

                    Resource.SetFilter("DGF Division", '<>%1', ''); // Hack POC

                    Clear(MinDateYear);
                    RecDate.SetRange("Period Type", RecDate."Period Type"::Week);
                    RecDate.SetRange("Period Start", CalcDate('<-CY>', DateStartingPreviousPeriod_g), DateStartingPreviousPeriod_g);
                    RecDate.SetRange("Period No.", 1);
                    if not RecDate.FindFirst() then begin
                        RecDate.SetRange("Period No.", 2);
                        RecDate.FindFirst();
                    end;
                    MinDateYear := RecDate."Period Start";

                    // RecDate.Get(RecDate."Period Type"::Week, 20210920D); // Hack pour la période du POC
                end;

                trigger OnAfterGetRecord()
                var
                    DefaultDim_L: Record "Default Dimension";
                    DimensionValue_L: Record "Dimension Value";
                    Resource_L: Record Resource;
                begin
                    Clear(CodeDpmtAnalytics_g);
                    Clear(NameDpmtAnalytics);
                    if Resource."SBX Termination Date" <> 0D then
                        if Resource."SBX Termination Date" < DateStartingPreviousPeriod_g then
                            CurrReport.Skip;

                    if Resource."Employment Date" <> 0D then
                        if Resource."Employment Date" > DateEndingPreviousPeriod_g then
                            CurrReport.Skip;

                    DefaultDim_L.ChangeCompany(Company.Name);
                    DefaultDim_L.SetRange("Table ID", Database::Resource);
                    DefaultDim_L.SetRange("Dimension Code", recMatterSetup_g."Dept Dimension Code");
                    DefaultDim_L.SetRange("No.", "No.");
                    if DefaultDim_L.FindFirst then begin
                        DimensionValue_L.Get(recMatterSetup_g."Dept Dimension Code", DefaultDim_L."Dimension Value Code");
                        CodeDpmtAnalytics_g := DefaultDim_L."Dimension Value Code";
                        NameDpmtAnalytics := DimensionValue_L.Name;
                    end;

                    if "DGF Division" = '.' then "DGF Division" := '';

                    Resource_L.ChangeCompany(Company.Name);
                    Resource_L.SetRange("No.", "No.");
                    ReportForecastViewHyperlink := GetUrl(CurrentClientType, Company.Name, ObjectType::"Report", report::"DGF Details Forecast View");
                    ResCardHyperlink := GetUrl(CurrentClientType, Company.Name, ObjectType::"Page", Page::"Resource Card", Resource_L, true);

                    If "Resource Group No." <> '' then begin
                        ResourceGroup.ChangeCompany(Company.Name);
                        ResourceGroup.Get("Resource Group No.");
                    end;
                end;
            }

        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(CurrWeekMandatoryInfoGrp)
                {
                    Caption = 'Current week', Comment = 'FRA = Semaine en cours';

                    field(oDisplayCalendar_g; oDisplayCalendar_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display Period';
                        OptionCaption = 'Day,Week,Month,Quarter,Year';
                        Enabled = false;
                        Visible = false;
                    }
                    field(CurrDateStartingPeriod; CurrDateStartingPeriod)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting week Date';

                        trigger OnValidate()
                        begin
                            if CurrDateStartingPeriod = 0D then
                                Error(Missing_Date);

                            case oDisplayCalendar_g of
                                oDisplayCalendar_g::Week:
                                    begin
                                        CurrDateStartingPeriod := CalcDate('<-CW>', CurrDateStartingPeriod);
                                        CurrDateEndingPeriod := CalcDate('<CW>', CurrDateStartingPeriod);

                                        DateStartingPreviousPeriod_g := CalcDate('<-CW-1W>', CurrDateStartingPeriod);
                                        DateEndingPreviousPeriod_g := CalcDate('<CW-1W>', CurrDateStartingPeriod);
                                    end;
                            end;
                        end;
                    }
                    field(CurrDateEndingPeriod; CurrDateEndingPeriod)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Enabled = false;
                        Caption = 'Ending Week Date';
                    }
                }
                group(PrevWeekMandatoryInfoGrp)
                {
                    Caption = 'Previous week', Comment = 'FRA = Semaine précédente';

                    field(DateStartingPreviousPeriod_g; DateStartingPreviousPeriod_g)
                    {
                        ShowMandatory = true;
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Starting Date';
                        Enabled = false;

                        trigger OnValidate()
                        begin
                            if DateStartingPreviousPeriod_g = 0D then
                                Error(Missing_Date);

                            case oDisplayCalendar_g of
                                oDisplayCalendar_g::Day:
                                    DateEndingPreviousPeriod_g := CalcDate('<CW>', DateStartingPreviousPeriod_g);

                                oDisplayCalendar_g::Week:
                                    begin
                                        DateStartingPreviousPeriod_g := CalcDate('<-CW>', DateStartingPreviousPeriod_g);
                                        DateEndingPreviousPeriod_g := CalcDate('<CW>', DateStartingPreviousPeriod_g);
                                    end;

                                oDisplayCalendar_g::Month:
                                    begin
                                        DateStartingPreviousPeriod_g := CalcDate('<-CM>', DateStartingPreviousPeriod_g);
                                        DateEndingPreviousPeriod_g := CalcDate('<CM>', DateStartingPreviousPeriod_g);
                                    end;

                                oDisplayCalendar_g::Quarter:
                                    DateEndingPreviousPeriod_g := CALCDATE('<CQ>', DateStartingPreviousPeriod_g);

                                oDisplayCalendar_g::Year:
                                    DateEndingPreviousPeriod_g := CalcDate('<CY>', DateStartingPreviousPeriod_g)
                            end;
                        end;
                    }
                    field(DateEndingPeriod_g; DateEndingPreviousPeriod_g)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Enabled = false;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if DateEndingPreviousPeriod_g = 0D then
                                Error(Missing_Date);

                            case oDisplayCalendar_g of
                                oDisplayCalendar_g::Day:
                                    DateEndingPreviousPeriod_g := CalcDate('<CW>', DateEndingPreviousPeriod_g);

                                oDisplayCalendar_g::Week:
                                    DateEndingPreviousPeriod_g := CalcDate('<CW>', DateEndingPreviousPeriod_g);

                                oDisplayCalendar_g::Month:
                                    DateEndingPreviousPeriod_g := CalcDate('<CM>', DateEndingPreviousPeriod_g);

                                oDisplayCalendar_g::Quarter:
                                    DateEndingPreviousPeriod_g := CALCDATE('<CM>', DateEndingPreviousPeriod_g);

                                oDisplayCalendar_g::Year:
                                    DateEndingPreviousPeriod_g := CalcDate('<CY>', DateEndingPreviousPeriod_g)
                            end;

                        end;
                    }
                }
            }
        }


    }

    labels
    {
        ReportTitle = 'Weekly Associate Agenda Meeting', Comment = 'FRA = Tableau réunion agenda du groupe des collaborateurs';
        PageCaption = 'Page';
        Period = 'Current Week:', Comment = 'FRA = Sem. en cours :';
        FilterCaption = 'Filter:';
        TimeKeeperCaption = 'Timekeeper';
        JobTitleCaption = 'Job Title';
        DpmtCaption = 'Department';
        DayCAption = 'Day';
        WeekCaption = 'Week';
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
        CumulativeMinProfitQtyLbl = 'Cumulative profit threshold', Comment = 'FRA =  Cumul Seuil rentabilité';
    }


    trigger OnInitReport()
    var
        UnitMeasure_L: Record "Unit of Measure";
        HRSetup_L: Record "Human Resources Setup";

    begin
        recMatterSetup_g.Get();
        recMatterSetup_g.TestField("Nb of Hours Worked");
        recMatterSetup_g.TestField("Dept Dimension Code");

        oDisplayCalendar_g := oDisplayCalendar_g::Week;
        CurrDateStartingPeriod := CalcDate('<-CW>', WorkDate);
        CurrDateEndingPeriod := CalcDate('<CW>', WorkDate);
        DateStartingPreviousPeriod_g := CalcDate('<-CW-1W>', WorkDate);
        DateEndingPreviousPeriod_g := CalcDate('<CW-1W>', WorkDate);

        InternalCustomerNo := '9999';

        // // Hack pour la période du POC
        // CurrDateStartingPeriod := 20210927D;
        // CurrDateEndingPeriod := 20211003D;
        // DateStartingPeriod_g := CalcDate('<-CW>', 20210920D);
        // DateEndingPeriod_g := CalcDate('<+CW>', 20210920D);


        HRSetup_L.Get;
        HRSetup_L.TestField(HRSetup_L."Base Unit of Measure");
        if UnitMeasure_L.Get(HRSetup_L."Base Unit of Measure") then begin
            if UnitMeasure_L."SBX Time Type" <> UnitMeasure_L."SBX Time Type"::"Worked Days" then begin
                Message(txtWarningAbsence);
                bSkipAbsenceEntries := true;
            end;
        end else
            bSkipAbsenceEntries := true;
    end;

    trigger OnPreReport()
    begin
        if (DateStartingPreviousPeriod_g = 0D) or (DateEndingPreviousPeriod_g = 0D) then
            Error(Missing_Date);
    end;


    var
        recMatterSetup_g: Record "SBX Matter Setup";
        ResourceGroup: Record "Resource Group";
        RecDate: Record Date;
        bSkipAbsenceEntries, InitializeCumulative : Boolean;
        InternalCustomerNo: Code[20];
        CurrDateStartingPeriod, CurrDateEndingPeriod, DateEndingPreviousPeriod_g, DateStartingPreviousPeriod_g, MinDate4Cumul, MinDateYear : Date;
        AbsQty, AbsQtyCumul, BillableQty, BillableQtyCumul, NotBillableQty, NotBillableQtyCumul : decimal;
        ForecastQty, NextForecastQtyBureau, ForecastQtyCumul, NextForecastQty : Decimal;
        WeekAverageBillableQty, WeekPeriodNo : Decimal;
        txtWarningAbsence: Label 'Absence entries are not present, for the Absence Base unit of Measeure is not of type Working Day .';
        NoDaylyAbsenceEntries: Label 'Absence not entered per day, please start processing to split the absence into a daily entries', Comment = 'FRA=Absence non saisie par jour, veuillez lancer le traitement pour transformer les absence en écritures quotidiennes';
        Missing_Date: Label 'Start and end dates are mandatory.', Comment = 'FRA = Les dates de début et de fin sont obligatoires.';
        WeekInitiale: Label 'W', Comment = 'FRA = S';
        oDisplayCalendar_g: Option Day,Week,Month,Quarter,Year;
        PeriodCommentTxt, ResCardHyperlink, ReportForecastViewHyperlink : Text;
        txtPlanningWeek_g: Text[4];
        txtPlanningYear_g: Text[4];
        txtPlanningDay_g: Text[20];
        txtPlanningMonth_g: Text[20];
        CodeDpmtAnalytics_g: Text[30];
        NameDpmtAnalytics: Text[50];
        txtFilter_g, AbsenceDates4PreviousPeriodTxt, AbsenceDates4NextPeriodsTxt : Text;

}

