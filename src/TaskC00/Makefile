TaskC00/run: TaskC00/zadanie.far

TaskC00/zadanie.far: TaskC00/zadanie.grm
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/fst" thraxcompiler --input_grammar=$< --output_far=$@
