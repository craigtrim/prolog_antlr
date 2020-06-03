# ANTLR Generated Files


## Grammar Generation
`Prolog.g4` is the Prolog Grammar.  

The grammar comes from this GitHub repo: https://github.com/antlr/grammars-v4. 

Specifically, this file https://github.com/antlr/grammars-v4/blob/master/prolog/prolog.g4 retrieved on June 1st, 2020.

The other files in this directory are all auto-generated using these commands:

Template:
```shell
java -Xmx500M -cp <ANTLR JAR> org.antlr.v4.Tool -Dlanguage=Python3 <GRAMMAR>
```

Example:
```shell
java -Xmx500M -cp /usr/local/lib/antlr-4.8-complete.jar org.antlr.v4.Tool -Dlanguage=Python3 Prolog.g4
```

You should not need to re-generate the grammar, unless you plan to make changes.


## Other Dependencies:
I tested this on OS X 10.15.5 (19F101).  

I used homebrew to install a Java Runtime and the ANTlR jar file from here: https://www.antlr.org/download.html 