Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Shadowing Tool"
$form.Width = 300

$serverLabel = New-Object System.Windows.Forms.Label
$serverLabel.Text = "Server:"
$serverLabel.Location = New-Object System.Drawing.Point(10, 20)
$serverLabel.Width = 70

$serverComboBox = New-Object System.Windows.Forms.ComboBox
$serverComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$serverComboBox.Location = New-Object System.Drawing.Point(90, 20)
$serverComboBox.Width = 180

$sessionIdLabel = New-Object System.Windows.Forms.Label
$sessionIdLabel.Text = "Session ID:"
$sessionIdLabel.Location = New-Object System.Drawing.Point(10, 60)
$sessionIdLabel.Width = 70

$sessionIdComboBox = New-Object System.Windows.Forms.ComboBox
$sessionIdComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$sessionIdComboBox.Location = New-Object System.Drawing.Point(90, 60)
$sessionIdComboBox.Width = 180

$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "Run Shadowing"
$startButton.Location = New-Object System.Drawing.Point(90, 100)
$startButton.Width = 120
$startButton.Add_Click({
    $selection = $sessionIdComboBox.SelectedItem.ToString()
    $username, $sessionId = $selection.Split(' - ')
    $server = $serverComboBox.SelectedItem.ToString()
    $command = "mstsc /v:$server /shadow:$sessionId /noConsentPrompt /Control /Prompt /multimon /f /admin"
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", $command
    [System.Windows.Forms.MessageBox]::Show("The shadowing has been successfully initiated.")
})

$form.Controls.Add($serverLabel)
$form.Controls.Add($serverComboBox)
$form.Controls.Add($sessionIdLabel)
$form.Controls.Add($sessionIdComboBox)
$form.Controls.Add($startButton)

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Shadowing Tool"
$form.Width = 300

$serverLabel = New-Object System.Windows.Forms.Label
$serverLabel.Text = "Server:"
$serverLabel.Location = New-Object System.Drawing.Point(10, 20)
$serverLabel.Width = 70

$serverComboBox = New-Object System.Windows.Forms.ComboBox
$serverComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$serverComboBox.Location = New-Object System.Drawing.Point(90, 20)
$serverComboBox.Width = 180

$sessionIdLabel = New-Object System.Windows.Forms.Label
$sessionIdLabel.Text = "Session ID:"
$sessionIdLabel.Location = New-Object System.Drawing.Point(10, 60)
$sessionIdLabel.Width = 70

$sessionIdComboBox = New-Object System.Windows.Forms.ComboBox
$sessionIdComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$sessionIdComboBox.Location = New-Object System.Drawing.Point(90, 60)
$sessionIdComboBox.Width = 180

$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "Start Shadowing"
$startButton.Location = New-Object System.Drawing.Point(90, 100)
$startButton.Width = 120
$startButton.Add_Click({
    $selection = $sessionIdComboBox.SelectedItem.ToString()
    $username, $sessionId = $selection.Split(' - ')
    $server = $serverComboBox.SelectedItem.ToString()
    $command = "mstsc /v:$server /shadow:$sessionId /noConsentPrompt /Prompt /multimon /f /admin"
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", $command
    [System.Windows.Forms.MessageBox]::Show("Shadowing has been started successfully.")
})

$form.Controls.Add($serverLabel)
$form.Controls.Add($serverComboBox)
$form.Controls.Add($sessionIdLabel)
$form.Controls.Add($sessionIdComboBox)
$form.Controls.Add($startButton)

# Generate list of servers (avdsh-0.domain.com to avdsh-6.domain.com)
$servers = @()
for ($i = 0; $i -le 6; $i++) {
    $servers += "avdsh-$i.domain.com"
}

$serverComboBox.Items.AddRange($servers)

$serverComboBox.Add_SelectedIndexChanged({
    $selectedServer = $serverComboBox.SelectedItem.ToString()
    $sessionIdComboBox.Items.Clear()

    # Set remote session configuration
    $sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

    # Connect remotely to the selected server
    $session = New-PSSession -ComputerName $selectedServer -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "avdadmin", (ConvertTo-SecureString "PASSWORD" -AsPlainText -Force)) -SessionOption $sessionOptions

    # Run 'query session' command on the remote server and filter by 'Active'
    $querySessionResult = Invoke-Command -Session $session -ScriptBlock { query session }

    # Debug: print 'query session' result
    #Write-Host "Query Session Result:"
    #Write-Host $querySessionResult

    $sessionInfo = $querySessionResult |
        Select-String -Pattern '^\s*[^ ]+\s+([^ ]+)\s+(\d+)\s+(?:Activo|Active)' |
        ForEach-Object { "{0} - {1}" -f $_.Matches.Groups[1].Value, $_.Matches.Groups[2].Value }

    if ($sessionInfo -ne $null -and $sessionInfo.Count -gt 0) {
        $sessionIdComboBox.Items.AddRange($sessionInfo)
    } else {
        Write-Host "No active sessions found."
    }

    print $querySessionResult

    # Close the remote session
    Remove-PSSession $session
})

# Show the form
$form.ShowDialog()
