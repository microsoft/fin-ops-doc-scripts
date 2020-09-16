.".\MetadataProvider.ps1"

Function Get-AxLicenseCodes {

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
    $licenseCodeModelInfos = $metadataProvider.LicenseCodes.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $licenseCodeModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.LicenseCodes.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            Models = $modelNames
            Package = $element.Package
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }
  }

  END {}
}

Function Get-AxConfigKeys {

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
    $configKeyModelInfos = $metadataProvider.ConfigurationKeys.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $configKeyModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.ConfigurationKeys.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            Models = $modelNames
            LicenseCode = $element.LicenseCode
            ParentKey = $element.ParentKey
            ConfigKey = $element.ConfigurationKey
            Enabled = $element.Enabled
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }
  }

  END {}
}

Function Get-AxConfigKeyGroups {

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
    $configKeyModelInfos = $metadataProvider.ConfigurationKeyGroups.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $configKeyModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.ConfigurationKeyGroups.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            Models = $modelNames
            LicenseCode = $element.LicenseCode
            ParentKeyGroup = $element.ParentKeyGroup
            ConfigKeys = $element.ConfigurationKeys
            Enabled = $element.Enabled
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }
  }

  END {}
}

Function Get-AxMenuItems {

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
    $displayMenuItemModelInfos = $metadataProvider.MenuItemDisplays.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $displayMenuItemModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.MenuItemDisplays.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            MenuItemType = "Display"
            Models = $modelNames
            ObjectType = $element.ObjectType
            Object = $element.Object
            ConfigKey = $element.ConfigurationKey
            Enabled = $element.Enabled
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }

    $actionMenuItemModelInfos = $metadataProvider.MenuItemActions.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $actionMenuItemModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.MenuItemActions.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            MenuItemType = "Display"
            Models = $modelNames
            ObjectType = $element.ObjectType
            Object = $element.Object
            ConfigKey = $element.ConfigurationKey
            Enabled = $element.Enabled
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }

    $outputMenuItemModelInfos = $metadataProvider.MenuItemOutputs.GetPrimaryKeysWithModelInfo()

    foreach ($tuple in $outputMenuItemModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.MenuItemOutputs.Read($elementName)

        $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
            Name = $element.Name
            MenuItemType = "Display"
            Models = $modelNames
            ObjectType = $element.ObjectType
            Object = $element.Object
            ConfigKey = $element.ConfigurationKey
            Enabled = $element.Enabled
            LabelID = $element.Label
            Label = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
        }

        $outItems
    }
  }

  END {}
}

#
# LicenseCode
#
$outFile = $env:USERPROFILE + "\Documents\LicenseCodes"

$lc = Get-AxLicenseCodes -metadataPath "C:\AOSService\PackagesLocalDirectory"

$lc | 
    Select-Object Name, Models, Package, LabelID, Label | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

#
# ConfigKey
#
$outFile = $env:USERPROFILE + "\Documents\ConfigKeys"

$configKeys = Get-AxConfigKeys -metadataPath "C:\AOSService\PackagesLocalDirectory"

$configKeys | 
    Select-Object Name, Models, LicenseCode, ParentKey, ConfigKey, Enabled, LabelID, Label | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file

#
# ConfigKeyGroup
#
$outFile = $env:USERPROFILE + "\Documents\ConfigKeyGroups"

$configKeyGroups = Get-AxConfigKeyGroups -metadataPath "C:\AOSService\PackagesLocalDirectory"

$configKeyGroups | 
    Select-Object Name, Models, LicenseCode, ParentKeyGroup, ConfigKeys, Enabled, LabelID, Label | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file


#
# MenuItems
#
$outFile = $env:USERPROFILE + "\Documents\MenuItems"

$menuItems = Get-AxMenuItems -metadataPath "C:\AOSService\PackagesLocalDirectory"

$menuItems | 
    Select-Object Name, MenuItemType, Models, ObjectType, Object, ConfigKey, LabelID, Label | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file
