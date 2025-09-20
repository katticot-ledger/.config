#!/usr/bin/env python3
"""Interactive and CLI tooling for bootstrapping this dotfiles repo."""

import argparse
import subprocess
import sys
from typing import Dict, Iterable, List


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
        result = subprocess.run(
            command,
            shell=True,
            check=check,
            capture_output=True,
            text=True,
        )
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


def install_packages(packages: Dict[str, List[str]], categories: Iterable[str] = None) -> None:
    """Install packages for the provided categories."""
    if not check_brew_installed():
        install_homebrew()

    categories_to_install = list(packages.keys()) if categories is None else list(categories)

    for cat in categories_to_install:
        if cat not in packages:
            print(f"{Colors.RED}Category '{cat}' not found!{Colors.END}")
            continue

        print(f"\n{Colors.CYAN}{Colors.BOLD}📦 Installing {cat}{Colors.END}")

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


PACKAGES: Dict[str, List[str]] = {
    "🖥️ Terminal Emulators & Multiplexers": [
        "ghostty:cask",
        "kitty:brew",
        "wezterm:cask",
        "tmux:brew",
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
        "dust:brew",
        "bass:brew",
    ],
    "💻 Code Editors": [
        "neovim:brew",
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
        "gnupg:brew",
    ],
    "🪟 Window Management (macOS)": [
        "koekeishiya/formulae:tap",
        "FelixKratz/formulae:tap",
        "yabai:brew",
        "skhd:brew",
        "sketchybar:brew",
    ],
    "📊 System Monitoring": [
        "btop:brew",
        "wtfutil:brew",
    ],
    "🚀 Productivity & Utilities": [
        "raycast:cask",
        "1password-cli:brew",
    ],
    "☁️ Cloud & Infrastructure": [
        "awscli:brew",
        "k9s:brew",
        "kubectx:brew",
        "tunnelblick:cask",
    ],
    "🔄 Runtime & Package Managers": [
        "nvm:brew",
        "yarn:brew",
        "pdm:brew",
    ],
}


def list_packages(packages: Dict[str, List[str]], categories: Iterable[str] = None) -> None:
    """Print packages, optionally scoped to a subset of categories."""
    categories_to_list = list(packages.keys()) if categories is None else list(categories)

    for cat in categories_to_list:
        if cat not in packages:
            print(f"{Colors.RED}Category '{cat}' not found!{Colors.END}")
            continue

        print(f"\n{Colors.CYAN}{cat}{Colors.END}")
        for package_info in packages[cat]:
            package_name, install_type = package_info.split(":")
            print(f"  • {package_name} ({install_type})")


def choose_category(packages: Dict[str, List[str]]) -> str:
    """Prompt the user to select a single category for installation."""
    categories = list(packages.keys())
    print(f"\n{Colors.WHITE}{Colors.BOLD}Select a category to install:{Colors.END}")
    for idx, category in enumerate(categories, start=1):
        print(f"{idx}. {category}")

    selection = input(f"\n{Colors.YELLOW}Enter number or name: {Colors.END}").strip()
    if selection.isdigit():
        index = int(selection) - 1
        if 0 <= index < len(categories):
            return categories[index]
    elif selection in packages:
        return selection

    print(f"{Colors.RED}Invalid selection. Returning to main menu.{Colors.END}")
    return ""


def update_homebrew() -> None:
    """Update Homebrew formulae and upgrade installed packages."""
    if not check_brew_installed():
        print(f"{Colors.RED}Homebrew is not installed. Install packages first.{Colors.END}")
        return

    print(f"\n{Colors.CYAN}{Colors.BOLD}🔄 Updating Homebrew...{Colors.END}")
    for description, command in (
        ("brew update", "brew update"),
        ("brew upgrade", "brew upgrade"),
        ("brew upgrade --cask", "brew upgrade --cask"),
    ):
        print(f"  {description}...")
        result = run_command(command, check=False)
        if result.returncode == 0:
            print(f"  {Colors.GREEN}✓ {description} completed{Colors.END}")
        else:
            print(f"  {Colors.YELLOW}⚠ {description} may require manual review{Colors.END}")


def parse_args() -> argparse.Namespace:
    """Build the CLI argument parser."""
    parser = argparse.ArgumentParser(description="Manage development environment packages")
    parser.add_argument(
        "--list",
        action="store_true",
        help="List available package categories and their contents",
    )
    parser.add_argument(
        "--install",
        metavar="CATEGORY",
        action="append",
        help="Install a specific category (can be passed multiple times)",
    )
    parser.add_argument(
        "--install-all",
        action="store_true",
        help="Install every category",
    )
    parser.add_argument(
        "--post-install",
        action="store_true",
        help="Run the post-installation helpers",
    )
    parser.add_argument(
        "--update-brew",
        action="store_true",
        help="Run brew update and upgrade",
    )
    return parser.parse_args()


def interactive_menu() -> None:
    """Start the interactive TUI for managing the packages."""
    print(f"{Colors.CYAN}{Colors.BOLD}")
    print("=" * 60)
    print("   🛠️  Development Environment Setup Tool  🛠️")
    print("=" * 60)
    print(f"{Colors.END}")

    while True:
        print(f"\n{Colors.WHITE}{Colors.BOLD}Available Actions:{Colors.END}")
        print("1. 📦 Install all packages")
        print("2. 🗂️ Install a single category")
        print("3. 📋 List all packages")
        print("4. 🔧 Run post-installation setup")
        print("5. 🔄 Update Homebrew")
        print("6. ❌ Exit")

        choice = input(f"\n{Colors.YELLOW}Enter your choice (1-6): {Colors.END}").strip()

        if choice == "1":
            print(f"\n{Colors.MAGENTA}Installing all packages...{Colors.END}")
            install_packages(PACKAGES)
            post_install_setup()
        elif choice == "2":
            category = choose_category(PACKAGES)
            if category:
                install_packages(PACKAGES, categories=[category])
        elif choice == "3":
            print(f"\n{Colors.WHITE}{Colors.BOLD}📋 Complete Package List:{Colors.END}")
            list_packages(PACKAGES)
        elif choice == "4":
            post_install_setup()
        elif choice == "5":
            update_homebrew()
        elif choice == "6":
            print(f"{Colors.GREEN}Goodbye! 👋{Colors.END}")
            break
        else:
            print(f"{Colors.RED}Invalid choice! Please enter 1-6.{Colors.END}")


def main() -> None:
    """Entry point for CLI and interactive workflows."""

    args = parse_args()
    executed = False

    if args.list:
        list_packages(PACKAGES)
        executed = True

    if args.install_all:
        install_packages(PACKAGES)
        executed = True

    if args.install:
        install_packages(PACKAGES, categories=args.install)
        executed = True

    if args.post_install:
        post_install_setup()
        executed = True

    if args.update_brew:
        update_homebrew()
        executed = True

    if executed:
        return

    interactive_menu()


if __name__ == "__main__":
    main()
