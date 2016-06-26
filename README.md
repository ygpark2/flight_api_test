# Getting Started

#### 1. Install dependencies:

__The next command will download all necessary dependencies from a server and create node_modules foler under the project folder.__

```sh
$ npm install
```

#### 2. Install bower:

```sh
$ npm install --global bower
```

#### 3. Install bower dependencies:

__The bower command will download mainly front end files such as bootstrap, jquery and __

```sh
$ bower install
```

#### 4. Start Dev Server:

__If you didn't install gulp module globally, you are able to execute the next command to start the express server__

```sh
$ ./node_modules/gulp/bin/gulp.js
```
or execute the next command on the assumption that you installed gulp globally.

```sh
$ gulp
```
Now, you should be able to see the main page on the url http://localhost:3000

__If you can properly see the main page, you are ready to test the API which is incorporated in the main page.__

