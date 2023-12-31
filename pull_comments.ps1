param(
        [Parameter(mandatory=$true)]
        [string] $reddit_username
)

$total = @()

$url = "https://old.reddit.com/user/$reddit_username/.json"
$response = $(Invoke-WebRequest -URI $url).content | ConvertFrom-Json

$list = $response.data.children.data.name
$total += $response.data.children

@"

Pulling comments for user: $reddit_username

"@

do {

	$x++  
	
	$last = $list[24]

	$url = "https://old.reddit.com/user/$reddit_username/.json?after=$last"
	$response = $(Invoke-WebRequest -URI $url).content | ConvertFrom-Json

	$list = $response.data.children.data.name

	"Page: $x"
	
	$total += $response.data.children
	
} until ($list.count -ne 25)
#} until ($x -gt 5 -or $list.count -ne 25) # for testing

$total | convertto-json -depth 10 | out-file "./data/$reddit_username`_comments_$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").json" 

