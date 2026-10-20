<#
.SYNOPSIS
  Verifies that the DevAgent adapters, Claude Code wrappers and internal links stay in sync.
.DESCRIPTION
  Checks: (1) skill mirrors in .claude/skills, (2) subagent wrappers and personas,
  (3) role aliases and the commit/push prohibition in every platform adapter,
  (4) relative Markdown links resolve and no file:/// links remain.
  Exit code 0 = OK, 1 = problems found.
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$errors = New-Object System.Collections.Generic.List[string]
function Fail($msg) { $script:errors.Add($msg) }

function Get-Frontmatter($path) {
    $text = [IO.File]::ReadAllText($path)
    $m = [regex]::Match($text, '(?s)\A---\r?\n(.*?)\r?\n---')
    $h = @{}
    if (-not $m.Success) { return $h }
    foreach ($line in ($m.Groups[1].Value -split '\r?\n')) {
        $kv = [regex]::Match($line, '^(\w[\w-]*):\s*(.*)$')
        if ($kv.Success) { $h[$kv.Groups[1].Value] = $kv.Groups[2].Value.Trim().Trim('"').Trim("'") }
    }
    return $h
}

# 1. Skill mirrors
foreach ($dir in Get-ChildItem '.agents/skills' -Directory) {
    $src = Join-Path $dir.FullName 'SKILL.md'
    $mirror = ".claude/skills/$($dir.Name)/SKILL.md"
    if (-not (Test-Path $mirror)) { Fail "Missing Claude skill mirror: $mirror"; continue }
    $a = Get-Frontmatter $src; $b = Get-Frontmatter $mirror
    # Wrapper descriptions are intentionally trigger-style, so only name/presence is enforced.
    if ($a['name'] -ne $b['name']) { Fail "Skill '$($dir.Name)': frontmatter 'name' differs between .agents and .claude" }
    foreach ($k in 'name', 'description') {
        if (-not $b[$k]) { Fail "Skill mirror ${mirror}: missing frontmatter '$k'" }
    }
    if ($b['name'] -ne $dir.Name) { Fail "Skill mirror ${mirror}: name '$($b['name'])' != folder '$($dir.Name)'" }
    if ((Get-Content $mirror -Raw) -notmatch [regex]::Escape(".agents/skills/$($dir.Name)/SKILL.md")) {
        Fail "Skill mirror $mirror does not point to .agents/skills/$($dir.Name)/SKILL.md"
    }
}
foreach ($dir in Get-ChildItem '.claude/skills' -Directory) {
    if (-not (Test-Path ".agents/skills/$($dir.Name)/SKILL.md")) { Fail "Orphan Claude skill (no source in .agents/skills): $($dir.Name)" }
}

# 2. Subagent wrappers
foreach ($f in Get-ChildItem '.claude/agents' -Filter *.md) {
    $fm = Get-Frontmatter $f.FullName
    foreach ($k in 'name', 'description') { if (-not $fm[$k]) { Fail "$($f.Name): missing frontmatter '$k'" } }
    if ($fm['name'] -and $fm['name'] -ne $f.BaseName) { Fail "$($f.Name): name '$($fm['name'])' != filename" }
    $body = Get-Content $f.FullName -Raw
    if ($body -notmatch '\.agents/personas/[\w-]+\.md') { Fail "$($f.Name): does not reference a persona in .agents/personas/" }
    foreach ($ref in [regex]::Matches($body, '\.agents/(personas|skills|rules)/[\w\-/]+\.md')) {
        if (-not (Test-Path $ref.Value)) { Fail "$($f.Name): referenced file not found: $($ref.Value)" }
    }
}

# 3. Adapters: aliases + commit/push prohibition
$adapters = 'CLAUDE.md', 'AGENTS.md', 'GEMINI.md', 'CODEX.md', '.cursorrules', '.github/copilot-instructions.md', 'README.md'
$aliases = '@Architect', '@WebDesigner', '@TicketPlanner', '@DevJunior', '@DevSenior', '@Security'
foreach ($ad in $adapters) {
    if (-not (Test-Path $ad)) { Fail "Missing adapter: $ad"; continue }
    $t = Get-Content $ad -Raw
    foreach ($al in $aliases) { if ($t -notmatch [regex]::Escape($al)) { Fail "${ad}: missing alias $al" } }
    if ($t -notmatch 'git commit' -or $t -notmatch 'git push') { Fail "${ad}: missing commit/push prohibition" }
}

# 4. Links
$mdFiles = Get-ChildItem -Recurse -File -Include *.md, .cursorrules |
    Where-Object { $_.FullName -notmatch '[\/](\.git|node_modules)[\/]' }
foreach ($f in $mdFiles) {
    $rel = $f.FullName.Substring($root.Length + 1)
    $text = [IO.File]::ReadAllText($f.FullName)
    if ($text -match 'file:///') { Fail "${rel}: contains file:/// link (use a relative path)" }
    foreach ($m in [regex]::Matches($text, '(?<!!)\[[^\]]*\]\(([^)\s]+)\)')) {
        $target = $m.Groups[1].Value
        if ($target -match '^(https?:|mailto:|#)') { continue }
        $target = ($target -split '#')[0]
        if (-not $target) { continue }
        $full = Join-Path $f.DirectoryName $target
        if (-not (Test-Path -LiteralPath $full)) {
            # tolerate links to deliverables generated in target projects
            if ($target -match '(^|[\/])docs[\/]' -or $target -match 'plan\.md$') { continue }
            Fail "${rel}: broken link -> $target"
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Consistency check FAILED ($($errors.Count) problem(s)):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host 'Consistency check passed.' -ForegroundColor Green
