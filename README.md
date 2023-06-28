# Shadowing AVD Servers
Shadowing AVD Servers with noConsentprompt


## EXPLAIN THE PS1

**This code is written in PowerShell and creates a simple GUI application using Windows Forms. The application is a "Shadowing Tool" used for remote desktop session shadowing. Here's a line-by-line explanation:**

Add-Type -AssemblyName System.Windows.Forms: Adds the System.Windows.Forms assembly to the PowerShell session, which provides functionality for creating Windows Forms applications.

* 3-5. Create a new instance of System.Windows.Forms.Form and set properties for the form, such as title and width.

* 7-11. Create a label for the server and set its properties (text, location, and width).

* 13-17. Create a combo box for selecting the server and set its properties (drop-down list style, location, and width).

* 19-23. Create a label for the session ID and set its properties (text, location, and width).

* 25-29. Create a combo box for selecting the session ID and set its properties (drop-down list style, location, and width).

* 31-38. Create a button for starting the shadowing process and set its properties (text, location, width, and click event handler). The event handler retrieves the selected session ID and server, constructs a command, and starts the shadowing process using Start-Process.

* 40-44. Add the server label, server combo box, session ID label, session ID combo box, and start button to the form's controls collection.

* 47-54. Generate a list of servers and add them to the server combo box.

* 56-81. Add an event handler to the server combo box's SelectedIndexChanged event. When a server is selected, the event handler connects remotely to the selected server using PowerShell's New-PSSession cmdlet. It runs the query session command on the remote server to retrieve information about active sessions. The session IDs are extracted from the command output and added to the session ID combo box. If no active sessions are found, a message is displayed. Finally, the remote session is closed using Remove-PSSession.

**Show the form as a dialog.
The code allows users to select a server and a session ID, and then initiate shadowing by clicking the "Start Shadowing" button. It provides a basic graphical interface for the shadowing tool.**


## CHANGES FOR YOUR ORGANIZATION

* 1. Update lines 91 to 94 with the DNS and hostname of your Azure AVD infrastructure. If you cannot reach the resources via DNS, you can use IP addresses instead. However, it is crucial that you have network visibility within the AVD environment. We strongly recommend setting up internal routing using an Azure VPN for this process. Under no circumstances should it be done through public access, as the code is not prepared for it.**

* 2. Modify line 107 with the credentials of your local AVD session host machines.

* 3. Finally, to ensure proper functionality, it is necessary to enable PSRemoting on both the local machine and the server, and add TrustedHosts on both as well.**

## Local commands to set usage 

Here are the commands to accomplish these final steps:

### PSRemoting
```Enable-PSRemoting -Force```

### TrustedHosts
```Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "*" -Force```
