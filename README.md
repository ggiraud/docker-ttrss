docker-ttrss
============================

Tiny-Tiny-RSS docker image, based on the v1.13(Jul 21, 2014).
**Requires a mysql container to link.**

Official page: [http://tt-rss.org/redmine/projects/tt-rss/wiki](http://tt-rss.org/redmine/projects/tt-rss/wiki)

GitHub repo: [https://github.com/gothfox/Tiny-Tiny-RSS](https://github.com/gothfox/Tiny-Tiny-RSS)

Usage
-----

Clone the repo:

```bash
git clone https://github.com/ggiraud/docker-ttrss
```

Build:

```bash
docker build -t ttrss .
```

Or pull from hub:

```bash
docker pull ggiraud/ttrss
```

Running your TTRSS docker image
-------------------------------

```bash
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql
```

```bash
docker run --name some-ttrss --link some-mysql:mysql -p 80:80 -d ggiraud/ttrss
```

The following environment variables allow you to configure your mysql database:

* ```-e TTRSS_DB_USER=...``` (defaults to "root")
* ```-e TTRSS_DB_PASSWORD=...``` (defaults to the value of the ```MYSQL_ROOT_PASSWORD``` environment variable from the linked mysql container) 
* ```-e TTRSS_DB_NAME=...``` (defaults to "ttrss")

If the ```TTRSS_DB_NAME``` specified does not already exist in the given MySQL container, it will be created automatically upon container startup, along with the necessary permissions for ```TTRSS_DB_USER```.

Visit the web interface on http://YourIP/tt-rss/
