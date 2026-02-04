Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

if ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
	scoop update
}

if ( -Not ( Get-Command git -ErrorAction SilentlyContinue ) ) {
	scoop install git
}

scoop bucket add extras
scoop bucket add nerd-fonts

if ( -Not ( Get-Command atuin -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://setup.atuin.sh | sh
}

if ( -Not ( Get-Command pnpm -ErrorAction SilentlyContinue ) ) {
	iwr https://get.pnpm.io/install.ps1 -useb | iex
} else {
	pnpm self-update
}
