pagecustomization "DGF Customer Card" customizes "Customer Card"
{
    layout
    {

        modify(Invoicing)
        { Visible = false; }

        // SBL
        modify("Balance (LCY)")
        { Visible = false; }
        modify("Privacy Blocked")
        { Visible = false; }
        // modify("Salesperson Code")
        // {  Visible = false; }
        modify("Responsibility Center")
        { Visible = false; }
        modify("Disable Search by Name")
        { Visible = false; }
        modify("Service Zone Code")
        { Visible = false; }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        { Visible = false; }
        modify(AdjCustProfit)
        { Visible = false; }
        modify(AdjProfitPct)
        { Visible = false; }
        modify("Copy Sell-to Addr. to Qte From")
        { Visible = false; }
        modify("Tax Liable")
        { Visible = false; }
        modify("Tax Area Code")
        { Visible = false; }
        modify("Customer Disc. Group")
        { Visible = false; }
        modify("Invoice Disc. Code")
        { Visible = false; }
        modify("Prices Including VAT")
        { Visible = false; }

        modify("Prepayment %")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Combine Shipments")
        { Visible = false; }
        modify("Reserve")
        { Visible = false; }
        modify("Shipping Advice")
        { Visible = false; }
        modify("Shipment Method Code")
        { Visible = false; }
        modify("Shipping Agent Code")
        { Visible = false; }
        modify("Shipping Agent Service Code")
        { Visible = false; }
        modify("Shipping Time")
        { Visible = false; }
        modify(Shipping)
        { Visible = false; }

        modify(GLN)
        { Visible = false; }
        modify("Use GLN in Electronic Document")
        { Visible = false; }

        modify("SBX WIP Amt")
        { Visible = false; }
        modify(AgedAccReceivableChart)
        { Visible = false; }


        // Factbox
        modify(SalesHistSelltoFactBox)
        { Visible = false; }
    }

    actions
    {
        modify("&Customer") // Group
        { Visible = false; }

        modify(Dimensions)
        { Visible = false; }
        modify("Bank Accounts")
        { Visible = false; }
        modify("Direct Debit Mandates")
        { Visible = false; }
        modify(ShipToAddresses)
        { Visible = false; }
        modify("&Payment Addresses")
        { Visible = false; }
        modify("Item References")
        { Visible = false; }
        modify(ApprovalEntries)
        { Visible = false; }
        modify(Attachments)
        { Visible = false; }
        modify(CustomerReportSelections)
        { Visible = false; }
        // modify(SentEmails)
        // { Visible = false; }



        modify(History) // Group
        { Visible = false; }

        modify("Ledger E&ntries")
        { Visible = false; }
        modify(Action76)
        { Visible = false; }
        modify("S&ales")
        { Visible = false; }
        modify("Sent Emails")
        { Visible = false; }
        modify("SBX Matters List")
        { Visible = false; }


        modify("Prices and Discounts") // Group
        { Visible = false; }
        modify("SBX SBLMatterResourcePrices")
        { Visible = false; }

        // modify("Invoice &Discounts")
        // { Visible = false; }
        // modify(PriceLists)
        // { Visible = false; }


        modify(Action82) // Group
        { Visible = false; }

        modify(Documents) // Group
        { Visible = false; }
        modify("SBX SBMatterPostedDocView")
        { Visible = false; }
        modify(Invoices)
        { Visible = false; }



        // Area Creation
        modify(NewSalesInvoice)
        { Visible = false; }
        modify(NewSalesCreditMemo)
        { Visible = false; }

        modify(SBXSBLNewMatter)
        { Visible = false; }
        modify(SBXSBLCreateWizardMatter)
        { Visible = false; }


        // Area Processing
        modify(Approval)  // Group
        { Visible = false; }
        modify(Approve)
        { Visible = false; }
        modify(Reject)
        { Visible = false; }
        modify(Delegate)
        { Visible = false; }
        modify(Comment)
        { Visible = false; }


        modify("Request Approval") // Group
        { Visible = false; }
        modify(SendApprovalRequest)
        { Visible = false; }
        modify(CancelApprovalRequest)
        { Visible = false; }

        modify(Flow) // Group
        { Visible = false; }
        modify(CreateFlow)
        { Visible = false; }
        modify(SeeFlows)
        { Visible = false; }

        modify(Workflow) // Group
        { Visible = false; }
        modify(CreateApprovalWorkflow)
        { Visible = false; }
        modify(ManageApprovalWorkflows)
        { Visible = false; }

        modify("F&unctions") // Group
        { Visible = false; }
        modify(Templates)
        { Visible = false; }
        modify(ApplyTemplate)
        { Visible = false; }
        modify(SaveAsTemplate)
        { Visible = false; }
        modify(MergeDuplicate)
        { Visible = false; }


        modify("Post Cash Receipts")
        { Visible = false; }
        modify("Sales Journal")
        { Visible = false; }
        modify(PaymentRegistration)
        { Visible = false; }
        modify(WordTemplate)
        { Visible = false; }
        modify(Email)
        { Visible = false; }



        // Area Reporting
        modify("Report Customer Detailed Aging")
        { Visible = false; }
        modify("Report Customer - Labels")
        { Visible = false; }
        modify("Report Customer - Balance to Date")
        { Visible = false; }
        modify("Report Statement")
        { Visible = false; }
        modify(BackgroundStatement)
        { Visible = false; }

    }

}