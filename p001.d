// Schema
digraph "p001.pl" {
	node [fontsize=8]
	graph [compound=True]
	UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122 -> UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster0 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="mortal(X)"
		UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster0 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122 -> UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster1 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="person(X)"
		UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster1 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster0 -> UUID_D3F71C7C_B02C_11EA_BB09_ACDE48001122_Cluster1 [label="mortal(X):-person(X)." arrowhead=normal color=8 colorscheme=greys9 fontsize=10 lhead=Cluster1 ltail=Cluster0 style=normal weight=2]
}
