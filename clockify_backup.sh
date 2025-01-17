#!/bin/bash
#
# backup current and last month as well as clients and projects
#

if [ -z "$CLOCKIFY_API_KEY" ] ; then
    echo "Environment variable CLOCKIFY_API_KEY must be set!"
    exit 1
fi

CLOCKIFY_API_BASE_URL=https://api.clockify.me/api

function clockify_api {
    api_path=$1
    curl -s -H "X-Api-Key: $CLOCKIFY_API_KEY" $CLOCKIFY_API_BASE_URL$api_path
}

user_id=$(clockify_api /v1/user | jq -r .id)
workspace_id=$(clockify_api /v1/workspaces | jq -r ".[0].id")

#
# find last months boundaries
#

first_of_this_month_string=$(date +%Y-%m-01)
first_of_this_month_epoch=$(date --date=$first_of_this_month_string +%s)
# subtract one day worth of seconds from the first of this month to get the last day of last month
#last_day_of_last_month_string=$(date --date=@$(($first_of_this_month_epoch-86400)) +%Y-%m-%d)
#first_day_of_last_month_string=$(date --date=@$(($first_of_this_month_epoch-86400)) )
set $(date --date=@$(($first_of_this_month_epoch-86400)) +"%Y-%m-%d %Y-%m-01 %Y-%m")
last_day_of_last_month_string=$1
first_day_of_last_month_string=$2
last_month_filename=$3

first_day_of_current_month_string=$(date +%Y-%m-01)
current_month_filename=$(date +%Y-%m)

if clockify_api /v1/workspaces/$workspace_id/user/$user_id/time-entries?start=${first_day_of_last_month_string}T00:00:00Z\&end=${last_day_of_last_month_string}T23:59:59Z > tmp.json ; then
    mv tmp.json time-entries-$last_month_filename.json
fi

if clockify_api /v1/workspaces/$workspace_id/user/$user_id/time-entries?start=${first_day_of_current_month_string}T00:00:00Z > tmp.json ; then
    mv tmp.json time-entries-$current_month_filename.json
fi

if clockify_api /v1/workspaces/$workspace_id/projects > tmp.json ; then
    mv tmp.json projects.json
fi

if clockify_api /v1/workspaces/$workspace_id/clients > tmp.json ; then
    mv tmp.json clients.json
fi

