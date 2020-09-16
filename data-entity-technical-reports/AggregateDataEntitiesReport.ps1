.".\MetadataProvider.ps1"

Function Get-AxAggregateDataEntities {

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
    $aggregateDataEntityModelInfos = $metadataProvider.AggregateDataEntities.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $aggregateDataEntityModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.AggregateDataEntities.Read($elementName)

        #filter out system fields
        $fields = @()
            foreach($j in $element.Fields)
            {
                if($j -notlike "AX_*")
                {
                    $fields += $j
                }
            }

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            EntityCategory = $element.EntityCategory
            Models = $modelNames
            PublicCollectionName = $element.PublicCollectionName
            DataSource = $element.AggregateViewDataSource.Measurement
            TableGroup = $element.TableGroup
            Name = $element.Name
            Public = $element.IsPublic
            Fields = [string]::Join(", ", $fields)
        }

        $outItems
    }
    }

    END {}
}


$outFile = $env:USERPROFILE + "\Documents\AggregateDataEntities"

$aggregateDataEntities = Get-AxAggregateDataEntities -metadataPath "C:\AOSService\PackagesLocalDirectory"

$aggregateDataEntities | Sort-Object Name |
    Select-Object Name, DataSource, Public, PublicCollectionName, TableGroup, EntityCategory, Fields, Models | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

