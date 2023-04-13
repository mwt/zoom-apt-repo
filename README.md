Zoom does not provide an official repository for Debian/Ubuntu. This repository serves the latest official `.deb` from Zoom. All files are checked against the Zoom GPG keys. The repo is automatically updated twice per day.

## Installation Instructions

**Step 1:** Add my GPG certificate to your keyrings folder. This does **not** automatically trust my key for anything.

```
sudo mkdir -p /etc/apt/keyrings && wget -qO- https://mirror.mwt.me/my/gpgkey | sudo tee /etc/apt/keyrings/mwt.asc > /dev/null
```

**Step 2:** Add this to your list of repositories. This step tells apt to use my key to check the repo.

```
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mwt.asc by-hash=force] https://mirror.mwt.me/my/deb any zoom" | sudo tee /etc/apt/sources.list.d/mwt.list
```

## Usage with my RStudio Repo

To use this with my RStudio repository, replace the command in Step 2 with:

```
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mwt.asc by-hash=force] https://mirror.mwt.me/my/deb any rstudio zoom" | sudo tee /etc/apt/sources.list.d/mwt.list
```
