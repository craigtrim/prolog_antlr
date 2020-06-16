// Schema
digraph "p020.pl" {
	node [fontsize=8]
	graph [compound=True]
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D0397FB2_B022_11EA_A037_ACDE48001122 [label="\"Analysis\nSkill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D03985A2_B022_11EA_A037_ACDE48001122 [label=business_analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D03986D8_B022_11EA_A037_ACDE48001122 [label="\"Business\nAnalysis Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D0398C0A_B022_11EA_A037_ACDE48001122 [label=skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D0399704_B022_11EA_A037_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D03997CC_B022_11EA_A037_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D039A7A8_B022_11EA_A037_ACDE48001122 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 -> UUID_D0397FB2_B022_11EA_A037_ACDE48001122 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_D03985A2_B022_11EA_A037_ACDE48001122 -> UUID_D03986D8_B022_11EA_A037_ACDE48001122 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 -> UUID_D0398C0A_B022_11EA_A037_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_D03985A2_B022_11EA_A037_ACDE48001122 -> UUID_D0397C7E_B022_11EA_A037_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D039A7A8_B022_11EA_A037_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_D039A7A8_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 -> UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D0397FB2_B022_11EA_A037_ACDE48001122 -> UUID_D0397FB2_B022_11EA_A037_ACDE48001122_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster0 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(analysis_skill,\"Analysis Skill\")"
		UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster0 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D0397FB2_B022_11EA_A037_ACDE48001122_Cluster0 [label="\"Analysis\nSkill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D03985A2_B022_11EA_A037_ACDE48001122 -> UUID_D03985A2_B022_11EA_A037_ACDE48001122_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D03986D8_B022_11EA_A037_ACDE48001122 -> UUID_D03986D8_B022_11EA_A037_ACDE48001122_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster1 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(business_analysis_skill,\"Business Analysis Skill\")"
		UUID_D03985A2_B022_11EA_A037_ACDE48001122_Cluster1 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D03986D8_B022_11EA_A037_ACDE48001122_Cluster1 [label="\"Business\nAnalysis Skill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 -> UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster2 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D0398C0A_B022_11EA_A037_ACDE48001122 -> UUID_D0398C0A_B022_11EA_A037_ACDE48001122_Cluster2 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster2 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(analysis_skill,skill)"
		UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster2 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D0398C0A_B022_11EA_A037_ACDE48001122_Cluster2 [label=skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D03985A2_B022_11EA_A037_ACDE48001122 -> UUID_D03985A2_B022_11EA_A037_ACDE48001122_Cluster3 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D0397C7E_B022_11EA_A037_ACDE48001122 -> UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster3 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster3 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(business_analysis_skill,analysis_skill)"
		UUID_D03985A2_B022_11EA_A037_ACDE48001122_Cluster3 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D0397C7E_B022_11EA_A037_ACDE48001122_Cluster3 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster4 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D03997CC_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster4 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster4 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster4 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster4 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster5 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D03997CC_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster5 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster5 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Y)"
		UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster5 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster5 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster6 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D03997CC_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster6 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster6 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster6 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster6 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0399704_B022_11EA_A037_ACDE48001122 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster7 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D039A7A8_B022_11EA_A037_ACDE48001122 -> UUID_D039A7A8_B022_11EA_A037_ACDE48001122_Cluster7 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster7 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Z)"
		UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster7 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D039A7A8_B022_11EA_A037_ACDE48001122_Cluster7 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D039A7A8_B022_11EA_A037_ACDE48001122 -> UUID_D039A7A8_B022_11EA_A037_ACDE48001122_Cluster8 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	UUID_D03997CC_B022_11EA_A037_ACDE48001122 -> UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster8 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=1]
	subgraph Cluster8 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(Z,Y)"
		UUID_D039A7A8_B022_11EA_A037_ACDE48001122_Cluster8 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_D03997CC_B022_11EA_A037_ACDE48001122_Cluster8 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster4 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster5 [label="ancestor(X,Y):-parent(X,Y)." arrowhead=normal color=8 colorscheme=greys9 fontsize=10 lhead=Cluster5 ltail=Cluster4 style=normal weight=2]
	UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster6 -> UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster7 [label="ancestor(X,Y):-parent(X,Z),ancestor(Z,Y)." arrowhead=normal color=8 colorscheme=greys9 fontsize=10 lhead=Cluster7 ltail=Cluster6 style=normal weight=2]
	UUID_D0399704_B022_11EA_A037_ACDE48001122_Cluster6 -> UUID_D039A7A8_B022_11EA_A037_ACDE48001122_Cluster8 [label="ancestor(X,Y):-parent(X,Z),ancestor(Z,Y)." arrowhead=normal color=8 colorscheme=greys9 fontsize=10 lhead=Cluster8 ltail=Cluster6 style=normal weight=2]
}
