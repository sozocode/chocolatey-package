# Publishing VisuaLeaf to Chocolatey

Chocolatey is a package manager for Windows. Once VisuaLeaf is listed on the
Chocolatey Community Repository, Windows users can install it with one command:

    choco install visualeaf

This folder holds everything that goes into the package:

- `visualeaf.nuspec`: the package description (name, version, links, text).
- `tools/chocolateyinstall.ps1`: downloads the official installer from
  release.sozocode.com, checks that the file is the exact one we published
  (SHA256 checksum), and runs it silently for all users.
- `tools/chocolateyuninstall.ps1`: finds VisuaLeaf in Windows' list of
  installed programs and runs its uninstaller silently.

The installer itself is not stored in the package. It is downloaded at install
time, so the package stays small and no extra license or verification files are
needed.

## Before the first submission

1. **Create the package source repository.** The nuspec points
   `packageSourceUrl` at `https://github.com/sozocode/chocolatey-package`.
   That repository does not exist yet. Either create it (public) and copy this
   folder into it as `visualeaf/`, or change `packageSourceUrl` in
   `visualeaf.nuspec` to wherever these files will live publicly. Moderators
   check that this link works and shows the package files.

2. **Check the icon.** The package uses
   `https://visualeaf.com/assets/images/apple-touch-icon.png` (180 x 180 PNG).
   It works today. If the website is ever restructured, keep that URL alive or
   update `iconUrl`.

## One-time setup: account and API key

1. Go to https://community.chocolatey.org/account/Register and create an
   account. Use a company address you will keep (for example a shared SozoCode
   address), because moderators send all messages about the package there.
   Confirm the email.
2. Sign in, open your account page (https://community.chocolatey.org/account),
   and find the **API Key** section. Click to show the key and copy it. Treat it
   like a password: do not paste it into files in this repository.
3. On a Windows machine with Chocolatey installed (https://chocolatey.org/install),
   open PowerShell and save the key once:

       choco apikey --key YOUR-API-KEY --source https://push.chocolatey.org/

## Building and submitting a release

Do this on Windows, in this folder:

    choco pack
    choco push visualeaf.1.0.2686.nupkg --source https://push.chocolatey.org/

`choco pack` creates the `.nupkg` file; `choco push` uploads it. Do not commit
the `.nupkg` file.

It is a good idea to test before pushing, on a Windows machine or virtual
machine where VisuaLeaf is not installed:

    choco install visualeaf --source . -y
    choco uninstall visualeaf -y

The install should finish without any window asking questions, and VisuaLeaf
should appear in the Start menu. The uninstall should remove it.

## What happens after you push

Every new version goes through moderation before the public can install it.

1. **Automatic checks (minutes to a few hours).** A validator checks the
   package description and scripts, a verifier installs and uninstalls it on a
   clean Windows machine, and a virus scan runs on the downloaded installer.
   Results arrive by email and appear on the package page.
2. **Human review (a few days, sometimes a couple of weeks for a first
   package).** A volunteer moderator reads the package. If they ask for
   changes, you get an email. Fix the files, keep the same version number,
   run `choco pack` and `choco push` again. Reply on the package page if
   something needs explaining.
3. **Approved.** The package becomes public. After a few versions are approved
   without problems, later versions can be approved faster, sometimes
   automatically.

Things moderators sometimes raise for an app like this, with the answers:

- *"The app updates itself."* That is normal and allowed; it is mentioned in
  the description.
- *"Why is there no LICENSE.txt or VERIFICATION.txt?"* Those are only needed
  when the installer is stored inside the package. Ours is downloaded and
  checked with a SHA256 checksum.
- *"License"*: VisuaLeaf is proprietary; the license link points to
  https://visualeaf.com/eula.

## Releasing a new version

For each VisuaLeaf release (example: 1.0.2600):

1. In `visualeaf.nuspec`, change `<version>` to `1.0.2600`.
2. In `tools/chocolateyinstall.ps1`, change both places in the `url64bit` line
   to the new version:

       https://release.sozocode.com/releases/v1.0.2600/VisuaLeaf-Setup-1.0.2600.exe

3. Get the new checksum. On a Mac:

       curl -sL https://release.sozocode.com/releases/v1.0.2600/VisuaLeaf-Setup-1.0.2600.exe | shasum -a 256

   On Windows, after downloading the file:

       Get-FileHash .\VisuaLeaf-Setup-1.0.2600.exe -Algorithm SHA256

   Put the result into `checksum64` (upper or lower case both work).
4. Run `choco pack` and `choco push visualeaf.1.0.2600.nupkg --source https://push.chocolatey.org/`.

The same version number and checksum are also used by the winget manifest in
`../winget/`, so you can update both at the same time.

Rules to remember:

- Never re-upload a different installer under a version that was already
  published. If the `.exe` changes, the checksum check fails for every user.
- A version that has been approved cannot be replaced. If a package has a
  mistake after approval, publish a fixed one with a fourth number added, for
  example `1.0.2600.20261021` (year, month, day).
