.".\MetadataProvider.ps1"

Function Get-KPIs {

    [CmdletBinding()]
    param(
    [string]$logfile = 'errors.txt',

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string]$metadataPath,

    [string]$axLibraryPath
    )

    BEGIN {
        $metadataProvider = Get-AxMetadataProvider -metadataPath "C:\AOSService\PackagesLocalDirectory"
    }

    PROCESS {
    
    $KPIModelInfos = $metadataProvider.KPIs.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $KPIModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.KPIs.Read($elementName)

        if($element.Name -eq "FMRevenue")
        {
            $calcMeasure = $element.Value.Measure
            $calcMeasureGroup = $element.Value.MeasureGroup
        }
        else
        {
            $calcMeasure = $element.Goal.Measure
            $calcMeasureGroup = $element.Goal.MeasureGroup
        }

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Measurement = $element.Measurement
            Name = $element.Name
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
            ValueType = $element.Value.ValueType
            GoalType = $element.Goal.GoalType
            CalculatedMeasure = $calcMeasure
            CalculatedMeasureGroup = $calcMeasureGroup
            Value = $element.goal.Value
        }

        $outItems
    }
    }

    END {}
}

#
# KPIs
#
$outFile = $env:USERPROFILE + "\Documents\KPIs"

$KPIs = Get-KPIs -metadataPath "C:\AOSService\PackagesLocalDirectory"

$KPIs | Sort-Object Name |
    Select-Object Name, Label, Measurement, ValueType, GoalType, Value, CalculatedMeasure, CalculatedMeasureGroup, FormExposed, WorkspaceExposed | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

