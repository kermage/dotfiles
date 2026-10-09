$ErrorActionPreference = 'Stop'

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

if ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
	scoop update
}

if ( -Not ( Get-Command git -ErrorAction SilentlyContinue ) ) {
	scoop install git
	if ($LASTEXITCODE -ne 0) {
		throw 'scoop install git failed'
	}
}

scoop bucket add extras
scoop bucket add nerd-fonts

if ( -Not ( Get-Command atuin -ErrorAction SilentlyContinue ) ) {
	Invoke-RestMethod -Uri https://setup.atuin.sh | sh -s -- --non-interactive
	if ($LASTEXITCODE -ne 0) {
		throw 'atuin install failed'
	}
}

# pnpm's installer shells out to tar. Driven from Git Bash, PowerShell inherits
# a PATH where GNU tar precedes the native one, and GNU tar reads a C:\ path as
# a remote host: "Cannot connect to C: resolve failed". System32 first fixes it.
$env:PATH = "$env:SystemRoot\System32;$env:PATH"

if ( -Not ( Get-Command pnpm -ErrorAction SilentlyContinue ) ) {
	iwr https://get.pnpm.io/install.ps1 -useb | iex
} else {
	pnpm self-update
}
