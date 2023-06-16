# This script is used to run a scheduled job that updates data flow status manifests
# See Sage IT service catalog section about this here:
#   https://help.sc.sageit.org/sc/Service-Catalog-Provisioning.938836322.html#ServiceCatalogProvisioning-ScheduledJobs

# load libraries
library(dfamodules)

# set variables
base_url <- "https://schematic.api.sagebionetworks.org/"
schema_url <- Sys.getenv("SCHEMA_URL")
asset_view <- Sys.getenv("ASSET_VIEW")
manifest_dataset_id <- Sys.getenv("MANIFEST_DATASET_ID")
secrets <- jsonlite::fromJSON(Sys.getenv("SCHEDULED_JOB_SECRETS"))
access_token <- secrets$pat

# check variables
if (is.null(schema_url) || nchar(schema_url) == 0) stop("missing schema_url")
if (is.null(asset_view) || nchar(asset_view) == 0) stop("missing asset_view")
if (is.null(manifest_dataset_id) || nchar(manifest_dataset_id) == 0) stop("missing manifest_dataset_id")
if (is.null(access_token) || nchar(access_token) == 0) stop("missing access_token")

# update FAIR demo
tryCatch({
  update_data_flow_manifest(asset_view = asset_view,
                            manifest_dataset_id = manifest_dataset_id,
                            na_replace = "Not Applicable",
                            schema_url = schema_url,
                            access_token = access_token,
                            base_url = base_url)
},
error=function(e) {
  message(paste0("Update to ", asset_view, " failed"))
  message(e)
}
)
