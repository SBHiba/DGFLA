codeunit 50001 "DGF Management"
{
    trigger OnRun()
    begin
    end;

    procedure SetDGFTimeSheetOutOfProcedure(_recMatterJnlLine: Record "SBX Matter Journal Line"): Boolean
    var
        recDate_L, recDate2_L : Record Date;
        recDGFSetup_L: Record "DGF Setup";
        dDate_L, ReferenceDate_L : Date;
        eDaysList_L: enum "DGF Days List";
        iDaySetup_L: Integer;
        tTime_L: Time;

    begin
        recDGFSetup_L.Get();
        if not recDGFSetup_L."Enable out of proc. Mgt" then
            exit(false);

        // case _recMatterJnlLine."Matter Entry Type" of
        //     _recMatterJnlLine."Matter Entry Type"::"External Expense",
        //     _recMatterJnlLine."Matter Entry Type"::Adjustment:
        //         exit(false);
        // end;
        if _recMatterJnlLine."Matter Entry Type" <> _recMatterJnlLine."Matter Entry Type"::Service then
            exit(false);

        if _recMatterJnlLine."DGF Procedure" then
            exit(false);

        iDaySetup_L := recDGFSetup_L."Seizure day allowed for proc.".AsInteger();

        dDate_L := DT2Date(CurrentDateTime);
        tTime_L := DT2Time(CurrentDateTime);

        ReferenceDate_L := 0D;

        recDate_L.Reset();
        recDate_L.SetRange("Period Type", recDate_L."Period Type"::Date);
        recDate_L.SetRange("Period Start", dDate_L);
        recDate_L.SetRange("Period No.", iDaySetup_L);
        if recDate_L.FindFirst() then begin
            if tTime_L < recDGFSetup_L."Time Entry allowed for proc." then begin
                recDate2_L.Reset();
                recDate2_L.CopyFilters(recDate_L);
                recDate2_L.SetRange("Period Start");
                recDate2_L.SetFilter("Period Start", '<%1', dDate_L);
                if recDate2_L.find('>') then
                    ReferenceDate_L := recDate2_L."Period Start";
            end else
                ReferenceDate_L := recDate_L."Period Start";
        end else begin
            recDate_L.SetRange("Period Start");
            recDate_L.SetFilter("Period Start", '<=%1', dDate_L);
            if recDate_L.FindLast() then
                ReferenceDate_L := recDate_L."Period Start";
        end;

        exit(_recMatterJnlLine."Planning Date" < ReferenceDate_L);
    end;


    procedure GetPartnerFilterByProfil(): Code[250]
    var
        cuMatterMgt_L: Codeunit "SBX Matter Management";
        Resource_L: Record Resource;
        txtFilter_L: Text;
    begin
        // Filter by profil management
        if cuMatterMgt_L.GetResourceByUSERID(Resource_L, UserId, false) then begin
            case Resource_L."SBX Resource Type" of
                Resource_L."SBX Resource Type"::Partner:
                    begin
                        exit(Resource_L."No.");
                    end;

                Resource_L."SBX Resource Type"::Administrative,
                Resource_L."SBX Resource Type"::Clerk:
                    begin
                        txtFilter_L := cuMatterMgt_L.GetPartnersWithSecretary(UserId, true);
                        if txtFilter_L <> '' then
                            exit(txtFilter_L)
                        else
                            exit('-');
                    end;

                Resource_L."SBX Resource Type"::Board,
                Resource_L."SBX Resource Type"::Billing,
                Resource_L."SBX Resource Type"::Accountant,
                Resource_L."SBX Resource Type"::Administrator:
                    begin
                        exit('');
                    end;

                Resource_L."SBX Resource Type"::Other:
                    begin
                        exit('-');
                    end;

                Resource_L."SBX Resource Type"::Interim,
                Resource_L."SBX Resource Type"::Junior,
                Resource_L."SBX Resource Type"::Senior,
                Resource_L."SBX Resource Type"::Manager:
                    begin
                        exit(Resource_L."No.");
                    end;

                else begin
                    exit('-');
                end;
            end;
        end else begin
            exit('not found');
        end;

        // FILTERGROUP(2);
        // AlltxtFilter := '\Groupe (2) : ' + GETFILTERS;
        // FILTERGROUP(-1);
        // AlltxtFilter += '\Groupe (-1) : ' + GETFILTERS;
        // FILTERGROUP(0);
        // AlltxtFilter += '\Groupe (0) : ' + GETFILTERS;
        // MESSAGE(AlltxtFilter);
        // End - Filter by Profile managment
    end;
}