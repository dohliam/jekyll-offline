# Jekyll Offline - Turn any Jekyll site into an offline application with relative links

Jekyll Offline creates a copy of a specified Jekyll-based website and rewrites all of the internal links as relative URLs so that the site can be viewed from a local machine without requiring access to the Internet.

Usually, Jekyll sites can be viewed either by uploading the generated site files to a remote server or locally using the `jekyll serve` command, which hosts the site temporarily on a local server. However, it is not always possible or practical to do this (for example, on a phone or other mobile device). As static sites, Jekyll sites are well-suited to running offline and usually present no special challenges other than that all of the resources and links are relative to the root of the server, not the user's computer file structure.

So long as the Jekyll-generated site code is available, the Jekyll executable itself is not even required for this script to work.

## Prerequisites

The script (`jekyll_offline.rb`) can be used directly and does not need to be installed. There are no prerequisites other than [Ruby](https://www.ruby-lang.org/).

## Usage

Clone or download the repository and enter the following command in a terminal from within the repo main directory:

    ./jekyll_offline.rb demo.yml

This will create a new folder named `demo_offline` in the same directory. This folder contains the offline version of the default Jekyll demo site. You can visit it by opening the file `START_HERE.html` within the `demo_offline` folder in a web browser.

To create your own new offline site, simply adjust the variables in the `config.yml` file and run the script again:

    ./jekyll_offline

The configuration file is assumed to be `config.yml` by default, so it does not need to be specified unless you are using a different file.

Note that the `config.yml` file should point to the generated `_site` folder of a Jekyll website, and not the unprocessed Jekyll source code.

## Library

The methods in the `lib_rellinks.rb` library may be useful for relativizing links more generally in HTML pages other than Jekyll sites.

It is extremely useful to have an offline version of a website that can work without an Internet connection or a local server, so it was quite surprising to find that a library to do this did not already exist.

This script has been used to create fully-functional offline versions of the [Global Storybooks](https://globalstorybooks.net) websites.

## License

MIT.
