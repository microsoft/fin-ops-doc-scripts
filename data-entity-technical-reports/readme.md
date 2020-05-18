# Run the data entity reports

These are the report files.

Script | Outputs | Description
---|---|---|
AggregateDataEntitiesReport.ps1 | AggregateDataEntities.csv |
AggregateMeasuresReport.ps1 | AggregateMeasures.csv|
DataEntityFieldReport.ps1 | DataEntityFields.csv |
DataEntityReport.ps1 | DataEntities.csv |
KPIReport.ps1 | KPIs.csv | 
SSRSReport.ps1 | SSRSReports.csv |
TablePermissionsReport.ps1 | AosAuthorizations.csv | 
TablesReport.ps1 | Tables.csv |  dependent on AxDataEntityFieldReport, takes a while to run, but produces status output while it runs.
WorkflowTypesReport.ps1 | WorkflowTypes.csv |
LicenseCode-ConfigKeyReport.ps1 | LicenseCodes.csv<br>ConfigKeys.csv<br>ConfigKeyGroups.csv<br>MenuItems.csv | 

The report scripts use functions from these files:

+ GetDataEntitiesWithSources.ps1
+ MetadataProvider.ps1

Because the reports scripts include the function files, you need to run the reports from the folder with the .ps1 files.

