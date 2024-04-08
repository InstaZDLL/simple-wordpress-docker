# Simple Wordpress Docker Setup

This repository contains a Docker setup for running a WordPress site. It includes a Dockerfile that sets up a WordPress server and an `init.sql` script that initializes the WordPress database.

**Info :** The worpress in the container is a pre-build image so the user, password, language, front page and the first article has been already set.
You can modify is in the settings of wordpress.

[ ![GitHub Release](https://img.shields.io/github/v/release/InstaZDLL/simple-wordpress-docker?style=for-the-badge)](https://img.shields.io/github/v/release/InstaZDLL/simple-wordpress-docker?sort=date&display_name=release&style=for-the-badge
)  ![GitHub License](https://img.shields.io/github/license/InstaZDLL/simple-wordpress-docker?style=for-the-badge) ![GitHub last commit (by committer)](https://img.shields.io/github/last-commit/InstaZDLL/simple-wordpress-docker?style=for-the-badge) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/InstaZDLL/simple-wordpress-docker/total?style=for-the-badge&color=%230080ff)

## How It Works

The Dockerfile starts from the `ubuntu:jammy` base image and installs necessary software including Nginix and PHP 8.3. It then copies the WordPress files into the `/var/www/wordpress/` directory in the container and sets up Nginx and PHP to serve the WordPress site.

The `init.sql` script is run when the container starts up to initialize the WordPress database. It replaces all instances of `http://localhost` with the value of the `WORDPRESS_HOST` environment variable in the SQL dump.

## How to Run

To run a container from the image, use the following command:

```bash
docker run -d --name wordpress \
    -e WORDPRESS_DATABASE_HOST=your-database-host \
    -v /path/to/volume/:/var/www/wordpress \
    -p 80:80 \
    nayeonyny/wordpress:latest
```

## Environment Variables
The following environment variables can be set when running the Docker container:

| ENV | Default value | Example | Description |
| --- | ------------- | ------- | ----------- |
| WORDPRESS\_DATABASE | wordpress | mydatabase | The name of the WordPress database. |
| WORDPRESS\_DATABASE\_USER | wpuser | myuser | The username for the WordPress database. |
| WORDPRESS\_DATABASE\_PASSWORD | wpuser | mypassword | The password for the WordPress database. |
| WORDPRESS\_DATABASE\_HOST | localhost | example.com or 64.23.50.120 | The ip address of the WordPress database, can be private, public or you can use a domain. |
| WORDPRESS\_HOST | localhost | example.com or 64.23.50.120 | The host of your WordPress site. If this is not set or is empty, it will default to <strong>localhost</strong>. This means that all resources will only be available on localhost. To make your WordPress site work online, change this variable to the public IP address or domain name of your host. |

⚠️ **Important :** The var `WORDPRESS_DATABASE_HOST` it can't be localhost you must change this variable or the container will be stopped, if you have a database container change to host or container ip. ⚠️

### How to do :

This provides the IP address of your database container.

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```


## Health Check
The Dockerfile includes a health check that sends a request to http://localhost/ every 5 minutes. If the request is successful (i.e., the HTTP status code is 200), the container is considered healthy. If the request is not successful, the container is considered unhealthy.

## Author

- [@InstaZDLL](https://github.com/InstaZDLL)


## License

```text
Copyright (C) 2024 Ethan Besson

Licensed under the Academic Free License version 3.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://opensource.org/license/afl-3-0-php/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
