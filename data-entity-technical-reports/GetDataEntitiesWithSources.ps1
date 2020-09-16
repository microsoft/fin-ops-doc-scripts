
Function Get-AxDataEntities {

    [CmdletBinding()]
    param(
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
            $modelInfoNames = $tuple.Item2 | Select-Object -ExpandProperty Name # convert list of ModelInfo objects to list of Names
            $modelNames = [string]::Join("; ", $modelInfoNames);

            $element = $metadataProvider.DataEntityViews.Read($elementName)

            #
            # Build list of DataSources
            #
            $datasourceList = @()
            foreach($datasource in $element.ViewMetadata.DataSources) {
                $datasourceList += New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    DataSourceName = $datasource.Name
                    DataSourceTable = $datasource.Table
                }
                $datasourceList += QueryDataSourceRecursion($datasource.DataSources)
            }

            #
            # Convert DataSource list to hash
            #
            $dataSourceHash = @{}
            $datasourceList | ForEach-Object {
                $dataSourceHash[$_.DataSourceName] = $_
            }

            $fields = @()
            foreach($j in $element.Fields) {

                #filter out system fields
                if($j -notlike "AX_*")
                {
                    $typeName= $j.GetType().Name 
                    $field_binding = ""

                    if ($typename -eq "AxDataEntityViewMappedField") {

                        $tableName = ""
                        if ($dataSourceHash.ContainsKey($j.DataSource)) {
                            $tableName = $dataSourceHash[$j.DataSource].DataSourceTable
                        }
                        $field_binding = $j.DataSource + "(" + $tableName + ")." + $j.DataField

                    } 
                    elseif ($j.IsComputedField -ne $null -and $j.ComputedFieldMethod -ne $null) {

                        # handle case of AxDataEntityViewUnmappedField{PrimitiveType}
                        $field_binding = "METHOD: " + $j.ComputedFieldMethod

                    } 
                    else {
                        Write-Warning "Unexpected type $typeName"
                    }

                    $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                        EntityCategory = $element.EntityCategory
                        StagingTable= $element.DataManagementStagingTable
                        PublicCollectionName = $element.PublicCollectionName
                        TableGroup = $element.TableGroup
                        Name = $element.Name
                        Public = $element.IsPublic
                        Field_Name = $j.Name
                        Field_Binding = $field_binding
                    }
                    
                    $outItems
                }
            }
        }
    }
}

#
# Recurse on the AxQuerySimpleEmbeddedDataSource array used by DataEntity under the AxQuerySimpleRootDataSource to return an array of objects
#
Function QueryDataSourceRecursion ([Microsoft.Dynamics.AX.Metadata.MetaModel.AxQuerySimpleEmbeddedDataSource[]] $queryDataSources) {

    $datasourceList = @() 
    foreach($datasource in $queryDataSources) {

        $datasourceList += New-Object PSObject -Property @{ # create a hash table of the name/value pair
            DataSourceName = $datasource.Name
            DataSourceTable = $datasource.Table
        }

        $datasourceList += QueryDataSourceRecursion($datasource.DataSources)
    }

    $datasourceList
}

