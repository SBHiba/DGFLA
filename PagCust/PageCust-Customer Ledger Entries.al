pagecustomization "DGF Customer Ledger Entries" customizes "Customer Ledger Entries"
{
    layout
    {


        modify("SBX Sell-to Customer No.")
        {
            Visible = true;
        }
        modify("DGF Sell-to Name")
        {
            Visible = true;
        }
        moveafter("Customer Name"; "SBX Sell-to Customer No.")

        //moveafter("SBX Sell-to Customer No."; "DGFLA Sell-to Name")

        modify("Customer No.")
        {
            Visible = false;
        }
        modify("Customer Name")
        {
            Visible = false;
        }

    }

    actions
    {
        modify("Ent&ry") // Group
        { Visible = false; }

        modify("Reminder/Fin. Charge Entries")
        { Visible = false; }

        modify(AppliedEntries)
        { Visible = false; }

        modify(Customer)
        { Visible = false; }

        modify(Dimensions)
        { Visible = false; }

        modify(SetDimensionFilter)
        { Visible = false; }

        modify("Detailed &Ledger Entries")
        { Visible = false; }


        modify("F&unctions") // Group
        { Visible = false; }

        modify("&Navigate")
        { Visible = false; }

        modify(ShowDocumentAttachment)
        { Visible = false; }

        modify("Create Reminder")
        { Visible = false; }

        modify("Create Finance Charge Memo")
        { Visible = false; }

        modify("Apply Entries")
        { Visible = false; }

        modify(UnapplyEntries)
        { Visible = false; }

        modify(ReverseTransaction)
        { Visible = false; }

        modify(SelectIncomingDoc)
        { Visible = false; }

        modify(IncomingDocAttachFile)
        { Visible = false; }

    }
}