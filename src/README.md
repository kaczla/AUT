# Sprawdzenie poprawności wykonanego zadania:


#### Przed wykonaniem poleceń poniżej upewnij się że masz uprawnienia do wykonania:

`chmod u+x run`

lub

`chmod a+x run`
</br>
</br>

#### Zadania A00-A03:

<file> - nazwa pliku
</br>
`diff -s <(./run <file>.arg < <file>.in) <(cat <file>.exp)`
</br>
Przykład:
</br>
`diff -s <(./run simple1.arg < simple1.in) <(cat simple1.exp)`
</br>
</br>

#### Zadania B00-B48

<file> - nazwa pliku
</br>
`diff -s <(./run < <file>.in) <(cat <file>.exp)`
</br>
Przykład:
</br>
`diff -s <(./run < test.in) <(cat test.exp)`
</br>
