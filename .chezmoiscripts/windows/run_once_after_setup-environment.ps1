[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "%USERPROFILE%\.config", "User")
[Environment]::SetEnvironmentVariable("BAT_CONFIG_DIR", "%USERPROFILE%\.config\bat", "User")
[Environment]::SetEnvironmentVariable("YAZI_CONFIG_HOME", "%USERPROFILE%\.config\yazi", "User")

if ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue ) ) {
	$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
				[System.Environment]::GetEnvironmentVariable("PATH", "User")
}

bat cache --build
