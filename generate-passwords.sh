#!/bin/bash

number_of_passwords=1000000
# check if the user provided a number of passwords
if [ $# -eq 1 ]; then
  number_of_passwords=$1
fi
echo "Generating $number_of_passwords passwords..."

#if pwnedpasswords_sorted.txt already exists, skip download and sorting as they are resource intensive
if [ ! -f pwnedpasswords_sorted.txt ]; then
  # if the file pwnedpasswords.txt does not exist, download it
  if [ ! -f pwnedpasswords.txt ]; then
    echo "Downloading pwnedpasswords.txt..."
    # If brew is not installed, throw
    if ! command -v brew &>/dev/null; then
      echo "Homebrew not found, please install Homebrew first."
      exit 1
    fi
    # If dotnet sdk is not installed, install it
    if ! command -v dotnet &>/dev/null; then
      echo "dotnet not found, installing..."
      brew install --cask dotnet-sdk
    fi
    # If haveibeenpwned-downloader is not installed, install it
    if ! command -v haveibeenpwned-downloader &>/dev/null; then
      echo "haveibeenpwned-downloader not found, installing..."
      dotnet tool install --global haveibeenpwned-downloader
    fi
    # Download the pwnedpasswords.txt file
    haveibeenpwned-downloader --output pwnedpasswords.txt
  else
    echo "pwnedpasswords.txt found, skipping download."
  fi

  # Check if the pwnedpasswords.txt file was downloaded successfully
  if [ ! -f pwnedpasswords.txt ]; then
    echo "pwnedpasswords.txt not found, please check the download process."
    exit 1
  fi

  # Sort the pwnedpasswords.txt file by frequency
  echo "Sorting pwnedpasswords.txt by frequency..."
  sort -t: -k2,2nr pwnedpasswords.txt -o pwnedpasswords_sorted.txt
fi

# Get the top 1.000.000 passwords
echo "Extracting the top 1,000,000 passwords..."
head -n $number_of_passwords pwnedpasswords_sorted.txt >top_passwords.txt

# Remove the frequency column
echo "Removing frequency column..."
cut -d':' -f1 top_passwords.txt >top_passwords_hash_only.txt

# Sort the passwords by hash
echo "Sorting passwords by hash..."
sort top_passwords_hash_only.txt -o top_passwords_hash_only_sorted.txt

# Remove the temporary files
echo "Cleaning up temporary files..."
rm top_passwords.txt top_passwords_hash_only.txt

# Move the final file
mv top_passwords_hash_only_sorted.txt passwords/common_passwords.txt

# Ask if the user wants to delete the original pwnedpasswords.txt file
if [ -f pwnedpasswords.txt ]; then
  read -p "Do you want to delete the original pwnedpasswords.txt file? (y/n): " delete_original
  if [[ "$delete_original" == "y" || "$delete_original" == "Y" ]]; then
    echo "Deleting original pwnedpasswords.txt file..."
    rm pwnedpasswords.txt
  else
    echo "Keeping original pwnedpasswords.txt file."
  fi
fi

# Ask if the user wants to delete the sorted file
read -p "Do you want to delete the sorted pwnedpasswords_sorted.txt file? (y/n): " delete_sorted
if [[ "$delete_sorted" == "y" || "$delete_sorted" == "Y" ]]; then
  echo "Deleting sorted pwnedpasswords_sorted.txt file..."
  rm pwnedpasswords_sorted.txt
else
  echo "Keeping sorted pwnedpasswords_sorted.txt file."
fi
