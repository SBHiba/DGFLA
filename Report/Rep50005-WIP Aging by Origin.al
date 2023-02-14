report 50005 "DGF WIP Aging by Origin"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50005-WIP Aging by Origin.rdlc';
    Caption = 'WIP Aging by Month and Origin', Comment = 'FRA = FAE par Origine';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = SBXSBLawyer;
    AccessByPermission = tabledata "SBX Matter Header" = R;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem("Matter Header"; "SBX Matter Header")
        {
            CalcFields = "Partner Name", "Responsible Name";
            DataItemTableView = SORTING(Status, "Partner No.", "Matter Category", Blocked) WHERE(Status = FILTER(< Closed), "Matter Type" = CONST(Chargeable));
            PrintOnlyIfDetail = true;
            //RequestFilterFields = "Partner No.";

            column(CompanyName; COMPANYPROPERTY.DisplayName)
            { }
            column(StartDate; StartDate)
            { }
            column(codeLCY; codeLCY)
            { }
            column(DisplayByPartner; bPartnerDisplay)
            { }
            column(DisplayByOrigin; bOriginDisplay)
            { }
            column(ReportFilter; TxtFilter)
            { }
            column(MatterNo; "Matter No.")
            { }
            column(MatterDescription; Name)
            { }
            column(MatterHeader_Partner; "Partner No." + ' - ' + "Partner Name")
            { }
            column(MatterHeader_Responsible; "Responsible No." + ' - ' + "Responsible Name")
            { }
            column(MatterHeader_SelltoCustomer; "Sell-to Customer No." + ' - ' + "Sell-to Name")
            { }
            column(PeriodStartDate2; Format(PeriodStartDate[2], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate3; Format(PeriodStartDate[3], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate4; Format(PeriodStartDate[4], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate5; Format(PeriodStartDate[5], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate6; Format(PeriodStartDate[6], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate7; Format(PeriodStartDate[7], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate8; Format(PeriodStartDate[8], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate9; Format(PeriodStartDate[9], 0, '<Month Text> <Year>'))
            { }
            column(PeriodStartDate10; Format(PeriodStartDate[10], 0, '<Month Text> <Year>'))
            { }

            dataitem("Matter Ledger Entry"; "SBX Matter Ledger Entry")
            {
                DataItemLink = "Matter No." = FIELD("Matter No.");
                DataItemTableView = SORTING("Planning Date", Status, "Matter No.", Type, "No.", "Action Code") WHERE("Closed by Ledger Entry No." = CONST(0), "Non Billable" = CONST(false));
                CalcFields = "Sales Amount (Expected) (LCY)";
                PrintOnlyIfDetail = true;

                column(WIPBalanceDueLCY_10; WipBalanceDueLCY[10])
                { }
                column(WIPBalanceDueLCY_9; WipBalanceDueLCY[9])
                { }
                column(WIPBalanceDueLCY_8; WipBalanceDueLCY[8])
                { }
                column(WIPBalanceDueLCY_7; WipBalanceDueLCY[7])
                { }
                column(WIPBalanceDueLCY_6; WipBalanceDueLCY[6])
                { }
                column(WIPBalanceDueLCY_5; WipBalanceDueLCY[5])
                { }
                column(WIPBalanceDueLCY_4; WipBalanceDueLCY[4])
                { }
                column(WIPBalanceDueLCY_3; WipBalanceDueLCY[3])
                { }
                column(WIPBalanceDueLCY_2; WipBalanceDueLCY[2])
                { }
                column(WIPBalanceDueLCY_1; WipBalanceDueLCY[1])
                { }
                column(MatterEntryType; MatterFamily)
                { }
                column(SalesAmountExpectedLCY; "Reference Amount")
                { }

                dataitem("SBX Internal Originating"; "SBX Internal Originating")
                {
                    DataItemLink = "No." = FIELD("Matter No.");
                    DataItemTableView = sorting(Type, "No.", "Resource No.") where(Type = const(Matter), Percentage = filter(<> 0));
                    CalcFields = "Resource Name";

                    column(Origin; "Resource No." + ' - ' + "Resource Name")
                    { }
                    column(Percentage; Percentage)
                    { }
                    column(DisplayOrder; DisplayOrder)
                    { }

                    column(OriginUnitPrice; ResUnitPrice)
                    { }


                    trigger OnPreDataItem()
                    begin
                        if not bOriginDisplay then
                            CurrReport.Break();
                    end;

                    trigger OnAfterGetRecord()
                    var
                        Resource_L: Record Resource;
                        ResourceGroup_L: Record "Resource Group";

                    begin
                        Resource_L.Get("Resource No.");
                        ResUnitPrice := Resource_L."Unit Price";
                        ResourceGroup_L.Get(Resource_L."Resource Group No.");
                        DisplayOrder := ResourceGroup_L."SBX Name 2";
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Planning Date", 0D, StartDate);
                    // if StartDate <> Today then SetRange("Date Filter", 0D, StartDate) else
                    SetFilter(Status, '%1|%2', "Matter Ledger Entry".Status::Active, "Matter Ledger Entry".Status::"On Hold");
                end;

                trigger OnAfterGetRecord()
                var
                    MatterLine_L: Record "SBX Matter Line";

                begin
                    Clear(WipBalanceDueLCY);
                    Clear(WipBalanceDueLCY0);

                    if "Sales Amount (Expected) (LCY)" = 0 then
                        CurrReport.Skip;

                    for i := 1 to 10 do begin
                        if ("Matter Ledger Entry"."Planning Date" > PeriodStartDate[i]) and ("Matter Ledger Entry"."Planning Date" <= PeriodStartDate[i + 1]) then
                            // WipBalanceDueLCY[i] := "Matter Ledger Entry"."Sales Amount (Expected) (LCY)";
                            WipBalanceDueLCY[i] := "Matter Ledger Entry"."Reference Amount";
                    end;

                    Clear(MatterFamily);
                    MatterLine_L.Get("Matter No.", "Matter Line No.");
                    MatterFamily := MatterLine_L.Description;

                end;
            }

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control8088262)
                {
                    Caption = 'Option';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Start Date';

                        trigger OnValidate()
                        begin
                            if StartDate = 0D then
                                Error('');
                        end;
                    }
                    field(bPartnerDisplay; bPartnerDisplay)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display WIP by Partner';
                        Visible = false;
                    }
                    field(bOriginDisplay; bOriginDisplay)
                    {
                        ApplicationArea = SBXSBLawyer;
                        Caption = 'Display WIP by Origin', Comment = 'Afficher FAE par Origine';
                        Visible = false;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if StartDate = 0D then
                StartDate := WorkDate;
        end;
    }

    labels
    {
        ReportTitle = 'WIP AGING BY SOURCE', Comment = 'FAE PAR ORIGINE';
        PageCaption = 'Page';
        AllAmountsLCYCaption = 'All amounts are in %1';
        FilterCaption = 'Filter:';
        CustomerCaption = 'Bill to Customer';
        TotalCaption = 'Total';
        SourceCaption = 'Matter Origin', Comment = 'Origine dossier';
        PartnerCaption = 'Partner', Comment = 'Associé';
        TextCaption = 'As of', Comment = 'Au';
        TxtAboveCaption = 'and beyond', Comment = 'et au delà';
        Colour1 = '#0c3374', Locked = true;
        Colour2 = '#5B9B3F', Locked = true;
        Colour3 = '#E49F32', Locked = true;
        FontColour1 = 'White', Locked = true;
        FontColour2 = 'Black', Locked = true;
        FontColour3 = 'DimGray', Locked = true;
    }

    trigger OnInitReport()
    begin
        bPartnerDisplay := false;
        bOriginDisplay := true;
        StartDate := WorkDate;

        // // Hack date pour POC
        // StartDate := 20211031D;
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
        GLSetup.TestField("LCY Code");
        codeLCY := GLSetup."LCY Code";

        PeriodStartDate[10] := CalcDate('<CM>', StartDate);
        PeriodStartDate[11] := 99991231D;
        for i := 9 downto 2 do
            PeriodStartDate[i] := CalcDate('<-1M>', PeriodStartDate[i + 1]);

        TxtFilter := "Matter Header".GetFilters;
    end;

    var
        bPartnerDisplay: Boolean;
        bOriginDisplay: Boolean;
        StartDate: Date;
        TxtFilter: Text;
        PeriodStartDate: array[11] of Date;
        WipBalanceDueLCY: array[10] of Decimal;
        WipBalanceDueLCY0, ResUnitPrice : Decimal;
        i: Integer;
        GLSetup: Record "General Ledger Setup";
        codeLCY: Code[10];
        MatterFamily: Text;
        DisplayOrder: Text[50];
}

