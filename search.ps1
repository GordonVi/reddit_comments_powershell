function pause {
	
write-host -foregroundcolor cyan @"

Paused: Press ENTER key to quit
"@

Read-Host | out-null


}
$list = $(gci ./data).name | ? { $_ -like "*.json" }
clear

if ($list.count -eq 0) {
	
write-host -foregroundcolor yellow @"


You have not pulled any data. 

Use `"pull_comments.ps1`" to pull data.

Then use `"search.ps1`" to search the data you pulled.

"@

	pause
	exit

}

if ($list.count -eq 1) {
	
	$file = $list
	
	} else {

	import-module ./PSMenu/PSMenu/PSMenu.psm1

	write-host -foregroundcolor yellow @"

	File Selection Menu:

	Which file do you want to open?

"@

	$file = show-menu $list

}

write-host -foregroundcolor yellow @"

What do you want to look for?  
  
Ex: *narwhals*

"@

$search = read-host "Search"

$b = gc "./data/$file" | ConvertFrom-Json

$results = $b | ? {$_.data.body -like $search}

write-host -foregroundcolor yellow @"
Total Comment Count: $($b.count)
      Comment Count: $($results.count)
            Results: 

"@

foreach ($item in $results) {
	
	write-host -foregroundcolor cyan $item.data.link_permalink
	write-host -foregroundcolor green $item.data.link_url
	""
	$item.data.body

@"




"@

	}

pause
