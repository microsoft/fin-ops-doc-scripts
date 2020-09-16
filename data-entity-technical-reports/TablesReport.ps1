.".\MetadataProvider.ps1"
.".\GetDataEntitiesWithSources.ps1"

Function Get-AxForms {

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
    
    $formsModelInfos = $metadataProvider.Forms.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $formsModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.Forms.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            DataSources = $element.DataSources       
        }

        $outItems
    }
    }

    END {}
}

Function Get-AxViews {

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
    
    $viewsModelInfos = $metadataProvider.Views.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $viewsModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.Views.Read($elementName)
            
        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    Name = $element.Name
                    DataSources = $element.ViewMetadata.DataSources

                }

        $outItems  
        }
    }

    END {}
}

$dataEntities = Get-AxDataEntities -metadataPath "C:\AOSService\PackagesLocalDirectory"
$forms = Get-AxForms -metadataPath "C:\AOSService\PackagesLocalDirectory"
$views = Get-AxViews -metadataPath "C:\AOSService\PackagesLocalDirectory"

Function Get-AxTables {

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
    
    $tablesModelInfos = $metadataProvider.Tables.GetPrimaryKeysWithModelInfo()

    #declare variables
    $entityOrView
    $crossCompany = ""

    foreach ($tuple in $tablesModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.Tables.Read($elementName)
        Write-Host $elementName

        #check if table is used in an entity
        $entityMatch = "No"
        foreach($i in $dataEntities)
        {
            if ($i.DataSource) {
                if($i.DataSource.StartsWith($element.Name + " ["))
                {
                    $entityMatch = "Yes"
                }
            }
        }

        #check if table is used in a view
        $viewMatch = "No"
        foreach($i in $views)
        {
            foreach($k in $i.DataSources)
            {
                  
                if($element.Name -eq $k.Name)
                {
                    $viewMatch = "Yes"
                }
            }
        }

        if($viewMatch -eq "Yes" -or $entityMatch -eq "Yes")
        {
            $entityOrView = "Yes"
        }
        else
        {
            $entityOrView = "No"
        }

        #check if form's data source is the table and then taking CrossCompanyAutoQuery property
        foreach($i in $forms)
        {
            foreach($k in $i.DataSources)
            {
                if($k.Name -eq $element.Name)
                {
                    $crossCompany = $k.CrossCompanyAutoQuery
                    if($crossCompany -eq "")
                    {
                        $crossCompany = "No"
                    }
                }
            }
        }

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    Name = $element.Name
                    TableGroup = $element.TableGroup
                    CrossCompany = $crossCompany
                    SystemTable = $element.SystemTable
                    Indexes = [string]::Join(", ", $element.Indexes)
                    EntityOrView = $entityOrView
                }

        $outItems  
        }
    }

    END {}
}

#
#Tables Reports
#


$outFile = $env:USERPROFILE + "\Documents\Tables"

$tables = Get-AxTables -metadataPath "C:\AOSService\PackagesLocalDirectory"

$tables | Sort-Object Name |
    Select-Object Name, TableGroup, CrossCompany, SystemTable, Indexes, EntityOrView | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file
