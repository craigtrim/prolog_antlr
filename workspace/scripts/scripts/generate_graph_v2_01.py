#!/usr/bin/env python
# -*- coding: UTF-8 -*-


IS_DEBUG = True


def main():
    source_code = """
    label(skill, "Skill").
    label(analysis_skill, "Analysis Skill").
    label(business_analysis_skill, "Business Analysis Skill").
    
    parent(analysis_skill, skill).
    parent(business_analysis_skill, analysis_skill).
    
    ancestor(X,Y):- 
        parent(X,Y).   		/* someone is your ancestor if there are your parent */
    ancestor(X,Y):- 
        parent(X,Z), 		/* or somebody is your ancestor if they are the parent */
        ancestor(Z,Y). 		/* of someone who is your ancestor */ 
    """
    from grapher.core.bp import GraphvizAPI
    from parser.antlr.bp import ParsePrologAPI

    source_lines = [x.strip() for x in source_code.split('\n')]

    parser_api = ParsePrologAPI(is_debug=IS_DEBUG)
    grapher_api = GraphvizAPI(is_debug=IS_DEBUG)

    ast = parser_api.parse(source_lines)
    ast = parser_api.post_process(ast)
    df_ast = parser_api.as_dataframe(ast)

    grapher_api.graph_v2(df_ast)


if __name__ == '__main__':
    main()
