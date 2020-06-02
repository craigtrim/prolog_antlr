## Environment
Tested on OS X 10.15.5 (19F101) using conda 4.8.2.

## HOWTO: 

Template:
```shell
java -Xmx500M -cp <ANTLR JAR> org.antlr.v4.Tool -Dlanguage=Python3 <GRAMMAR>
```

Example:
```shell
java -Xmx500M -cp /usr/local/lib/antlr-4.8-complete.jar org.antlr.v4.Tool -Dlanguage=Python3 Hello.g4
```

```shell script
(antlr) ~/Documents/data/workspaces/personal/antlr/hello_world$ python driver.py 
hello world
<CTRL-D>
Hello: world
```

## Tutorials:
1. http://blog.anvard.org/articles/2016/03/15/antlr-python.html
