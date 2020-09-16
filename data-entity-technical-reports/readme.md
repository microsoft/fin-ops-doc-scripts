# Run the data entity reports

These are the report scripts.

Script | Outputs
---|---
AggregateDataEntitiesReport.ps1 | AggregateDataEntities.csv 
AggregateMeasuresReport.ps1 | AggregateMeasures.csv
DataEntityFieldReport.ps1 | DataEntityFields.csv 
DataEntityReport.ps1 | DataEntities.csv 
KPIReport.ps1 | KPIs.csv 
LicenseCode-ConfigKeyReport.ps1 | LicenseCodes.csv<br>ConfigKeys.csv<br>ConfigKeyGroups.csv<br>MenuItems.csv 
SSRSReport.ps1 | SSRSReports.csv 
TablesReport.ps1 | Tables.csv 
WorkflowTypesReport.ps1 | WorkflowTypes.csv 

The TablesReport.ps1 script takes awhile to run, but produces output as it runs.

The report scripts use functions from these files:

+ GetDataEntitiesWithSources.ps1
+ MetadataProvider.ps1

Because the reports scripts include the function files, you need to run the reports from the folder with the .ps1 files.

You might see this message when you run the reports: 

```Plaintext
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer. If you trust this script, use the Unblock-File cmdlet to allow the script to without this warning message. Do want to run <filename> ? 
```

Click **Run once** to run the report.

