TaskX06/run: TaskX06/zadanie.far

TaskX06/zadanie.far: TaskX06/zadanie.grm
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/fst" thraxcompiler --input_grammar=$< --output_far=$@
