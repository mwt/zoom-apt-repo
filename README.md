RStudio does not provide an official repository for Debian/Ubuntu. This repository serves the latest official `.deb` from RStudio. All files are checked against the RStudio GPG keys. The repo is automatically updated twice per day.

## Installation Instructions

**Step 1:** Add my GPG certificate to your keyrings folder. This does **not** automatically trust my key for anything.

```
sudo wget -O /usr/share/keyrings/mwt.asc https://mirror.mwt.me/my/gpgkey
```

**Step 2:** Add this to your list of repositories. This step tells apt to use my key to check the repo.

```
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt.asc by-hash=force] https://mirror.mwt.me/my/deb any rstudio" > /etc/apt/sources.list.d/mwt.list'
```

## Usage with my Zoom Repo

To use this with my Zoom repository, replace the command in Step 2 with:

```
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt.asc by-hash=force] https://mirror.mwt.me/my/deb any rstudio zoom" > /etc/apt/sources.list.d/mwt.list'
```
