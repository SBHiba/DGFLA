page 50008 "DGF Days List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Date;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Period Type"; Rec."Period Type")
                {
                    ToolTip = 'Specifies the value of the Period Type field';
                    ApplicationArea = All;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ToolTip = 'Specifies the value of the Period Start field';
                    ApplicationArea = All;
                }
                field("Period End"; Rec."Period End")
                {
                    ToolTip = 'Specifies the value of the Period End field';
                    ApplicationArea = All;
                }
                field("Period No."; Rec."Period No.")
                {
                    ToolTip = 'Specifies the value of the Period No. field';
                    ApplicationArea = All;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name field';
                    ApplicationArea = All;
                }
            }
        }
    }

}