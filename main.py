#!/usr/bin/env python3
"""
Development Environment Setup Tool
Installs and manages tools configured in ~/.config
"""

import os
import subprocess
import sys
from typing import Dict, List, Set


class Colors:
    """ANSI color codes for terminal output"""
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    END = '\033[0m'


def run_command(command: str, check: bool = True) -> subprocess.CompletedProcess:
    """Run shell command with error handling"""
    try:
        result = subprocess.run(command, shell=True, check=check, 
                              capture_output=True, text=True)
        return result
    except subprocess.CalledProcessError as e:
        print(f"{Colors.RED}Error running command: {command}{Colors.END}")
        print(f"{Colors.RED}{e.stderr}{Colors.END}")
        if check:
            sys.exit(1)
        return e


def check_brew_installed() -> bool:
    """Check if Homebrew is installed"""
    result = run_command("which brew", check=False)
    return result.returncode == 0


def install_homebrew():
    """Install Homebrew if not present"""
    print(f"{Colors.YELLOW}Installing Homebrew...{Colors.END}")
    install_cmd = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    run_command(install_cmd)
    print(f"{Colors.GREEN}Homebrew installed successfully!{Colors.END}")


def install_packages(packages: Dict[str, List[str]], category: str = None):
    """Install packages by category"""
    if not check_brew_installed():
        install_homebrew()
    
    categories_to_install = [category] if category else packages.keys()
    
    for cat in categories_to_install:
        if cat not in packages:
            print(f"{Colors.RED}Category '{cat}' not found!{Colors.END}")
            continue
            
        print(f"\n{Colors.CYAN}{Colors.BOLD}📦 Installing {cat}...{Colors.END}")
        
        for package_info in packages[cat]:
            package, install_type = package_info.split(":")
            
            if install_type == "brew":
                cmd = f"brew install {package}"
            elif install_type == "cask":
                cmd = f"brew install --cask {package}"
            elif install_type == "tap":
                cmd = f"brew tap {package}"
            elif install_type == "gh":
                cmd = f"gh extension install {package}"
            else:
                cmd = package  # Custom command
            
            print(f"  Installing {package}...")
            result = run_command(cmd, check=False)
            
            if result.returncode == 0:
                print(f"  {Colors.GREEN}✓ {package} installed{Colors.END}")
            else:
                print(f"  {Colors.RED}✗ Failed to install {package}{Colors.END}")


def post_install_setup():
    """Run post-installation setup commands"""
    print(f"\n{Colors.MAGENTA}{Colors.BOLD}🔧 Running post-installation setup...{Colors.END}")
    
    setup_commands = [
        ("Install Bun runtime", 'curl -fsSL https://bun.sh/install | bash'),
        ("Install pnpm", 'npm install -g pnpm'),
        ("Setup Fish shell", 'echo $(which fish) | sudo tee -a /etc/shells && chsh -s $(which fish)'),
    ]
    
    for description, command in setup_commands:
        print(f"  {description}...")
        result = run_command(command, check=False)
        
        if result.returncode == 0:
            print(f"  {Colors.GREEN}✓ {description} completed{Colors.END}")
        else:
            print(f"  {Colors.YELLOW}⚠ {description} may need manual setup{Colors.END}")


def update_package_list(new_package: str, category: str, install_type: str):
    """Add a new package to the configuration (simplified version)"""
    # This would update the PACKAGES dictionary in the file
    print(f"{Colors.GREEN}Package {new_package} added to {category} (manual edit required){Colors.END}")


def main():
    """Main function with comprehensive package management"""
    
    # Comprehensive package dictionary organized by category
    PACKAGES = {
        "🖥️ Terminal Emulators & Multiplexers": [
            "ghostty:cask",
            "kitty:brew", 
            "wezterm:cask",
            "tmux:brew"
        ],
        "🐚 Shell & Command Line": [
            "fish:brew",
            "starship:brew",
            "atuin:brew", 
            "broot:brew",
            "eza:brew",
            "fzf:brew",
            "zoxide:brew",
            "bat:brew",
            "ripgrep:brew",
            "dust:brew"
        ],
        "💻 Code Editors": [
            "neovim:brew"
        ],
        "🔧 Development Tools": [
            "git:brew",
            "gh:brew",
            "github/gh-copilot:gh",
            "dlvhdr/gh-dash:gh",
            "google-cloud-sdk:cask",
            "lazygit:brew",
            "jq:brew",
            "cmake:brew",
            "gnupg:brew"
        ],
        "🪟 Window Management (macOS)": [
            "koekeishiya/formulae:tap",
            "FelixKratz/formulae:tap", 
            "yabai:brew",
            "skhd:brew",
            "sketchybar:brew"
        ],
        "📊 System Monitoring": [
            "btop:brew",
            "wtfutil:brew"
        ],
        "🚀 Productivity & Utilities": [
            "raycast:cask",
            "1password-cli:brew"
        ],
        "☁️ Cloud & Infrastructure": [
            "awscli:brew",
            "k9s:brew",
            "kubectx:brew",
            "tunnelblick:cask"
        ],
        "🔄 Runtime & Package Managers": [
            "nvm:brew",
            "yarn:brew",
            "pdm:brew"
        ]
    }
    
    print(f"{Colors.CYAN}{Colors.BOLD}")
    print("=" * 60)
    print("   🛠️  Development Environment Setup Tool  🛠️")  
    print("=" * 60)
    print(f"{Colors.END}")
    
    while True:
        print(f"\n{Colors.WHITE}{Colors.BOLD}Available Actions:{Colors.END}")
        print("1. 📦 Install all packages")
        print("2. 📋 List all packages")
        print("3. 🔧 Run post-installation setup")
        print("4. ❌ Exit")
        
        choice = input(f"\n{Colors.YELLOW}Enter your choice (1-4): {Colors.END}").strip()
        
        if choice == "1":
            print(f"\n{Colors.MAGENTA}Installing all packages...{Colors.END}")
            install_packages(PACKAGES)
            post_install_setup()
            
        elif choice == "2":
            print(f"\n{Colors.WHITE}{Colors.BOLD}📋 Complete Package List:{Colors.END}")
            for category, packages in PACKAGES.items():
                print(f"\n{Colors.CYAN}{category}{Colors.END}")
                for package_info in packages:
                    package_name = package_info.split(":")[0]
                    install_type = package_info.split(":")[1]
                    print(f"  • {package_name} ({install_type})")
                    
        elif choice == "3":
            post_install_setup()
            
        elif choice == "4":
            print(f"{Colors.GREEN}Goodbye! 👋{Colors.END}")
            break
            
        else:
            print(f"{Colors.RED}Invalid choice! Please enter 1-4.{Colors.END}")


if __name__ == "__main__":
    main()
