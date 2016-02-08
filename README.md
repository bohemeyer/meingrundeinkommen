meingrundeinkommen
==================


##Rake tasks

Once you are done with `bower.json` or `Bowerfile` you can run

* `rake bower:install` to install packages
* `rake bower:install:deployment` to install packages from bower.json
* `rake bower:update` to update packages
* `rake bower:update:prune` to update components and uninstall extraneous packages
* `rake bower:list` to list all packages
* `rake bower:clean` to remove all files not listed as [main files](#bower-main-files) (if specified)
* `rake bower:resolve` to resolve [relative asset paths](#relative-asset-paths) in components
* `rake bower:cache:clean` to clear the bower cache. This is useful when you know a component has been updated. 
* 

## Deployment

!!! Check if the newsletter scripts is running before deploying. !!!

## Jameica Server

### Ports
```"sudo iptables -I net2fw 5 -p tcp -m tcp --dport 8080 -j ACCEPT“```
