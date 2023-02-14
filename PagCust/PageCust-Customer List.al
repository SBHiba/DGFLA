pagecustomization "DGF Customer List" customizes "Customer List"
{
    layout
    {
        modify(Blocked)
        { Visible = true; }
        modify("Phone No.")
        { Visible = false; }
        modify(Contact)
        { Visible = false; }

        // Factbox
        modify(SalesHistSelltoFactBox)
        { Visible = false; }

    }


    actions
    {
        // Area Navigation
        modify("&Customer") // group
        { Visible = false; }
        modify("Co&mments")
        { Visible = false; }
        modify("SBX SBLOriginating")
        { Visible = false; }
        modify(Dimensions) // Group
        { Visible = false; }
        modify(DimensionsSingle)
        { Visible = false; }
        modify(DimensionsMultiple)
        { Visible = false; }

        modify("Bank Accounts")
        { Visible = false; }
        modify("Direct Debit Mandates")
        { Visible = false; }
        modify(ShipToAddresses)
        { Visible = false; }
        modify("C&ontact")
        { Visible = false; }

        // modify(SentEmails)
        // { Visible = false; }
        modify(History)// Group
        { Visible = false; }
        modify(CustomerLedgerEntries)
        { Visible = false; }
        modify("Sent Emails")
        { Visible = false; }

        modify(NewSalesOrder)
        { Visible = false; }
        modify(NewSalesInvoice)
        { Visible = false; }
        modify(NewSalesCrMemo)
        { Visible = false; }

        modify("Request Approval") // Group
        { Visible = false; }
        modify(SendApprovalRequest)
        { Visible = false; }
        modify(CancelApprovalRequest)
        { Visible = false; }

        modify(Workflow) // Group
        { Visible = false; }
        modify(CreateApprovalWorkflow)
        { Visible = false; }
        modify(ManageApprovalWorkflows)
        { Visible = false; }

        modify("Cash Receipt Journal")
        { Visible = false; }
        modify("Sales Journal")
        { Visible = false; }
        modify(ApplyTemplate)
        { Visible = false; }
        modify(WordTemplate)
        { Visible = false; }
        modify(Email)
        { Visible = false; }
        modify(PaymentRegistration)
        { Visible = false; }
        modify(Display)  // Group
        { Visible = false; }

        modify(Sales)
        { Visible = false; }
        modify(Documents)
        { Visible = false; }
        modify(Reports)
        { Visible = false; }
        modify(ReportSalesStatistics)
        { Visible = false; }




    }

    views
    {
        addlast
        {

            view(DGFCustListWithSOrigin)
            {
                Caption = 'Client sans origine';
                Filters = where("SBX Origin Lawyer Count" = const(0));
                SharedLayout = true;
            }
        }
    }

}