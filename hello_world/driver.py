from antlr4 import *
from HelloLexer import HelloLexer
from HelloListener import HelloListener
from HelloParser import HelloParser
import sys

class HelloPrintListener(HelloListener):
    def enterHi(self, ctx):
        print("Hello: %s" % ctx.ID())

def main():
    lexer = HelloLexer(StdinStream())
    print ("Instantiated Lexer ...")

    stream = CommonTokenStream(lexer)
    print ("Instantiated Stream ...")

    parser = HelloParser(stream)
    print ("Instantiated Parser ...")

    tree = parser.hi()
    print ("Created Tree ...")

    printer = HelloPrintListener()
    print ("Instantiated Printer ...")

    walker = ParseTreeWalker()
    print ("Instantiated Walker ...")

    walker.walk(printer, tree)
    print ("Program Completed ...")

if __name__ == '__main__':
    main()
