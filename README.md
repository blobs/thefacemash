The face mash
===========

Installation:
- First you should clone repo.
- Next install:  nodejs (latest version, not from ubuntu repo, from ppa preferably)
- Next install global node modules, nodemon and grunt-cli if they not installed for your user Ex:(# npm install -g nodemon)
- Next install local modules from package.json file. Command which reads modules and install it: ($ npm install)
- Next command: "$ grunt" - which run compiler in watch mode
- And next add PORT env variable with your port(300* where * latest digit from your vpn ip)
- And run code with: "nodemon ./js/app.js"
- Check on: http://ip:port/battle
- Write code, save code, update page.
- Make branch, commit, push. After completing branch make pull request.
