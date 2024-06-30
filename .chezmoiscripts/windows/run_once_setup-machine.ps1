Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

if ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

if ( -Not ( Get-Command pnpm -ErrorAction SilentlyContinue ) ) {
	iwr https://get.pnpm.io/install.ps1 -useb | iex
}
