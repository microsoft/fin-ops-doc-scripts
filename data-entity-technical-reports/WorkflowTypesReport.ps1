.".\MetadataProvider.ps1"

Function Get-AxWorkflowTypes {

    [CmdletBinding()]
    param(
    [string]$logfile = 'errors.txt',

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string]$metadataPath,

    [string]$axLibraryPath
    )

    BEGIN {}

    PROCESS {
    
    $metadataProvider = Get-AxMetadataProvider -metadataPath "C:\AOSService\PackagesLocalDirectory"
    $workflowTypesModelInfos = $metadataProvider.WorkflowTemplates.GetPrimaryKeysWithModelInfo()
        
    foreach ($tuple in $workflowTypesModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.WorkflowTemplates.Read($elementName)

        foreach($supportedElement in $element.SupportedElements)
        {    
            $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    Name = $element.Name
                    HelpText = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.HelpText)  
                    Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
                    AssociationType = $element.AssociationType
                    Category = $element.Category
                    Participant = $supportedElement.Name
                    Role = $supportedElement.Type
                }
        }
            $outItems   
    }
    }

    END {}
}


#
#Workflow Types Reports
#
$outFile = $env:USERPROFILE + "\Documents\WorkflowTypes"

$workflows = Get-AxWorkflowTypes -metadataPath "C:\AOSService\PackagesLocalDirectory"

$workflows | Sort-Object Name |
    Select-Object Name, Label, HelpText, AssociationType, Category, Participant, Role | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file
