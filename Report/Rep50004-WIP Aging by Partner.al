report 50004 "DGF WIP Aging by Parnter"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Rep50004-WIP Aging by Partner.rdlc';
    Caption = 'WIP Aging by Month and Partner', Comment = 'FRA = FAE par Associé';
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
            RequestFilterFields = "Partner No.";

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
            column(PartnerUnitPrice; ResUnitPrice)
            { }

            dataitem("Matter Ledger Entry"; "SBX Matter Ledger Entry")
            {
                CalcFields = "Sales Amount (Expected) (LCY)";
                DataItemLink = "Matter No." = FIELD("Matter No.");
                DataItemTableView = SORTING("Planning Date", Status, "Matter No.", Type, "No.", "Action Code") WHERE("Closed by Ledger Entry No." = CONST(0), "Non Billable" = CONST(false));

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

            trigger OnPreDataItem()
            var
                cuMatterMgt_L: Codeunit "SBX Matter Management";
                ResourceUser_L: Record Resource;
                txtFilter_L: Text;
                AlltxtFilter: Text;
            begin
                // // Filter by profil management
                // cuMatterMgt_L.GetResourceByUSERID(ResourceUser_L, UserId, false);
                // case ResourceUser_L."SBX Lawyer Type" of
                //     ResourceUser_L."SBX Lawyer Type"::Partner:
                //         begin
                //             "Matter Header".FilterGroup(-1);
                //             "Matter Header".SetRange("Partner No.", ResourceUser_L."No.");
                //             "Matter Header".SetRange("Responsible No.", ResourceUser_L."No.");
                //             "Matter Header".FilterGroup(0);
                //         end;

                //     ResourceUser_L."SBX Lawyer Type"::Administrative:
                //         begin
                //             txtFilter_L := cuMatterMgt_L.GetPartnersWithSecretary(UserId, true);
                //             if txtFilter_L <> '' then begin
                //                 "Matter Header".FilterGroup(2);
                //                 "Matter Header".SetFilter("Partner No.", txtFilter_L);
                //                 "Matter Header".FilterGroup(0);
                //             end;
                //         end;

                //     ResourceUser_L."SBX Lawyer Type"::Clerk:
                //         begin
                //             txtFilter_L := cuMatterMgt_L.GetPartnersWithSecretary(UserId, true);
                //             if txtFilter_L <> '' then begin
                //                 "Matter Header".FilterGroup(-1);
                //                 "Matter Header".SetFilter("Partner No.", txtFilter_L);
                //                 "Matter Header".SetFilter("Responsible No.", txtFilter_L);
                //                 "Matter Header".SetRange("Secretary No.", ResourceUser_L."No.");
                //                 "Matter Header".FilterGroup(0);
                //             end;
                //         end;

                //     ResourceUser_L."SBX Lawyer Type"::Board:
                //         begin
                //             "Matter Header".FilterGroup(2);
                //             "Matter Header".SetFilter("Matter No.", '');
                //             "Matter Header".FilterGroup(0);
                //         end;

                //     ResourceUser_L."SBX Lawyer Type"::Other:
                //         begin
                //             "Matter Header".FilterGroup(2);
                //             "Matter Header".SetFilter("Matter No.", '-');
                //             "Matter Header".FilterGroup(0);
                //         end;

                //     ResourceUser_L."SBX Lawyer Type"::Interim, ResourceUser_L."SBX Lawyer Type"::Junior, ResourceUser_L."SBX Lawyer Type"::Senior, ResourceUser_L."SBX Lawyer Type"::Manager:
                //         begin
                //             "Matter Header".FilterGroup(2);
                //             "Matter Header".SetRange("Responsible No.", ResourceUser_L."No.");
                //             "Matter Header".FilterGroup(0);
                //         end;

                //     else begin
                //             "Matter Header".FilterGroup(2);
                //             "Matter Header".SetRange("Matter No.", '-');
                //             "Matter Header".FilterGroup(0);
                //         end;
                // end;

                // FILTERGROUP(2);
                // AlltxtFilter := '\Groupe (2) : ' + GETFILTERS;
                // FILTERGROUP(-1);
                // AlltxtFilter += '\Groupe (-1) : ' + GETFILTERS;
                // FILTERGROUP(0);
                // AlltxtFilter += '\Groupe (0) : ' + GETFILTERS;
                // MESSAGE(AlltxtFilter);
                // End - Filter by Profile managment
            end;

            trigger OnAfterGetRecord()
            var
                Resource_L: Record Resource;

            begin
                Resource_L.Get("Partner No.");
                ResUnitPrice := Resource_L."Unit Price";
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
                        Caption = 'Display WIP by Manager';
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
        ReportTitle = 'WIP AGING BY PARTNER', Comment = 'FAE PAR ASSOCIÉ';
        PageCaption = 'Page';
        AllAmountsLCYCaption = 'All amounts are in %1';
        FilterCaption = 'Filter:';
        CustomerCaption = 'Bill to Customer';
        TotalCaption = 'Total';
        PartnerCaption = 'Partner';
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
        bPartnerDisplay := true;
        bOriginDisplay := false;
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
}

