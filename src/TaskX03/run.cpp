#include <iostream>

int main( int argc, char* argv[] ){
	std::string input;	
	while( std::cin>>input ){
		std::cout<<input.size()<<" "<<input<<"\n"; 
	}
	return 0;
}
