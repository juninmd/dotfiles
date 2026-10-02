# Downloads the dotfiles installer and verifies its SHA-256 before running.
$ErrorActionPreference = 'Stop'
$rel = 'https://github.com/juninmd/dotfiles/releases/latest/download'
$name = 'dotfiles-windows-x64.exe'
$tmp = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid())
New-Item -ItemType Directory $tmp | Out-Null
try {
  Invoke-WebRequest "$rel/$name" -OutFile "$tmp\$name"
  $sums = (Invoke-WebRequest "$rel/SHA256SUMS").Content -split "`n"
  $want = ($sums | Where-Object { $_ -match [regex]::Escape($name) + '\s*$' } | Select-Object -First 1) -split '\s+' | Select-Object -First 1
  if (-not $want) { throw "no checksum for $name" }
  $got = (Get-FileHash "$tmp\$name" -Algorithm SHA256).Hash
  if ($want -ne $got) { throw 'checksum mismatch' }
  & "$tmp\$name" @args
} finally { Remove-Item -Recurse -Force $tmp }
