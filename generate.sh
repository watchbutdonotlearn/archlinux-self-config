#!/bin/bash

#written with gemini.

script_file="extract_script.sh"
zip_file="archive.zip"
commands_script_file="commands.sh"
output_script="selfextract.sh"

#copy any files you want to track in /etc or elsewhere to files to add


# --- Create the extraction script if it doesn't exist ---
if [ ! -f "$script_file" ]; then
cat > "$script_file" <<EOL
#!/bin/bash
# Self-extracting script

# Script to extract appended zip archive and run commands.sh

# Check if unzip is installed
if ! command -v unzip &> /dev/null; then
  echo "unzip is not installed. Installing..."
  sudo pacman -S unzip --noconfirm # --noconfirm to avoid prompts (use with caution)

  if [ $? -eq 0 ]; then
    echo "unzip installed successfully."
  else
    echo "Failed to install unzip."
    exit 1  # Exit with an error code
  fi
else
  echo "unzip is already installed."
fi

# Create a directory to extract to
extraction_dir="extracted_files"
mkdir -p "\$extraction_dir"

# Extract the zip archive from the current script file
unzip "\$0" -d "\$extraction_dir"

echo "Archive extracted to '\$extraction_dir'"

# Check if commands.sh was extracted and execute it
echo "Executing extracted commands.sh..."
chmod +x "\$extraction_dir/commands.sh" # Make executable in case it isn't
cd \$extraction_dir
./commands.sh # Execute the commands script
echo "commands.sh execution finished."


exit 0
# ---- ZIP ARCHIVE STARTS BELOW THIS LINE ----
EOL
fi


# --- Create a temporary zip file that includes both archive.zip and commands.sh ---
# Create the zip archive
cd files-to-add
zip "combined_archive.zip" *
mv "combined_archive.zip" ..
cd ..

# --- Generate the self-extracting script by appending the combined zip ---
cat "$script_file" "combined_archive.zip" > "$output_script"
chmod +x "$output_script"

# --- Cleanup temporary combined zip ---
rm "combined_archive.zip"
rm "$script_file"


echo "Self-extracting script '$output_script' generated successfully."
echo "Run it with: ./$output_script"
echo "It will extract to the 'extracted_files' directory and run commands.sh (if included)."
