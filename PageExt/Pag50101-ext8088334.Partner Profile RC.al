pageextension 50101 "DGF Partner Profile RC" extends "SBX Partner Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(DGFPartnerFigures; "DGF Partner Activities")
            {
                ApplicationArea = SBXSBLawyer;
            }
        }

        addafter(Control8088263)
        {
            part(DGFNewCustomer; "DGF New Customers List")
            {
                Caption = 'Nouveaux Clients';
                ApplicationArea = SBXSBLawyer;
            }

            part(DGFNewMatters; "DGF New Matters List")
            {
                Caption = 'Nouveaux Dossiers';
                ApplicationArea = SBXSBLawyer;
            }
        }

        modify(UserTaskPart)
        { Visible = false; }

    }

    actions
    {
        // Area Embedding
        modify(SBXInvoiceAction)
        { Visible = false; }

        modify(ContactsAction)
        { Visible = false; }

        modify(CustomersAction)
        { Visible = false; }

        // Area Sections
        modify(MatterGrp)
        { Visible = false; }

        modify(SBXCustomerGrp)
        { Visible = false; }

        modify(SBXMarketingGrp)
        { Visible = false; }

        modify(SBXresourceGrp)
        { Visible = false; }

        // modify(SBXInvoicingGrp)
        // { Visible = false; }

        modify(SBXPurchasesGrp)
        { Visible = false; }

        modify(SBXAccoutingGrp)
        { Visible = false; }

        modify(SBXHumansRessGrp)
        { Visible = false; }

        modify(SBXHistoryDocGrp)
        { Visible = false; }


        // Area Reporting
        modify(SBXTopCustAction)
        { Visible = false; }


        // Area creation
        modify(TransSheetAction)
        { Visible = false; }


        modify(NewGrp) // Group
        { Visible = false; }

    }
}