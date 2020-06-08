// Schema
digraph output {
	node [fontsize=8]
	graph [compound=True]
	UUID_A08A9F4A_A9B9_11EA_B222_3AF9D3E36CF7 [label=skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AA09E_A9B9_11EA_B222_3AF9D3E36CF7 [label="\"Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AA512_A9B9_11EA_B222_3AF9D3E36CF7 [label=analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AA652_A9B9_11EA_B222_3AF9D3E36CF7 [label="\"Analysis\nSkill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AAAB2_A9B9_11EA_B222_3AF9D3E36CF7 [label=business_analysis_skill color=8 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AABE8_A9B9_11EA_B222_3AF9D3E36CF7 [label="\"Business\nAnalysis Skill\"" color=9 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08ABC1E_A9B9_11EA_B222_3AF9D3E36CF7 [label=X color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08ABCE6_A9B9_11EA_B222_3AF9D3E36CF7 [label=Y color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08AD442_A9B9_11EA_B222_3AF9D3E36CF7 [label=Z color=7 colorscheme=blues9 fixedsize=true fontcolor=gray fontsize=8 shape=doublecircle]
	UUID_A08A9F4A_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08AA09E_A9B9_11EA_B222_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_A08AA512_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08AA652_A9B9_11EA_B222_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_A08AAAB2_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08AABE8_A9B9_11EA_B222_3AF9D3E36CF7 [label=label arrowhead=vee arrowsize=0.5 color=3 colorscheme=bupu9 fontsize=8]
	UUID_A08AA512_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08A9F4A_A9B9_11EA_B222_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_A08AAAB2_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08AA512_A9B9_11EA_B222_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_A08ABC1E_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08ABCE6_A9B9_11EA_B222_3AF9D3E36CF7 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
	UUID_A08ABC1E_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08AD442_A9B9_11EA_B222_3AF9D3E36CF7 [label=parent arrowhead=vee arrowsize=1.0 color=4 colorscheme=bupu9 fontsize=8 style=solid]
	UUID_A08AD442_A9B9_11EA_B222_3AF9D3E36CF7 -> UUID_A08ABCE6_A9B9_11EA_B222_3AF9D3E36CF7 [label=ancestor arrowhead=normal color=5 colorscheme=bupu9 fontsize=8 weight=1.5]
}
