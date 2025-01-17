# clockify_backup.sh

## Description

This script backs up time-entries, projects and clients from clockify.me. It will export the current and last month
into JSON files named after the corresponding month. 

# Requirements

curl and jq need to be installed

# Running

This script takes no arguments but requires the environment varible CLOCKIFY_API_KEY to be set:

```
CLOCKIFY_API_KEY=... ./clockify_backup.sh
```

Output will be written to the current directory.
