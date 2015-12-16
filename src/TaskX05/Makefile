
# .far to specjalny format do przechowywania spakowanych transduktorów

TaskX05/run: TaskX05/legiatolech.far

TaskX05/legiatolech.far: TaskX05/legiatolech.grm
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/fst" thraxcompiler --input_grammar=$< --output_far=$@
