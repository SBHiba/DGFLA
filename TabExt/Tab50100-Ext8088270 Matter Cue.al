tableextension 50100 "DGF Matter Cue" extends "SBX Matter Cue"
{
    fields
    {
        field(50000; "DGF Cust. Prospect Status"; Integer)
        {
            CalcFormula = Count(Customer where(Status = filter('Prospect'), "Account Manager" = field(filter("Partner No. Filter"))));
            Caption = 'Clients - Prospect';
            FieldClass = FlowField;
        }

        field(50001; "Matter Creation Step"; Integer)
        {
            CalcFormula = Count("SBX Matter Header" where("SBX Doc Step Name" = filter('Création'),
                                                        "Partner No." = field(FILTER("Partner No. Filter")),
                                                        "Responsible No." = field(FILTER("Responsible No. Filter")),
                                                        "Matter Category" = field("Matter Categorie Filter"),
                                                        "Secretary No." = field(FILTER("Secretary No. Filter"))));

            Caption = 'Dossiers - Création';
            FieldClass = FlowField;
        }
        field(50002; "Matter Prospection Step"; Integer)
        {
            CalcFormula = Count("SBX Matter Header" where("SBX Doc Step Name" = filter('Prospection'), "Partner No." = field(FILTER("Partner No. Filter")),
                                                       "Responsible No." = field(FILTER("Responsible No. Filter")),
                                                       "Matter Category" = field("Matter Categorie Filter"),
                                                       "Secretary No." = field(FILTER("Secretary No. Filter"))));
            Caption = 'Dossiers - Prospection';
            FieldClass = FlowField;
        }

        field(50003; "DGF My Customers"; Integer)
        {
            CalcFormula = Count("Customer"); //where("Account Manager" = field(FILTER("Partner No. Filter"))));
            Caption = 'Clients';
            FieldClass = FlowField;
        }

    }

}
