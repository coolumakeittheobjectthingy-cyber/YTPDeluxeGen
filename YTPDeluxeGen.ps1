Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Helper: Show an image in a PictureBox, falling back on an error message
function Show-PreviewImage {
    param([string]$Path, [System.Windows.Forms.PictureBox]$PictureBox)
    try {
        $PictureBox.Image = [System.Drawing.Image]::FromFile($Path)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Preview failed: $_")
        $PictureBox.Image = $null
    }
}

# GUI definitions
$form = New-Object System.Windows.Forms.Form
$form.Text = "YTPDeluxeGen (Mega) - PowerShell Edition"
$form.Size = New-Object System.Drawing.Size(700,520)
$form.FormBorderStyle = 'Fixed3D'

# Asset List
$listAssets = New-Object System.Windows.Forms.ListBox
$listAssets.Location = New-Object System.Drawing.Point(10,40)
$listAssets.Size = New-Object System.Drawing.Size(260,280)
$form.Controls.Add($listAssets)

# Asset controls
$btnImport = New-Object System.Windows.Forms.Button
$btnImport.Text = "Import Assets"
$btnImport.Location = New-Object System.Drawing.Point(10,330)
$form.Controls.Add($btnImport)

$btnPreview = New-Object System.Windows.Forms.Button
$btnPreview.Text = "Preview"
$btnPreview.Location = New-Object System.Drawing.Point(110,330)
$form.Controls.Add($btnPreview)

$btnRemove = New-Object System.Windows.Forms.Button
$btnRemove.Text = "Remove"
$btnRemove.Location = New-Object System.Drawing.Point(190,330)
$form.Controls.Add($btnRemove)

# Asset Preview area
$picturePreview = New-Object System.Windows.Forms.PictureBox
$picturePreview.Location = New-Object System.Drawing.Point(290,40)
$picturePreview.Size = New-Object System.Drawing.Size(300,170)
$picturePreview.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$form.Controls.Add($picturePreview)

# Style/Type/Format
$lblStyle = New-Object System.Windows.Forms.Label
$lblStyle.Location = New-Object System.Drawing.Point(290,220)
$lblStyle.Size = New-Object System.Drawing.Size(80,20)
$lblStyle.Text = "Style:"
$form.Controls.Add($lblStyle)
$cmbStyle = New-Object System.Windows.Forms.ComboBox
$cmbStyle.Items.AddRange(@("2007-2012 (classic)", "2013-2021 (modern)", "Advance", "Mega", "Deluxe"))
$cmbStyle.SelectedIndex = 3 # 'Mega'
$cmbStyle.Location = New-Object System.Drawing.Point(360,220)
$cmbStyle.Width = 140
$form.Controls.Add($cmbStyle)

$lblType = New-Object System.Windows.Forms.Label
$lblType.Location = New-Object System.Drawing.Point(290,250)
$lblType.Size = New-Object System.Drawing.Size(80,20)
$lblType.Text = "Project Type:"
$form.Controls.Add($lblType)
$cmbType = New-Object System.Windows.Forms.ComboBox
$cmbType.Items.AddRange(@("Generic", "YTP Tennis", "Collab Entry", "YTPMV"))
$cmbType.SelectedIndex = 0
$cmbType.Location = New-Object System.Drawing.Point(360,250)
$cmbType.Width = 140
$form.Controls.Add($cmbType)

$lblFormat = New-Object System.Windows.Forms.Label
$lblFormat.Location = New-Object System.Drawing.Point(290,280)
$lblFormat.Size = New-Object System.Drawing.Size(80,20)
$lblFormat.Text = "Format:"
$form.Controls.Add($lblFormat)
$cmbFormat = New-Object System.Windows.Forms.ComboBox
$cmbFormat.Items.AddRange(@("WMV","MP4","AVI","MKV"))
$cmbFormat.SelectedIndex = 1
$cmbFormat.Location = New-Object System.Drawing.Point(360,280)
$cmbFormat.Width = 140
$form.Controls.Add($cmbFormat)

# Project name and metadata
$lblProject = New-Object System.Windows.Forms.Label
$lblProject.Location = New-Object System.Drawing.Point(10,10)
$lblProject.Size = New-Object System.Drawing.Size(90,20)
$lblProject.Text = "Project Name:"
$form.Controls.Add($lblProject)
$txtProjectName = New-Object System.Windows.Forms.TextBox
$txtProjectName.Location = New-Object System.Drawing.Point(100,10)
$txtProjectName.Size = New-Object System.Drawing.Size(170,20)
$form.Controls.Add($txtProjectName)

$lblMinDur = New-Object System.Windows.Forms.Label
$lblMinDur.Location = New-Object System.Drawing.Point(480,10)
$lblMinDur.Size = New-Object System.Drawing.Size(80,20)
$lblMinDur.Text = "Min Dur (s):"
$form.Controls.Add($lblMinDur)
$numMinDur = New-Object System.Windows.Forms.NumericUpDown
$numMinDur.Location = New-Object System.Drawing.Point(560,10)
$numMinDur.Minimum = 1
$numMinDur.Maximum = 600
$numMinDur.Value = 1
$form.Controls.Add($numMinDur)

$lblMaxDur = New-Object System.Windows.Forms.Label
$lblMaxDur.Location = New-Object System.Drawing.Point(480,35)
$lblMaxDur.Size = New-Object System.Drawing.Size(80,20)
$lblMaxDur.Text = "Max Dur (s):"
$form.Controls.Add($lblMaxDur)
$numMaxDur = New-Object System.Windows.Forms.NumericUpDown
$numMaxDur.Location = New-Object System.Drawing.Point(560,35)
$numMaxDur.Minimum = 1
$numMaxDur.Maximum = 3600
$numMaxDur.Value = 5
$form.Controls.Add($numMaxDur)

$lblClips = New-Object System.Windows.Forms.Label
$lblClips.Location = New-Object System.Drawing.Point(480,60)
$lblClips.Size = New-Object System.Drawing.Size(80,20)
$lblClips.Text = "Clip Count:"
$form.Controls.Add($lblClips)
$numClips = New-Object System.Windows.Forms.NumericUpDown
$numClips.Location = New-Object System.Drawing.Point(560,60)
$numClips.Minimum = 1
$numClips.Maximum = 999
$numClips.Value = 10
$form.Controls.Add($numClips)

# Generate button
$btnGenerate = New-Object System.Windows.Forms.Button
$btnGenerate.Text = "Generate Demo"
$btnGenerate.Location = New-Object System.Drawing.Point(420,340)
$btnGenerate.Size = New-Object System.Drawing.Size(170,40)
$form.Controls.Add($btnGenerate)

# Asset storage
$global:AssetInfoList = @()

# Asset import logic
$btnImport.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Multiselect = $true
    $ofd.Filter = "Media Files|*.mp4;*.wmv;*.avi;*.png;*.jpg;*.jpeg;*.webp;*.gif;*.mp3;*.wav;*.ogg|All Files|*.*"
    if($ofd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        foreach ($f in $ofd.FileNames) {
            $global:AssetInfoList += [PSCustomObject]@{
                Path = $f
                Tag  = [System.IO.Path]::GetFileName($f)
                Type = switch -regex ($f) {
                    '\.(png|jpg|jpeg|webp|gif)$' { "Image"; break }
                    '\.(mp4|wmv|avi|mkv)$' { "Video"; break }
                    '\.(mp3|wav|ogg)$' { "Audio"; break }
                    default { "Unknown" }
                }
            }
            $listAssets.Items.Add([System.IO.Path]::GetFileName($f))
        }
    }
})

# Remove asset
$btnRemove.Add_Click({
    $idx = $listAssets.SelectedIndex
    if($idx -ge 0){
        $listAssets.Items.RemoveAt($idx)
        $global:AssetInfoList = $global:AssetInfoList | Where-Object { $_.Tag -ne $global:AssetInfoList[$idx].Tag }
        $picturePreview.Image = $null
    }
})

# Preview logic
$btnPreview.Add_Click({
    $idx = $listAssets.SelectedIndex
    if($idx -eq -1){ return }
    $asset = $global:AssetInfoList[$idx]
    switch ($asset.Type) {
        'Image' {
            Show-PreviewImage $asset.Path $picturePreview
        }
        'Video' { Start-Process $asset.Path }
        'Audio' { Start-Process $asset.Path }
        default { [System.Windows.Forms.MessageBox]::Show("Unsupported preview type: $($asset.Type)") }
    }
})

# Generate Demo (Fake render/demo functionality)
$btnGenerate.Add_Click({
    $summary = "YTPGen Mega Project `"$($txtProjectName.Text)`" Demo`n"
    $summary += "Type: " + $cmbType.SelectedItem + " | Style: " + $cmbStyle.SelectedItem + " | Format: " + $cmbFormat.SelectedItem + "`n"
    $summary += "Clips: $($numClips.Value) | Duration: $($numMinDur.Value)-$($numMaxDur.Value) s`n"
    $summary += "Assets:`n"
    foreach($a in $global:AssetInfoList){
        $summary += "- [$($a.Type)] $($a.Tag)`n"
    }
    [System.Windows.Forms.MessageBox]::Show($summary, "Generation Results")
})

# Show
$form.Topmost = $true
[void]$form.ShowDialog()