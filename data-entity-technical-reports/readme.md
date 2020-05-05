# Run the data entity reports

Run the reports in this order:

Script | Outputs | Description
---|---|---|
AxAggregateDataEntitiesReport.ps1 | AggregateDataEntities.csv<br>AggregateDataEntities.xml
AxAggregateMeasuresReport.ps1 | AggregateMeasures.csv<br>AggregateMeasures.xml<br>Analysis-AxAggregateDimensionsV2.xml |
AxDataEntityFieldReport.ps1 | DataEntityFields.csv<br>DataEntityFields.xml |
AxDataEntityReport.ps1 | DataEntities.csv<br>DataEntities.xml |
AxKPIReport.ps1 | KPIs.csv<br>KPIs.xml | 
AxSSRSReport.ps1 | SSRSReports.csv<br>SSRSReports.xml |
AxTablePermissionsReport.ps1 | AosAuthorizations.csv<br>AosAuthorizations.xml |  |
AxTablesReport.ps1 | Tables.csv<br>Tables.xml |  dependent on AxDataEntityFieldReport, takes a while to run, but produces status output while it runs.
AxWorkflowTypesReport.ps1 | WorkflowTypes.csv<br>WorkflowTypes.xml |
LicenseCode-ConfigKeyReport.ps1 | LicenseCodes.csv<br>LicenseCodes.xml<br>ConfigKeys.csv<br>ConfigKeys.xml<br>ConfigKeyGroups.csv<br>ConfigKeyGroups.xml | 



Message when you click Run is:

```Plaintext
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer. If you trust this script, use the Unblock-File cmdlet to allow the script to without this warning message. Do want to run <filename> ? 
```
Click **Run once** to run the report.


