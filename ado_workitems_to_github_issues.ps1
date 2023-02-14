##############################################################
# Migrate Azure DevOps work items to GitHub Issues
##############################################################

# Prerequisites:
# 1. Install az devops and github cli
# 2. create a label for EACH work item type that is being migrated (as lower case) 
#      - ie: "user story", "bug", "task", "feature"
# 3. define under what area path you want to migrate
#      - You can modify the WIQL if you want to use a different way to migrate work items, such as [TAG] = "migrate"


# How to run:
# ./ado_workitems_to_github_issues.ps1 -ado_pat "xxx" -ado_org "jjohanning0798" -ado_project "PartsUnlimited" -ado_area_path "PartsUnlimited\migrate" -gh_pat "xxx" -gh_org "joshjohanning-org" -gh_repo "migrate-ado-workitems" -gh_update_assigned_to $true -gh_assigned_to_user_suffix "_corp" -gh_add_ado_comments $true
#
# Things it migrates:
# 1. Title
# 2. Description (or repro steps + system info for a bug)
# 3. State (if the work item is done / closed, it will be closed in GitHub)
# 4. It will try to assign the work item to the correct user in GitHub - based on ADO email (-gh_update_assigned_to and -gh_assigned_to_user_suffix options) - they of course have to be in GitHub already
# 5. Migrate acceptance criteria as part of issue body (if present)
# 6. Adds in the following as a comment to the issue:
#   a. Original work item url 
#   b. Basic details in a collapsed markdown table
#   c. Entire work item as JSON in a collapsed section
#

# 
# To Do:
# 1. Create a comment on the Azure DevOps work item that says "Migrated to GitHub Issue #"
#

#
# Things it won't ever migrate:
# 1. Created date/update dates
# 



[CmdletBinding()]
param (
    [string]$ado_pat, # Azure DevOps PAT
    [string]$ado_org, # Azure devops org without the URL, eg: "MyAzureDevOpsOrg"
    [string]$ado_project, # Team project name that contains the work items, eg: "TailWindTraders"
    [string]$ado_area_path, # Area path in Azure DevOps to migrate; uses the 'UNDER' operator)
    [string]$gh_pat, # GitHub PAT
    [string]$gh_org, # GitHub organization to create the issues in
    [string]$gh_repo, # GitHub repository to create the issues in
    [bool]$gh_update_assigned_to = $false, # try to update the assigned to field in GitHub
    [string]$gh_assigned_to_user_suffix = "", # the emu suffix, ie: "_corp"
    [bool]$gh_add_ado_comments = $false # try to get ado comments
)

echo "$ado_pat" | az devops login --organization "https://dev.azure.com/$ado_org"
az devops configure --defaults organization="https://dev.azure.com/$ado_org" project="$ado_project"
echo $gh_pat | gh auth login --with-token

#$wiql="select [ID], [Title] from workitems where [System.AreaPath] UNDER '$ado_area_path' AND [System.Title] NOT CONTAINS '(GitHub' AND ([Work Item Type]='Task' OR [Work Item Type]='Bug' OR [Work Item Type]='Issue') order by [ID]"
$wiql="select [ID], [Title] from workitems where [System.Title] NOT CONTAINS '(GitHub' AND ([Work Item Type]='Task' OR [Work Item Type]='Bug' OR [Work Item Type]='Issue') order by [ID]"

$query=az boards query --wiql $wiql | ConvertFrom-Json

Remove-Item -Path ./temp_comment_body.txt -ErrorAction SilentlyContinue
Remove-Item -Path ./temp_issue_body.txt -ErrorAction SilentlyContinue

ForEach($workitem in $query) {
    $original_workitem_json_beginning="`n`n<details><summary>Original Work Item JSON</summary><p>" + "`n`n" + '```json'
    $original_workitem_json_end="`n" + '```' + "`n</p></details>"

    $details_json = az boards work-item show --id $workitem.id --output json
    $details = $details_json | ConvertFrom-Json

    # double quotes in the title must be escaped with \ to be passed to gh cli
    # workaround for https://github.com/cli/cli/issues/3425 and https://stackoverflow.com/questions/6714165/powershell-stripping-double-quotes-from-command-line-arguments
    $title = $details.fields.{System.Title} +" (AzDevOps AB#"+$details.fields.{System.ID}+")" -replace "`"","`\`""

    $description=""

    # bug doesn't have Description field - add repro steps and/or system info
    if ($details.fields.{System.WorkItemType} -eq "Bug") {
        if(![string]::IsNullOrEmpty($details.fields.{Microsoft.VSTS.TCM.ReproSteps})) {
            $description+="## Repro Steps`n`n" + $details.fields.{Microsoft.VSTS.TCM.ReproSteps} + "`n`n"
        }
        if(![string]::IsNullOrEmpty($details.fields.{Microsoft.VSTS.TCM.SystemInfo})) {
            $description+="## System Info`n`n" + $details.fields.{Microsoft.VSTS.TCM.SystemInfo} + "`n`n"
        }
    } else {
        $description+=$details.fields.{System.Description}
        # add in acceptance criteria if it has it
        if(![string]::IsNullOrEmpty($details.fields.{Microsoft.VSTS.Common.AcceptanceCriteria})) {
            $description+="`n`n## Acceptance Criteria`n`n" + $details.fields.{Microsoft.VSTS.Common.AcceptanceCriteria}
        }
    }
    
    $description+="`n`n" + "(AzDevOps AB#"+$details.fields.{System.ID}+")"
    
    $description | Out-File -FilePath ./temp_issue_body.txt

    $url="[Original Work Item URL](https://dev.azure.com/$ado_org/$ado_project/_workitems/edit/$($workitem.id))"
    $url | Out-File -FilePath ./temp_comment_body.txt

    # use empty string if there is no user is assigned
    
    #if ( $null -ne $details.fields.{System.AssignedTo}.displayName )
    #{
    #    $ado_assigned_to_display_name = $details.fields.{System.AssignedTo}.displayName
    #    $ado_assigned_to_unique_name = $details.fields.{System.AssignedTo}.uniqueName
    #}
    #else {
        $ado_assigned_to_display_name = ""
        $ado_assigned_to_unique_name = ""
    #}
    if ( $null -ne $details.fields.{Custom.b3a03d26-20b9-4f4c-a5d8-771568e3737b} )
    {
        write-host "non null value"
        $ado_assigned_to_display_name = $details.fields.{Custom.b3a03d26-20b9-4f4c-a5d8-771568e3737b}
        $ado_assigned_to_unique_name = $details.fields.{Custom.b3a03d26-20b9-4f4c-a5d8-771568e3737b}
    }
    # create the details table
    $ado_details_beginning="`n`n<details><summary>Original Work Item Details</summary><p>" + "`n`n"
    $ado_details_beginning | Add-Content -Path ./temp_comment_body.txt
    $ado_details= "| Created date | Created by | Changed date | Changed By | Assigned To | State | Type | Area Path | Iteration Path|`n|---|---|---|---|---|---|---|---|---|`n"
    $ado_details+="| $($details.fields.{System.CreatedDate}) | $($details.fields.{System.CreatedBy}.displayName) | $($details.fields.{System.ChangedDate}) | $($details.fields.{System.ChangedBy}.displayName) | $ado_assigned_to_display_name | $($details.fields.{System.State}) | $($details.fields.{System.WorkItemType}) | $($details.fields.{System.AreaPath}) | $($details.fields.{System.IterationPath}) |`n`n"
    $ado_details | Add-Content -Path ./temp_comment_body.txt
    $ado_details_end="`n" + "`n</p></details>"    
    $ado_details_end | Add-Content -Path ./temp_comment_body.txt

    # prepare the comment
    $original_workitem_json_beginning | Add-Content -Path ./temp_comment_body.txt
    $details_json | Add-Content -Path ./temp_comment_body.txt
    $original_workitem_json_end | Add-Content -Path ./temp_comment_body.txt

    # getting comments if enabled
    if($gh_add_ado_comments -eq $true) {
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $base64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$ado_pat"))
        $headers.Add("Authorization", "Basic $base64")
        $response = Invoke-RestMethod "https://dev.azure.com/$ado_org/$ado_project/_apis/wit/workItems/$($workitem.id)/comments?api-version=7.1-preview.3" -Method 'GET' -Headers $headers
        
        if($response.count -gt 0) {
            $ado_comments_details=""
            $ado_original_workitem_json_beginning="`n`n<details><summary>Work Item Comments ($($response.count))</summary><p>" + "`n`n"
            $ado_original_workitem_json_beginning | Add-Content -Path ./temp_comment_body.txt
            ForEach($comment in $response.comments) {
                $ado_comments_details= "| Created date | Created by | JSON URL |`n|---|---|---|`n"
                $ado_comments_details+="| $($comment.createdDate) | $($comment.createdBy.displayName) | [URL]($($comment.url)) |`n`n"
                $ado_comments_details+="**Comment text**: $($comment.text)`n`n-----------`n`n"
                $ado_comments_details | Add-Content -Path ./temp_comment_body.txt
            }
            $ado_original_workitem_json_end="`n" + "`n</p></details>"
            $ado_original_workitem_json_end | Add-Content -Path ./temp_comment_body.txt
        }
    }
    
    # setting the label on the issue to be the work item type
    $work_item_type = $details.fields.{System.WorkItemType}.ToLower()

    # create the issue
    #comment Edit et Test Creating
    $gh_assignee=$ado_assigned_to_unique_name.Split("@")[0]
    $gh_assignee=$gh_assignee.Replace(".", "-")
    #comment Edit et Test Creating 
    
    $issue_url=gh issue create --body-file ./temp_issue_body.txt --repo "$gh_org/$gh_repo" --title "$title" --label $work_item_type --assignee $gh_assignee
    write-host "issue created: $issue_url"
    
     #>>Update WorkItem DevOps
        
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $base64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$ado_pat"))
        $headers.Add("Authorization", "Basic $base64")
        #$JSON1 = @'[{ "op": "add", "path": "/fields/System.Title","value": "ValidationOnly won't patch this title or increase Rev"}]'@
        #$Body = @( @{ "op"="test" "path"="/rev" "value"= 6 } @( @{ "op"="add" "path"="/fields/System.Title" "value"=$details.fields.{System.Title} +" (GitHub Issue)"  } )
        $spliturl = $issue_url -split '/',7
        
        #$jsonBody = '[{"op": "add","path": "/fields/System.Title","value": "'+$details.fields.{System.Title} +' (GitHub Created)"},{"op": "add", "path": "/relations/-","value": {rel: "Hyperlink",url: '+$issue_url+'}}{"op": "add","path": "/fields/System.History","value": "GitHub <a href='+$issue_url+' target=_new>issue #'+$spliturl+'</a>"}]'
        #jsonBody = [{"op": "add","path": "/fields/System.Title","value": "'+$details.fields.{System.Title} +' (GitHub Created)"}]'
        $issuevm=$spliturl[6];
        $titleGH=" (GitHub Issue #"+$issuevm+")"
        
        $jsonBody = @(
                @{
                    op= "add"
                    path= "/fields/System.Title"
                    value = $details.fields.{System.Title} +$titleGH
                    
                 },
                @{
                    op="add"
                    path= "/fields/System.Tags"
                    value = "GitHub Issue;"+$gh_repo
                 }
        )
        
        write-host $spliturl[6]
        write-host (ConvertTo-Json -InputObject $jsonBody)
        #write-host "https://dev.azure.com/$ado_org/$ado_project/_apis/wit/workItems/$($workitem.id)?api-version=7.1-preview.3"
        $response = Invoke-RestMethod "https://dev.azure.com/$ado_org/$ado_project/_apis/wit/workItems/$($workitem.id)?api-version=7.1-preview.3" -Method 'PATCH' -Headers $headers -Body (ConvertTo-Json -InputObject $jsonBody) -ContentType "application/json-patch+json;charset=UTF-8" 
    
    
    #<<Update DevOps
    
    #write-host "toto : "  + $details.fields.Custom.{b3a03d26-20b9-4f4c-a5d8-771568e3737b}
    #write-host "toto2 : " + $details.fields.{Custom.b3a03d26-20b9-4f4c-a5d8-771568e3737b}
    #write-host "toto3 : " + $details.fields.Custom.b3a03d26-20b9-4f4c-a5d8-771568e3737b
    #write-host "toto4 : " + $details.fields.Custom."Assigné à Github"


    
    # update assigned to in GitHub if the option is set - tries to use ado email to map to github username
    #if ($gh_update_assigned_to -eq $true -and $ado_assigned_to_unique_name -ne "") {
    #    $gh_assignee=$ado_assigned_to_unique_name.Split("@")[0]
    #    #$gh_assignee=$gh_assignee.Replace(".", "-") + $gh_assigned_to_user_suffix
    #    $gh_assignee=$gh_assignee.Replace(".", "-")
    #    write-host "trying to assign to: $gh_assignee"
    #    $assigned=gh issue edit $issue_url --add-assignee "$gh_assignee"
    #}
    
    

    # add the comment
    $comment_url=gh issue comment $issue_url --body-file ./temp_comment_body.txt
    write-host "comment created: $comment_url"

    Remove-Item -Path ./temp_comment_body.txt -ErrorAction SilentlyContinue
    Remove-Item -Path ./temp_issue_body.txt -ErrorAction SilentlyContinue


    # close out the issue if it's closed on the Azure Devops side
    $ado_closure_states = "Done","Closed","Resolved","Removed"
    if ($ado_closure_states.Contains($details.fields.{System.State})) {
        gh issue close $issue_url
    }
    
    
    
}
