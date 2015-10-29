#include <iostream>
#include <string>
#include <cctype>

using namespace std;

int main( int argc, char* arv[] ){
	string line;
	int liczba = 0;
	int i, znak;
	while( getline( cin, line ) ){
		i = 0;
		znak = 0;
		if( line[i] != '#' ){
			while( i < line.size() ){
				if( isalpha( line[i] ) ){
					znak = 1;
				}
				++i;
			}
			if(znak == 1){
				liczba++;
			}
		}
	}
	cout<<liczba<<endl;
	return 0;
}
