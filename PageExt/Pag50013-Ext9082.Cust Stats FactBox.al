pageextension 50013 "DGF Cust. Stats FactBox" extends "Customer Statistics FactBox"

{
    layout
    {
        modify("Balance (LCY)")
        {
            ApplicationArea = SBXSBLSuite;
            // Visible = false;
        }

        modify("Outstanding Invoices (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        modify("Payments (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        modify("Refunds (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        modify(LastPaymentReceiptDate)
        { ApplicationArea = SBXSBLSuite; }


        modify("Total (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        modify("Balance Due (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }

        modify("Sales (LCY)")
        {
            // Visible = false;
            ApplicationArea = SBXSBLSuite;
        }
    }
}
