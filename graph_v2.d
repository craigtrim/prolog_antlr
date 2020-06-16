// Schema
digraph output {
	node [fontsize=8]
	graph [compound=True]
	UUID_C9D685F8_B012_11EA_BD86_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_C9D68710_B012_11EA_BD86_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_C9D685F8_B012_11EA_BD86_ACDE48001122 -> UUID_C9D68710_B012_11EA_BD86_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_C9D685F8_B012_11EA_BD86_ACDE48001122 -> UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_C9D68710_B012_11EA_BD86_ACDE48001122 -> UUID_C9D68710_B012_11EA_BD86_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster0 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster0 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_C9D68710_B012_11EA_BD86_ACDE48001122_Cluster0 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_C9D685F8_B012_11EA_BD86_ACDE48001122 -> UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_C9D68710_B012_11EA_BD86_ACDE48001122 -> UUID_C9D68710_B012_11EA_BD86_ACDE48001122_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster1 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Y)"
		UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster1 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_C9D68710_B012_11EA_BD86_ACDE48001122_Cluster1 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster0 -> UUID_C9D685F8_B012_11EA_BD86_ACDE48001122_Cluster1 [label="ancestor(X,Y):-parent(X,Y)." arrowhead=normal color=8 colorscheme=greys9 fontsize=10 lhead=Cluster1 ltail=Cluster0 style=normal weight=2]
}
