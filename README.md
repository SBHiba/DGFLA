# Template_ALExtension
Ce modèle est là pour vous permettre d'avoir un modèle AL à jour régulièrement.
Certains fichiers serviront juste à synchroniser des répertoires sur Git.
D'autres fichiers auront la structure demandée, mais ils auront des balises à remplacer pour compléter correctement le fichier

# Les Bonnes Pratiques

## Prefixe ou Suffixe sur les objets et Procédures

Un préfixe ou un suffixe est obligatoire quand on souhaite publier sur l'Appsource. Mais il est tout aussi recommandé de le faire pour un projet client. 

Pour la plublication sur l'Appsource, il faut utiliser : SBX (en préfixe ou en suffixe).

Sinon, pour un projet client, il faut créer un préfixe en se basant du nom du client. Exemple : le client Dataneo, son préfixe/suffixe devrait être : DTN.

Les mêmes règles que pour la publication sur l'Appsource sont à respecter. Voici les règles :

### General rules
* The prefix/suffix must be at least 3 characters
* The object/field name must start or end with the prefix/suffix
* If a conflict arises, the one who registered the prefix/suffix always wins
* For your own objects, you must set the prefix/suffix at the top object level
* For pages/tables/enums/reports/permissionsets in the base application or other apps that you extend, you must set the prefix/suffix at the top object level and also * at the control/field/action/procedure/values/dataitem/column level
* Use the AppSourceCop tool to find all missing prefixes and/or suffixes. Configuration options for this tool can be found here. The Rules section explains the different checks that the analyzer will do. For prefix/suffix detection, refer to the Configuration section. It explains how to set your affixes in the AppSourceCop.json file.

https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/compliance/apptest-prefix-suffix


## Nommage des fichiers

Exceptés certains qui ne possèdent pas de numéro d'ID comme les pages customizations, la plupart demande un ID pour chaque fichier. 
Voici une liste non exhaustive qui donne un exemple de comment je nomme les fichiers :

| Type Object  | Nom Fichier                                                        | Exemple Fichier                        |
|--------------|--------------------------------------------------------------------|----------------------------------------|
| Codeunit     | Cod<ID>.<ObjectName>.al                                            | Cod50000.Datineo Event Handler.al      |
| ControlAddin | Particularité, on nomme le répertoire <Prefix>.Addins.<ObjectName> | SBX.Addins.Web.AboutSBLawyer           |
| Enum         | Enu<ID>.<ObjecTName>.al                                            | Enu50000.DTN Precision Convert.al      |
| EnumExt      | Enu<ID>-Ext<IDStd>.<ObjectName>.al                                 | Enu8088266-Ext7003.SBL Price Source.al |
| Interface    | Int<ObjectName>.al                                                 | intSBX SMS Http Methods.al             |
| PagCust      | PagCust-<ObjectName>.al                                            | PagCust-SBL Customer Ledger Entries.al |
| Page         | Pag<ID>.<ObjectName>.al                                            | Pag50000.Car Setup.al                  |
| PageExt      | Pag<ID>-Ext<IDStd>.<ObjectName>.al                                 | Pag50000-Ext10CountriesRegions.al      |
| Permissions  | <Prefix>.<ObjectName>.PermissionSet.al                             | SBLCONFADJDIM.PermissionSet.al         |
| Profiles     | Profile.<Prefix>.<ObjectName>.al                                   | Profile.SBL Administrator.al           |
| Query        | Que<ID>.<ObjectName>.al                                            | QUE50000.Sales Inv. Line by Matters.al |
| Report       | Rep<ID>.<ObjectName>.al                                            | Rep50000.Batch To Register Matter.al   |
| ReportExt    | Rep<ID>-Ext<IDStd>.<ObjectName>.al                                 | Rep50001-Ext406.Cha Purchase Invoic.al |
| TabExt       | Tab<ID>-Ext<IDStd>.<ObjectName>.al                                 | Tab50000-Ext9.Matter Country Region.al |
| Table        | Tab<ID>.<ObjectName>.al                                            | Tab50000.Matter Setup.al               |
| XMLPort      | XML<ID>.<ObjectName>.al                                            | XML500000.Export Permissions.al        |


## Variables et Procedures

### Variables

	En général Pour différencier les variables globales et locales: je mets souvent un _L à la fin des variables locales.
	Pour les variables Temporaires, il faut préfixer par Tmp ou Temp.
	
|Type|Structure|Exemple
|-----------|-----------|-----------|
|Biginteger| bgi(Var) ou bigint(var)|bgiEntryNo
|BigText| bgt(Var) ou bigtext(var)|bgtMessage
|Blob| blb(Var) ou blob(var)|TempBlob
|Boolean| b(Var) ou bool(var)|bOk
|Byte| byte(Var) |byteMessage
|Char| char(Var) ou ch(var)|chA
|Codeunit| cu(Var) ou cod(var)|cuMatterEventHandler
|Date| d(Var) ou dte(var) ou (var)date|dStartingDate
|Dateformula| dtf(Var) ou dateform(var)|dtfPeriod
|DateTime| dt(Var) ou dtime(var)|dtStartingDate
|Decimal| dec(Var) ou d(var)|decAmount
|Dialog| dial(Var) ou window|dialwindow
|Dictionary| dic(Var) |dicList
|dotnet| dot(Var) ou dnet(var)|dotdll
|Duration| dur(Var)|durTime
|Enum| en(Var) ou enum(var)|enumSalesType
|fieldref| fref(Var) ou fieldref(var)|frefRecord
|File| f(Var) ou file(var)|file
|FilterPageBuilder| fpb(Var) ou fpbuild(var)|fpbDate
|Guid| guid(Var) ou id(var)|idMessage
|InStream| ins(Var) ou inStr(var)|inStrRead
|Integer| i(Var) ou int(var)|iEntryNo
|JsonArray| jsArray(Var) ou jsonArray(var)|
|JsonObject| jsobj(Var) ou jsonobj(var)|
|JsonToken| jst(Var) ou jsonToken(var)|
|JsonValue| jsv(Var) ou jsonVal(var)|
|Keyref| key(Var) ou keyref(var)|
|Label| lbl(Var) |lblMess
|List| ls(Var) ou list(var)|listValue
|Media| med(Var) ou media(var)|
|MediaSet| mset(Var) ou mediaset(var)|
|ModuleDependencyInfo| mdi(Var) ou mdinfo(var)|
|ModuleInfo| mi(Var) ou modinfo(var)|
|NavApp| napp(Var) ou app(var)|
|Notification| notif(Var) ou not(var)|
|Option| opt(Var)|optType
|Outstream| ostr(Var) ou outStr(var)|ostrWrite
|Page| p(Var) ou pag(var)|pCustomerCard
|Query| q(Var) ou que(var)|qStat
|Record| rec(Var) ou <TableName>|recSalesheader or Salesheader
|Recordid| rid(Var) ou recid(var)|
|RecordRef| rref(Var) ou recref(var)|
|Report| rep(Var) ou r(var)|
|RequestPage| rpage(Var) ou rp(var)|
|Session| sess(Var) ou session(var)|
|SessionInformation| sessinfo(Var) ou sinfo(var)|
|SessionSettings| sset(Var) ou sessset(var)|
|System| syst(Var) ou sys(var)|
|TaskScheduler| ts(Var) ou task(var)|
|TestAction| i(Var) ou int(var)|iEntryNo
	
	
La suite dans un prochaine épisode...	


https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/library

	
### Procedures

	Pas de règles précises, mais le nom doit être parlant, expliquant ce que la procédure fait. Exemple, on fait pouvoir masquer un dialog, on va créer une fonction qui se nomme SetHideDialog.
	
Néanmoins, il y a règles universelles qui permettent de définir une fonction. 

* Une fonction qui affecte commence par Set
* Une fonction qui récupère une valeur commence par Get
* Une fonction qui vérifie commence par Check
* Une fonction qui calcule commence par Calc

## Events et Codeunits

	Il est recommandé de créer au moins un codeunit réservé aux Event Handler. C'est ici que les events subscribers seront regroupés. 
	
	Il est recommandé de créer aussi un codeunit réservé aux Events Manuels. 

### Event Publisher

Pour les Events Publisher, il est fortement recommandé de suivre la structure Suivante :

	On(Before/After)(NomExplicite/Nomdelafonction) ==> Doit permettre de pouvoir positionner ou se trouve l'event.

Exemple sur le codeunit 80 
	
	OnBeforePostSalesLines(SalesHeader, TempSalesLineGlobal, TempVATAmountLine);

Cela montre que l'event est positionné juste avant la validation des lignes de ventes.
	
### Event Subscriber
	
C'est assez simple, la règle est la suivante : 
	* On commence toujours par Run
	* Ensuite le nom de l'objet
	* ensuite le nom de l'event
	
exemple sur le codeunit 80 pour l'event publishier OnBeforePostSalesLines.

	RunSalesPostBeforePostSalesLines(SalesHeader, TempSalesLineGlobal, TempVATAmountLine);
	
## Gitignore

Ce que je rajoute en général dans le gitignore afin d'exclure certains fichiers 

![image](https://user-images.githubusercontent.com/47382516/177292515-fe05ac9b-ed40-4b5a-9ba1-260d1601432e.png)


## Extensions utilisés sur VSCode

* AL Extension Pack de Waldo : Il installe 26 pack qui pour la plupart sont intéressants comme le Create GUID
* AL Formatter de Rasmus Aaen
* AL Language de Microsoft
* AL Language Tools
* BusinessCentral.LinterCop de Stefan Maron
* Dynamics 365 Translation Service (Preview) de Microsoft
* French Language Pack for Visual Studio Code
* Git Project Manager
* Github Pull Requests and issues
* Github Repositories
* Powershell de Microsoft
* Remote Repositories de Microsoft
* Todo Tree de Gruntfuggly

![image](https://user-images.githubusercontent.com/47382516/194509189-c7f87eff-4b46-4821-9d09-37c12a2e535a.png)


# Syncrhonisation avec DevOps
Si vous avez créer un projet Devops dans l'organisation s-bconsulting. Vous devez tout d'abord le synchroniser côté DevOps

## Côté Devops

![image](https://user-images.githubusercontent.com/47382516/176876460-673937bb-3323-4e33-80eb-e176fc0be7b4.png)

![image](https://user-images.githubusercontent.com/47382516/176876543-bb83df6f-e115-4e94-adb1-cdb21f517f34.png)

![image](https://user-images.githubusercontent.com/47382516/176876682-763be314-8cb2-454b-82ce-4b0d28d4f8c9.png)

En général un projet Devops sera lié avec un repo mais il est possible comme pour SBLawyer, que plusieurs repos soient utilisés pour un seul projet.

![image](https://user-images.githubusercontent.com/47382516/176877018-10cd400c-020b-4915-85f7-dd0e4d33d0e7.png)

## côté Github

Quand vous allez initialiser ce repo, vous aurez 4 fichiers pour gérer la synchro avec Devops :
a la racine de l'extension :
### ado_workitems_to_github_issues.ps1

- ado_workitems_to_github_issues.ps1 : Ce fichier sert de script powershell pour le batch qui va vérifier les tâches, les bugs, et les issues à créer sur Github. Il est prévu de tourner tous les jours 1 fois à 18h. Si vous souhaitez modifier pour augmenter le nombre de fois qu'il doit tourner, il faut modifier le fichier : .github\workflows\SyncDevopstoIssue.yml

![image](https://user-images.githubusercontent.com/47382516/176912778-6e046e9a-9682-4ab7-9a79-200a945454b0.png)

vous devez modifier le paramètre dans cron.
Les règles de cron sont : 

![image](https://user-images.githubusercontent.com/47382516/176913028-5c7e3ec9-af3c-4c0a-92b9-c2c0aff35c46.png)

![image](https://user-images.githubusercontent.com/47382516/176913096-4bbd568d-ef65-424b-b3f7-50b9b4797796.png)

#### Exemples de calendrier
Le tableau suivant présente quelques exemples de plannings de tâches Cron et leur description:

Exemple de calendrier	Format de la tâche Cron
	
|Exemple de calendrier                               | Format de la tâche Cron |
|----------------------------------------------------|-------------------------|
| Toutes les minutes                                 |   * * * * *             |
| Tous les samedis à 23h45                           |   45 23 * * 6           |
| Chaque lundi à 9h (9h)                             |   0 9 * * 1             |
| Tous les dimanches à 4h05                          |   5 4 * * SUN           |
| Tous les jours de la semaine (lun-ven) à 22h (22h) |   0 22 * * 1-5          |

### Les 3 fichiers se trouvent dans .github\workflows

* adoworkitem.yml : Script qui permet d'exécuter manuellement la synchro Devops --> Github
* SyncDevopstoIssue.yml : Script qui tourne par défaut tous les jours à 18h pour chréer les workitems Devops vers Github
* syncGithubToDevOps.yml : Synchro monodirectionnel de Github vers Devops par event : Issue : [opened, edited, deleted, closed, reopened, labeled, unlabeled, assigned] et issue_comment : [created, edited, deleted]

###Vous avez deux choses à paramétrer à chaque création de repo : 

* La création d'un secret sur le repository pour stocker le nom du projet d'Azure Devops
* Stocker le nom du repository en dur dans le fichier : SyncDevopstoIssue.yml

#### Création d'une variable Secret dans un repository 

![image](https://user-images.githubusercontent.com/47382516/176915938-b47e5eea-4d3c-4e42-b4cd-fbbfc68d27f5.png)

![image](https://user-images.githubusercontent.com/47382516/176916126-c0f25b8d-552b-415c-81a2-ae2393df7b17.png)

Vous faîtes New Repository Secret et vous le nommez obligatoirement comme ceci : ADO_PROJECT
et sa valeur : <le nom du projet Azure DevOps>. Exemple : Pour le projet SyncDevOpsGithub, il faut le stocker comme ce que tu vois sur Azure:

![image](https://user-images.githubusercontent.com/47382516/176916544-58ae9cd2-c155-4d92-9f84-932733838242.png)
![image](https://user-images.githubusercontent.com/47382516/176916581-f3d041b9-b76e-41f8-9d07-cbfccb66b8a3.png)

#### Renseigner le nom du repo github dans le fichier SyncDevopstoIssue.yml

![image](https://user-images.githubusercontent.com/47382516/176916959-8cda5f46-d35a-43b9-9e87-3be8fb17ed68.png)

Vous le nommez correctement comme ça : 

![image](https://user-images.githubusercontent.com/47382516/176917133-0b268fef-597a-4544-95d6-073741ed5745.png)





