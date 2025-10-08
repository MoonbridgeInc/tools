# Go Installation Script

A bash script for automated installation of Go (Golang) with version selection and optimized configuration.

## Features

- **Automatic Architecture Detection** - Supports both x86_64 (amd64) and ARM64 architectures
- **Version Selection** - Interactive menu to choose from available Go versions or install latest stable
- **Root Privileges Check** - Ensures script runs with necessary permissions
- **Dependency Management** - Automatically installs required packages (curl, tar)
- **Multi-Distro Support** - Works with apt-get (Debian/Ubuntu), yum (CentOS/RHEL), and dnf (Fedora)
- **Environment Configuration** - Sets up Go environment for all system users
- **Go Modules Enabled** - Configures Go modules with optimal settings out of the box

## What the Script Does

1. **Prerequisites Check**
   - Verifies root privileges
   - Detects system architecture

2. **Version Management**
   - Fetches available Go versions from official site
   - Provides interactive selection menu
   - Option for "Latest stable" version

3. **Installation Process**
   - Downloads selected Go version
   - Extracts to `/usr/local/go`
   - Cleans up temporary files

4. **Environment Setup**
   - Creates `/etc/profile.d/go.sh` for system-wide configuration
   - Sets up:
     - PATH inclusion for Go binaries
     - GOPATH directory
     - Go modules enabled by default (`GO111MODULE=on`)
     - Official Go proxy and checksum database

5. **Verification**
   - Checks if installation was successful
   - Displays installed Go version

## Quick Install

```bash
wget https://raw.githubusercontent.com/mrhoodd/tools/refs/heads/main/go_version_install.sh
chmod +x go_version_install.sh
sudo ./go_version_install.sh
```

### Example Session

```
Installing required packages...
Available Go versions:
1) 1.20.1
2) 1.20.2
3) 1.21.0
4) 1.21.5
5) Latest stable
#? 5

Installing Go 1.22.0...
Extracting to /usr/local...
Setting up environment for all users...

Installation complete!
Installed Go version: go version go1.22.0 linux/amd64
Go Modules are enabled by default for all users
To apply to current session run: source /etc/profile.d/go.sh
```

## Environment Variables

The script configures the following in `/etc/profile.d/go.sh`:

```bash
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org,direct
export GOSUMDB=sum.golang.org
```

## Requirements

- Linux system (Debian/Ubuntu, RHEL/CentOS, or Fedora)
- Root access (sudo)
- Internet connection

## Post-Installation

Apply environment variables to current session:

```bash
source /etc/profile.d/go.sh
```

Verify installation:

```bash
go version
go env
```

## Uninstall

```bash
sudo rm -rf /usr/local/go
sudo rm /etc/profile.d/go.sh
```

## Notes

- Previous Go installations in `/usr/local/go` are removed automatically
- Changes take effect system-wide for all users
- New terminal sessions will have Go configured automatically
