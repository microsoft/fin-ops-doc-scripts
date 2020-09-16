.".\MetadataProvider.ps1"

Function Get-AxSSRSReports {

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
    
    $reportsModelInfos = $metadataProvider.Reports.GetPrimaryKeysWithModelInfo()

    #array of the names of all the reports that use Print Management (used PrintMgmtReportFormat table from Application Explorer)
    $printMgmtReports = @("SalesInvoice", "SalesConfirm", "SalesPackingSlip", "WMSPickingList_OrderPick", "FreeTestInvoice", "SalesQuotationConfirmation", 
    "SalesQuotation", "VendInvoiceDocument", "PurchPackingSlip", "PurchReceiptsList", "PurchPurchaseOrder", "ProjInvoice", 
    "PurchRFQFormLetter_Send", "CustInterestNote", "CustCOllectionJour", "CustAccountStatementExt", "AgreementConfirmation", "PSAQuotations", 
    "PSAProjInvoice", "PSAContractLineInvoice","PSAManageInvoice", "PSAManageInvoiceBR", "PSACustRetentionReleaseInvoice")

    foreach ($tuple in $reportsModelInfos)
    {
        $elementName = $tuple.Item1
        $modelInfoNames = $tuple.Item2 | select -ExpandProperty Name # convert list of ModelInfo objects to list of Names
        $modelNames = [string]::Join("; ", $modelInfoNames);

        $element = $metadataProvider.Reports.Read($elementName)

        $printMgmt = ($printMgmtReports -contains $element.Name)

        foreach($i in $element.DataSets)
        {
            #filter out system fields
            $fields = @()
            foreach($j in $i.Fields)
            {
                if($j -notlike "AX_*")
                {
                    $fields += $j
                }
            }
                
            $filters = @()
            #filter out system parameters
            foreach($k in $i.Parameters)
            {
                if($k -notlike "AX_*")
                {
                    $filters += $k
                }
            } 
                  
                $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    DataSet = $i.Name
                    Name = $element.Name
                    Fields = [string]::Join(", ", $fields)
                    Filters = [string]::Join(", ", $filters)
                    PrintMgmt = $printMgmt
                }

            $outItems       
        }
    }
    }
}

#
#SSRS Reports
#
$outFile = $env:USERPROFILE + "\Documents\SSRSReports"

$reports = Get-AxSSRSReports -metadataPath "C:\AOSService\PackagesLocalDirectory"

$reports | Sort-Object Name |
    Select-Object Name, DataSet, Filters, Fields, PrintMgmt | 
    Export-Csv $outFile".csv" -NoTypeInformation # export as csv file
