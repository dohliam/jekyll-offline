# Jekyll Offline - Turn any Jekyll site into an offline application with relative links

[Jekyll Offline](https://dohliam.github.io/jekyll-offline) creates a copy of a specified Jekyll-based website and rewrites all of the internal links as relative URLs so that the site can be viewed from a local machine without requiring access to the Internet.

Usually, Jekyll sites can be viewed either by uploading the generated site files to a remote server or locally using the `jekyll serve` command, which hosts the site temporarily on a local server. However, it is not always possible or practical to do this (for example, on a phone or other mobile device). As static sites, Jekyll sites are well-suited to running offline and usually present no special challenges (with the exception of some [known issues](#issues)) other than that all of the resources and links on a typical web page are relative to the root of the server, rather than the user's computer file structure.

So long as the Jekyll-generated site code is available, the Jekyll executable itself is not even required for this script to work.

## Requirements

The script (`jekyll_offline.rb`) can be used directly and does not need to be installed. There are no prerequisites other than [Ruby](https://www.ruby-lang.org/).

If you have the source code for a Jekyll site that has not been generated yet, you will need to [install Jekyll](https://jekyllrb.com/) first and then build the site:

    cd my_jekyll_site/
    jekyll build

You can then point your Jekyll Offline configuration file at the resulting `_site` folder to convert it to a fully functoning offline site (for details, see the [Usage](#usage) section below).

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

## Issues

There are some unexpected challenges with `file://` URIs that make them different from URIs loaded from a server (even one running on localhost).

* So-called "clean URLs" (where e.g., pages named `index.html` can be accessed by following a link to the parent directory without needing to add `index.html` at the end) are a feature of the webserver, and thus do not work with `file://` URIs.
  * For example, if you have a file located at `/blog/index.html` and you link to it using `/blog`, it will work fine on a webserver, but on a local filesystem you will be taken to an index page listing all the files in the directory instead.
  * Jekyll Offline handles this by rewriting these links so that they point to the actual file (e.g., `index.html`) instead of the parent directory.
* To be truly portable, all local links must be relative to some arbitrary "root" level that represents the top level of the site
  * This means that the distance between each link on the site and the root directory must be calculated independently, which is what Jekyll Offline does.

When crawling an online website, some of these issues can be resolved using a tool like Wget with option `--convert-links` for example. However, Jekyll Offline has been designed for cases where the entire website is already available locally, and simply needs to be adjusted slightly to run offline.

There are also some known issues remaining to be resolved:

* Due to [this 7 year-old unresolved bug](https://bugzilla.mozilla.org/show_bug.cgi?id=760436) in Firefox, local fonts will not load on a page unless they are placed in the same directory as the page. This can be quite problematic for sites with multiple pages, however as noted in the linked bug report, these sites should still work fine in other browsers.
  * Note that this also means that Font Awesome and similar icon fonts will not work properly in Firefox. One way to work around this is to extract the icons you need and embed them into each page. This is of course impractical for large fonts.
* There is currently an issue with converting sites in different locations than the script itself. While this is being resolved, it is recommended to place the `_site` folder and corresponding YAML configuration file in the same folder as (or a subfolder of) the `jekyll_offline.rb` script itself.

## Contributing

If you encounter any problems while converting a Jekyll site, please open an issue, ideally with a link to the source code of the website in question. PRs are also always welcome!

## License

MIT.
