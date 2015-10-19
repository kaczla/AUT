
# Aby `make clean` mogło dzialać poprawnie, wszystkie pliki binarne
# (także pliki .jar dla Javy) powinny zostać dodane do zmiennej
# BINARIES.
# Takie pliki dobrze także dodać do pliku `.gitignore`, żeby
# git przez pomyłkę ich nie dodaj (nigdy nie wypychamy binariów!).
BINARIES += TaskX02/run

# Aby skompilować plik `run` ze źródła (`run.cpp`) należy wywołać
# kompilator języka C++ (GNU C++ - `g++`).
# $@ to plik wynikowy (`run`)
# $< to plik wejściowy (`run.cpp`)
TaskX02/run: TaskX02/run.cpp
	g++ -o $@ $<
