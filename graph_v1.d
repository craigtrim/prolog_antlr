// Schema
digraph output {
	node [fontsize=8]
	UUID_D8904976_B012_11EA_94A1_ACDE48001122 [label="{Clause|mortal(X):-\n	person(X).}" fillcolor=yellow fontcolor=black fontsize=8 shape=record style=rounded text="{Clause|P0}"]
	UUID_D8904DAE_B012_11EA_94A1_ACDE48001122 [label=IF shape=plaintext text=IF]
	UUID_D8904E62_B012_11EA_94A1_ACDE48001122 [label=compound color=6 colorscheme=blues9 height=0.25 shape=ellipse text=compound width=0.25]
	UUID_D8904ED0_B012_11EA_94A1_ACDE48001122 [label=mortal fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	UUID_D8904FD4_B012_11EA_94A1_ACDE48001122 [label=X fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	UUID_D8905114_B012_11EA_94A1_ACDE48001122 [label=compound color=6 colorscheme=blues9 height=0.25 shape=ellipse text=compound width=0.25]
	UUID_D890516E_B012_11EA_94A1_ACDE48001122 [label=person fixedsize=true fontcolor=black fontsize=10 shape=doublecircle]
	UUID_D8904976_B012_11EA_94A1_ACDE48001122 -> UUID_D8904DAE_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8904DAE_B012_11EA_94A1_ACDE48001122 -> UUID_D8904E62_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8904E62_B012_11EA_94A1_ACDE48001122 -> UUID_D8904ED0_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8904E62_B012_11EA_94A1_ACDE48001122 -> UUID_D8904FD4_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8904DAE_B012_11EA_94A1_ACDE48001122 -> UUID_D8905114_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8905114_B012_11EA_94A1_ACDE48001122 -> UUID_D890516E_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
	UUID_D8905114_B012_11EA_94A1_ACDE48001122 -> UUID_D8904FD4_B012_11EA_94A1_ACDE48001122 [label="." arrowhead=normal arrowsize=1.0 color=black fontcolor=white fontsize=1 style=filled]
}
