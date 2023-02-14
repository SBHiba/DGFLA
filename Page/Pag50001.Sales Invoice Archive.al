page 50001 "DGF Sales Invoice Archive"
{
    Caption = 'Archive Facture Proforma';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Posting,Prepare,Invoice,Release,Request Approval,View,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Sales Header Archive";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice));
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = DocNoVisible;
                }

                field("SBX Campaign Lot No."; Rec."SBX Campaign Lot No.")
                {
                    ApplicationArea = SBXSBLAdvanced;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';


                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    Importance = Promoted;
                    NotBlank = true;
                    ShowMandatory = true;
                    AboutTitle = 'Who you are selling to';
                    AboutText = 'This can be an existing customer, or you can register a new from here. Customers can have special prices and discounts that are automatically used when you enter the sales lines.​';
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';


                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                    Visible = false;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("SBX Sell-to Address Code"; Rec."SBX Sell-to Address Code")
                    {
                        ApplicationArea = SBXSBLawyer;
                        Importance = Additional;
                    }
                    field("Sell-to Address"; Rec."Sell-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the address where the customer is located.';
                    }
                    field("Sell-to Address 2"; Rec."Sell-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City"; Rec."Sell-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'City';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the city of the customer on the sales document.';
                    }
                    group(Control60)
                    {
                        ShowCaption = false;
                        Visible = IsSellToCountyVisible;
                        field("Sell-to County"; Rec."Sell-to County")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'County';
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the state, province or county of the address.';
                        }
                    }
                    field("Sell-to Post Code"; Rec."Sell-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Code';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region Code';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the country or region of the address.';

                        trigger OnValidate()
                        begin
                            IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
                        end;
                    }
                    field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact No.';
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';


                    }
                    field(SellToPhoneNo; SellToContact."Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Phone No.';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
                    }
                    field(SellToMobilePhoneNo; SellToContact."Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mobile Phone No.';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the mobile telephone number of the contact person that the sales document will be sent to.';
                    }
                    field(SellToEmail; SellToContact."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Email';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the email address of the contact person that the sales document will be sent to.';
                    }
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact';
                    Editable = Rec."Sell-to Customer No." <> '';
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s reference. The contents will be printed on sales documents.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ShowMandatory = ExternalDocNoMandatory;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the campaign that the document is linked to.';
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center" = R;
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    StyleExpr = StatusStyleTxt;
                    AboutTitle = 'Check the invoice status here';
                    AboutText = 'You can only edit an open invoice. When status is Released, it means the invoice is up for next stage in processing, such as reserving the products being sold. Use Reopen if you must edit a released invoice.';
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }

                group(SBXOptionMatter)
                {
                    Caption = 'Options Matter';
                    field("SBX Matter No."; Rec."SBX Matter No.")
                    {
                        ApplicationArea = SBXSBLawyer;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update(true);
                        end;

                        trigger OnAssistEdit()
                        var
                            recMatterHeader_L: Record "SBX Matter Header";

                        begin
                            Rec.TestField("SBX Matter No.");
                            Clear(recMatterHeader_L);
                            recMatterHeader_L.Reset;
                            recMatterHeader_L.SetRange("Matter No.", Rec."SBX Matter No.");
                            Page.Run(Page::"SBX Matter Card", recMatterHeader_L);
                        end;
                    }

                    field("SBX Matter Name"; Rec."SBX Matter Description")
                    {
                        ApplicationArea = SBXSBLawyer;
                        Importance = Promoted;
                        Editable = false;
                    }

                    field("SBX Partner No."; Rec."SBX Partner No.")
                    {
                        ApplicationArea = SBXSBLawyer;
                    }
                    field("SBX Responsible No."; Rec."SBX Responsible No.")
                    {
                        ApplicationArea = SBXSBLawyer;
                    }
                    field("SBX Matter Prepayment"; Rec."SBX Matter Prepayment")
                    {
                        ApplicationArea = SBXSBLawyer;
                        ToolTip = 'This field is ticked when it is an prepayment invoice.';
                        Importance = Additional;
                    }

                    field("SBX Starting Period Date"; Rec."SBX Starting Period Date")
                    {
                        ApplicationArea = SBXSBLawyer;
                        Importance = Additional;
                    }
                    field("SBX Ending Period Date"; Rec."SBX Ending Period Date")
                    {
                        ApplicationArea = SBXSBLawyer;
                        Importance = Additional;
                    }
                }

                field("SBX Paper Process"; Rec."SBX Paper Process")
                {
                    ApplicationArea = SBXSBLAdvanced;
                    Importance = Additional;
                    Visible = false;
                }

                group("SBXMultiBillDocGrp")
                {
                    Caption = 'Multi Bill-to';

                    field("SBX Main Document No."; Rec."SBX Main Document No.")
                    {
                        ApplicationArea = SBXSBLawyer;
                        //Editable = true;

                    }
                    field("SBX Main Document"; Rec."SBX Main Document")
                    {
                        ApplicationArea = SBXSBLawyer;
                    }
                }

                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(WorkDescription; WorkDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';


                    }
                }
            }
            part(SalesLines; "DGF Sales Inv. Archive Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = Rec."Sell-to Customer No." <> '';
                Enabled = Rec."Sell-to Customer No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';


                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                    Visible = false;
                }

                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                    Visible = false;

                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';


                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';


                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the document.';
                    Visible = false;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies if the transaction is related to trade with a third party within the EU.';
                    Visible = false;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';


                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';


                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment discount percentage granted if the customer pays on or before the date entered in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                    Visible = false;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Importance = Additional;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                    Visible = false;
                }
                group(SBXSBLOptionsInvoicing)
                {
                    Caption = 'Matter Billing Options';
                    field("SBX To Merge"; Rec."SBX To Merge")
                    {
                        ApplicationArea = SBXSBLawyer;
                        ToolTip = 'Specifies that the customer wants to consolidate all invoices into one invoice.';
                    }
                    field("SBX Print Invoice Details"; Rec."SBX Print Invoice Details")
                    {
                        ApplicationArea = SBXSBLawyer;
                        ToolTip = 'Specifies whether a annex with the detailed times and expenses is added to the invoice.';
                    }

                    group(SBXMemoGrp)
                    {
                        ShowCaption = false;

                        field("SBX Memo"; Rec."SBX Memo")
                        {
                            // Visible = bHideMemo;
                            Caption = 'Memo';
                            ApplicationArea = SBXSBLMemo;
                            // Importance = Additional;
                            ToolTip = 'Specifies whether a summary of billed services is added to the invoice.';
                        }
                        field("SBX Hide Memo Tablix "; Rec."SBX Hide Memo Tablix")
                        {
                            ApplicationArea = SBXSBLMemo;
                            Importance = Additional;
                            ToolTip = 'Specifies whether a tablix summary of billed services is added to the invoice.';
                        }

                    }
                    group(SBXLedes)
                    {
                        Caption = 'LEDES';
                        field("SBX Electronic Invoice "; Rec."SBX Electronic Invoice")
                        {
                            ApplicationArea = SBXSBLawyer;
                            ToolTip = 'Specifies that the customer wants to receive an electronic invoice';
                        }
                        field("SBX LEDES Format"; Rec."SBX LEDES Format")
                        {
                            ApplicationArea = SBXSBLawyer;
                            ToolTip = 'Used to specify the version of LEDES format owned by the client';

                        }
                    }
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Cover Letter and Billing';
                Enabled = Rec."Sell-to Customer No." <> '';
                group(Control34)
                {
                    ShowCaption = false;
                    group(Control200)
                    {
                        ShowCaption = false;
                        field(ShippingOptions; ShipToOptions)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship-to';
                            OptionCaption = 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';
                        }
                        group(Control202)
                        {
                            ShowCaption = false;
                            Visible = NOT (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                            field("Ship-to Code"; Rec."Ship-to Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Code';
                                Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                                Importance = Promoted;
                                ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';


                            }
                            field("Ship-to Name"; Rec."Ship-to Name")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                            }
                            field("Ship-to Address"; Rec."Ship-to Address")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                            }
                            field("Ship-to Address 2"; Rec."Ship-to Address 2")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies additional address information.';
                            }
                            field("Ship-to City"; Rec."Ship-to City")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the city of the customer on the sales document.';
                            }
                            group(Control82)
                            {
                                ShowCaption = false;
                                Visible = IsShipToCountyVisible;
                                field("Ship-to County"; Rec."Ship-to County")
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'County';
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    QuickEntry = false;
                                    ToolTip = 'Specifies the state, province or county of the address.';
                                }
                            }
                            field("Ship-to Post Code"; Rec."Ship-to Post Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Post Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the postal code.';
                            }
                            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the customer''s country/region.';


                            }
                        }
                        field("Ship-to Contact"; Rec."Ship-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact';
                            ToolTip = 'Specifies the name of the contact person at the address that products on the sales document will be shipped to.';
                        }
                    }
                    group("Shipment Method")
                    {
                        Caption = 'Shipment Method';
                        field("Shipment Method Code"; Rec."Shipment Method Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Code';
                            Importance = Additional;
                            ToolTip = 'Specifies how items on the sales document are shipped to the customer.';
                        }
                        field("Shipping Agent Code"; Rec."Shipping Agent Code")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Agent';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                        }
                        field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Agent service';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                        }
                        field("Package Tracking No."; Rec."Package Tracking No.")
                        {
                            ApplicationArea = Suite;
                            Importance = Additional;
                            ToolTip = 'Specifies the shipping agent''s package number.';
                        }
                    }
                }
                group(Control203)
                {
                    ShowCaption = false;
                    field(BillToOptions; BillToOptions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bill-to';
                        OptionCaption = 'Default (Customer),Another Customer,Custom Address';
                        ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';


                    }
                    group(Control205)
                    {
                        ShowCaption = false;
                        Visible = NOT (BillToOptions = BillToOptions::"Default (Customer)");
                        field("Bill-to Name"; Rec."Bill-to Name")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Name';
                            Editable = BillToOptions = BillToOptions::"Another Customer";
                            Enabled = BillToOptions = BillToOptions::"Another Customer";
                            Importance = Promoted;
                            NotBlank = true;
                            ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';


                        }
                        field("Bill-to Address"; Rec."Bill-to Address")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the address of the customer that you will send the invoice to.';
                        }
                        field("Bill-to Address 2"; Rec."Bill-to Address 2")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address 2';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies additional address information.';
                        }
                        field("Bill-to City"; Rec."Bill-to City")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'City';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the city of the customer on the sales document.';
                        }
                        group(Control85)
                        {
                            ShowCaption = false;
                            Visible = IsBillToCountyVisible;
                            field("Bill-to County"; Rec."Bill-to County")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'County';
                                Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                                Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the state, province or county of the address.';
                            }
                        }
                        field("Bill-to Post Code"; Rec."Bill-to Post Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Post Code';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");

                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the postal code.';
                        }
                        field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Country/Region';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");

                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the country or region of the address.';

                            trigger OnValidate()
                            begin
                                IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
                            end;
                        }
                        field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact No.';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            ToolTip = 'Specifies the number of the contact the invoice will be sent to.';
                        }
                        field("Bill-to Contact"; Rec."Bill-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") OR (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            ToolTip = 'Specifies the name of the person you should contact at the customer you are sending the invoice to.';
                        }
                        field(BillToContactPhoneNo; BillToContact."Phone No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Phone No.';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = PhoneNo;
                            ToolTip = 'Specifies the telephone number of the person you should contact at the customer you are sending the invoice to.';
                        }
                        field(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Mobile Phone No.';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = PhoneNo;
                            ToolTip = 'Specifies the mobile telephone number of the person you should contact at the customer you are sending the invoice to.';
                        }
                        field(BillToContactEmail; BillToContact."E-Mail")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Email';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = EMail;
                            ToolTip = 'Specifies the email address of the person you should contact at the customer you are sending the invoice to.';
                        }
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies a specification of the document''s transaction, for the purpose of reporting to INTRASTAT.';
                    Visible = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                    Visible = false;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                    Visible = false;
                }
                field("Exit Point"; Rec."Exit Point")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.';
                    Visible = false;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.';
                    Visible = false;

                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the language to be used on printouts for this document.';
                    Visible = false;
                }
            }

            group(SBXArchiveGrp)
            {
                Caption = 'Archive';
                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = All;
                }
                field("Date Archived"; Rec."Date Archived")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the document was archived.';
                }
                field("Time Archived"; Rec."Time Archived")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies what time the document was archived.';
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the user ID of the person who archived this document.';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Archived By");
                    end;
                }
            }
        }
        area(factboxes)
        {

            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = false;
            }

        }
    }

    actions
    {
        area(navigation)
        {
            group("Invoice")
            {
                Caption = 'Invoice';
                Image = Invoice;

                action("Comments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category7;
                    RunObject = Page "Sales Archive Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }

                action(Function_CustomerCard)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Enabled = IsCustomerOrContactNotEmpty;
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category11;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No."),
                                  "Date Filter" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer on the sales document.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }

            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        // WorkDescription := GetWorkDescription;
        if SellToContact.Get(Rec."Sell-to Contact No.") then;
        if BillToContact.Get(Rec."Bill-to Contact No.") then;
    end;

    trigger OnOpenPage()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
        OfficeMgt: Codeunit "Office Management";
        EnvironmentInfo: Codeunit "Environment Information";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate());

        ActivateFields;

        SetDocNoVisible;

        if Rec."No." = '' then
            if OfficeMgt.CheckForExistingInvoice(Rec."Sell-to Customer No.") then
                Error(''); // Cancel invoice creation
        IsSaaS := EnvironmentInfo.IsSaaS;
        if (Rec."No." <> '') and (Rec."Sell-to Customer No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));
    end;

    var
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        CustomerMgt: Codeunit "Customer Mgt.";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        WorkDescription: Text;
        [InDataSet]

        StatusStyleTxt: Text;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        OpenPostedSalesInvQst: Label 'The invoice is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
        IsCustomerOrContactNotEmpty: Boolean;
        ShowQuoteNo: Boolean;
        JobQueuesUsed: Boolean;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        EmptyShipToCodeErr: Label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';
        IsSaaS: Boolean;
        IsBillToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        SkipConfirmationDialogOnClosing: Boolean;

    protected var
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer","Custom Address";

    local procedure ActivateFields()
    begin
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Invoice, Rec."No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    procedure SetSkipConfirmationDialogOnClosing(Skip: Boolean)
    begin
        SkipConfirmationDialogOnClosing := Skip;
    end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostOnAfterSetDocumentIsPosted(SalesHeader: Record "Sales Header"; var IsScheduledPosting: Boolean; var DocumentIsPosted: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostOnBeforeSalesHeaderInsert(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShipToOptions(var SalesHeader: Record "Sales Header"; ShipToOptions: Option)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShipToOptions(var SalesHeader: Record "Sales Header"; ShipToOptions: Option)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnPostDocumentBeforeNavigateAfterPosting(var SalesHeader: Record "Sales Header"; var PostingCodeunitID: Integer; var Navigate: Enum "Navigate After Posting"; DocumentIsPosted: Boolean; var IsHandled: Boolean)
    begin
    end;
}

