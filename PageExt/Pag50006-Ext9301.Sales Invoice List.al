pageextension 50006 "DGF Sales Invoice List" extends "Sales Invoice List"
{
    actions
    {
        addlast(Reports)
        {
            action(DGF_BoniMaliReviewReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Tableau Boni/Mali';
                Image = "Report";
                RunObject = Report "DGF Boni-Mali Review";
            }
        }
    }

}