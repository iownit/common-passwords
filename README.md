# common-passwords

This repository contains:

- Our list of common passwords, which is a collection of the most frequently used passwords across various platforms. The list is intended to help users avoid using easily guessable passwords and to promote better password security practices. So it can be uploaded and imported into the portal project.
- A script to generate a password list from the common passwords, which can be used to update or modify the existing password list in the portal project.

## Passwords list rules

- The passwords should be all SHA1 hashed.
- The passwords can contain comments if needed, but they should be prefixed with a non HEX character (e.g., `#`).
  - Example: `A48EEA9EF657D73D99748628412320B4B5031AB7#corastone`
- The passwords list order is not important.
- The passwords list should not contain any duplicates.
- The password list must be saved in the `passwords` directory as `common-passwords.txt`.

## How to generate a password list automatically - [HaveIBeenPwned](https://haveibeenpwned.com/)

1. Make sure you have `brew` installed on your system. If you don't have it, you can install it by following the instructions at [brew.sh](https://brew.sh/).
2. Make sure you have enough storage space available, as the script will download a large file (~55Gb) and process it.
3. Make sure you don't have resource-intensive applications running, as the script will download a large file and process it.
4. Run the `generate-passwords.sh` script to download the latest passwords list from HaveIBeenPwned and generate a new `common-passwords.txt` file with 1,000,000 most common passwords.

   ```bash
   ./generate-passwords.sh
   ```

5. Optionally you can pass the number of passwords you want to generate as an argument. For example, to generate 100,000 passwords:

   ```bash
   ./generate-passwords.sh 100000
   ```

## How to generate a password list manually - [HaveIBeenPwned](https://github.com/HaveIBeenPwned/PwnedPasswordsDownloader?tab=readme-ov-file)

1. Install .NET SDK

   ```bash
   brew install --cask dotnet-sdk
   ```

2. Install the PwnedPasswordsDownloader tool

   ```bash
   dotnet tool install --global haveibeenpwned-downloader
   ```

3. Download the full passwords list (~55Gb), it will be saved as `pwnedpasswords.txt` in the current directory

   ```bash
   haveibeenpwned-downloader
   ```

4. Sort the passwords list by frequency (descending order) and save it to `sorted.txt` (This step will take a while and be resource-intensive on RAM and CPU)

   ```bash
   sort -t: -k2,2nr pwnedpasswords.txt > pwnedpasswords_sorted.txt

   ```

5. Extract the top 1.000.000 passwords.

   ```bash
   head -n 1000000 pwnedpasswords_sorted.txt > top_passwords.txt
   ```

6. Remove the frequency column (optional, but recommended for consistency and reduced file size)

   ```bash
   cut -d':' -f1 top_passwords.txt > top_passwords_hash_only.txt
   ```

7. Sort the passwords list by hash (optional, but recommended for consistency and may improve performance in some applications)

   ```bash
   sort top_passwords_hash_only.txt > top_passwords_hash_only_sorted.txt
   ```

8. Move it into the `passwords` directory

   ```bash
   mv top_plasswords_hash_only_sorted.txt passwords/common-passwords.txt
   ```
