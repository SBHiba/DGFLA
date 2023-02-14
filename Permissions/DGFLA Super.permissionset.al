permissionset 50000 "DGFLA Super"
{
    Assignable = true;
    Access = Internal;
    Caption = 'DGFLA App. - Admin', Comment = 'fr-FR = DGFLA App. - Admin';

    Permissions =
        tabledata "DGF Setup" = RIMD,
        tabledata "Related Bill-to Contacts" = RIMD,

        table "DGF Setup" = X,
        table "Related Bill-to Contacts" = X,

        report "Days Sales Outstanding" = X,
        report "DGF Agenda Meeting" = X,
        report "DGF Agenda Meeting 2" = X,
        report "DGF Boni-Mali List" = X,
        report "DGF Boni-Mali Review" = X,
        report "DGF Details Forecast View" = X,
        report "DGF Gross Fees Follow-Up" = X,
        report "DGF Leverage effect Overview" = X,
        report "DGF Leverage effect Overview2" = X,
        report "DGF Source Leverage Overview" = X,
        report "DGF Time converted Summary" = X,
        report "DGF Time Entries Follow-Up" = X,
        report "DGF Weekly Time Overview" = X,
        report "DGF WIP Aging by Origin" = X,
        report "DGF WIP Aging by Parnter" = X,

        codeunit "DGF Event Handler" = X,
        codeunit "DGF Management" = X,

        page "DGF Days List" = X,
        page "DGF New Customer Card" = X,
        page "DGF New Customers List" = X,
        page "DGF New Matter Card" = X,
        page "DGF New Matters List" = X,
        page "DGF Partner Activities" = X,
        page "DGF Related Bill-to Addr." = X,
        page "DGF Sales Inv. Archive" = X,
        page "DGF Sales Inv. Archive Subform" = X,
        page "DGF Sales Invoice Archive" = X,
        page "DGF Sales Line Archive Admin" = X,
        page "DGF Setup" = X;

}