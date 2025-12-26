Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

##########################
## Variables and Models ##
##########################

$ytpgen_Project = [ordered]@{
    Assets = @()
    AudioLibrary = @()
    AudioEffects = @()
    VideoEffects = @()
    ProjectName = ""
    MinStreamDuration = 1
    MaxStreamDuration = 5
    ClipCount = 10
    Style = "Deluxe"
    ProjectMode = "Generic"
    PreferredOutputFormat = "MP4"
}

$audioEffects = @(
    "Random sound", "Mute", "Speed up", "Slow down", "Reverse", "Chorus", "Vibrato",
    "Stutter", "Dance", "Squidward", "Sus", "Lagfun", "Low harmony", "High harmony",
    "Confusion", "Random chords", "Trailing reverses", "Low quality meme", "Audio crust",
    "Pitch-shifting loop", "Mashup mixing"
)
$videoEffects = @(
    "Framerate reduction", "Random cuts", "Speed loop boost", "Scrambling", "Random chopping",
    "Invert", "Rainbow", "Mirror", "Mirror symmetry", "Screen clip", "Overlay images/sources",
    "Spadinner", "Sentence mixing", "Shuffle/loop frames", "Spadinner"
)

###############
##   Form    ##
###############

$form = New-Object Windows.Forms.Form
$form.Text = "YTPDeluxeGen (Demo) - PowerShell GUI"
$form.Size = New-Object Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"

# Project Name
$lblProject = New-Object Windows.Forms.Label
$lblProject.Location = '10,10'
$lblProject.Size = '90,23'
$lblProject.Text = "Project Name:"
$form.Controls.Add($lblProject)

$txtProject = New-Object Windows.Forms.TextBox
$txtProject.Location = '110,8'
$txtProject.Size = '150,23'
$txtProject.Text = "YTPGen_Project"
$form.Controls.Add($txtProject)

# Video Effects
$clbVideoEffects = New-Object Windows.Forms.CheckedListBox
$clbVideoEffects.Location = '10,40'
$clbVideoEffects.Size = '230,200'
$clbVideoEffects.CheckOnClick = $true
$clbVideoEffects.Items.AddRange($videoEffects)
$form.Controls.Add($clbVideoEffects)

# Audio Effects
$clbAudioEffects = New-Object Windows.Forms.CheckedListBox
$clbAudioEffects.Location = '250,40'
$clbAudioEffects.Size = '230,200'
$clbAudioEffects.CheckOnClick = $true
$clbAudioEffects.Items.AddRange($audioEffects)
$form.Controls.Add($clbAudioEffects)

# Asset listbox
$lblAssets = New-Object Windows.Forms.Label
$lblAssets.Text = "Assets:"
$lblAssets.Location = '500,10'
$form.Controls.Add($lblAssets)

$lstAssets = New-Object Windows.Forms.ListBox
$lstAssets.Location = '500,40'
$lstAssets.Size = '250,200'
$form.Controls.Add($lstAssets)

# Preview Panel
$lblPreview = New-Object Windows.Forms.Label
$lblPreview.Text = "Image Preview:"
$lblPreview.Location = '500,250'
$form.Controls.Add($lblPreview)

$picPreview = New-Object Windows.Forms.PictureBox
$picPreview.Location = '500,270'
$picPreview.Size = '250,180'
$picPreview.BorderStyle = "Fixed3D"
$picPreview.SizeMode = "Zoom"
$form.Controls.Add($picPreview)

#############################
##   Project Setting Group ##
#############################

$grbSettings = New-Object Windows.Forms.GroupBox
$grbSettings.Location = '10,250'
$grbSettings.Size = '470,120'
$grbSettings.Text = "Generator Settings"
$form.Controls.Add($grbSettings)

$lblMinDur = New-Object Windows.Forms.Label
$lblMinDur.Location = '10,25'
$lblMinDur.Text = "Min Duration:"
$lblMinDur.Size = '90,20'
$grbSettings.Controls.Add($lblMinDur)

$nudMinDur = New-Object Windows.Forms.NumericUpDown
$nudMinDur.Location = '110,23'
$nudMinDur.Minimum = 1
$nudMinDur.Maximum = 300
$nudMinDur.Value = 1
$grbSettings.Controls.Add($nudMinDur)

$lblMaxDur = New-Object Windows.Forms.Label
$lblMaxDur.Location = '10,53'
$lblMaxDur.Text = "Max Duration:"
$lblMaxDur.Size = '90,20'
$grbSettings.Controls.Add($lblMaxDur)

$nudMaxDur = New-Object Windows.Forms.NumericUpDown
$nudMaxDur.Location = '110,51'
$nudMaxDur.Minimum = 2
$nudMaxDur.Maximum = 800
$nudMaxDur.Value = 5
$grbSettings.Controls.Add($nudMaxDur)

$lblClipCount = New-Object Windows.Forms.Label
$lblClipCount.Location = '10,81'
$lblClipCount.Text = "Clip Count:"
$lblClipCount.Size = '90,20'
$grbSettings.Controls.Add($lblClipCount)

$nudClipCount = New-Object Windows.Forms.NumericUpDown
$nudClipCount.Location = '110,79'
$nudClipCount.Minimum = 1
$nudClipCount.Maximum = 100
$nudClipCount.Value = 10
$grbSettings.Controls.Add($nudClipCount)

$lblFormat = New-Object Windows.Forms.Label
$lblFormat.Location = '250,25'
$lblFormat.Text = "Output Format:"
$lblFormat.Size = '90,20'
$grbSettings.Controls.Add($lblFormat)

$cmbFormat = New-Object Windows.Forms.ComboBox
$cmbFormat.DropDownStyle = "DropDownList"
$cmbFormat.Items.AddRange(@('WMV','MP4','AVI','MKV'))
$cmbFormat.SelectedIndex = 1
$cmbFormat.Location = '350,23'
$cmbFormat.Size = '100,23'
$grbSettings.Controls.Add($cmbFormat)

$lblMode = New-Object Windows.Forms.Label
$lblMode.Location = '250,53'
$lblMode.Text = "Project Mode:"
$lblMode.Size = '90,20'
$grbSettings.Controls.Add($lblMode)

$cmbMode = New-Object Windows.Forms.ComboBox
$cmbMode.DropDownStyle = "DropDownList"
$cmbMode.Items.AddRange(@('Generic','YTP Tennis','Collab Entry','YTPMV'))
$cmbMode.SelectedIndex = 0
$cmbMode.Location = '350,51'
$cmbMode.Size = '100,23'
$grbSettings.Controls.Add($cmbMode)

$lblStyle = New-Object Windows.Forms.Label
$lblStyle.Location = '250,81'
$lblStyle.Text = "Style:"
$lblStyle.Size = '90,20'
$grbSettings.Controls.Add($lblStyle)

$cmbStyle = New-Object Windows.Forms.ComboBox
$cmbStyle.DropDownStyle = "DropDownList"
$cmbStyle.Items.AddRange(@('2007-2012 (classic)','2013-2021 (modern)','Advance','Mega','Deluxe'))
$cmbStyle.SelectedIndex = 4
$cmbStyle.Location = '350,79'
$cmbStyle.Size = '100,23'
$grbSettings.Controls.Add($cmbStyle)

#######################
## Buttons: Import, Preview, Remove, Render
#######################

# Import Media
$btnImport = New-Object Windows.Forms.Button
$btnImport.Text = "Import Assets"
$btnImport.Location = '500,470'
$btnImport.Size = '120,30'
$btnImport.Add_Click({
    $ofd = New-Object Windows.Forms.OpenFileDialog
    $ofd.Multiselect = $true
    $ofd.Filter = "Media Files|*.mp4;*.wmv;*.avi;*.png;*.jpg;*.jpeg;*.webp;*.gif;*.mp3;*.wav;*.ogg;*.xm;*.mod;*.it;*.s3m|All Files|*.*"
    if ($ofd.ShowDialog() -eq 'OK') {
        foreach ($f in $ofd.FileNames) {
            $ytpgen_Project.Assets += @{
                Path = $f
                Tag  = [System.IO.Path]::GetFileName($f)
            }
            $lstAssets.Items.Add([System.IO.Path]::GetFileName($f)) | Out-Null
        }
    }
})
$form.Controls.Add($btnImport)

# Preview Button
$btnPreview = New-Object Windows.Forms.Button
$btnPreview.Text = "Preview"
$btnPreview.Location = '630,470'
$btnPreview.Size = '60,30'
$btnPreview.Add_Click({
    $i = $lstAssets.SelectedIndex
    if ($i -ne -1) {
        $file = $ytpgen_Project.Assets[$i].Path
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        if ($ext -match '\.(jpg|jpeg|png|gif|webp)$') {
            try {
                $img = [System.Drawing.Image]::FromFile($file)
                $picPreview.Image = $img
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Failed to preview image.")
            }
        } else {
            $picPreview.Image = $null
            if ([System.Windows.Forms.MessageBox]::Show("Open with default program?", "Preview", "YesNo") -eq "Yes") {
                Start-Process -FilePath $file
            }
        }
    }
})
$form.Controls.Add($btnPreview)

# Remove Asset
$btnRemove = New-Object Windows.Forms.Button
$btnRemove.Text = "Remove"
$btnRemove.Location = '700,470'
$btnRemove.Size = '50,30'
$btnRemove.Add_Click({
    $idx = $lstAssets.SelectedIndex
    if ($idx -ge 0) {
        $lstAssets.Items.RemoveAt($idx)
        $ytpgen_Project.Assets = $ytpgen_Project.Assets[0..($idx-1)] + $ytpgen_Project.Assets[($idx+1)..($ytpgen_Project.Assets.Count-1)]
        $picPreview.Image = $null
    }
})
$form.Controls.Add($btnRemove)

# Render/Generate Button
$btnRender = New-Object Windows.Forms.Button
$btnRender.Text = "Render (Simulate)"
$btnRender.Location = '570,510'
$btnRender.Size = '180,35'
$btnRender.BackColor = "Gold"
$btnRender.Add_Click({
    $ytpgen_Project.ProjectName = $txtProject.Text
    $ytpgen_Project.MinStreamDuration = [int]$nudMinDur.Value
    $ytpgen_Project.MaxStreamDuration = [int]$nudMaxDur.Value
    $ytpgen_Project.ClipCount = [int]$nudClipCount.Value
    $ytpgen_Project.VideoEffects = @(); foreach ($i in $clbVideoEffects.CheckedIndices) { $ytpgen_Project.VideoEffects += $videoEffects[$i] }
    $ytpgen_Project.AudioEffects = @(); foreach ($i in $clbAudioEffects.CheckedIndices) { $ytpgen_Project.AudioEffects += $audioEffects[$i] }
    $ytpgen_Project.Style = $cmbStyle.SelectedItem
    $ytpgen_Project.ProjectMode = $cmbMode.SelectedItem
    $ytpgen_Project.PreferredOutputFormat = $cmbFormat.SelectedItem

    $out = [System.Windows.Forms.SaveFileDialog]::new()
    $out.Filter = "MP4|*.mp4|WMV|*.wmv|AVI|*.avi|MKV|*.mkv"
    $out.FileName = $ytpgen_Project.ProjectName
    if ($out.ShowDialog() -eq "OK") {
        # Simulate a render...
        [System.Windows.Forms.MessageBox]::Show("Render simulation complete! File saved: $($out.FileName) `n`n(Audio/Video mixing, ffmpeg handling, and script generation would go here.)", "DeluxeGen Demo")
    }
})
$form.Controls.Add($btnRender)

############################
## Simple DEMO note
############################

$lblDemo = New-Object Windows.Forms.Label
$lblDemo.Text = "This is a DEMO for a YTPDeluxeGen GUI engine in PowerShell. Real rendering and video/audio actions require backend tools."
$lblDemo.Location = '10,400'
$lblDemo.Size = '480,90'
$lblDemo.ForeColor = 'DarkRed'
$form.Controls.Add($lblDemo)

########################
# Main Form Startup
########################

$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
