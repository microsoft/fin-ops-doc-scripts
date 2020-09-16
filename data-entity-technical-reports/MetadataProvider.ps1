Function Get-AxMetadataProvider {

    [CmdletBinding()]
    param(
    [string]$logfile = 'errors.txt',

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string]$metadataPath,

    [string]$axLibraryPath
    )

    BEGIN {
    }

    PROCESS {
    if ($axLibraryPath -eq "") {
        $axLibraryPath = $metadataPath + "\bin\"
    }

    Add-Type -LiteralPath $axLibraryPath\Microsoft.Dynamics.AX.Metadata.dll
    Add-Type -LiteralPath $axLibraryPath\Microsoft.Dynamics.AX.Metadata.Storage.dll
    Add-Type -LiteralPath $axLibraryPath\Microsoft.Dynamics.AX.Metadata.Core.dll
    Add-Type -LiteralPath $axLibraryPath\Microsoft.Dynamics.AX.Metadata.Extensions.dll
    Add-Type -LiteralPath $axLibraryPath\Microsoft.Dynamics.AX.Xpp.Support.dll

    $providerConfig = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
    $providerConfig.XppMetadataPath = $metadataPath # e.g. "C:\AOSService\PackagesLocalDirectory"
    $providerConfig.MetadataPath = $metadataPath 

    $providerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
    $metadataProvider = $providerFactory.CreateDiskProvider($providerConfig)

    return ,$metadataProvider
    }

      END {}
    }

