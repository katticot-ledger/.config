import os

def install_packages(packages):
    for package in packages:
        os.system(f"brew install {package}")

def update_brew_install(new_package, packages):
    file_path = __file__  # Gets the path of the current script

    # Check if the package already exists in the set
    if new_package in packages:
        print(f"'{new_package}' is already in the list.")
        return False

    # Add the new package to the set
    packages.add(new_package)

    # Read the existing content
    with open(file_path, 'r') as file:
        content = file.readlines()

    # Locate the block with the package set and update it
    start_index, end_index = None, None
    for index, line in enumerate(content):
        if line.strip().startswith("packages = {"):
            start_index = index
        if start_index is not None and line.strip().endswith("}"):
            end_index = index
            break

    # Construct the updated package set
    updated_packages = ',\n        '.join(f'"{pkg}"' for pkg in sorted(packages))
    updated_block = f"packages = {{\n        {updated_packages},\n    }}\n"
    
    # Replace the old package block with the new one
    content[start_index:end_index+1] = [updated_block]

    # Write the updated content back to the file
    with open(file_path, 'w') as file:
        file.writelines(content)

    return True

def main():
    packages = {
        "1password-cli",
        "aws",
        "awscli",
        "bat",
        "dust",
        "exa",
        "fzf",
        "gnupg",
        "jq",
        "k9s",
        "kitty",
        "kubectx",
        "lazygit",
        "nvm",
        "ripgrep",
        "tig",
        "tunnelblick",
        "zoxide",
    }

    choice = input("Choose an action:\n1. Install packages\n2. Add a new package\nEnter choice (1/2): ")

    if choice == "1":
        install_packages(packages)
    elif choice == "2":
        new_package = input("Enter the name of the new package to add: ")
        if update_brew_install(new_package, packages):
            print(f"'{new_package}' has been added.")
        else:
            print(f"'{new_package}' was not added.")
    else:
        print("Invalid choice!")

if __name__ == "__main__":
    main()
