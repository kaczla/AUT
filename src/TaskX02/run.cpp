#include <string>
#include <iostream>

int main(int argc, char* arv[])
{
    unsigned int line_counter = 0;
    std::string line;
    while (std::getline(std::cin, line))
        ++line_counter;

    std::cout << line_counter << std::endl;
}
