page 50003 "DGF New Customers List"
{
    Caption = 'New Customers';
    CardPageID = "DGF New Customer Card";
    Editable = false;
    PageType = ListPart;
    //PromotedActionCategories = 'New,Process,Report,Approve,New Document,Request Approval,Customer,Navigate,Prices & Discounts';
    RefreshOnActivate = true;
    SourceTable = Customer;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }

                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
            }

        }

    }

    actions
    {

    }

    trigger OnAfterGetCurrRecord()
    var

    begin

    end;

    trigger OnInit()
    begin

    end;

    trigger OnOpenPage()
    var

    begin

        Rec.SetRange("Date Filter", 0D, WorkDate());
        Rec.FilterGroup := 2;
        Rec.Setfilter(SystemCreatedAt, '%1..', CreateDateTime(calcdate('<-4D>', WorkDate()), 0T));
        Rec.SetFilter(Name, '<>%1', '');
        Rec.SetRange(Confidential, false);
        Rec.FilterGroup := 1;
    end;

    procedure GetSelectionFilter(): Text
    var
        Cust: Record Customer;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Cust);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;

    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SetSelectionFilter(Cust);
    end;


}

