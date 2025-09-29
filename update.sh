# nixfmt
find . -name '*.nix' -exec nixfmt {} \;

# update flake
sudo nix flake update
#sudo darwin-rebuild switch --flake ~/nix
nh darwin switch ~/nix-config/
# Check if last command succeeded
status=$?

# Garbage collection (optional)
read -p "Do you want to collect the trash? (y/n): " answer
if [[ $status -eq 0 || "$answer" =~ ^[Yy]$ ]]; then
  echo "Starting garbage collection"
  #nix store gc
  #nix-collect-garbage -d
  nh clean all
elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
  echo "Garbage wont be collected"
else
  echo "Invalid input. Please enter 'y' or 'n'."
fi
