// Schema
digraph "p004.pl" {
	node [fontsize=8]
	graph [compound=True]
	UUID_5B93C204_B02B_11EA_B4B6_ACDE48001122 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_5B93C33A_B02B_11EA_B4B6_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_5B93C204_B02B_11EA_B4B6_ACDE48001122 -> UUID_5B93C33A_B02B_11EA_B4B6_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_5B93C204_B02B_11EA_B4B6_ACDE48001122 -> UUID_5B93C204_B02B_11EA_B4B6_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_5B93C33A_B02B_11EA_B4B6_ACDE48001122 -> UUID_5B93C33A_B02B_11EA_B4B6_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster0 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(Z,Y)"
		UUID_5B93C204_B02B_11EA_B4B6_ACDE48001122_Cluster0 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_5B93C33A_B02B_11EA_B4B6_ACDE48001122_Cluster0 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
}
