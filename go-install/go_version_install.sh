#!/bin/bash

# Go (Golang) installation script with version selection and modules enabled by default

# Root check
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script requires root privileges. Please run with sudo." >&2
  exit 1
fi

# Architecture detection
ARCH=$(uname -m)
case $ARCH in
  x86_64)  GOARCH="amd64" ;;
  aarch64) GOARCH="arm64" ;;
  *)       echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# Function to list available Go versions
list_go_versions() {
  echo "Fetching available Go versions..."
  curl -s https://go.dev/dl/ | grep -E 'go[0-9]+\.[0-9]+(\.[0-9]+)?\.linux-'${GOARCH}'.tar.gz' | \
    sed -E 's/.*go([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/' | sort -V | uniq
}

# Install dependencies
echo "Installing required packages..."
if command -v apt-get &>/dev/null; then
  apt-get update && apt-get install -y curl tar
elif command -v yum &>/dev/null; then
  yum install -y curl tar
elif command -v dnf &>/dev/null; then
  dnf install -y curl tar
fi

# Version selection
echo "Available Go versions:"
versions=$(list_go_versions)
select version in $versions "Latest stable"; do
  case $version in
    "Latest stable")
      version=$(curl -s https://go.dev/VERSION?m=text | head -1 | sed 's/go//')
      break
      ;;
    *)
      if [ -n "$version" ]; then
        break
      else
        echo "Invalid selection. Please try again."
      fi
      ;;
  esac
done

GO_TAR="go${version}.linux-${GOARCH}.tar.gz"
GO_URL="https://dl.google.com/go/${GO_TAR}"

echo "Installing Go ${version}..."
curl -fL --progress-bar "$GO_URL" -o "/tmp/${GO_TAR}" || {
  echo "Download failed!" >&2; exit 1
}

echo "Extracting to /usr/local..."
rm -rf /usr/local/go 2>/dev/null
tar -C /usr/local -xzf "/tmp/${GO_TAR}" || {
  echo "Extraction failed!" >&2; exit 1
}
rm -f "/tmp/${GO_TAR}"

# Configure environment with modules enabled
echo "Setting up environment for all users..."
cat > /etc/profile.d/go.sh <<'EOF'
#!/bin/sh

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export GOPROXY=https://proxy.golang.org,direct
export GOSUMDB=sum.golang.org
EOF

chmod 755 /etc/profile.d/go.sh

# Apply to current session
source /etc/profile.d/go.sh

# Verify installation
if ! command -v go &>/dev/null; then
  echo "Error: Go installation failed!" >&2
  exit 1
fi

echo -e "\n\033[1;32mInstallation complete!\033[0m"
echo -e "Installed Go version: \033[1;34m$(go version)\033[0m"
echo -e "Go Modules are enabled by default for all users"
echo -e "To apply to current session run: \033[1;37msource /etc/profile.d/go.sh\033[0m\n"
