report 50012 "DGF Details Forecast View"
{
    ApplicationArea = All;
    Caption = 'Details Lawyer Forecast View';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50012.Details Forecast View.rdlc';

    dataset
    {
        dataitem(Resource; Resource)
        {
            DataItemTableView = sorting("Resource Group No.") where(Type = const(Person), "SBX Inactive" = const(false));
            RequestFilterFields = "No.", "Resource Group No.", "Use Time Sheet", "SBX Inactive";
            PrintOnlyIfDetail = true;

            column(CompanyName; CompanyProperty.DisplayName)
            { }
            column(Report_Filter; ReportFilter)
            { }

            column(No_Resource; "No.")
            { }
            column(Name_Resource; Name)
            { }

            dataitem(SBXSBLTimeSheetForecast; "SBX SBL TimeSheet Forecast")
            {
                DataItemTableView = sorting("Resource No.", "Starting Date", "Ending Date", "Period No.", "Matter No.");
                DataItemLink = "Resource No." = field("No.");

                // column(EntryNo_SBXSBLTimeSheetForecast; "Entry No.")
                // { }
                column(PeriodType_SBXSBLTimeSheetForecast; "Period Type")
                { }
                column(PeriodNo_SBXSBLTimeSheetForecast; "Period No.")
                { }
                column(StartingDate_SBXSBLTimeSheetForecast; "Starting Date")
                { }
                column(EndingDate_SBXSBLTimeSheetForecast; "Ending Date")
                { }
                column(MatterSelltoCustNo; recMatterHeader."Sell-to Name")
                { }
                column(MatterNo_SBXSBLTimeSheetForecast; "Matter No.")
                { }
                column(MatterName_SBXSBLTimeSheetForecast; "Matter Name")
                { }
                column(MatterCategory_SBXSBLTimeSheetForecast; "Matter Category")
                { }
                column(MatterPartner; recMatterHeader."Partner No.")
                { }
                // column(MatterEntryType_SBXSBLTimeSheetForecast; "Matter Entry Type")
                // { }
                // column(MatterLineDescription_SBXSBLTimeSheetForecast; "Matter Line Description")
                // { }
                // column(NonBillable_SBXSBLTimeSheetForecast; "Non Billable")
                // { }
                // column(WorkTypeCode_SBXSBLTimeSheetForecast; "Work Type Code")
                // { }
                column(Timedescription_SBXSBLTimeSheetForecast; "Time description")
                { }
                column(PeriodQuantity_SBXSBLTimeSheetForecast; "Period Quantity")
                { }


                trigger OnPreDataItem()
                begin
                    SetRange("Starting Date", StartingDate);
                end;


                trigger OnAfterGetRecord()
                begin
                    if "Matter No." <> '' then
                        recMatterHeader.Get("Matter No.");
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
                group(GroupName)
                {
                    Caption = 'Period Filter', Comment = 'Filtre Périoode';

                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Week start date', Comment = 'Début semaine';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if StartingDate = 0D then
                                Error(MandatoryDateErr);

                            StartingDate := CalcDate('<-CW>', StartingDate);
                        end;
                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }

        trigger OnOpenPage()
        begin
            //Resource.SetFilter("Resource Group No.", CollabResGrp);
        end;

    }

    labels
    {
        ReportTitleLbl = 'Tableau des heures prévisionnelles du groupe des collaborateurs', comment = 'Tableau des heures prévisionnelles du groupe des collaborateurs';
        ResGrpLbl = 'Associate', Comment = 'Collaborateur';
        StartWeekDateLbl = 'Week Start Date', Comment = 'Début semaine';
        ResouceNoLbl = 'Res.', Comment = 'Coll.';

    }

    trigger OnInitReport()
    begin
        if StartingDate = 0D then
            StartingDate := CalcDate('<-CW>', WorkDate());

        CollabResGrp := 'AVOCAT';
    end;

    trigger OnPreReport()
    begin
        ReportFilter := Resource.GetFilters;
    end;

    var
        recMatterHeader: Record "SBX Matter Header";
        StartingDate: Date;
        MandatoryDateErr: Label 'This Date field is mandatroy to run the report!', comment = 'le champ Date est obligatoire pour éxécuter l''état !';
        ReportFilter: Text;
        CollabResGrp: Code[60];

}
