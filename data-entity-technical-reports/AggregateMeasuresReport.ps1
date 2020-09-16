.".\MetadataProvider.ps1"

Function ArrayToHash
{
    param() 
    begin { $hash = @{} }
    process { $hash[$_.Name] = $_ }
    end { return $hash }
}


Function Get-AxAggregateDimensions {

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
    
    $aggregateDimensionsModelInfos = $metadataProvider.AggregateDimensions.GetPrimaryKeysWithModelInfo()
        
    foreach ($tuple in $aggregateDimensionsModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.AggregateDimensions.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            DataSource = $element.Table
        }
            
        $outItems      
    } 
    }

    END {}
}
    
$aggregateDimensions = Get-AxAggregateDimensions -metadataPath "C:\AOSService\PackagesLocalDirectory"
$aggregateDimensionsHash = $aggregateDimensions | ArrayToHash

Function Get-AxAggregateMeasures {

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
    
    $aggregateMeasurementsModelInfos = $metadataProvider.AggregateMeasurements.GetPrimaryKeysWithModelInfo()
        
    foreach ($tuple in $aggregateMeasurementsModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.AggregateMeasurements.Read($elementName)

        foreach($k in $element.MeasureGroups)
        {
            $dimensionsArray = @()

            #creates an array of dimensions and their data source in parenthesis per MeasureGroup
            foreach($i in $k.Dimensions)
            {
                $pos = $i.ToString().IndexOf(" ")
                $i = $i.ToString().Substring(0, $pos)

                $dimensionsArray += ($i + " ("+$aggregateDimensionsHash[$i].DataSource+")")  
            }
                
            $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    Measures = [String]::join(", ", $k.Measures)
                    MeasureGroup = $k.Name
                    MeasureGroupDataSource = $k.Table
                    Dimensions = [String]::join(", ", $dimensionsArray)
                    Name = $element.Name
                }

                $outItems    
        }
    }
    }

    END {}
}

#
# Aggregate Measures
#
$outFile = $env:USERPROFILE + "\Documents\AggregateMeasures"

$aggregateMeasures = Get-AxAggregateMeasures -metadataPath "C:\AOSService\PackagesLocalDirectory"

$aggregateMeasures | Sort-Object Name |
    Select-Object Name, MeasureGroup, MeasureGroupDataSource, Measures, Dimensions | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

