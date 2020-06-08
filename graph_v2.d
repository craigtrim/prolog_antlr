// Schema
digraph output {
	node [fontsize=8]
	graph [compound=True]
	UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7 [label=skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF23AAA_A9C6_11EA_A756_3AF9D3E36CF7 [label="\"Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF2404A_A9C6_11EA_A756_3AF9D3E36CF7 [label="\"Analysis\nSkill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7 [label=business_analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF245AE_A9C6_11EA_A756_3AF9D3E36CF7 [label="\"Business\nAnalysis Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23AAA_A9C6_11EA_A756_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF2404A_A9C6_11EA_A756_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF245AE_A9C6_11EA_A756_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF23AAA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23AAA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster0 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster0 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(skill,\"Skill\")"
		UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7_Cluster0 [label=skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF23AAA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster0 [label="\"Skill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF2404A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF2404A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster1 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster1 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(analysis_skill,\"Analysis Skill\")"
		UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster1 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF2404A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster1 [label="\"Analysis\nSkill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7_Cluster2 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF245AE_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF245AE_A9C6_11EA_A756_3AF9D3E36CF7_Cluster2 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster2 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(business_analysis_skill,\"Business Analysis Skill\")"
		UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7_Cluster2 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF245AE_A9C6_11EA_A756_3AF9D3E36CF7_Cluster2 [label="\"Business\nAnalysis Skill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster3 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7_Cluster3 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster3 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(analysis_skill,skill)"
		UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster3 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF23960_A9C6_11EA_A756_3AF9D3E36CF7_Cluster3 [label=skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7_Cluster4 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster4 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster4 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(business_analysis_skill,analysis_skill)"
		UUID_DAF24482_A9C6_11EA_A756_3AF9D3E36CF7_Cluster4 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF23F0A_A9C6_11EA_A756_3AF9D3E36CF7_Cluster4 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster5 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster5 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster6 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster6 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster6 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Y)"
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster6 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster6 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster7 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster7 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster8 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7_Cluster8 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster8 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Z)"
		UUID_DAF255DA_A9C6_11EA_A756_3AF9D3E36CF7_Cluster8 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7_Cluster8 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
	UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7_Cluster9 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7 -> UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster9 [label="" arrowhead=none color=1 colorscheme=greys9 fontsize=5 style=dotted weight=5]
	subgraph Cluster9 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(Z,Y)"
		UUID_DAF267A0_A9C6_11EA_A756_3AF9D3E36CF7_Cluster9 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_DAF256A2_A9C6_11EA_A756_3AF9D3E36CF7_Cluster9 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	}
}
