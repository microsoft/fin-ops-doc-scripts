.".\MetadataProvider.ps1"
.".\GetDataEntitiesWithSources.ps1"


Function AxDataEntityFieldReport  {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string]$metadataPath = "C:\AOSService\PackagesLocalDirectory",

        [string]$axLibraryPath,

        [string]$outFile = $env:USERPROFILE + "\Documents\DataEntityFields",

        [string]$loadFromCache = $false,

        [string]$updateCache = $true
    )

    BEGIN {
        if ($axLibraryPath -eq "") {
            $axLibraryPath = $metadataPath + "\bin\"
        }

        $dataEntities = Get-AxDataEntities -metadataPath $metadataPath -axLibraryPath $axLibraryPath
    }

    PROCESS {
        $dataEntities | Sort-Object Name |
            Select-Object Name, Public, PublicCollectionName, StagingTable, EntityCategory, TableGroup, Field_Name, Field_Binding | 
            Export-Csv $outFile".csv" -NoTypeInformation # export as csv file
    }

    END {
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

AxDataEntityFieldReport -metadataPath "C:\AOSService\PackagesLocalDirectory"

