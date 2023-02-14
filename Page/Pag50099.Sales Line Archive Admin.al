page 50099 "DGF Sales Line Archive Admin"
{
    Caption = 'Sales Line Archive - Admin', Comment = 'fr-FR = "Ligne vente archive - Admin"';
    PageType = List;
    SourceTable = "Sales Line Archive";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));
    UsageCategory = Administration;
    ApplicationArea = SBXSBLawyer;
    LinksAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Doc. No. Occurrence"; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Allow quantity Disc."; Rec."Allow quantity Disc.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = SBXSBLawyer;
                    Editable = true;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("VAT Clause Code"; Rec."VAT Clause Code")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("VAT Identifier"; Rec."VAT Identifier")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Prepmt. VAT Calc. Type"; Rec."Prepmt. VAT Calc. Type")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Prepayment Line"; Rec."Prepayment Line")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = SBXSBLawyer;
                    Editable = true;
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = SBXSBLawyer;
                }

                field("SBX Matter Entry Description"; Rec."SBX Matter Entry Description")
                {
                    ApplicationArea = SBXSBLawyer;
                }



                field("SBX Planning Date"; Rec."SBX Planning Date")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = true;
                }
                field("Substitution Available"; Rec."Substitution Available")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that a substitute is available for the item on the sales line.';
                    Visible = true;
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    Visible = true;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that this item is a catalog item.';
                    Visible = true;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = true;
                }

                field("SBX Sales Topic"; Rec."SBX Sales Topic")
                {
                    ApplicationArea = SBXSBLawyer;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the sales order archive.';
                }

                field("SBX Description 2"; Rec."Description 2")
                {
                    ApplicationArea = SBXSBLawyer;

                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
                    Visible = true;
                }
                field("Special Order"; Rec."Special Order")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that the item on the sales line is a special-order item.';
                    Visible = true;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                    Visible = true;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies whether items will never, automatically (Always), or optionally be reserved for this customer. Optional means that you must manually reserve items for this customer.';
                    Visible = true;
                }

                field("SBX Source Entry Time"; Rec."SBX Source Entry Time")
                {
                    ApplicationArea = SBXSBLawyer;
                    Visible = true;

                }
                field("SBX Entry Time"; Rec."SBX Entry Time")
                {
                    ApplicationArea = SBXSBLawyer;

                }
                field("SBX Source Quantity"; Rec."SBX Source Quantity")
                {
                    ApplicationArea = SBXSBLawyer;

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many units are being sold.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                    Visible = true;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                    Visible = true;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Visible = true;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = true;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    Visible = true;
                }

                field("SBX Line Amount Adjusted"; Rec."SBX Line Amount Adjusted")
                {
                    ApplicationArea = SBXSBLawyer;

                    Visible = true;

                }
                field("SBX Line Unit Price Adjustemen"; Rec."SBX Line Unit Price Adj")
                {
                    ApplicationArea = SBXSBLawyer;

                    Visible = true;
                }
                field("SBX Line Adjusted %"; Rec."SBX Line Adjusted %")
                {
                    ApplicationArea = SBXSBLawyer;

                    Visible = true;

                }
                field("SBX Total Line Amount Adjusted"; Rec."SBX Total Line Amount Adjusted")
                {
                    ApplicationArea = SBXSBLawyer;
                    Visible = true;

                }
                field("SBX Write Off"; Rec."SBX Write Off")
                {
                    ApplicationArea = SBXSBLawyer;
                    ToolTip = 'Specify the line to write off.';

                }
                field("SBX Postpone"; Rec."SBX Postpone")
                {
                    ApplicationArea = SBXSBLawyer;
                    ToolTip = 'Specify the line to postpone, that is to say the lines to send back to WIP.';


                }
                field("SBX Transfer"; Rec."SBX Transfer")
                {

                    ApplicationArea = SBXSBLawyer;
                    ToolTip = 'Specify the line to transfert to another matter.Before transfering, all the lines have to be ticked.';
                }
                field("SBX Cost Switch Service"; Rec."SBX Cost Switch Service")
                {
                    ApplicationArea = SBXSBLawyer;
                    ToolTip = 'Specify the line to invoice as service fees';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
                    Visible = true;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
                    Visible = true;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity of items that remain to be shipped.';
                    Visible = true;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
                    Visible = true;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    Visible = true;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
                    Visible = true;
                }
                field("SBX VAT %"; Rec."VAT %")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("SBX VAT Base Amount"; Rec."VAT Base Amount")
                {
                    Visible = true;
                }
                field("SBX Matter No."; Rec."SBX Matter No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }
                field("SBX Matter Line No."; Rec."SBX Matter Line No.")
                {
                    ApplicationArea = SBXSBLawyer;
                }

                field("SBX Matter Entry Type"; Rec."SBX Matter Entry Type")
                {
                    ApplicationArea = SBXSBLawyer;
                    Editable = true;
                }
                field("SBX Matter Ledger Entry No."; Rec."SBX Matter Ledger Entry No.")
                {
                    ApplicationArea = SBXSBLawyer;
                    Visible = true;
                    Editable = true;
                }
                field("SBX Nature Code"; Rec."SBX Nature Code")
                {
                    ApplicationArea = SBXSBLawyer;
                }

                field("SBX Reference Amount"; Rec."SBX Reference Amount")
                {
                    ApplicationArea = SBXSBLawyer;
                }


                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that you can assign item charges to this line.';
                    Visible = true;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the requested delivery date for the sales order.';
                    Visible = true;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = true;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the planned date that the shipment will be delivered at the customer''s address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.';
                    Visible = true;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Suite;
                    Visible = true;
                    ToolTip = 'Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Suite;
                    Visible = true;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
                    Visible = true;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';
                    Visible = true;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.';
                    Visible = true;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the job number that the archived document was linked to.';
                    Visible = true;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related job task.';
                    Visible = true;
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number of the job planning line that the sales line is linked to.';
                    Visible = true;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date.';
                    Visible = true;
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the blanket order that the record originates from.';
                    Visible = true;
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the blanket order line that the record originates from.';
                    Visible = true;
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the posting date of the related fixed asset transaction, such as a depreciation.';
                    Visible = true;
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if depreciation was calculated until the FA posting date of the line.';
                    Visible = true;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = true;
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. ';
                    Visible = true;
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
                    Visible = true;
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
                    Visible = true;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied to.';
                    Visible = true;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = Suite;
                    Visible = true;
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible3;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible4;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible5;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible6;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible7;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible8;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Line")
            {
                Caption = 'Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Comments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }

                action(DeferralSchedule)
                {
                    ApplicationArea = Suite;
                    Caption = 'Deferral Schedule';
                    Image = PaymentPeriod;
                    ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';

                    trigger OnAction()
                    begin
                        Rec.ShowDeferrals;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetDimensionsVisibility();
        SetItemReferenceVisibility();
    end;

    trigger OnAfterGetRecord()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);
    end;

    var
        [InDataSet]
        ItemReferenceVisible: Boolean;

    protected var
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;

    procedure ShowDocumentLineTracking()
    var
        DocumentLineTracking: Page "Document Line Tracking";
    begin
        Clear(DocumentLineTracking);
        DocumentLineTracking.SetDoc(0, Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", '', 0);
        DocumentLineTracking.RunModal;
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

    local procedure SetItemReferenceVisibility()
    var
        ItemReferenceMgt: Codeunit "Item Reference Management";
    begin
        ItemReferenceVisible := ItemReferenceMgt.IsEnabled();
    end;
}

