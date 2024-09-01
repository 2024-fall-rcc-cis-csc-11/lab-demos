

#include <iostream>

extern "C"
{
	void the_cpp_function();
}


void the_cpp_function()
{
	std::cout << "Hello! This is the C++ function!" << std::endl;
}

