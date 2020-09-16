.".\MetadataProvider.ps1"

Function Get-DataEntities {

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

    $dataEntityModelInfos = $metadataProvider.DataEntityViews.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $dataEntityModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.DataEntityViews.Read($elementName)

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
            DataSource = [string]::Join(", ", $element.ViewMetadata.DataSources)
            StagingTable= $element.DataManagementStagingTable
            PublicCollectionName = $element.PublicCollectionName
            TableGroup = $element.TableGroup
            Name = $element.Name
            Public = $element.IsPublic
            Fields = [string]::Join(", ", $fields)
			ODataAccessible = $element.DataManagementEnabled             
        }

        $outItems
    }
    }

    END {}
}

$outFile = $env:USERPROFILE + "\Documents\DataEntities"

$dataEntities = Get-DataEntities -metadataPath "C:\AOSService\PackagesLocalDirectory"

$dataEntities | Sort-Object Name |
    Select-Object Name, DataSource, Public, PublicCollectionName, StagingTable, EntityCategory, TableGroup, Fields, ODataAccessible | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

