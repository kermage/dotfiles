Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

if ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
	scoop bucket add extras
	scoop bucket add nerd-fonts
}

if ( -Not ( Get-Command pnpm -ErrorAction SilentlyContinue ) ) {
	iwr https://get.pnpm.io/install.ps1 -useb | iex
}

Add-Content -Path "$HOME\.config\chezmoi\chezmoi.yaml" -Value "interpreters:`n  sh:`n    command: bash"
