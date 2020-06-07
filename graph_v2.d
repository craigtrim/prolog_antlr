// Schema
digraph output {
	node [fontsize=8]
	subgraph Cluster0 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(skill,\"Skill\")"
		UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster0 [label=skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122_Cluster0 [label="\"Skill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster0 -> UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122_Cluster0 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	}
	subgraph Cluster1 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(analysis_skill,\"Analysis Skill\")"
		UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster1 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC53323A_A871_11EA_ACBF_ACDE48001122_Cluster1 [label="\"Analysis\nSkill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster1 -> UUID_BC53323A_A871_11EA_ACBF_ACDE48001122_Cluster1 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	}
	subgraph Cluster2 {
		color=2 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="label(business_analysis_skill,\"Business Analysis Skill\")"
		UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster2 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122_Cluster2 [label="\"Business\nAnalysis Skill\"" color=5 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster2 -> UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122_Cluster2 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	}
	subgraph Cluster3 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(analysis_skill,skill)"
		UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster3 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster3 [label=skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster3 -> UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster3 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	}
	subgraph Cluster4 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(business_analysis_skill,analysis_skill)"
		UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster4 [label=business_analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster4 [label=analysis_skill color=4 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster4 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster4 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	}
	subgraph Cluster5 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	}
	subgraph Cluster6 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Y)"
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	}
	subgraph Cluster7 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(X,Y)"
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	}
	subgraph Cluster8 {
		color=3 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="parent(X,Z)"
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 [label=X color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster8 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 -> UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster8 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	}
	subgraph Cluster9 {
		color=1 colorscheme=orrd3 fontname=Helvetica fontsize=10 label="ancestor(Z,Y)"
		UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster9 [label=Z color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label=Y color=3 colorscheme=blues9 fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
		UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster9 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	}
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 [label=skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122 [label="\"Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC53323A_A871_11EA_ACBF_ACDE48001122 [label="\"Analysis\nSkill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 [label=business_analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122 [label="\"Business\nAnalysis Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 [label=skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 [label=business_analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 -> UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 -> UUID_BC53323A_A871_11EA_ACBF_ACDE48001122 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 -> UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 -> UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster0 -> UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster3 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster3 ltail=Cluster0 style=dotted weight=2]
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 -> UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster0 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC532B78_A871_11EA_ACBF_ACDE48001122 -> UUID_BC532B78_A871_11EA_ACBF_ACDE48001122_Cluster3 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122 -> UUID_BC532CC2_A871_11EA_ACBF_ACDE48001122_Cluster0 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster1 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster3 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster3 ltail=Cluster1 style=dotted weight=2]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster1 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster4 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster4 ltail=Cluster1 style=dotted weight=2]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster3 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster4 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster4 ltail=Cluster3 style=dotted weight=2]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster1 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster3 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC533104_A871_11EA_ACBF_ACDE48001122 -> UUID_BC533104_A871_11EA_ACBF_ACDE48001122_Cluster4 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC53323A_A871_11EA_ACBF_ACDE48001122 -> UUID_BC53323A_A871_11EA_ACBF_ACDE48001122_Cluster1 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster2 -> UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster4 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster4 ltail=Cluster2 style=dotted weight=2]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 -> UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster2 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC53367C_A871_11EA_ACBF_ACDE48001122 -> UUID_BC53367C_A871_11EA_ACBF_ACDE48001122_Cluster4 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122 -> UUID_BC5337B2_A871_11EA_ACBF_ACDE48001122_Cluster2 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster6 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster7 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster8 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster7 ltail=Cluster6 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster8 ltail=Cluster6 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster8 ltail=Cluster7 style=dotted weight=2]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster5 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster6 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534798_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534798_A871_11EA_ACBF_ACDE48001122_Cluster8 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster6 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster7 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster9 ltail=Cluster5 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster7 ltail=Cluster6 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster9 ltail=Cluster6 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster9 ltail=Cluster7 style=dotted weight=2]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster5 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster6 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster7 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC534860_A871_11EA_ACBF_ACDE48001122 -> UUID_BC534860_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster8 -> UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=4 colorscheme=greys9 fontsize=5 lhead=Cluster9 ltail=Cluster8 style=dotted weight=2]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 -> UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster8 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
	UUID_BC535D64_A871_11EA_ACBF_ACDE48001122 -> UUID_BC535D64_A871_11EA_ACBF_ACDE48001122_Cluster9 [label="" arrowhead=none color=3 colorscheme=greys9 fontsize=5 style=dotted weight=0.5]
}
