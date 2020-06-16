# Graphviz Visualization

On Mac OS X 10.15.5 (19F101) use homebrew to install Graphviz

```shell script
brew install graphviz
```

For more information on Graphviz installation, please visit:<br />
https://www.graphviz.org/download/  


## Troubleshooting

1. Executable Not Found
    ```text
    graphviz.backend.ExecutableNotFound: failed to execute ['fdp', '-Tpng', '-O', 'graph.png'], make sure the Graphviz executables are on your systems' PATH
    ```
    Solution: Install Graphviz (https://www.graphviz.org/download/)
    
## References:
1.  Generate a Dot Graph from ANTLR AST:<br />
    https://github.com/craigtrim/prolog_antlr/issues/3